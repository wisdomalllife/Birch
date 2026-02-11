#!/bin/bash -i
#
#SBATCH --job-name=blast
#SBATCH --cpus-per-task=8
#SBATCH --mem=120G
#SBATCH --time=48:00:00

conda activate augustus
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler/masurca/Submission

makeblastdb -in ${Mypath}/nucmer.fasta -dbtype nucl -out karelian_pendula
blastn -evalue 1e-10 -db karelian_pendula -query ${Mypath}/nucmer.fasta -out self_blast.txt -outfmt 10 -word_size 100
blastn -evalue 1e-10 -db karelian_pendula -query ${Mypath}/nucmer.fasta -out self_blast_outf6.txt -outfmt 6 -word_size 100
awk '$1 != $2 && $3 >= 90 && $4 >= 1000' self_blast_outf6.txt > self_blast_filt.txt
awk '{print $1" "$7" "$8" "$2" "$9" "$10}' self_blast_filt.txt > self_blast_circos.txt
for ((i=1; i<=14; i++)); do     awk -F ' ' -v chr="lcl|Bpe_Chr${i}_RagTag" '$1 == chr' self_blast_circos.txt > align/self_blast_Chr${i}.txt; done
#tblastn -query karelian.aa -db betula_pendula -out genes_tblastn_1e-20.txt -num_alignments 1 -evalue 1e-20

awk '$1 != $2 && $3 >= 95 && $4 >= 2000' self_blast_outf6.txt > self_blast_filt.txt
awk '$1 != $2 && $3 >= 93 && $4 >= 3000' self_blast_outf6.txt > self_blast_filt.txt

--------------------------------genes
#1
bedtools getfasta -fi nucmer.fasta -bed genes.gff -fo karelian_genes.fasta -name

#2
makeblastdb -in karelian_genes.fasta -dbtype nucl -out genes_karelian

#3
blastn -evalue 1e-10 -db genes_karelian -query karelian_genes.fasta -out self_blast_outf6.txt -outfmt 6 -word_size 100

awk '$1 != $2 && $3 >= 90 && $4 >= 1000' self_blast_outf6.txt > self_blast_filt.txt 
awk '$1 != $2 && $3 >= 99 && $4 >= 1000' self_blast_outf6.txt > self_blast_filt.txt
cut -f1-2,7-10 self_blast_filt.txt | sed 's/gene:://g'| sed 's/[:-]/\t/g' | awk '{print $1" "$2+$7-1" "$2+$8" "$4" "$5+$9-1" "$5+$10}' > self_blast_circos.txt
awk '{print $1" "$2+$7-1" "$2+$8" "$4" "$5+$9-1" "$5+$10}' self_blast_circos.txt > self_test.txt
awk '$1 != $4' self_blast_circos.txt > self_blast_circos_filt.txt