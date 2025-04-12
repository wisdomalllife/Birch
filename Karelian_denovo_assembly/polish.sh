#!/bin/bash -i
conda activate polishing

#SBATCH --job-name=polish
#SBATCH --cpus-per-task=64
#SBATCH --mem=512G
#SBATCH --time=240:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.soap.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.soap.err

# polishing step with Pilon
# Pilon requires BAM files of reads aligned to the input genome therefore bamdata was prepared in advance
# Additionally duplicates were marked in BAM files to use duplicates flag
# targets flag is used to split scaffolds and polish them sequentially to decrease memory usage
# a file listing changes in the output file will be generated

## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler/masurca
assembly=${Mypath}/birch/CA/primary.genome.scf.fasta
bamdata=${Mypath}/pilon/markbwa
file=${Mypath}/pilon/list2.txt
NAMES=$(cut -f1 $file)
path=${Mypath}/pilon/scaf_names

# run pilon
for targetl in $NAMES; do
    echo $targetl
    pilon -Xmx512G --genome $assembly \
    	--frags $bamdata/S1_EKDL240002135-1A_22375FLT4_L5_.dup.bam \
    	--frags $bamdata/S3_EKDL240002135-1A_22375FLT4_L5_.dup.bam \
    	--frags $bamdata/S4_EKDL240002135-1A_22375FLT4_L5_.dup.bam \
    	--frags $bamdata/S5_EKDL240002135-1A_22375FLT4_L5_.dup.bam \
    	--targets $path/$targetl.txt \
    	--changes --duplicates \
    	--output $targetl.polished
done
