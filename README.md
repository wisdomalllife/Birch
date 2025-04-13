# Birch
*Description:*
This project contains a workflow for the whole genome *de novo* assembly and analysis of the Karelian birch. Each directory includes scripts for different parts of the analysis.

* **Karelian_denovo_assembly**: *de novo* assembly of the Karelian birch genome (Silver birch genome as a reference)

* **non-Karelian_denovo_assembly**: *de novo* assembly of the Karelian birch, in which the Karelian phenotype did not manifest in adulthood (Silver birch genome as a reference)

* **structural_variants** - identification of structural variations between Karelian, non-Karelian and Silver birch genomes

* **SNPcalling** - snakemake workflow for SNPcalling with Karelian assembly as a reference

## denovo assembly
1. De novo genome assembly was performed using MaSuRCA (**masurcaassembly.sh**, **start.sh**). The configuration file contains the location of the compiled assembler, the location of the data and some parameters (**masurca_config**, **config**).
2. Pilon software was used in polishing step (**polish.sh**). For this purpose, reads alignment was prepared using a BWA aligner in advance (**bwa.sh**). Additionally duplicates were marked in BAM files using the Picard tool to prevent the interference caused by PCR (**markdup.sh**).
3. Scaffolding was performed using RagTag with Nucmer aligner option (**scaffolding.sh**).
4. BUSCO and QUAST were used to evaluate the quality of the assembly (**busco.sh**, **quast.sh**). To check the scaffolds coverage on the reference, scaffolds were mapped to the reference with Nucmer (**mumpilon.sh**, **mapping.sh**). **gaps.sh** evaluates lenght of the gaps.

## structural variants
*karelVSnonkarel* contains comparion between Karelian and non-Karelian birches. *karelVSref* - between Karelian and Silver birches.
1.(**align.sh**)
2.(**plots.sh**)
