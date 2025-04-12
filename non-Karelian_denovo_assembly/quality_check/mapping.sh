#!/bin/bash -i
conda activate mama

#SBATCH --job-name=mummer
#SBATCH --cpus-per-task=32
#SBATCH --mem=120G
#SBATCH --time=60:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/noncarel_assembler/%a.mum.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/noncarel_assembler/%a.mum.err


## path
Mypath=/mnt/tank/scratch/vshumakova
REF=${Mypath}/carel_assembler/ref/Betula_pendula_subsp._pendula.faa
polished_assembly=${Mypath}/noncarel_assembler/polish/pilon/noncarel.polished.fasta

#mummer
# Align scaffolds to reference
nucmer -p noncarel_pilon $REF $polished_assembly

#show-coords -r -c -l pilon5.filter > fpilon5.coords
#show-coords -r -c -l -T -H pilon5.filter > 2fpilon5.coords

# different identity
delta-filter -i 65 -l 1000 -r noncarel_pilon.delta > pilon_65.filter
show-coords -c pilon_65.filter > pilon_65_plotly.coords
#./mummerCoordsDotPlotly.R -i fpilon50_plotly.coords -o pilon -m 1000 -q 3000 -s -t -x -p 7 (env Rplots)

delta-filter -i 75 -l 1000 -r noncarel_pilon.delta > pilon_75.filter
show-coords -c pilon_75.filter > pilon_75_plotly.coords

delta-filter -i 85 -l 1000 -r noncarel_pilon.delta > pilon_85.filter
show-coords -c pilon_85.filter > pilon_85_plotly.coords

delta-filter -i 90 -l 1000 -r noncarel_pilon.delta > pilon_90.filter
show-coords -c pilon_90.filter > pilon_90_plotly.coords
