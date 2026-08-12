#!/bin/bash -i
#
#SBATCH --job-name=minimap
#SBATCH --cpus-per-task=10
#SBATCH --mem=40G
#SBATCH --time=03:00:00

conda activate hifi
## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler/pacbio
## data
primary_assembly=${Mypath}/Mitofilter/S18298Nr2.filtered.fa
PB=${Mypath}/cloud.mail.ru_downloader_mac_os_x/downloads/S18298_1/01_fastq/S18298Nr2.fastq.gz


# Run minimap2 to align pacbio data and generate paf files
# If large genome, set minimap2 -I option to ensure the genome can be indexed once
minimap2 -xmap-hifi -t 10 $primary_assembly $PB | gzip -c - > S18298Nr2.paf.gz

# calculate read depth histogram and base-level read depth
pbcstat S18298Nr2.paf.gz #produces PB.base.cov and PB.stat files
calcuts PB.stat > cutoffs 2>calcults.log

# produce a coverage histogram:
hist_plot.py -c cutoffs PB.stat PB.cov.png