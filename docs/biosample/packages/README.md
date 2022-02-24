# DDBJ BioSample packages  

## Changes on 24 February 2022   

[ddbj_biosample_definition_table.xlsx](https://github.com/ddbj/pub/blob/72054bad97a208e19c4cb6c6124ee202b5a2a131/docs/biosample/packages/archives/ddbj_biosample_definition_table_v1.4.0.xlsx)

* Package set version: 1.4.0  
* New packages added. 
	* Standard packages used for samples when it is not appropriate or advantageous to use MIxS or pathogen packages.
		* SARS-CoV-2.cl, version 1.0
		* SARS-CoV-2.wwsurv, version 1.0
		* Microbe, version 1.0
		* Model.organism.animal, version 1.0
		* Metagenome.environmental, version 1.0
		* Invertebrate, version 1.0
		* Human, version 1.0
		* Plant, version 1.0
		* Virus, version 1.0
		* Beta-lactamase, version 1.0
	* Pathogen packages used for pathogen samples that are relevant to public health.
		* Pathogen.cl, version 1.0
		* Pathogen.env, version 1.0
	* MIxS packages.
		* MIMAG: metagenome-assembled genome, version 5.0
		* MISAG: single amplified genome, version 5.0
		* MIUVIG: uncultivated virus genome, version 5.0
	* MIxS environmental packages.
		* built 
* Package changes.  
	* Functional genomics package renamed to Omics package.
* Definition added.
	* "Either one attribute is mandatory" is defined in the package-attribute sheet. For example, strain or isolate is required for the Microbe package organism attribute group (E:Organism).  

### Attribute name change {#name-change}

In the MIxS package, following attribute names are changed.  

* env_biome → env_broad_scale  
* env_feature → env_local_scale  
* env_material → env_medium  

## Changes on 15 December 2021   

[ddbj_biosample_definition_table.xlsx](https://github.com/ddbj/pub/blob/6e040b48efa18d87d78ba11c5516f027a0253ab2/docs/biosample/packages/ddbj_biosample_definition_table.xlsx)

* Package set version: 1.2.1  
* Changes: Strain is required in the MIGS.ba packages.  
## Changes on 25 July 2019   

This version is obsolete.

[ddbj_biosample_definition_table.xlsx](https://github.com/ddbj/pub/blob/a686f2383688e7d359b114c4c9353d0a6ec03292/docs/biosample/packages/ddbj_biosample_definition_table.xlsx)  

* Package set version: 1.3.0  
* Changes: Cardinality of attribute is defined in the package-attribute sheet.  
	* Attributes can be described only once: M (Mandatory), O (Optional), - (Not provided in the pre-defined package)      
	* Attributes can be described multiple times: M:N (Mandatory), O:N (Optional), -:N (Not provided in the pre-defined package)      
* New attributes "[component_organism](https://www.ddbj.nig.ac.jp/biosample/attribute.html?all=all#component_organism)" and "[metagenome_source](https://www.ddbj.nig.ac.jp/biosample/attribute.html?all=all#metagenome_source)" added.  

## Changes on 26 April 2018   

[ddbj_biosample_definition_table.xlsx](https://github.com/ddbj/pub/blob/32ea23bd13a73794cd811f73575bff3a611d27a0/docs/biosample/packages/ddbj_biosample_definition_table.xlsx)  

* Package set version: 1.2.0  
* Functional genomics package version: 1.0  
* Changes: New functional genomics package added.  

## Changes on 18 March 2018   

[ddbj_biosample_definition_table.xlsx](https://github.com/ddbj/pub/blob/8b688ed59e230bfb0f2fa5feb7a2beb7d9919551/docs/biosample/packages/ddbj_biosample_definition_table.xlsx)  

* Package set version: 1.1.0  
* Each package version: 1.1  
* Changes: taxonomy_id made optional.  



