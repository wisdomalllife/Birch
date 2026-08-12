#!/bin/bash -i
#
#SBATCH --job-name=hifi
#SBATCH --cpus-per-task=10
#SBATCH --mem=120G
#SBATCH --time=08:00:00

conda activate hifi

#ln -sf ../cloud.mail.ru_downloader_mac_os_x/downloads/S18298_1/01_fastq/S18298Nr2.fastq.gz
hifiadapterfilt.sh -t 10

# Number of adapter contaminated ccs reads: 0 (0% of total)
# BLAST 2.16.0