#!/bin/bash -i
#
#SBATCH --job-name=bwa
#SBATCH --cpus-per-task=8
#SBATCH --mem=60G
#SBATCH --array=1-2
#SBATCH --time=48:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.soap.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.soap.err

conda activate polishing

# alignment of filtered reads to the non-Karelian assembly using BWA
# 2 samples were aligned separetly and then sorted with samtools

## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler
Mypath2=/mnt/tank/scratch/vshumakova/noncarel_assembler
assembly=${Mypath2}/masurca/CA/primary.genome.scf.fasta

DATA=${Mypath}/trimmed
i=$SLURM_ARRAY_TASK_ID
FQ=${Mypath2}/polish/files_bwa.txt #list of input's names
FQBase=$(sed "${i}q;d" $FQ) # grab line number i
OUTPUT=${Mypath2}/polish/bwa

# index the assembly for bwa
#bwa index $assembly

# aligning
bwa mem -t 8 $assembly \
        $DATA/${FQBase}.1_paired.fq.gz \
        $DATA/${FQBase}.2_paired.fq.gz \
        | samtools sort -o $OUTPUT/${FQBase}.sorted.bam

samtools index $OUTPUT/${FQBase}.sorted.bam
