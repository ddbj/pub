# DDBJ Japanese Genotype-phenotype Archive (JGA) XML Schema 

## Changes to Common XML 1.3.0 on xx yyyy 2025

### New platforms and instrument models

GENAPSYS
* GS111
* unspecified

DNBSEQ
* DNBSEQ-G400
* DNBSEQ-G400 FAST
* DNBSEQ-T7
* DNBSEQ-G50
* unspecified

ELEMENT
* Element AVITI
* unspecified

GENEMIND
* GenoCare 1600
* GenoLab M
* FASTASeq 300
* unspecified

ULTIMA
* UG 100
* unspecified

TAPESTRI
* Tapestri
* unspecified

### New instrument models

LS454
* unspecified

ILLUMINA
* Illumina HiSeq X
* Illumina NovaSeq X
* unspecified

HELICOS
* unspecified

ABI_SOLID
* unspecified

COMPLETE_GENOMICS
* unspecified

BGISEQ
* BGISEQ-50

PACBIO_SMRT
* Sequel IIe
* Onso
* Revio
* unspecified

ION_TORRENT
* Ion Torrent Genexus

CAPILLARY
* unspecified

OXFORD_NANOPORE
* unspecified

VELA_DIAGNOSTICS
* unspecified

### Instrument model moves

The following three models were moved from BGISEQ to DNBSEQ.

BGISEQ
* DNBSEQ-G400
* DNBSEQ-T7
* DNBSEQ-G50

### Platform name changes

* Vela_Diagnostics to VELA_DIAGNOSTICS

## Changes to Common XML 1.2.0 on 2 March 2022

### Instrument model changes  

* New instrument model:  
	* NextSeq 1000
	* NextSeq 2000
	* BGISEQ-500
	* DNBSEQ-G400
	* DNBSEQ-T7
	* DNBSEQ-G50
	* MGISEQ-2000RS
	* Sequel II
	* Ion GeneStudio S5
	* Ion GeneStudio S5 plus
	* Ion GeneStudio S5 prime

## Changes to Experiment XML 1.2.0 on 2 March 2022    

### Library strategy changes  

* New library strategies:  
	* NOMe-Seq 

## Changes to Analysis XML 1.2.0 on 2 March 2022    

### Analysis type changes  

* New analysis types added:  
	* ABUNDANCE_MEASUREMENT
	* METABOLOMICS
	* PROTEOMICS
	* BIOCHEMICAL_ASSAY
	* OTHER

### Experiment type changes  

* New experiment types for SEQUENCE_VARIATION added:  
	* Short genetic variations
	* Structural variations

## Changes to Common XML 1.1.0 on 22 November 2018  

New schema effective from 22 November 2018: [JGA.common.xsd](https://github.com/ddbj/pub/blob/5525a5b5842515411ffb5a62730b2bf223819d8f/docs/jga/xsd/1-1/JGA.common.xsd)  

### Instrument model changes  

* New instrument model:  
	* Illumina NovaSeq 6000       
	* Illumina iSeq 100       

## Changes to Common XML 1.0.9 on 19 July 2017  

New schema effective from 19 July 2017: [JGA.common.xsd](https://github.com/ddbj/pub/blob/b109f64b01a4af4d434aa225c6570fd3f44294b5/docs/jga/xsd/1-0/JGA.common.xsd)  

### Instrument model changes  

* New instrument model:  
	* Illumina MiniSeq    
	* Ion Torrent S5    
	* Ion Torrent S5 XL    

## Changes to Analysis XML 1.0.9 on 19 July 2017  

New schema effective from 19 July 2017: [JGA.analysis.xsd](https://github.com/ddbj/pub/blob/b109f64b01a4af4d434aa225c6570fd3f44294b5/docs/jga/xsd/1-0/JGA.analysis.xsd)  

* New analysis type:  
	* MICROARRAY    
	* IMAGE  
	* DOCUMENT   

* New filetype:  
	* CEL  
	* CHP  
	* CNCHP  
	* IDAT  
	* raw_array_data  
	* normalized_array_data  
	* pedigree_file  
	* data_dictionary  
	* document  
	* image  
	* NIfTI  
	* Analyze  

## Changes to Common XML 1.0.8 on 11 January 2017  

New schema effective from 11 January 2017: [JGA.common.xsd](https://github.com/ddbj/pub/blob/71a9db338f6d23177860db0a357148acc30ec9d9/docs/jga/xsd/1-0/JGA.common.xsd)  

### Instrument model changes  

* New instrument model:  
	* Illumina HiSeq 1500  
	* Illumina HiSeq 3000  
	* Illumina HiSeq 4000  
	* HiSeq X Five  
	* HiSeq X Ten  
	* NextSeq 500  
	* NextSeq 550  
	* AB 5500xl-W Genetic Analysis System  
	* PacBio RS II  
	* Sequel  
	* Oxford Nanopore MinION  
	* Oxford Nanopore GridION  
	* Oxford Nanopore PromethION  

## Changes to Experiment XML 1.0.8 on 11 January 2017  

New schema effective from 11 January 2017: [JGA.experiment.xsd](https://github.com/ddbj/pub/blob/71a9db338f6d23177860db0a357148acc30ec9d9/docs/jga/xsd/1-0/JGA.experiment.xsd)  

### Sequencing library strategy changes  

* New library strategies:  
	* ssRNA-seq 
	* Synthetic-Long-Read   
	* Targeted-Capture  
	* Tethered Chromatin Conformation Capture and Synthetic-Long-Read  

### Library selection changes  

* New library selections:  
	* cDNA_randomPriming  
	* cDNA_oligo_dT  
	* PolyA  
	* Oligo-dT 
	* Inverse rRNA  

## Changes to Dataset XML 1.0.8 on 11 January 2017  

New schema effective from 11 January 2017: [JGA.dataset.xsd](https://github.com/ddbj/pub/blob/71a9db338f6d23177860db0a357148acc30ec9d9/docs/jga/xsd/1-0/JGA.dataset.xsd)  

* Dataset type made optional  

