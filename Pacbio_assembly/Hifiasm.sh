#!/bin/bash -i
#
#SBATCH --job-name=hifiasm
#SBATCH --cpus-per-task=32
#SBATCH --mem=256G
#SBATCH --time=48:00:00

conda activate hifi

DATA=../cloud.mail.ru_downloader_mac_os_x/downloads/S18298_1/01_fastq/S18298Nr2.fastq.gz

# with strict purging
hifiasm -o S18298Nr2.asm -t64 $DATA 2> S18298Nr2.asm.log
# weaker purging: hifiasm -o S18298Nr2.asm -t32 -l2 $DATA 2> S18298Nr2.asm.log

awk '/^S/{print ">"$2;print $3}' S18298Nr2.asm.bp.p_ctg.gfa > S18298Nr2.asm.p_ctg.fa  # get primary contigs in FASTA
