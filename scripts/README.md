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
