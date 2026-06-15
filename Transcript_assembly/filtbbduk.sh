#!/bin/bash -i
#
#SBATCH --job-name=trim
#SBATCH --cpus-per-task=3
#SBATCH --mem=20G
#SBATCH --time=12:00:00
#SBATCH --array=1-13

conda activate rnaseq

## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler/rnaseqcomparison
DATA=${Mypath}/reads

i=$SLURM_ARRAY_TASK_ID
FQ=${Mypath}/SRR.numbers #list of input's names
FQBase=$(sed "${i}q;d" $FQ) # grab line number i
OUTPUT=${Mypath}/readstrimmed

# preprocessing
bbduk.sh -Xmx5G in=$DATA/${FQBase}_1.fastq in2=$DATA/${FQBase}_2.fastq \
out=$OUTPUT/${FQBase}_trimmed_1.fq.gz out2=$OUTPUT/${FQBase}_trimmed_2.fq.gz \
tbo tpe ref=adapters \
ktrim=r k=23 mink=11 hdist=1 \
ftm=5 minlength=100 qtrim=rl trimq=20 maq=10

#trim adapters based on pair overlap detection, trim both reads to the same length
#Trim kmers to the right, kmer size, Look for shorter kmers with lengths from 23 to 11, Hamming distance
#Minimum read length of read to be kept,Quality trim the right and the left sides,Quality cutoff, Filters out reads with average quality BELOW 10
