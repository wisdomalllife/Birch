samtools faidx nucmer.fasta
awk '{print "chr - "$1" "substr($1,9,5)" 0 "$2" vvlblue"}' nucmer.fasta.fai > CurlyKaryotype1.txt # apropriate format
awk '{if ($4 ~ /Chr._/) {$4 = substr($4,1,4)} print}' CurlyKaryotype1.txt > CurlyKaryotype.txt # delete _
cut -d ' ' -f 4 CurlyKaryotype.txt | sed 's/[^0-9]*//' > col.txt # numeric column for sorting
paste CurlyKaryotype.txt col.txt > col2.txt # combine
sort -k8,8n col2.txt | cut -f 1 > CurlyKaryotype.txt # sorting
sed -i 's/dpurple/purples-3-seq-3/' CurlyKaryotype.txt

circos -conf circos_Karyotype.conf # build plot
