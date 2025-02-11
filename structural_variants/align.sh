#!/bin/bash -i
conda activate ragtagbase

#SBATCH --job-name=aligning
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=00:30:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.aligning.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.aligning.err

# align fresh assembly to the reference before using SYRI

## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler

## data
DATA=${Mypath}/masurca/ragtag/scaf_output/chr.fasta
REF=${Mypath}/ref/Betula_pendula_subsp._pendula.faa
OUTPUT=${Mypath}/masurca/syri

#bwa index $REF

# aligning
minimap2 -ax asm20 --eqx $REF $DATA > $OUTPUT/chr.sam
