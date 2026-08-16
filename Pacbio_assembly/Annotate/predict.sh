#!/bin/bash -i
#
#SBATCH --job-name=augustus
#SBATCH --cpus-per-task=8
#SBATCH --mem=120G
#SBATCH --time=48:00:00

conda activate augustus

# used softmasked genome
augustus --species=arabidopsis MaskerOutput/chrs.pacbio.fasta.masked > karelian.gff

# grep -v "#" karelian.gff | grep "gene[[:space:]]" | wc -l
# 26293