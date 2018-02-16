#!/bin/sh
#$ -S /bin/sh
#$ -cwd 
#$ -l s_vmem=10G,mem_req=10G
#$ -l short
#$ -pe def_slot 1
#$ -o ./log
#$ -e ./log

source ~/.bashrc
cd /home/takeshik/tanomare/dstep20180126


java -jar ~/src/trimmomatic/Trimmomatic-0.36/trimmomatic-0.36.jar PE ERR003990_1.fastq ERR003990_2.fastq ERR003990_1.trimmomatic.fq ERR003990_1.trimmomatic.unp.fq ERR003990_2.trimmomatic.fq ERR003990_2.trimmomatic.unp.fq TRAILING:8 MINLEN:36 
