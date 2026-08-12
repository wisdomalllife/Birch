#!/bin/bash -i
#
#SBATCH --job-name=kraken2
#SBATCH --cpus-per-task=30
#SBATCH --mem=256G
#SBATCH --time=24:00:00

conda activate ncbi

DATA=../purgedups/purged_l6m52u200.fa
DATA2=../cloud.mail.ru_downloader_mac_os_x/downloads/S18298_1/01_fastq/S18298Nr2.fastq.gz

# DOWNLOAD library
# build standart database
kraken2-build --standard --use-ftp --threads 24 --db kraken_DB # unmasked human!!!!!
# or download, BUT unmasked human!!!!!
cd kraken_DB
wget https://genome-idx.s3.amazonaws.com/kraken/k2_pluspf_20260626.tar.gz
tar -xvf k2_pluspf_20260626.tar.gz
rm k2_pluspf_20260626.tar.gz
#----------------------------------------------

k2 download-taxonomy --db kraken_DB # Downloading NCBI taxonomy info
kraken2-build --download-library human --db kraken_DB --threads 24 --use-ftp # Downloading human and mask
#k2 download-library --library human --threads 30 --db kraken_DB # doesn't work
#kraken2-build --download-library bacteria --db kraken_DB --threads 24 --use-ftp # time out( bacteria is too big

k2 build --threads 30 --db kraken_DB # Building database
k2 clean --db kraken_DB # Removing intermediate files
k2 classify --threads 24 --db kraken_DB --confidence 0.1 --unclassified-out contigs.unclassified.maskhuman \
--classified-out contigs.classified.maskhuman --report REPORT.contigs.maskhuman01 --output OUT.contigs.maskhuman $DATA
# evaluates the whole sequence, confidence decreases with length - better check raw data with it
#----------------------------------------------
k2 classify --threads 24 --db kraken_DB --confidence 0.5 \
 --report raw/REPORT05 --output raw/OUT05 $DATA2

