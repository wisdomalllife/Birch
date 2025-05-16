#!/bin/bash -i
#
#SBATCH --job-name=augustus
#SBATCH --cpus-per-task=8
#SBATCH --mem=120G
#SBATCH --time=48:00:00

conda activate augustus
## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler
## data
DATA=${Mypath}/masurca/ragtag/nucmer2/nucmer.fasta

augustus --species=arabidopsis $DATA > karelian.gff
#grep -v "#" karelian.gff | grep "gene[[:space:]]" | wc -l
