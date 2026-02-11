## data
genome=chr.carel.fasta
# check gaps lengths
for i in {1..14}; do
  grep -A 1 "Bpe_Chr${i}_RagTag" $genome | sed -n '2p'| \
  tr "ATGCatgc" "xxxxxxxx"| \
  sed -e 's/xN/\nN/g' -e 's/Nx/N\n/g' | \
  sed 's/x//g' | \
  awk '{print length($1)}' | grep -vw "^0$" > Chr${i}_Nsizes.txt
done

#------------------R_maxgap----------------------
for (i in 1:14) {
    name <- paste0("Chr", i, "_Nsizes.txt")
    NNN <- read.table(name)
    print(max(NNN$V1))
}
