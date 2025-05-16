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
#1
awk 'BEGIN { OFS="t" } $0 ~ /^#/ || $3 == "gene"' Betula_pendula_subsp_pendula_annos1_cds1_id_typename_nu1_upa1_add.gff > Betula_genes.gff
awk 'BEGIN {FS=OFS="\t"} 
{
    if ($9 ~ /ID=Bpev.*;/) {
        match($9, /ID=Bpev[^;]*/); # Находим подстроку
        $3 = substr($9, RSTART, RLENGTH);
    }
    print
}' Betula_genes.gff > Betula_genes2.gff

bedtools getfasta -fi $REF -bed $betula_gff -fo Betula_genes.fasta -name
# or another way to extract CDS :
gffread -w transcripts.fa -y transcripts_prot.fa -g $REF $betula_gff # The CDS can be extracted using -x option, while the -y option can provide automatic CDS translation (for transcripts having CDS ranges defined)

#2
getAnnoFasta.pl karelian.gff # Makes a fasta file with protein sequences (augustus.aa)
#getAnnoFasta.pl --codingseq=on karelian.gff

#3
makeblastdb -in Betula_genes.fasta -dbtype nucl -out betula_pendula # create database
#makeblastdb -in transcripts_prot.fa -dbtype prot -out betula_pendula # create a protein database
#blastn -query karelian.fasta -db betula_pendula -out genes_blastn_1align.txt -num_alignments 1 -evalue 1e-8
tblastn -query karelian.aa -db betula_pendula -out genes_blastn_1align.txt -num_alignments 1 -evalue 1e-10
tblastn -query karelian.aa -db betula_pendula -out genes_blastn_1e-8_table.txt -evalue 1e-8 -outfmt 6
tblastn -query karelian.aa -db betula_pendula -out genes_tblastn_1e-20.txt -num_alignments 1 -evalue 1e-20

#blastdbcmd -db betula_pendula -dbtype nucl -entry_batch hits.txt -outfmt %f -out hits.fasta # Extracting hits
#get the sequences we matched against from the database (perhaps to build an alignment and phylogenetic tree)