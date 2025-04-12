#!/bin/bash -i
conda activate busco_new

#SBATCH --job-name=buscoquality
#SBATCH --cpus-per-task=10
#SBATCH --mem=120G
#SBATCH --time=48:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.assemble.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.assemble.err


## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler/masurca

## data
DATA2=${Mypath}/pilon/scaffold_polished.fasta
DATA5=${Mypath}/birch/CA/primary.genome.scf.fasta
#REF=${Mypath}/ref/Betula_pendula_subsp._pendula.faa

# busco
#which python
python --version # version is important
#which busco
#busco -v
#busco --list-datasets

busco -i $DATA2 -m genome --offline --cpu 10 --lineage_dataset ${Mypath}/mummer/scaff/embryophyta_odb10 -o raw
busco -i $DATA5 -m genome --offline --cpu 10 --lineage_dataset ${Mypath}/mummer/scaff/embryophyta_odb10 -o masurca
generate_plot.py -wd ${Mypath}/summaries # graphical representation
