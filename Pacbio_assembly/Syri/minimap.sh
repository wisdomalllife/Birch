#!/bin/bash -i
#
#SBATCH --job-name=aligning
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=00:30:00

conda activate ragtagbase

## data
DATA=../RagTag/result/chrs.pacbio.fasta
REF=../../ref/Betula_pendula_subsp._pendula.faa

#bwa index $REF

# whole genome alignment for further Syri analysis (only chr10, reverse complimentary or else Syri gives error)

grep -A 1 'Chr10' ../RagTag/result/chrs.pacbio.fasta > chromosoms/chr10.fasta
bioawk -c fastx '$name == "lcl|Bpe_Chr10_RagTag" {print ">"$name"\n"revcomp($seq)}' chr10.fasta > Chr10_reverse.fasta
bioawk -c fastx '$name == "lcl|Bpe_Chr10" {print ">"$name"\n"$seq}' ../../ref/Betula_pendula_subsp._pendula.faa > chromosoms/refchr10.fasta
minimap2 -ax asm20 --eqx chromosoms/refchr10.fasta chromosoms/Chr10_reverse.fasta > Chr10_refVSkarel.sam

# for IGV visualization
#minimap2 -ax asm20 --eqx $REF $DATA > minimap_refVSkarel.sam
#samtools view -bS minimap_refVSkarel.sam | samtools sort -o minimap_refVSkarel.sorted.bam
#samtools index minimap_refVSkarel.sorted.bam
