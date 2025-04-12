#!/bin/bash -i
conda activate mama

#SBATCH --job-name=mummer
#SBATCH --cpus-per-task=32
#SBATCH --mem=120G
#SBATCH --time=60:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.soap.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.soap.err


## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler
REF=${Mypath}/ref/Betula_pendula_subsp._pendula.faa
assembly=${Mypath}/masurca/birch/CA/primary.genome.scf.fasta
filtered1_pilon=${Mypath}/masurca/pilon/buscocheck/filt_pilon1.fasta

#mummer
# Step 1: Align scaffolds to reference
nucmer -p filt1_pilon $REF $filtered1_pilon

# different identity
delta-filter -i 65 -l 1000 -r filt1_pilon.delta > pilon_65.filter
show-coords -c pilon_65.filter > fpilon_65_plotly.coords # dotplotly output
show-coords -r -c -l -T -H pilon_65.filter > 2fpilon_65.coords # output without header

# bioawk -c fastx '{if (length($seq) >= 10000) print ">"$name"\n"$seq}' ragtag.patch.fasta > filtered_ragtag.fasta # filter by length
#./mummerCoordsDotPlotly.R -i fpilon50_plotly.coords -o pilon -m 1000 -q 3000 -s -t -x -p 7 (env Rplots)

delta-filter -i 75 -l 1000 -r filt1_pilon.delta > pilon_75.filter
show-coords -c pilon_75.filter > fpilon_75_plotly.coords
show-coords -r -c -l -T -H pilon_75.filter > 2fpilon_75.coords

delta-filter -i 85 -l 1000 -r filt1_pilon.delta > pilon_85.filter
show-coords -c pilon_85.filter > fpilon_85_plotly.coords
show-coords -r -c -l -T -H pilon_85.filter > 2fpilon_85.coords

delta-filter -i 90 -l 1000 -r filt1_pilon.delta > pilon_90.filter
show-coords -c pilon_90.filter > fpilon_90_plotly.coords
show-coords -r -c -l -T -H pilon_90.filter > 2fpilon_90.coords
