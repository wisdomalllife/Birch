#!/bin/bash -i
#
#SBATCH --job-name=polish
#SBATCH --cpus-per-task=64
#SBATCH --mem=512G
#SBATCH --time=240:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.soap.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.soap.err

conda activate polishing

# polishing step with Pilon
# Pilon requires BAM files of reads aligned to the input genome therefore bamdata was prepared in advance
# Additionally duplicates were marked in BAM files to use duplicates flag
# a file listing changes in the output file will be generated

## path
Mypath=/mnt/tank/scratch/vshumakova/noncarel_assembler
assembly=${Mypath}/masurca/CA/primary.genome.scf.fasta
bamdata=${Mypath}/polish/markbwa
directory=${Mypath}/polish/pilon

# run pilon
pilon -Xmx512G --genome $assembly \
	--frags $bamdata/S2_EKDL240002135-1A_22375FLT4_L5_.dup.bam \
	--frags $bamdata/S6_EKDL240002135-1A_22375FLT4_L5_.dup.bam \
	--changes --duplicates \
	--output noncarel.polished --outdir $directory
