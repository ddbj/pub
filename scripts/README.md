#
# DDBJ BioSample definition OWL convertor

## Requirements
* ruby >= 2.3
* bundler

## How to use
#### install library
```
$ bundle install --path vendor/bundle
```

#### convert
Usage: ruby biosample_excel2owl.rb xlsxファイル [OWLバージョン名]
```
$ bundle exec ruby biosample_excel2owl.rb ../docs/biosample/packages/ddbj_biosample_definition_table.xlsx "1.4.0" > output.ttl
```

#
# kakenhi/institution xml convertor into csv

## Requirements
* python >= 3.6

## How to use
#### Original input xml files
https://bitbucket.org/niijp/grants_masterxml_kaken/src/master/review_section_master_kakenhi.xml
https://bitbucket.org/niijp/grants_masterxml_kaken/src/master/institution_master_kakenhi.xml


#### convert
Usage: python xml_parser_institution.py

Usage: python xml_parser_section.py
```
$ ls *.xml
institution_master_kakenhi.xml  review_section_master_kakenhi.xml
$ python xml_parser_institution.py
$ python xml_parser_section.py
$ ls *.csv
institution_master_kakenhi.csv  review_section_master_kakenhi.csv
```
