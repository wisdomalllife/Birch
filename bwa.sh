#!/bin/bash -i
conda activate polishing

#SBATCH --job-name=bwa
#SBATCH --cpus-per-task=8
#SBATCH --mem=60G
#SBATCH --array=1-4
#SBATCH --time=48:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.soap.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.soap.err


## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler
assembly=${Mypath}/masurca/birch/CA/primary.genome.scf.fasta

DATA=${Mypath}/trimmed
i=$SLURM_ARRAY_TASK_ID
FQ=${Mypath}/masurca/pilon/files_bwa.txt #list of input's names
FQBase=$(sed "${i}q;d" $FQ) # grab line number i
OUTPUT=${Mypath}/masurca/pilon/bwa

# index the assembly for bwa
#bwa index $assembly

# aligning
bwa mem -t 8 $assembly \
        $DATA/${FQBase}.1_paired.fq.gz \
        $DATA/${FQBase}.2_paired.fq.gz \
        | samtools sort -o $OUTPUT/${FQBase}.sorted.bam

samtools index $OUTPUT/${FQBase}.sorted.bam
