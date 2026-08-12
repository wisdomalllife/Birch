#!/bin/bash -i
#
#SBATCH --job-name=busco
#SBATCH --cpus-per-task=10
#SBATCH --mem=120G
#SBATCH --time=02:00:00
#SBATCH -w meduza-1

conda activate busco_new
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler/masurca/mummer/scaff
DATA=S18298Nr2.asm.p_ctg.fa

busco -i $DATA -m genome --offline --cpu 10 --lineage_dataset ${Mypath}/embryophyta_odb10 -o busco
#generate_plot.py --wd ${Mypath}/my_summaries

quast S18298Nr2.asm.p_ctg.fa -r ../../ref/Betula_pendula_subsp._pendula.faa -o quast
seqkit stats -a S18298Nr2.asm.p_ctg.fa > stats.txt