#!/bin/bash -i
#
#SBATCH --job-name=trinity
#SBATCH --cpus-per-task=28
#SBATCH --mem=200G
#SBATCH --time=86:01:00

conda activate trytrinity
# for reference assembly

#conda activate rnaseq

## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler/rnaseqcomparison
REF=/mnt/tank/scratch/vshumakova/carel_assembler/ref/Betula_pendula_subsp._pendula.faa
REFPATH=/mnt/tank/scratch/vshumakova/carel_assembler/ref
DATA=${Mypath}/readstrimmed


# without reference
# more than a day
Trinity --seqType fq --left $DATA/SRR31391705_trimmed_1.fq.gz --right $DATA/SRR31391705_trimmed_2.fq.gz --CPU 6 --max_memory 50G --output trinity
Trinity --seqType fq --left $DATA/SRR31391705_trimmed_1.fq.gz,$DATA/SRR31391704_trimmed_1.fq.gz,$DATA/SRR31391703_trimmed_1.fq.gz \
  --right $DATA/SRR31391705_trimmed_2.fq.gz,$DATA/SRR31391704_trimmed_2.fq.gz,$DATA/SRR31391703_trimmed_2.fq.gz \
  --CPU 26 --max_memory 150G --output trinity

# make gff
gmap_build -d Betula_pendula_gmap -D . $REF
gmap -n 0 -D . -d Betula_pendula_gmap -t 16 trinity/Trinity.fasta -f samse | samtools sort -o trinity_gmap.bam
samtools index trinity_gmap.bam
#gmap -D . -d Betula_pendula_gmap -B 4 -t 16 -f gff3_gene trinity/Trinity.fasta > Trinity.gff3
#gmap -D $REFPATH -d Betula_pendula_gmap -t 16 -f gff3_gene trinity_out/merged_nonkarel_trinity/Trinity-GG.fasta > Trinity_nonkarel.gff3
#------------------------------------------------------------------------------------------------

# with reference nonkarelian
samtools merge -b bamfiles.txt --threads 16 merged_nonkarel.bam # merge in one file

echo Start time is `date +%Y/%m/%d--%H:%M`
Trinity --max_memory 150G --genome_guided_max_intron 10000 \
   --output merged_nonkarel_trinity --CPU 28 --full_cleanup \
   --genome_guided_bam merged_nonkarel.bam
echo Finish time is `date +%Y/%m/%d--%H:%M`

TrinityStats.pl merged_nonkarel_trinity/Trinity-GG.fasta # statistics

gmap_build -d Betula_pendula_gmap -D . $REF
gmap -n 0 -D $REFPATH -d Betula_pendula_gmap -t 16 merged_nonkarel_trinity/Trinity-GG.fasta -f samse | samtools sort -o trinity_nonkarel_gmap.bam
samtools index trinity_nonkarel_gmap.bam
#-------------------------------------------------------------------------------------------------------------------------

# with reference karelian
samtools merge -b bamfiles.txt --threads 16 merged_karel.bam # merge in one file

echo Start time is `date +%Y/%m/%d--%H:%M`
Trinity --max_memory 150G --genome_guided_max_intron 10000 \
   --output merged_karel_trinity --CPU 28 --full_cleanup \
   --genome_guided_bam merged_karel.bam
echo Finish time is `date +%Y/%m/%d--%H:%M`

gmap -n 0 -D $REFPATH -d Betula_pendula_gmap -t 16 merged_karel_trinity/Trinity-GG.fasta -f samse | samtools sort -o trinity_karel_gmap.bam
samtools index trinity_karel_gmap.bam