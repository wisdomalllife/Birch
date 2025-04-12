#!/bin/bash -i
conda activate mybase_new

#SBATCH --job-name=duplicates
#SBATCH --cpus-per-task=8
#SBATCH --mem=120G
#SBATCH --array=1-4
#SBATCH --time=48:00:00
#SBATCH --output=/mnt/tank/scratch/vshumakova/carel_assembler/%a.assemble.out
#SBATCH --error=/mnt/tank/scratch/vshumakova/carel_assembler/%a.assemble.err

# marking duplicates using picard tool to prevent the interference caused by PCR

## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler/masurca
i=$SLURM_ARRAY_TASK_ID
FQ=${Mypath}/pilon/files_bwa.txt #list of input's names
name=$(sed "${i}q;d" $FQ)

pic=${Mypath}/gapclosing
DATA=${Mypath}/pilon/bwa
DATA2=${Mypath}/pilon/markbwa

java "-Xmx30g" -jar ${pic}/picard.jar AddOrReplaceReadGroups \
 I=$DATA/${name}.sorted.bam O=$DATA2/${name}.rg.bam \
 RGSM=${name} RGLB=${name} RGID=${name}.0 RGPU=${name}.1 RGPL=illumina

java "-Xms10g" "-Xmx30g" -jar ${pic}/picard.jar MarkDuplicates \
 I=$DATA2/${name}.rg.bam O=$DATA2/${name}.dup.bam \
 M=$DATA2/marked_dup_metrics.${name}.txt REMOVE_DUPLICATES=false VALIDATION_STRINGENCY=LENIENT ASSUME_SORT_ORDER=coordinate

samtools index $DATA2/${name}.dup.bam
