#!/bin/bash -i
conda activate polishing

#SBATCH --job-name=polish
#SBATCH --cpus-per-task=64
#SBATCH --mem=512G
#SBATCH --time=240:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.soap.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.soap.err


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
