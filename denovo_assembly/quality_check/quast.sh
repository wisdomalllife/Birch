#!/bin/bash -i
conda activate quast

#SBATCH --job-name=qality
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=48:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.assemble.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.assemble.err


## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler

## data
DATA=${Mypath}/masurca/quast
REF=${Mypath}/ref/Betula_pendula_subsp._pendula.faa

# quast
quast $DATA/primary.genome.scf.fasta \
        -r $REF \
        -o birchquast
