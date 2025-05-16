#!/bin/bash -i
#
#SBATCH --job-name=plink
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=02:00:00

conda activate mybase_new

## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler/masurca/SNPcalling/snake
vcf=${Mypath}/snps

geno=${Mypath}/SNP/genotype

#Create a binary dataset
#plink --vcf $geno/filterPASSED_snps.vcf.gz --make-bed --allow-extra-chr --out passed_snps
#plink --vcf biallel_snp.vcf --make-bed --out plink_snps

#plink --vcf biallel_snp.vcf --double-id --allow-extra-chr \
#--set-missing-var-ids @:# \
#--indep-pairwise 50 10 0.1 --out 

bcftools view --types snps -m 2 -M 2 $vcf/genotype_out.filterPASSED_snps.vcf.gz > biallel_snp.vcf
#sed -i 's/lcl|Bpe//g' file.txt
# --set-missing-var-ids @:# -> поменять точки на позицию+хромосома (awk '!/^#/ {$3 = $1 ":" $2; print} /^#/ {print}' etest)
#awk '$1 ~ /^#/ {print} $1 == "Chr10"' your_file.vcf
#awk 'BEGIN { OFS="\t"} !/^#/ {$3 = "S10_" $2; print} /^#/ {print}' filterPASSED_snps.vcf > changename/betula_snp.vcf
# --double-id -> duplicate the id of our samples

plink --vcf biallel_snp.vcf --double-id --allow-extra-chr --set-missing-var-ids @:# --indep-pairwise 50 10 0.1 --out biallel

plink --vcf biallel_snp.vcf --double-id --allow-extra-chr --set-missing-var-ids @:# --extract biallel.prune.in --make-bed --pca --out biallel

#library(tidyverse)
pca <- read_table("biallel.eigenvec", col_names = FALSE)
eigenval <- scan("biallel.eigenval")
pca <- pca[,-1]
# set names
names(pca)[1] <- "ind"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))
c <- c("kar","non","kar","kar","kar","non")
pca[8] <- c
names(pca)[8] <- "type"
c <- c("S1_parent","S2_offspring","S3_Karelia","S4_Belarus","S5_Finland","S6_offspring")
pca[1] <- c
#spp <- rep(NA, length(pca$ind))
#spp[grep("S1", pca$ind)] <- "S1"
#pca <- as.tibble(data.frame(pca, spp, loc, spp_loc))

# first convert to percentage variance explained
pve <- data.frame(PC = 1:6, pve = eigenval/sum(eigenval)*100)
a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
a + ylab("Percentage variance explained") + theme_light()
cumsum(pve$pve)

ggplot(pca, aes(PC1, PC2, col = ind, shape = type)) + geom_point(size = 3) +
  coord_equal() + theme_light() +
  xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) + ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))