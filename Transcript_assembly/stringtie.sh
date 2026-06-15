#!/bin/bash -i
#
#SBATCH --job-name=stringtie
#SBATCH --cpus-per-task=8
#SBATCH --mem=130G
#SBATCH --time=12:00:00

conda activate rnaseq

## path
Mypath=/mnt/tank/scratch/vshumakova/carel_assembler/rnaseqcomparison
RNA_REF_GFF=${Mypath}/genes/Betula_pendula_subsp_pendula_annos1_cds1_id_typename_nu1_upa1_add.gff

SAMPLES=${Mypath}/SRR.numbers #list of input's names
DATA=${Mypath}/aligned
OUTPUT=${Mypath}/stringtie

# without reference
#stringtie -p 4 $DATA/${FQBase}.sorted.bam -o $OUTPUT/noref_karelian_transcripts.gtf
# with reference
# sbatch -w meduza-1 stringtie_test.sh 
for SAMPLE in $(cat $SAMPLES)
do
  #OUT_PATH=$OUTPUT/$SAMPLE
  #mkdir -pv $OUT_PATH
  #OUTPUT_GTF=$OUT_PATH/${SAMPLE}.gtf
  echo Start time is `date +%Y/%m/%d--%H:%M`
  stringtie -p 8 -l $SAMPLE $DATA/${SAMPLE}.sorted.bam -o $OUTPUT/${SAMPLE}.gtf -G $RNA_REF_GFF
  echo Finish time is `date +%Y/%m/%d--%H:%M`
done
# merge
#ls -1 SRR*.gtf > assembly_GTF_list.txt
#stringtie --merge -p 4 -o karel_merged.gtf -G $RNA_REF_GFF karel_GTF_list.txt
#stringtie --merge -p 4 -o nonkarel_merged.gtf -G $RNA_REF_GFF nonkarel_GTF_list.txt
