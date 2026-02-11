plink --vcf betula_snp.vcf --make-bed --chr 10 --out intermid
# restrict the plot to just our specific SNPs of interest: subset the VCF file using PLINK
plink --bfile intermid --make-bed --extract mysnps.txt --out subset1

plink --bfile subset --recode vcf --out subset_betula_snp
./LDBlockShow/bin/LDBlockShow   -InVCF subset_betula_snp.vcf  -OutPut out  -Region  10:2752900:2977000  -OutPng -SeleVar 2
./LDBlockShow/bin/LDBlockShow   -InPlink subset2  -OutPut snpsubset3465  -Region  10:2465000:4457300 -SpeSNPName subset -OutPng -SeleVar 2
./LDBlockShow/bin/LDBlockShow   -InVCF betula_snp.vcf  -OutPut interval_3463000.3473000  -Region Chr10:3463000:3473000 -SpeSNPName names.txt -OutPng -SeleVar 2
perl LDBlockShow/bin/svg_kit/svg2xxx.pl snpinterval_2855409-3160049.svg -t png --height 50
awk '$7 > 0.8' betulaLD_3465040.ld > betulaLD_0.8.ld
awk 'NR > 1 {print $6}' betulaLD_0.8.ld > 3465snp.txt
sed -i 's/^/S10_/' mysnps.txt 

awk '{$2 = "S10_" $1; print}' snp_name.txt > snp_n.txt
awk '{print "10", $0}' snp_n.txt > snp_names.txt










