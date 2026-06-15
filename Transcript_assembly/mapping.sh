#!/bin/bash -i
#
#SBATCH --job-name=map
#SBATCH --cpus-per-task=3
#SBATCH --mem=30G
#SBATCH --time=12:00:00
#SBATCH --array=1-13

conda activate rnaseq

## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler/rnaseqcomparison
REF=/mnt/tank/scratch/vshumakova/carel_assembler/ref/Betula_pendula_subsp._pendula.faa
IDX=/mnt/tank/scratch/vshumakova/carel_assembler/ref/hisat2idx

i=$SLURM_ARRAY_TASK_ID
FQ=${Mypath}/SRR.numbers #list of input's names
FQBase=$(sed "${i}q;d" $FQ) # grab line number i
DATA=${Mypath}/readstrimmed
OUTPUT=${Mypath}/aligned

# index file:
#hisat2-build $REF $IDX/Betula_pendula_subsp._pendula_hisat2idx
# align
hisat2 -p 3 -x $IDX/Betula_pendula_subsp._pendula_hisat2idx \
-1 $DATA/${FQBase}_trimmed_1.fq.gz -2 $DATA/${FQBase}_trimmed_2.fq.gz \
 | samtools sort -o $OUTPUT/${FQBase}.sorted.bam

#-S $OUTPUT/${FQBase}.sam
samtools index $OUTPUT/${FQBase}.sorted.bam