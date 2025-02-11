#!/bin/bash -i
conda activate ragtagbase

#SBATCH --job-name=patching
#SBATCH --cpus-per-task=10
#SBATCH --mem=120G
#SBATCH --time=48:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.aligning.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.aligning.err

# closing gaps in masurca assembly (Target) with RagTag patch that uses reference genome (Query)

## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler

## data
Target=${Mypath}/masurca/birch/CA/primary.genome.scf.fasta
Query=${Mypath}/ref/Betula_pendula_subsp._pendula.fasta

# patch
ragtag.py patch $Target $Query
