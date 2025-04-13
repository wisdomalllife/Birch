#!/bin/bash -i
#
#SBATCH --job-name=snakeVC
#SBATCH --cpus-per-task=2
#SBATCH --mem=20G
#SBATCH --time=96:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/masurca/SNPcalling/snake/%x-%j.log


export SBATCH_DEFAULTS=" --output=%x-%j.log"
conda activate snakemake

#snakemake --snakefile Snakefile_snpcall.smk --profile=profile -p
snakemake --snakefile Snakefile_snpcall.smk --profile=profile2 -p
