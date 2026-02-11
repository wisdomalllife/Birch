#!/bin/bash -i
conda activate mybase

#SBATCH --job-name=trimming
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=48:00:00
#SBATCH --array=1-6
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.aligning.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.aligning.err


## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler

## data
DATA=${Mypath}/fastq

i=$SLURM_ARRAY_TASK_ID
FQ=${Mypath}/files_bwa.txt #list of input's names
FQBase=$(sed "${i}q;d" $FQ) # grab line number i
OUTPUT=${Mypath}/trimmed

# trimmomatic

trimmomatic PE -phred33 $DATA/${FQBase}1.fq.gz $DATA/${FQBase}2.fq.gz\
        $OUTPUT/${FQBase}.1_paired.fq.gz $OUTPUT/${FQBase}.1_unpaired.fq.gz\
        $OUTPUT/${FQBase}.2_paired.fq.gz $OUTPUT/${FQBase}.2_unpaired.fq.gz\
        ILLUMINACLIP:NexteraPE-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 MINLEN:80