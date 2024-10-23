#!/bin/bash -i
conda activate polishing

#SBATCH --job-name=polish
#SBATCH --cpus-per-task=64
#SBATCH --mem=512G
#SBATCH --time=240:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.soap.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.soap.err


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
