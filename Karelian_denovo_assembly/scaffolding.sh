#!/bin/bash -i
conda activate ragtagbase

#SBATCH --job-name=scaffolding
#SBATCH --cpus-per-task=10
#SBATCH --mem=120G
#SBATCH --time=48:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.aligning.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.aligning.err

# scaffolds orientation based on mapping to the reference

# path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler

## data
assembly=${Mypath}/masurca/pilon/scaffold_polished.fasta
REF=${Mypath}/ref/Betula_pendula_subsp._pendula.fasta

ragtag.py scaffold -o nucmer2 --aligner nucmer --nucmer-params='--maxmatch -l 50 -c 100' $REF $assembly
# take only Chrs (ragtag keeps unused scaffs)
#grep -A 1 '^>lcl' ragtag.scaffold.fasta > chrs.carel.fasta
# take only unplaced
#grep -A 1 'pilon' ragtag.scaffold.fasta > unplaced.fasta

# new reference
#bioawk -c fastx '{if ($name ~ /OZ2604[4,5][0-8]/ || $name ~ /OZ260449/) print ">"$name"\n"$seq}' GCA_965285875.1_dhBetPend1.hap1.1_genomic.fna > betula_2025.fna
#bioawk -c fastx '{if ($comment ~ /chromosome/) print ">"$name" "$comment"\n"$seq}' GCA_965285875.1_dhBetPend1.hap1.1_genomic.fna > betula_2025.fna
