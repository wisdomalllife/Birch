#!/bin/bash -i
#
#SBATCH --job-name=purge
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=02:00:00

conda activate hifi
## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler/pacbio
## data
primary_assembly=${Mypath}/Mitofilter/S18298Nr2.filtered.fa

# Set cutoffs manually
calcuts -l 6 -m 52 -u 200 PB.stat > cutoffs_manual

# Purge haplotigs and overlaps
purge_dups -2 -T cutoffs_manual -c PB.base.cov S18298Nr2.split.self.paf.gz > dups.bed 2> calcuts_manual-l6m52u200.log

# Get purged primary and haplotig sequences from draft assembly.
get_seqs -e dups.bed $primary_assembly

seqkit stats -a purged.fa > statsl6m52u200.txt

#calcuts -l 6 -m 52 -u 320 PB.stat > cutoffs_manual2
#purge_dups -2 -T cutoffs_manual2 -c PB.base.cov S18298Nr2.split.self.paf.gz > dupsl6m52u320.bed 2> calcuts_manual-l6m52u320.log
#get_seqs -e dupsl6m52u320.bed ../Mitofilter/S18298Nr2.filtered.fa
#seqkit stats -a purged.fa > statsl6m52u320.txt