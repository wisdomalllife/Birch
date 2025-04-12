#!/bin/bash -i
#
#SBATCH --job-name=buscoquality
#SBATCH --cpus-per-task=10
#SBATCH --mem=200G
#SBATCH --time=01:00:00

conda activate busco_new

## path
Mypath=/mnt/tank/scratch/vshumakova/noncarel_assembler

## data
DATA1=${Mypath}/masurca/CA/primary.genome.scf.fasta
DATA2=${Mypath}/polish/pilon/noncarel.polished.fasta
DATA3=${Mypath}/ragtag/scaf_output/chrs.noncarel.fasta
DATA4=${Mypath}/ragtag/nucmer2/chrs.noncarel.fasta


# busco
#python --version

#busco -i $DATA1 -m genome --offline --cpu 10 --lineage_dataset ${Mypath}/busco/embryophyta_odb10 -o masurca
#busco -i $DATA2 -m genome --offline --cpu 10 --lineage_dataset ${Mypath}/busco/embryophyta_odb10 -o pilon
#busco -i $DATA3 -m genome --offline --cpu 10 --lineage_dataset ${Mypath}/busco/embryophyta_odb10 -o ragtag
busco -i $DATA4 -m genome --offline --cpu 10 --lineage_dataset ${Mypath}/busco/embryophyta_odb10 -o ragtag2
#generate_plot.py -wd ${Mypath}/summaries
