#!/usr/bin/env ruby

require 'rubygems'
require 'roo'
require 'pp'
require 'date'


class PackageSortItem
  #attr_reader :val
  attr_reader :name
  attr_reader :type
  attr_reader :group
  COMMON_ATTRIBUTES = ['sample_name','sample_title','description','organism','taxonomy_id','bioproject_accession']    
  ORGANISM_GROUP_ATTRIBUTES = ['strain','isolate','breed','cultivar','ecotype']

  def initialize(val)
    @name = val[:name]
    @type = val[:type]
    @group = val[:group]
  end

  def priority 
      if COMMON_ATTRIBUTES.include?(self.name)
          return 1
      elsif self.type == 'either_one_mandatory attribute'
          if self.group == 'Organism'
            return 2
          else
            return 3
          end
      elsif self.type == 'mandatory attribute' 
          return 4
      elsif self.type == 'optional attribute'
          if self.name == ORGANISM_GROUP_ATTRIBUTES[0]
            return 5
          else
            return 6
          end
      else
          return 7
      end
  end

  def <=>(e)
      if self.priority == 1 && e.priority == 1
         return COMMON_ATTRIBUTES.index(self.name) <=> COMMON_ATTRIBUTES.index(e.name)
      elsif self.priority == 2 && e.priority == 2
         return ORGANISM_GROUP_ATTRIBUTES.index(self.name) <=> ORGANISM_GROUP_ATTRIBUTES.index(e.name)
      elsif self.priority == 3 && e.priority == 3
          if self.group == e.group
              return self.name <=> e.name
          else
              return self.group <=> e.group   
          end
      elsif self.priority == e.priority
          return self.name <=> e.name
      else
          return self.priority <=> e.priority
      end
  end
end

class BioSampleOwlWriter

    def initialize(xlsx, version = nil)
        @conf =[]
        @att_group = {}
        @package_conf = {}
        @version =  version || '1.0.0' #Date.today.to_s
        begin
            @spreadsheet = Roo::Spreadsheet.open(xlsx.shift)
        rescue
            raise Errno::ENOENT
            []
        end
        parse_attribute
        parse_package
    end

    def parse_attribute_header 
        @header = @spreadsheet.row(1)
    end 

    #def parse_package_list
    #    @packages = @header.slice(10,@header.count)
    #end 

    def parse_attribute
        @spreadsheet.default_sheet = 'attribute'
        parse_attribute_header
        #parse_package_list
        (2..@spreadsheet.last_row).each do |i| 
            @conf << Hash[[@header, @spreadsheet.row(i)].transpose]
        end 
    end 

    def parse_package_header 
        #@package_header = @package_spreadsheet.row(1)
        @package_header = @spreadsheet.row(1)
    end

    def parse_package
        @spreadsheet.default_sheet = 'package-attribute'
        parse_package_header
        (2..@spreadsheet.last_row).each do |i|
            package = @spreadsheet.cell(i,1)
            version = @spreadsheet.cell(i,2)
            @either_one_mandatory = Hash.new { |h,k| h[k] = [] }
            @group = {} 
            row = @spreadsheet.row(i).map.with_index{|x,j|
                case x
                when 'M' then 'mandatory attribute'
                when 'O' then 'optional attribute'
                when /E:(.+)/ then
                    @either_one_mandatory[$1] << @package_header[j]
                    @group[ @package_header[j]] = $1
                    "either_one_mandatory attribute"
                when '-' then 'attribute'
                else
                     x
                end
            }
            attributes =  @package_header.slice(2,@package_header.count).map.with_index do |attr,index|
                { :name => attr,
                  :type => row[index + 2],
                  :group => @group[attr] || '',
                  :class_name => att_class_name = attr.capitalize + "_Attribute"
                 }
            end
            @package_conf[package] = 
                {
                :name => package,
                :version => version,
                :attributes => attributes,
                :attribute_groups => @either_one_mandatory
            }
        end
    end


    def to_owl
       write_prefix
       write_annotation
       write_ddbj_defined_package
       #write_package_class
       write_attribute_class
       write_package_and_attribute
       write_attribute_group_each_package

    end

    # seeAlso: http://rdf.greggkellogg.net/yard/RDF/Writer.html#escaped-instance_method
    def ttl_escaped(string)
        return string if string.nil?
        string.gsub('\\', '\\\\\\\\').
        gsub("\b", '\\b').
        gsub("\f", '\\f').
        gsub("\t", '\\t').
        gsub("\n", '\\n').
        gsub("\r", '\\r').
        gsub('"', '\\"')
    end

    def write_prefix
        puts "
@base <http://ddbj.nig.ac.jp/ontologies/biosample> .
@prefix : <http://ddbj.nig.ac.jp/ontologies/biosample/> .
@prefix owl: <http://www.w3.org/2002/07/owl#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix dc: <http://purl.org/dc/elements/1.1/> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix skos: <http://www.w3.org/2004/02/skos/core#> .

"
    end

    def write_annotation
puts '
<>
    a owl:Ontology ;
    rdfs:label "DDBJ BioSample ontology" ;
    rdfs:comment "DDBJ BioSample ontology for semantic representation of the INSDC (DDBJ/ENA/GenBank) biosample records" ;
    rdfs:seeAlso <https://trace.ddbj.nig.ac.jp/biosample/index_e.html> ;
    dcterms:license <http://creativecommons.org/licenses/by/4.0/> ;
    owl:versionIRI <http://ddbj.nig.ac.jp/ontologies/biosample/' + @version +'> ;
    owl:versionInfo "version '+ @version + '" .

'
end

    def write_ddbj_defined_package
        puts "
:Package rdf:type owl:Class ;
    rdfs:label \"package\"@en;
    rdfs:comment \"package class\".

:DDBJ_Defined_Package rdf:type owl:Class ;
    rdfs:subClassOf :Package ;
    rdfs:label \"DDBJ defined package\"@en;
    rdfs:comment \"DDBJ defined package\".
"
    end

    def write_attribute_class
        puts "
:Attribute rdf:type owl:Class ;
    rdfs:label \"attribute\"@en;
    rdfs:comment \"attribute class\".
        "
        @conf.each do |attr|
            #pp attr
            class_name = attr['Harmonized name'].capitalize + "_Attribute"
            puts "
:#{class_name} rdf:type owl:Class ;
    rdfs:subClassOf :Attribute ;
    rdfs:label \"#{attr['Name']} attribute\"@en;
    dc:identifier \"#{attr['Harmonized name']}\";
    #{write_line_synonym(attr['Synonym'])}
    rdfs:comment \"#{self.ttl_escaped(attr['Description'])}\"@en;
    rdfs:comment \"#{self.ttl_escaped(attr['DescriptionJa'])}\"@ja;
    :format \"#{attr['Format']}\".
"

        end
    end

    def write_line_synonym(synonym)
        synonym.nil? ? nil : "skos:altLabel \"#{synonym}\";"
    end

    def write_package_and_attribute
        @package_conf.each do |obj, package|
            package_name = package[:name].gsub('/','-') + "_Package"
            puts "
:#{package_name} rdf:type owl:Class ;
\trdfs:subClassOf :DDBJ_Defined_Package ;
\tdc:identifier \"#{package[:name]}_v#{package[:version]}\" ;
\trdfs:label \"#{package[:name]} package\"@en ;
\towl:versioninfo \"#{package[:version]}\" ;
"
            package[:attribute_groups].each do |g, v|
                groupatt_class_name = g.capitalize.gsub('/','-') + "_Group_Attribute"
                puts "\t:has_attribute\t:#{groupatt_class_name};"
            end

            package[:attributes].sort_by{ |attr| PackageSortItem.new(attr)}.each_with_index do |v, i|
                predicate = v[:type].gsub(' ', '_')
                puts "\t:has_#{predicate}\t:#{v[:class_name]};"
                puts "\tdc:identifier \"#{package[:name].downcase}_attribute#{sprintf("%03d", i + 1)}\" ;"
            end
            puts "."
            #pp class_name
        end
    end

    def write_attribute_group_each_package
        @package_conf.each do |obj, package|
            package_name = package[:name].gsub('/','-') + "_Package"
            package[:attribute_groups].each do |g, v|
                groupatt_class_name = g.capitalize.gsub('/','-') + "_Group_Attribute" 
#                #puts ":#{groupatt_class_name}\towl:equivalentClass [
#                puts ":#{groupatt_class_name}\trdfs:subClassOf [
#                    rdfs:label \"#{g} group attribute on #{package[:name]}\";
#                    rdf:type owl:Restriction;
#                    owl:onProperty :has_group_attribute;
#                    owl:minCadinarity \"1\"^^xsd:nonNegativeInteger;
#                    owl:allValueFrom owl:oneOf(#{v.map{|a| ':' + a.capitalize + '_Attribute'}.join(', ')});
#                ]."

                puts "
[]
    a owl:Axiom ;
    rdfs:isDefinedBy :Attribute_Group ;
    owl:annotatedProperty rdfs:subClassOf ;
    owl:annotatedSource :#{groupatt_class_name} ;
    owl:annotatedTarget [
        a owl:Restriction ;
        owl:domain :#{package_name};
        rdfs:label \"#{g} group attribute in #{package[:name]}\";
        owl:minCadinarity \"1\"^^xsd:nonNegativeInteger;
        owl:onProperty :has_group_attribute;
        rdfs:range [
            owl:oneOf ( #{v.map{|a| ':' + a.capitalize + '_Attribute'}.join(' ')} )
        ];
    ] .

"
            end
        end
    end



#     def write_package_class
#        @packages.each do |package|
#            class_name = package.capitalize.gsub('/','-') + "_Package"
#            puts "
#:#{class_name} rdf:type owl:Class ;
#    rdfs:subClassOf :DDBJ_Defined_Package ;
#    rdfs:label \"#{package} package\"@en ;
#    rdfs:comment \"#{package} comment\"@en ;
#    owl:versioninfo \"#{@version}\" .
#"
#        end
#    end

end
input = ARGV # './ddbj_biosample_definition_table.xlsx'
owl = BioSampleOwlWriter.new(input)
owl.to_owl
#owl.write_package_and_attribute
#owl.write_attribute_group_each_package


