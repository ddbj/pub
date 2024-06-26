# DDBJ Sequence Read Archive (DRA) XML Schema

## Changes to Common XML 1.6.0 on 14 February 2024

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

## Changes to Common XML 1.5.9 on 7 July 2021

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

## Changes to Experiment XML 1.5.9 on 7 July 2021

### Library strategy changes

* New library strategies:
	* NOMe-Seq

## Changes to Common XML 1.5.8 on 12 September 2018

New schema effective from 12 September 2018: [SRA.common.xsd](https://github.com/ddbj/pub/blob/e478bd21b6626ff3aedff25f7638f1fea87bb9a0/docs/dra/xsd/1-5/SRA.common.xsd)

### Instrument model changes

* New instrument model:
	* Illumina iSeq 100
	* Illumina NovaSeq 6000

## Changes to Common XML 1.5.7 on 28 June 2017

New schema effective from 28 June 2017: [SRA.common.xsd](https://github.com/ddbj/pub/blob/d4720e692c29702f9cfb2a0ef80d49dec414be97/docs/dra/xsd/1-5/SRA.common.xsd)

### Instrument model changes

* New instrument model:
	* Illumina MiniSeq
	* Ion Torrent S5
	* Ion Torrent S5 XL

## Changes to Common XML 1.5.6 on 9 November 2016

New schema effective from 9 November 2016: [SRA.common.xsd](https://github.com/ddbj/pub/blob/10cbb9b98d126dfd45dd634c660f88c0529ffe2a/docs/dra/xsd/1-5/SRA.common.xsd#L635)

### Instrument model changes

* New instrument model:
	* PacBio Sequel

## Changes to Experiment XML 1.5.5 on 13 July 2016

New schema effective from 13 July 2016: [SRA.experiment.xsd](https://github.com/ddbj/pub/blob/32baff70a3e5551af7a5ede35ba82b6d2d43c381/docs/dra/xsd/1-5/SRA.experiment.xsd)

### Library selection changes

* New library selections:
	* cDNA_randomPriming
	* cDNA_oligo_dT
	* PolyA
	* Oligo-dT and Inverse rRNA

### Library strategy changes

* New library strategies:
	* ssRNA-seq
	* RAD-Seq
	* Hi-C
	* ATAC-seq
	* Targeted-Capture
	* Tethered Chromatin Conformation Capture and Synthetic-Long-Read

### Instrument model changes

* New instrument models:
	* Ilumina HiSeq 3000
	* Illumina HiSeq 4000
	* HiSeq X Five
	* NextSeq 550 and PromethION
