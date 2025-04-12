#!/bin/bash -i
#
#SBATCH --job-name=syri
#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.aligning.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.aligning.err

conda activate mysyri

## path
Mypath=/mnt/tank/scratch/vshumakova

## data
REF=${Mypath}/carel_assembler/masurca/ragtag/nucmer2/nucmer.fasta
DATA=${Mypath}/noncarel_assembler/ragtag/nucmer2/chrs.noncarel.fasta
OUTPUT=${Mypath}/noncarel_assembler/syri

# Syri analysis for structural variations and its visualization
syri -c minimap_curVSnoncur.sam -r $REF -q $DATA -k -F S
# bioawk -c fastx '{print $name, length($seq) }' chrs.noncarel.fasta > noncur.chrlen
plotsr  --sr syri.out --genomes genomes2.txt -o noncur_vs_cur.png -H 8 -W 5 -s 10
