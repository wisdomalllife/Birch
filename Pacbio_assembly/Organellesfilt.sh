#!/bin/bash -i
#
#SBATCH --job-name=blast
#SBATCH --cpus-per-task=8
#SBATCH --mem=120G
#SBATCH --time=48:00:00

conda activate augustus
## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler
## data
DATA=${Mypath}/pacbio/Hifiasm-assembly/S18298Nr2.asm.p_ctg.fa
DB=${Mypath}/ENA/mitochondrion

#1
#makeblastdb -in mitochondrion.1.1.genomic.fna -dbtype nucl -out RefSeq_Mitochondrion
# https://ftp.ncbi.nlm.nih.gov/genomes/refseq/mitochondrion/
#2
blastn -evalue 1e-10 -db ${DB}/RefSeq_Mitochondrion -query $DATA -out blast_outf6.txt -outfmt "6 qseqid sseqid length qstart qend evalue qcovs qcovhsp"

#contigs over 40% query coverage (qcovs) to the mitochondrial RefSeq database were considered as mitochondrial sequences
awk '$7 >= 40' blast_outf6.txt > blast_filt.txt
cut -f1 blast_filt.txt | sort -u > blast_filt_unique.txt
bioawk -c fastx 'BEGIN { while ((getline < "blast_filt_unique.txt") > 0) exclude[$0] } 
                 !($name in exclude) { print ">"$name; print $seq; }' ../Hifiasm-assembly/S18298Nr2.asm.p_ctg.fa > S18298Nr2.filtered.fa
                 
#--------------------------------------------------------------
# for future: remove plastids (chloroplasts) with greater than 99% query coverage (qcovs)
https://ftp.ncbi.nlm.nih.gov/genomes/refseq/plastid/ 
#makeblastdb -in plastid.1.1.genomic.fna -dbtype nucl -out RefSeq_Plastids
blastn -evalue 1e-10 -db RefSeq_Plastids -query ../S18298Nr2.filtered.fa -out blast_outf6.txt -outfmt "6 qseqid sseqid length qstart qend evalue qcovs qcovhsp"
awk '$7 >= 99' blast_outf6.txt > blast_filt.txt # resulted in 0 matches
# or use Oatk and MitoHifi