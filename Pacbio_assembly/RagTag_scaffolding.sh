#!/bin/bash -i
#
#SBATCH --job-name=scaffolding
#SBATCH --cpus-per-task=10
#SBATCH --mem=120G
#SBATCH --time=24:00:00

conda activate ragtagbase
#conda activate mama

## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler

## data
assembly=../purgedups/purged_l6m52u200.fa
REF=${Mypath}/ref/Betula_pendula_subsp._pendula.fasta

ragtag.py scaffold -o result --aligner nucmer $REF $assembly
# take only Chrs (ragtag keeps unused scaffs)
grep -A 1 '^>lcl' ragtag.scaffold.fasta > chrs.pacbio.fasta
seqkit stats -a chrs.pacbio.fasta > stats.txt

# plot
delta-filter -r result/ragtag.scaffold.asm.delta > ragtag.scaffold.delta.filter
show-coords -c ragtag.scaffold.delta.filter > ragtag.scaffold.coords
sed -i 's/lcl|Bpe_//g' ragtag.scaffold.coords
./mummerCoordsDotPlotly.R -i ragtag.scaffold.coords -o plot -m 1000 -q 3000 -l -s -t -x -p 12