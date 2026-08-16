#!/bin/bash -i
#
#SBATCH --job-name=syri
#SBATCH --cpus-per-task=6
#SBATCH --mem=120G
#SBATCH --time=01:00:00

#conda activate syri_env
conda activate mysyri

## path
Mypath=/mnt/tank/scratch/vshumakova

## data
DATA=../RagTag/result/chrs.pacbio.fasta
REF=../../ref/Betula_pendula_subsp._pendula.faa
#syri -c minimap_refVSkarel.sam -r $REF -q $DATA -k -F S

bioawk -c fastx '{print $name, length($seq) }' ../../ref/Betula_pendula_subsp._pendula.faa > ref.chrlen
bioawk -c fastx '{print $name, length($seq) }' ../RagTag/result/chrs.pacbio.fasta > karel.chrlen

syri -c Chr10_refVSkarel.sam -r chromosoms/refchr10.fasta -q chromosoms/Chr10_reverse.fasta -F S # syri
plotsr  --sr syri.out --genomes genomes.txt -o ref_vs_karel.png -H 8 -W 10 -s 10000 # plot
