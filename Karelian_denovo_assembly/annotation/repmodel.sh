#!/bin/bash -i
#
#SBATCH --job-name=repeatmodeler
#SBATCH --cpus-per-task=32
#SBATCH --mem=150G
#SBATCH --time=120:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/masurca/Repeats/model.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/masurca/Repeats/model.err

conda activate repeatmodeler

#BuildDatabase -name karelianbirch nucmer.fasta
RepeatModeler -database karelianbirch -threads 32 -LTRStruct
