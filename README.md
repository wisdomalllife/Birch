# Whole genome assembly of Karelian birch and analysis of chromosome regions associated with the curly wood phenotype
*Description:*
This project contains a workflow for the whole genome *de novo* assembly and analysis of the Karelian birch. Each directory includes scripts for different parts of the analysis.

* **Karelian_denovo_assembly**: *de novo* assembly of the Karelian birch genome (Silver birch genome as a reference)

* **non-Karelian_denovo_assembly**: *de novo* assembly of the Karelian birch, in which the Karelian phenotype did not manifest in adulthood (Silver birch genome as a reference)

* **structural_variants** - identification of structural variations between Karelian, non-Karelian and Silver birch genomes

* **SNPcalling** - snakemake workflow for SNPcalling with Karelian assembly as a reference
  
* **Phylogenetic** - phylogenetic tree construction using OrthoFinder

## denovo assembly
1. De novo genome assembly was performed using MaSuRCA (**masurcaassembly.sh**, **start.sh**). The configuration file contains the location of the compiled assembler, the location of the data and some parameters (**masurca_config**, **config**).
2. Pilon software was used in polishing step (**polish.sh**). For this purpose, reads alignment was prepared using a BWA aligner in advance (**bwa.sh**). Additionally duplicates were marked in BAM files using the Picard tool to prevent the interference caused by PCR (**markdup.sh**).
3. Scaffolding was performed using RagTag with Nucmer aligner option (**scaffolding.sh**).
4. BUSCO and QUAST were used to evaluate the quality of the assembly (**busco.sh**, **quast.sh**). To check the scaffolds coverage on the reference, scaffolds were mapped to the reference with Nucmer (**mumpilon.sh**, **mapping.sh**). **gaps.sh** evaluates length of the gaps.
5. Gene prediction using AUGUSTUS with arabidopsis as a species (**predict.sh**) and comparison with Silver birch genes (**blast.sh**).
6. TE annotation using RepeatModeler and RepeatMasker (**repmodel.sh**, **repmask.sh**).
7. Circle plot directory contains files for generating a summary of the de novo assembly (chromosomes, TEs and genes distribution, synteny blocks, InDels and SNPs distribution in 100 kb sliding window). Circos software was used.

## structural variants
*karelVSnonkarel* contains comparion between Karelian and non-Karelian birches. *karelVSref* - between Karelian and Silver birches.
1. Whole genome alignment was performed using minimap2 (**align.sh**).
2. SyRI analysis of structural variations and its visualization (**plots.sh**). genomes.txt and *name*.chrlen are used by plotsr (*name*.chrlen - file with chromosomes length).

## SNPcalling
`Snakefile_snpcall.smk`- snakemake file; `snpconfig.yaml` - configuration file with data location and filtering parameters; `submit_snakejob.sh` - submit snakemake to SLURM; `config.yaml` - configuration file for resource specifications; `env` - dependencies for conda environment.

`pca.sh` - additional file to create pca plot after snpcalling; `circos` contains files for generating a circle plot summary of InDels and SNPs distribution.

### Variant calling workflow:
**`BWA alignment`** -> **`Add or replace readgroups`** -> **`Mark dublicates`** -> **`HaplotypeCaller`** -> **`CombineGVCFs`** -> **`GenotypeGVCFs`** -> **`select SNPs and InDels`** -> **`filter SNPs and InDels`**
