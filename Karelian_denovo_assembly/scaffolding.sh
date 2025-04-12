#!/bin/bash -i
conda activate ragtagbase

#SBATCH --job-name=scaffolding
#SBATCH --cpus-per-task=10
#SBATCH --mem=120G
#SBATCH --time=48:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.aligning.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.aligning.err

# scaffolds orientation based on mapping to the reference

# path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler

## data
assembly=${Mypath}/masurca/pilon/scaffold_polished.fasta
REF=${Mypath}/ref/Betula_pendula_subsp._pendula.fasta

# patch
ragtag.py scaffold -o scaf_output --aligner nucmer $REF $assembly
