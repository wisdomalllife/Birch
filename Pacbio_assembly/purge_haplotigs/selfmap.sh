#!/bin/bash -i
#
#SBATCH --job-name=selfminimap
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=02:00:00

conda activate hifi
## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler/pacbio
## data
primary_assembly=${Mypath}/Mitofilter/S18298Nr2.filtered.fa

# Split an assembly and do a self-self alignment
split_fa $primary_assembly > S18298Nr2.split
minimap2 -xasm5 -DP S18298Nr2.split S18298Nr2.split | gzip -c - > S18298Nr2.split.self.paf.gz