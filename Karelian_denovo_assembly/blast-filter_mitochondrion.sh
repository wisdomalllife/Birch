#!/bin/bash -i
#
#SBATCH --job-name=blast
#SBATCH --cpus-per-task=8
#SBATCH --mem=120G
#SBATCH --time=48:00:00

conda activate augustus
## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler/ENA
## data
DATA=${Mypath}/polish/pilon_res/scaffold_polished.fasta
#1
#makeblastdb -in mitochondrion.1.1.genomic.fna -dbtype nucl -out RefSeq_Mitochondrion
# https://ftp.ncbi.nlm.nih.gov/genomes/refseq/mitochondrion/
#2
blastn -evalue 1e-10 -db RefSeq_Mitochondrion -query $DATA -out blast_outf6.txt -outfmt "6 qseqid sseqid length qstart qend evalue qcovs qcovhsp"

#awk '$7 >= 40' blast_outf6.txt > blast_filt.txt
#cut -f1 blast_filt.txt | sort -u > blast_filt_unique.txt
# Read the list of scaffold names into an array
bioawk -c fastx 'BEGIN { while ((getline < "blast_filt_unique.txt") > 0) exclude[$0] } 
                 !($name in exclude) { print ">"$name; print $seq; }' scaffold_polished.fasta > scaffold_polished_filtered.fasta
