#!/bin/bash -i
conda activate masurcaotconda

#SBATCH --job-name=assembly
#SBATCH --cpus-per-task=64
#SBATCH --mem=512G
#SBATCH --time=240:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/masurca/ass.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/masurca/ass.err


## path
#Mypath=/mnt/tank/scratch/vshumakova/carel_assembler

## data
#DATA=${Mypath}/fastq
#Mazurka=${Mypath}/masurca/MaSuRCA-4.1.1


# Masurca
./assemble.sh