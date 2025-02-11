#!/bin/bash -i
conda activate mysyri

#SBATCH --job-name=syri
#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=01:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.aligning.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.aligning.err


## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler

## data
DATA=${Mypath}/masurca/ragtag/scaf_output/chr.fasta
REF=${Mypath}/ref/Betula_pendula_subsp._pendula.faa
OUTPUT=${Mypath}/masurca/syri

# syri & plotsr
syri -c $OUTPUT/chr.sam -r $REF -q $DATA -k -F S
plotsr \
    --sr syri.out \
    --genomes genomes.txt \
    -o output_plot.png \
    -H 8 -W 5 -s 10 #--chr lcl|Bpe_Chr10':2600000-3850000 #--chr lcl|Bpe_Chr10
