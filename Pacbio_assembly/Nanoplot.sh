#!/bin/bash -i
#
#SBATCH --job-name=nanoplot
#SBATCH --cpus-per-task=4
#SBATCH --mem=120G
#SBATCH --time=03:00:00

conda activate mybase_new

#quality check
NanoPlot --fastq ../cloud.mail.ru_downloader_mac_os_x/downloads/S18298_1/01_fastq/S18298Nr2.fastq.gz

# Total bases: 31,906,283,501
# Number of reads: 3,292,446




# filtering
fastplong -i S16968Nr10.1.fastq -o S16968Nr10.1_trimmed.fastq --length_required 1000 --disable_quality_filtering --disable_adapter_trimming # maybe not
# bioawk -c fastx '{if (length($seq) >= 1000) print ">"$name"\n"$seq}' file.fasta > filtered.fasta # length filter