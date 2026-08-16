#!/bin/bash -i
#
#SBATCH --job-name=repeatmodeler
#SBATCH --cpus-per-task=32
#SBATCH --mem=150G
#SBATCH --time=120:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/pacbio/annotation/model.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/pacbio/annotation/model.err

conda activate repeatmodeler
# identify repeats de novo
BuildDatabase -name karelianbirch ../RagTag/result/chrs.pacbio.fasta # Create a Database for RepeatModeler
RepeatModeler -database ref/karelianbirch -threads 32 -LTRStruct

