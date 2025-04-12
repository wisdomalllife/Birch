#!/bin/bash -i
#
#SBATCH --job-name=aligning
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=00:30:00
#SBATCH --output=aligning.out
#SBATCH --error=aligning.err

conda activate ragtagbase

## path
Mypath=/mnt/tank/scratch/vshumakova

## data
DATA=${Mypath}/noncarel_assembler/ragtag/nucmer2/chrs.noncarel.fasta
REF=${Mypath}/carel_assembler/masurca/ragtag/nucmer2/nucmer.fasta
REF2=${Mypath}/carel_assembler/ref/Betula_pendula_subsp._pendula.faa
OUTPUT=${Mypath}/noncarel_assembler/syri

#bwa index $REF

# whole genome alignment for further Syri analysis 
minimap2 -ax asm20 --eqx $REF $DATA > $OUTPUT/minimap_curVSnoncur.sam
minimap2 -ax asm20 --eqx $REF2 $DATA > $OUTPUT/minimap_refVSnoncur.sam

# prepare bam file for IGV visualization
samtools view -bS minimap_refVSnoncur.sam | samtools sort -o minimap_refVSnoncur.sorted.bam
samtools index minimap_refVSnoncur.sorted.bam
