#grep -A 1 "Bpev01.c0000.g0109" Betula_pendula_subsp._pendula.cdna.faa > g0109.cdna.faa
bioawk -c fastx '{if ($name == "Bpev01.c0000.g0109.mRNA1") print ">"$name"\n"$seq}' Betula_pendula_subsp._pendula.cdna.faa > g0109.cdna.faa

grep -v "#" karelian.gff | grep "gene[[:space:]]" > genes.gff
grep "lcl|Bpe_Chr10_RagTag" genes.gff > genes10chr.gff
bedtools getfasta -fi chr.fasta -bed genes10chr.gff -fo karelian_genes10chr.fasta -name

makeblastdb -in karelian_genes10chr.fasta -dbtype nucl -out genes_karelian10chr
blastn -evalue 1e-20 -db genes_karelian10chr -query g0109.cdna.faa -out blast_oute20.txt -num_alignments 1

grep -A 1 "gene::lcl|Bpe_Chr10_RagTag:3619508-3623628" karelian_genes10chr.fasta > 109_karel.fasta
sed -n '/# start gene g6058/,/# end gene g6058/p' karelian.gff > 109_karel.txt