#!/bin/bash -i
#
#SBATCH --job-name=repeatmasker
#SBATCH --cpus-per-task=20
#SBATCH --mem=120G
#SBATCH --time=96:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/masurca/Repeats/mask.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/masurca/Repeats/mask.err

conda activate repeatmodeler

## path
Mypath=/mnt/tank/scratch/vshumakova/annotate/annotation
RepeatMasker -pa 20 -a -s -gff -dir MaskerOutput -lib karelianbirch-families.fa nucmer.fasta
buildSummary.py nucmer.fasta.out