#!/bin/bash -i
#
#SBATCH --job-name=merqury
#SBATCH --cpus-per-task=20
#SBATCH --mem=120G
#SBATCH --time=04:00:00

conda activate hifi
## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler/pacbio
## data
reads=../cloud.mail.ru_downloader_mac_os_x/downloads/S18298_1/01_fastq/S18298Nr2.fastq.gz
asm=${Mypath}/Hifiasm-assembly/S18298Nr2.asm.p_ctg.fa
asm_filt=${Mypath}/Mitofilter/S18298Nr2.filtered.fa
asm_purgdup=${Mypath}/purgedups/purged_l6m52u200.fa

#$MERQURY/best_k.sh 400000000 # 19

#Build k-mer dbs with meryl (with pacbio or illumina wgs)
meryl k=31 threads=20 memory=120g count $reads output karelian.meryl

merqury.sh karelian.meryl $asm S18298Nr2.asm
#merqury.sh karelian.meryl $asm_filt S18298Nr2.filt
#merqury.sh karelian.meryl $asm_purgdup S18298Nr2.purgdup

# if problem with size in spectra plot:
#$MERQURY/plot/plot_spectra_cn.R -f S18298Nr2.asm.S18298Nr2.asm.p_ctg.spectra-cn.hist -o newplot -m 80 -n 19785858