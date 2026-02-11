#!/bin/bash -i
#
#SBATCH --job-name=plink
#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=05:00:00

conda activate mybase_new

# --thin 0.1 --chr 1 --allow-no-sex -r2 gz --geno 0.1 --mind 0.5 --maf 0.1
# Because it runs faster, and low-frequency variant statistics 'can' be inaccurate.
# --ld-window-kb - this is the upper end of the LD window.
# --ld-window - this allows us to set the size of the lower end of the LD window.
# --ld-window-r2 - this sets a filter on the final output but we want all values of LD to be written out, so we set it to 0.
plink --vcf miss80maf10.recode.vcf --double-id --allow-extra-chr \
--set-missing-var-ids @:# --maf 0.1 \
 -r2 --ld-window 100 --ld-window-kb 1000 \
--ld-window-r2 0 \
--make-bed --out miss80ld
