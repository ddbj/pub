#!/bin/sh
#$ -S /bin/bash
#$ -cwd
#$ -l short
#$ -l s_vmem=1G,mem_req=1G
#$ -o ./
#$ -e ./

source ~/.bashrc

FASTQDUMP="/usr/local/pkg/sra-tools/2.5.7/bin/fastq-dump.2.5.7"
Dbdir="/home/takeshik/tanomare/dstep20180126"

arr=( "ERR003990" )

for f in ${arr[@]}
do
  make SRA=$f.sra
  $FASTQDUMP --split-files $f.sra
done


