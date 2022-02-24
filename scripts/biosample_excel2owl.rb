#!/usr/bin/env ruby

require 'rubygems'
require 'roo'
require 'pp'
require 'date'


class PackageSortItem
  attr_reader :name
  attr_reader :type
  attr_reader :group
  COMMON_ATTRIBUTES = ['sample_name','sample_title','description','organism','taxonomy_id','bioproject_id', 'locus_tag_prefix']
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
    @attribute_def =[]
    @att_group = {}
    @package_conf = {}
    @version =  version || Date.today.strftime("%Y%m%d")
    begin
      @spreadsheet = Roo::Spreadsheet.open(xlsx)
    rescue
      raise Errno::ENOENT
      []
    end
    parse_attribute
    parse_package_group
    parse_package
    parse_package_attribute
  end

  def parse_attribute_header
    @header = @spreadsheet.row(1)
  end

  def parse_attribute
    @spreadsheet.default_sheet = 'attribute'
    parse_attribute_header
    (2..@spreadsheet.last_row).each do |i|
      @attribute_def << Hash[[@header, @spreadsheet.row(i)].transpose]
    end
  end

  def parse_package_group_header
    @package_group_header = @spreadsheet.row(1)
  end

  def parse_package_group
    @spreadsheet.default_sheet = 'package-group'
    header = parse_package_group_header
    @package_group_def = {}
    (2..@spreadsheet.last_row).each_with_index do |i, idx|
      package_group = @spreadsheet.cell(i, header.find_index("Package group name") + 1)
      display_name = @spreadsheet.cell(i, header.find_index("DisplayName") + 1)
      description = @spreadsheet.cell(i, header.find_index("Description") + 1)
      group = @spreadsheet.cell(i, header.find_index("Group") + 1)
      @package_group_def[package_group] =
      {
        :name => package_group,
        :display_name => display_name,
        :description => description,
        :group => group,
        :order => idx + 1
      }
    end
  end

  def parse_package_header
    @package_header = @spreadsheet.row(1)
  end
  def parse_package
    @spreadsheet.default_sheet = 'package'
    header = parse_package_header
    @package_def = {}
    (2..@spreadsheet.last_row).each_with_index do |i, idx|
      package = @spreadsheet.cell(i, header.find_index("Package name") + 1)
      version = @spreadsheet.cell(i, header.find_index("Version") + 1)
      display_name = @spreadsheet.cell(i, header.find_index("DisplayName") + 1)
      short_name = @spreadsheet.cell(i, header.find_index("ShortName") + 1)
      env_package = @spreadsheet.cell(i, header.find_index("EnvPackage") + 1)
      description = @spreadsheet.cell(i, header.find_index("Description") + 1)
      example = @spreadsheet.cell(i, header.find_index("Example") + 1)
      group = @spreadsheet.cell(i, header.find_index("Group") + 1)
      @package_def[package] =
      {
        :name => package,
        :version => version,
        :display_name => display_name,
        :short_name => short_name,
        :env_package => env_package,
        :description => description,
        :example => example,
        :group => group,
        :order => idx + 1
      }
    end
  end

  def parse_package_attribute_header
    @package_attribute_header = @spreadsheet.row(1)
  end

  def parse_package_attribute
    @spreadsheet.default_sheet = 'package-attribute'
    parse_package_attribute_header
    (2..@spreadsheet.last_row).each do |i|
      package = @spreadsheet.cell(i,1)
      version = @spreadsheet.cell(i,2)
      @either_one_mandatory = Hash.new { |h,k| h[k] = [] }
      @group = {}
      attr_type = []
      multiple = []
      @spreadsheet.row(i).map.with_index{|v,j|
        if v.start_with?("M")
          attr_type.push("mandatory attribute")
        elsif v.start_with?("O")
          attr_type.push("optional attribute")
        elsif v =~ /E:(.+)/
          @either_one_mandatory[$1] << @package_attribute_header[j]
          @group[@package_attribute_header[j]] = $1
          attr_type.push("either_one_mandatory attribute")
        elsif v.start_with?("-")
          attr_type.push("attribute")
        else
          attr_type.push(v)
        end

        # multiple flag
        if v.end_with?(":N")
          multiple.push(true)
        else
          multiple.push(false)
        end
      }
      attributes =  @package_attribute_header.slice(2,@package_attribute_header.count).map.with_index do |attr,index|
        {
          :name => attr,
          :type => attr_type[index + 2],
          :multiple => multiple[index + 2],
          :group => @group[attr] || '',
          :class_name => attr.capitalize + "_Attribute"
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
    puts write_prefix
    puts write_annotation
    puts write_package_group_class
    puts write_package_class
    puts write_attribute_class
    puts write_package_and_attribute
    puts write_attribute_group_each_package
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
    text = <<~"EOS"
      @base <http://ddbj.nig.ac.jp/ontologies/biosample> .
      @prefix : <http://ddbj.nig.ac.jp/ontologies/biosample/> .
      @prefix owl: <http://www.w3.org/2002/07/owl#> .
      @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
      @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
      @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
      @prefix dc: <http://purl.org/dc/elements/1.1/> .
      @prefix dcterms: <http://purl.org/dc/terms/> .
      @prefix skos: <http://www.w3.org/2004/02/skos/core#> .
      @prefix sio: <http://semanticscience.org/resource/> .


    EOS
    text
  end

  def write_annotation
    text = <<~"EOS"
      <>
        a owl:Ontology ;
        rdfs:label "DDBJ BioSample ontology" ;
        rdfs:comment "DDBJ BioSample ontology for semantic representation of the INSDC (DDBJ/ENA/GenBank) biosample records" ;
        rdfs:seeAlso <https://trace.ddbj.nig.ac.jp/biosample/index_e.html> ;
        dcterms:license <http://creativecommons.org/licenses/by/4.0/> ;
        owl:versionIRI <http://ddbj.nig.ac.jp/ontologies/biosample/#{@version}> ;
        owl:versionInfo "version #{@version}" .


    EOS
    text
  end

  def write_package_group_class
    text = <<~"EOS"
      :PackageGroup rdf:type owl:Class ;
        rdfs:label "package group"@en;
        rdfs:comment "package group class".

    EOS

    @package_group_def.each do |name, package_group|
      class_name = package_group[:name].gsub('/','-') + "_PackageGroup"
      sub_package_text = ""
      unless package_group[:group].nil? || package_group[:group] == ""
        sub_package_text = "sio:SIO_000095 :#{package_group[:group].gsub('/','-')}_PackageGroup ;"
      end
      text += <<~"EOS"
        :#{class_name} rdf:type owl:Class ;
          rdfs:subClassOf :PackageGroup ;
          #{sub_package_text}
          rdfs:label "#{self.ttl_escaped(package_group[:display_name])}"@en;
          dc:identifier "#{package_group[:name]}";
          dcterms:description "#{self.ttl_escaped(package_group[:description])}"@en;
          :display_order #{package_group[:order]} .

      EOS
    end
    text
  end

  def write_package_class
    text = <<~"EOS"
      :Package rdf:type owl:Class ;
        rdfs:label "package"@en;
        rdfs:comment "package class".

      :DDBJ_Defined_Package rdf:type owl:Class ;
        rdfs:subClassOf :Package ;
        rdfs:label "DDBJ defined package"@en;
        rdfs:comment "DDBJ defined package".

    EOS
    @package_def.each do |name, package|
      package_name = package[:name].gsub('/','-').gsub(' ','-') + "_Package"
      sub_package_text = ""
      unless package[:group].nil? || package[:group] == ""
        sub_package_text = "sio:SIO_000095 :#{package[:group].gsub('/','-').gsub(' ','-')}_PackageGroup ;"
      end
      text << <<~"EOS"
        :#{package_name} rdf:type owl:Class ;
          rdfs:subClassOf :DDBJ_Defined_Package ;
          #{sub_package_text}
          dc:identifier "#{package[:name]}" ;
          rdfs:label "#{package[:display_name]}"@en ;
          skos:altLabel "#{package[:short_name]}"@en ;
          :envPackage "#{package[:env_package]}"@en ;
          dcterms:description "#{self.ttl_escaped(package[:description])}"@en ;
          owl:versioInfo "#{package[:version]}" ;
          :display_order #{package[:order]} .

      EOS
    end
    text
  end

  def write_attribute_class
    text = <<~"EOS"
      :Attribute rdf:type owl:Class ;
        rdfs:label "attribute"@en;
        rdfs:comment "attribute class".


    EOS
    @attribute_def.each do |attr|
      class_name = attr['Harmonized name'].capitalize + "_Attribute"
      text += <<~"EOS"
        :#{class_name} rdf:type owl:Class ;
          rdfs:subClassOf :Attribute ;
          rdfs:label "#{attr['Name']} attribute"@en;
          dc:identifier "#{attr['Harmonized name']}";
          #{write_line_synonym(attr['Synonym'])}
          rdfs:comment "#{self.ttl_escaped(attr['Description'])}"@en;
          rdfs:comment "#{self.ttl_escaped(attr['DescriptionJa'])}"@ja;
          :format "#{attr['Format']}".

      EOS
    end
    text
  end

  def write_line_synonym(synonym)
    synonym.nil? ? nil : "skos:altLabel \"#{synonym}\";"
  end

  def write_package_and_attribute
    text = ""
    @package_conf.each do |obj, package|
      text << "\n\n"
      package_name = package[:name].gsub('/','-').gsub(' ','-') + "_Package"
      package[:attributes].sort_by{ |attr| PackageSortItem.new(attr)}.each_with_index do |v, i|
        predicate = v[:type].gsub(' ', '_')
        max_cardinality_num = v[:type].start_with?("mandatory") ? 1 : 0
        max_cardinality_triple = v[:multiple] ? "" : "owl:maxCardinality \"1\"^^xsd:nonNegativeInteger ;"
        text << <<~"EOS"
          []
            a owl:Axiom ;
            rdfs:isDefinedBy :#{package_name} ;
            dc:identifier "#{package[:name].downcase}_attribute#{sprintf("%03d", i + 1)}" ;
            owl:annotatedProperty [
              a owl:Restriction ;
              owl:onProperty :has_#{predicate} ;
              owl:minCardinality "#{max_cardinality_num}"^^xsd:nonNegativeInteger ;
              #{max_cardinality_triple}
            ] ;
            owl:annotatedSource :#{package_name} ;
            owl:annotatedTarget :#{v[:class_name]} .

        EOS
      end
    end
    text
  end

  def write_attribute_group_each_package
    text = ""
    @package_conf.each do |obj, package|
      package_name = package[:name].gsub('/','-') + "_Package"
      package[:attribute_groups].each do |g, v|
        groupatt_class_name = g.gsub('/','-') + "_Group_Attribute"

        text += <<~"EOS"
          []
            a owl:Axiom ;
            rdfs:isDefinedBy :Attribute_Group ;
            owl:annotatedProperty rdfs:subClassOf ;
            owl:annotatedSource :#{groupatt_class_name} ;
            owl:annotatedTarget [
              a owl:Restriction ;
              owl:domain :#{package_name};
              rdfs:label "#{g} group attribute in #{package[:name]}";
              owl:minCardinality "1"^^xsd:nonNegativeInteger;
              owl:onProperty :has_group_attribute;
              rdfs:range [
                owl:oneOf ( #{v.map{|a| ':' + a.capitalize + '_Attribute'}.join(' ')} )
              ];
            ] .

        EOS
      end
    end
    text
  end

end

if ARGV.size < 1
  STDERR.puts "Usage: ruby biosample_excel2owl.rb xlsxファイル [OWLバージョン名]"
  STDERR.puts "Example: bundle exec ruby biosample_excel2owl.rb ../docs/biosample/packages/archives/ddbj_biosample_definition_table_v1.4.0.xlsx '1.4.0' > ../docs/biosample/packages/archives/ddbj_biosample_definition_table_v1.4.0.ttl"
  exit(1)
end
input = ARGV.shift # './ddbj_biosample_definition_table.xlsx'
version = ARGV.shift
owl = BioSampleOwlWriter.new(input, version)
owl.to_owl