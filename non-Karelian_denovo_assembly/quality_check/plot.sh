#!/bin/bash -i
conda activate Rplots

#SBATCH --job-name=dotplot
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=01:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/noncarel_assembler/%a.mum.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/noncarel_assembler/%a.mum.err


## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler/masurca/mummer/dotPlotly
sed -i 's/lcl|Bpe_//g' pilon_65_plotly.coords
sed -i 's/lcl|Bpe_//g' pilon_75_plotly.coords
sed -i 's/lcl|Bpe_//g' pilon_85_plotly.coords
sed -i 's/lcl|Bpe_//g' pilon_90_plotly.coords

${Mypath}/mummerCoordsDotPlotly.R -i pilon_65_plotly.coords -o pilon65 -m 3000 -q 3000 -s -t -x -p 12
${Mypath}/mummerCoordsDotPlotly.R -i pilon_75_plotly.coords -o pilon75 -m 3000 -q 3000 -s -t -x -p 12
${Mypath}/mummerCoordsDotPlotly.R -i pilon_85_plotly.coords -o pilon85 -m 3000 -q 3000 -s -t -x -p 12
${Mypath}/mummerCoordsDotPlotly.R -i pilon_90_plotly.coords -o pilon90 -m 3000 -q 3000 -s -t -x -p 12

