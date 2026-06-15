#!/bin/bash -i
#
#SBATCH --job-name=sraload
#SBATCH --cpus-per-task=16
#SBATCH --mem=120G
#SBATCH --time=12:00:00

conda activate phylogenetic

## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler

esearch -db sra -query PRJNA1173919 | efetch -format runinfo | cut -d "," -f 1 > SRR.numbers

SRA_LIST="SRR.numbers"

# Loop through each accession number in the list
while IFS= read -r accession; do
    echo "Processing $accession"
    prefetch $accession && fasterq-dump $accession --outdir reads
done < "$SRA_LIST"