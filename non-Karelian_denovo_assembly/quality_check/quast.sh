#!/bin/bash -i
#
#SBATCH --job-name=quality
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=06:00:00

conda activate quast

## path
Mypath=/mnt/tank/scratch/vshumakova

## data
#DATA=${Mypath}/noncarel_assembler/masurca/CA/primary.genome.scf.fasta
#DATA=${Mypath}/noncarel_assembler/ragtag/scaf_output/chrs.noncarel.fasta
DATA2=${Mypath}/noncarel_assembler/ragtag/nucmer2/chrs.noncarel.fasta
REF=${Mypath}/carel_assembler/ref/Betula_pendula_subsp._pendula.faa

# quast
quast $DATA2 -r $REF -o ragtagquast2
