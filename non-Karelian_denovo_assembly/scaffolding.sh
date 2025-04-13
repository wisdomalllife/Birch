#!/bin/bash -i
#
#SBATCH --job-name=scaffolding
#SBATCH --cpus-per-task=10
#SBATCH --mem=120G
#SBATCH --time=48:00:00

conda activate ragtagbase
#scaffolds orientation based on mapping to the reference

## path
Mypath=/mnt/tank/scratch/vshumakova

## data
assembly=${Mypath}/noncarel_assembler/polish/pilon/noncarel.polished.fasta
REF=${Mypath}/carel_assembler/ref/Betula_pendula_subsp._pendula.fasta

ragtag.py scaffold -o nucmer2 --aligner nucmer --nucmer-params='--maxmatch -l 50 -c 100' $REF $assembly
# take only Chrs (ragtag keeps unused scaffs)
#grep -A 1 '^>lcl' ragtag.scaffold.fasta > chrs.noncarel.fasta
