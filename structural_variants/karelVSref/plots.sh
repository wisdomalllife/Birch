#!/bin/bash -i
#
#SBATCH --job-name=syri
#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.aligning.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.aligning.err

conda activate mysyri

## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler

## data
DATA=${Mypath}/masurca/ragtag/nucmer2/chr.fasta
REF=${Mypath}/ref/Betula_pendula_subsp._pendula.faa
OUTPUT=${Mypath}/masurca/syri

# syri & plotsr
syri -c $OUTPUT/chr.sam -r $REF -q $DATA -k -F S
plotsr \
    --sr syri.out \
    --genomes genomes.txt \
    -o karelVSref.png \
    -H 8 -W 5 -s 10 #--chr lcl|Bpe_Chr10':2600000-3850000 #--chr lcl|Bpe_Chr10
