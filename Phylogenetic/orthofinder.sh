#!/bin/bash -i
#
#SBATCH --job-name=orthofinder
#SBATCH --cpus-per-task=32
#SBATCH --mem=120G
#SBATCH --time=48:00:00

conda activate phylogenetic

## try to get Betula_pendula transcript
#sed -i 's/lcl|//g' Betula_genes.fasta -  pipe slows down transeq
#transeq -sformat pearson -sequence Betula_genes.fasta -outseq Betula_pep.fa
#awk 'NR==482225 {$0=">ID=Bpev01.c0029.g000::Bpe_Chr8"} {print}' Betula_pendula.fa > Betula.fa # gene naming
#grep -n "^X$" Betula.fa > out.txt # proteins from single nucleotide
#awk '!/^X$/ {if (prev) print prev; prev=$0} /^X$/ {prev=""} END {if (prev) print prev}' Betula.fa > out.txt
#prthofinder didn't accept it

#preparation
#for f in *faa ; do python ~/miniconda3/envs/phylogenetic/bin/primary_transcript.py $f ; done
#for f in *fa ; do python ~/miniconda3/envs/phylogenetic/bin/primary_transcript.py $f ; done

orthofinder -f primary_transcripts/ -t 32 -o phylo_res3
#python ~/miniconda3/envs/phylogenetic/bin/make_ultrametric.py SpeciesTree_rooted.txt # make tree ultrametric
#orthofinder -b phylo_res/Results_Jun15/WorkingDirectory -f new_primary_transcripts -t 32 # redone