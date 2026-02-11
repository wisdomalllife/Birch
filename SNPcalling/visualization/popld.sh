#!/bin/bash -i
#
#SBATCH --job-name=lddecay
#SBATCH --cpus-per-task=4
#SBATCH --mem=60G
#SBATCH --time=05:00:00

conda activate lddecay

#PopLDdecay  -InVCF  miss80maf10.recode.vcf  -OutStat LDdecay
PopLDdecay  -InVCF  miss80maf10.recode.vcf  -OutStat LDdecay_1000 -MAF 0.05 -MaxDist 1000
PopLDdecay  -InVCF  miss80maf10.recode.vcf  -OutStat LDdecay_100 -MAF 0.05 -MaxDist 100
perl Plot_OnePop.pl -inFile LDdecay_100.stat.gz  -output  Fig_100
