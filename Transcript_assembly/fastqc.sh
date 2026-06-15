#!/bin/bash -i
#
#SBATCH --job-name=fastqc
#SBATCH --cpus-per-task=3
#SBATCH --mem=20G
#SBATCH --time=03:00:00
#SBATCH --array=1-13

conda activate mybase_new

## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler/rnaseqcomparison

## data
DATA=${Mypath}/reads

i=$SLURM_ARRAY_TASK_ID
FQ=${Mypath}/SRR.numbers #list of input's names
FQBase=$(sed "${i}q;d" $FQ) # grab line number i
OUTPUT=${Mypath}/reads/fastqc


fastqc -o $OUTPUT $DATA/${FQBase}_1.fastq
fastqc -o $OUTPUT $DATA/${FQBase}_2.fastq

#multiqc fastqc

