#!/bin/bash -i
#
#SBATCH --job-name=genomesize
#SBATCH --cpus-per-task=16
#SBATCH --mem=120G
#SBATCH --time=03:00:00

conda activate mybase_new

## data
DATA=../cloud.mail.ru_downloader_mac_os_x/downloads/S18298_1/01_fastq/S18298Nr2.fastq.gz

k=19
#k2=21

# count kmers
jellyfish count -C -m ${k} -s 5G -t 16 --min-qual-char=? -o ${k}mer_out \
  <(zcat $DATA) # pacbio, k-mer count

jellyfish histo -t 10 ${k}mer_out > reads${k}mer.histo
genomescope2 -i reads${k}mer.histo -o ${k}mer -k ${k} # get statistics




#-------------------------------------------------------------------------
# illumina
DATA=${Mypath}/trimmed2
READ1=${DATA}/S5_EKDL240002135-1A_22375FLT4_L5_.1_trimmed.fq.gz
READ2=${DATA}/S5_EKDL240002135-1A_22375FLT4_L5_.2_trimmed.fq.gz
READ3=${DATA}/S4_EKDL240002135-1A_22375FLT4_L5_.1_trimmed.fq.gz
READ4=${DATA}/S4_EKDL240002135-1A_22375FLT4_L5_.2_trimmed.fq.gz

jellyfish count -C -m ${k} -s 5G -t 16 --min-qual-char=? -o pacbio/19S4S5/${k}mer_out \
  <(zcat $READ1) <(zcat $READ2) <(zcat $READ3) <(zcat $READ4) # illumina, k-mer count

jellyfish histo -t 10 pacbio/19S4S5/${k}mer_out > pacbio/19S4S5/reads${k}mer.histo
genomescope2 -i pacbio/19S4S5/reads${k}mer.histo -o pacbio/19S4S5/${k}mer -k ${k}
# Model converged het:0.0135 kcov:14.9 err:0.00287 model fit:1.13 len:394536547
# Model converged het:0.0135 kcov:15.2 err:0.00303 model fit:1.15 len:399340816 # 21S1S5

# By hand:
#dataframeS1 <- read.table("21S1/reads21mer.histo")
#plot(dataframeS1[2:200,], type="l", xlab = "frequency", ylab = "total number of k-mers with a given frequency")
#sum(as.numeric(dataframeS1[2:9960,1]*dataframeS1[2:9960,2])) # total k-mers

