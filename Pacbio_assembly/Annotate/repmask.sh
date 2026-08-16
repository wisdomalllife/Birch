#!/bin/bash -i
#
#SBATCH --job-name=repeatmasker
#SBATCH --cpus-per-task=20
#SBATCH --mem=120G
#SBATCH --time=96:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/pacbio/annotation/mask.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/pacbio/annotation/mask.err

conda activate repeatmodeler

#RepeatMasker --help
# https://www.dfam.org/releases/current/families/FamDB/
# ./famdb.py lineage -ad arabidopsis
# ~/miniconda3/envs/repeatmodeler/share/RepeatMasker/famdb.py lineage Magnoliophyta -ad
#RepeatMasker -species arabidopsis -pa 20 -a -s -gff -xsmall -dir MaskerOutput ../RagTag/result/chrs.pacbio.fasta

RepeatMasker -pa 20 -a -s -gff -xsmall -dir MaskerOutput -lib ref/karelianbirch-families.fa ../RagTag/result/chrs.pacbio.fasta