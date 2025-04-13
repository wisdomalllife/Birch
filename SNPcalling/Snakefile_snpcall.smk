configfile: "snpconfig.yaml"

rule all:
    input:
        "snps/genotype_out.filter_snps.vcf",
        "indels/genotype_out.filter_indel.vcf",
        expand("{variant}/genotype_out.filterPASSED_{variant}.vcf.gz", variant = ["snps","indels"])

rule ref_bwa_index:
    input:
        ref=expand("{genome}.fasta", genome = config["reference"])
    output:
        expand("{genome}.fasta.sa", genome = config["reference"]),
        expand("{genome}.fasta.pac", genome = config["reference"]),
        expand("{genome}.fasta.bwt", genome = config["reference"]),
        expand("{genome}.fasta.ann", genome = config["reference"]),
        expand("{genome}.fasta.amb", genome = config["reference"])
    log:
        "logs/bwaindex.log"
    conda: 'env/env-samtools.yaml'
    resources:
        runtime='2h',
        threads=2,
        mem='10G'
    shell:
        "(bwa index {input.ref}) &> {log}"

rule bwa_map:
    input:
        expand("{genome}.fasta", genome = config["reference"]),
        lambda wildcards: config["samples"][wildcards.sample],
        expand("{genome}.fasta.sa", genome = config["reference"]),
        expand("{genome}.fasta.pac", genome = config["reference"]),
        expand("{genome}.fasta.bwt", genome = config["reference"]),
        expand("{genome}.fasta.ann", genome = config["reference"]),
        expand("{genome}.fasta.amb", genome = config["reference"])
    output:
        "mapped_bams/{sample}.sorted.bam",
        "mapped_bams/{sample}.sorted.bam.bai"
    log:
        "logs/bwa/{sample}.log"
    conda: 'env/env-samtools.yaml'
    resources:
        runtime='24h',
        threads=8,
        mem='60G'
    shell:
        """
        (bwa mem -t {resources.threads} {input[0]} {input[1]} | samtools sort -o {output[0]}
        samtools index {output[0]}) &> {log}
        """

rule ref_samtools_index:
    input:
        ref=expand("{genome}.fasta", genome = config["reference"])
    output:
        expand("{genome}.fasta.fai", genome = config["reference"])
    log:
        "logs/index.log"
    conda: 'env/env-samtools.yaml'
    resources:
        runtime='2h',
        threads=2,
        mem='10G'
    shell:
        "(samtools faidx {input.ref}) &> {log}"

rule create_sequence_dictionary:
    input:
        ref=expand("{genome}.fasta", genome = config["reference"])
    output:
        expand("{genome}.dict", genome = config["reference"])
    log:
        "logs/createdict.log"
    conda: 'env/env-picard.yaml'
    resources:
        threads=4,
        mem='20G'
    shell:
        "(picard CreateSequenceDictionary -R {input.ref} -O {output}) &> {log}"

rule add_replace_readgroups:
    input:
        bams="mapped_bams/{sample}.sorted.bam",
        bai="mapped_bams/{sample}.sorted.bam.bai"
    output:
        "read_groups/{sample}.rg.bam"
    log:
        "logs/readgroups/{sample}.log"
    conda: 'env/env-picard.yaml'
    resources:
        threads=4,
        mem='30G'
    shell:
        """
        (picard AddOrReplaceReadGroups I={input.bams} O={output} \
         RGSM={wildcards.sample} RGLB={wildcards.sample} RGID={wildcards.sample}.0 RGPU={wildcards.sample}.1 RGPL=illumina) &> {log}
        """

rule mark_duplicates:
    input:
        "read_groups/{sample}.rg.bam"
    output:
        "marked_bams/{sample}.dup.bam",
        "marked_bams/marked_dup_metrics.{sample}.txt"
    log:
        "logs/mark_duplicates/{sample}.log"
    conda: 'env/env-picard.yaml'
    resources:
        threads=4,
        mem='30G'
    shell:
        """
        (picard MarkDuplicates I={input} O={output[0]} M={output[1]} \
         REMOVE_DUPLICATES=true VALIDATION_STRINGENCY=LENIENT AS=true) &> {log}
        """

rule samtools_index:
    input:
        "marked_bams/{sample}.dup.bam"
    output:
        "marked_bams/{sample}.dup.bam.bai"
    log:
        "logs/index/{sample}.log"
    conda: 'env/env-samtools.yaml'
    resources:
        runtime='2h',
        threads=2,
        mem='10G'
    shell:
        "(samtools index {input}) &> {log}"

rule haplotype_caller:
    input:
        ref=expand("{genome}.fasta", genome = config["reference"]),
        dict=expand("{genome}.dict", genome = config["reference"]),
        bam="marked_bams/{sample}.dup.bam",
        bai="marked_bams/{sample}.dup.bam.bai",
        fai=expand("{genome}.fasta.fai", genome = config["reference"])
    output:
        "gVCF_DIR/{sample}.g.vcf.gz"
    params:
        memmax = "-Xmx60g"
    log:
        "logs/haplotype_caller/{sample}.log"
    resources:
        threads=8,
        mem='120G'
    conda: 'env/env-gatk.yaml'
    shell:
        """
        (gatk --java-options {params.memmax} HaplotypeCaller --reference {input.ref} \
        --input {input.bam} --output {output} -ERC GVCF) &> {log}
        """

rule combine_GVCFs:
    input:
        ref=expand("{genome}.fasta", genome = config["reference"]),
        logs=expand("logs/haplotype_caller/{sample}.log", sample = config["samples"])
    output:
        "genotype/cohort.g.vcf.gz"
    params:
        lambda w: " -V ".join(expand("gVCF_DIR/{sample}.g.vcf.gz", sample = config["samples"])),
        memmax = "-Xmx20g"
    log:
        "logs/genotype/combine.log"
    conda: 'env/env-gatk.yaml'
    resources:
        threads=8,
        mem='60G'
    shell:
        """
        (gatk --java-options {params.memmax} CombineGVCFs -R {input.ref} -V {params[0]} -O {output}) &> {log} 
        """
        
rule genotype_GVCFs:
    input:
        ref=expand("{genome}.fasta", genome = config["reference"]),
        vcf="genotype/cohort.g.vcf.gz"
    output:
        "genotype/genotype_out.vcf.gz"
    params:
        memmax = "-Xmx20g"
    log:
        "logs/genotype/genotype.log"
    conda: 'env/env-gatk.yaml'
    resources:
        threads=8,
        mem='60G'
    shell:
        """
        (gatk --java-options {params.memmax} GenotypeGVCFs -R {input.ref} -V {input.vcf} -O {output}) &> {log} 
        """

rule prepare_tofilter:
    input:
        vcf="genotype/genotype_out.vcf.gz"
    output:
        sorted_vcf="genotype/genotype_out.sorted.vcf.gz",
        tbi="genotype/genotype_out.sorted.vcf.gz.tbi"
    params:
        mem = "20G"
    log:
        "logs/genotype/tabix.log"
    conda: 'env/env-tabix.yaml'
    resources:
        runtime='4h',
        threads=8,
        mem='20G'
    shell:
        """
        (bcftools sort -m {params.mem} -Oz -o {output.sorted_vcf} {input.vcf}
        tabix -p vcf {output.sorted_vcf}) &> {log}
        """

rule select_SNPs: 
    input:
        ref=expand("{genome}.fasta", genome = config["reference"]), 
        vcf="genotype/genotype_out.sorted.vcf.gz"
    output: 
         "snps/genotype_out.snps.vcf.gz"
    params:
        memmax = "-Xmx60g"
    log:
        "logs/variants/select_snp.log"
    conda: 'env/env-gatk.yaml' 
    resources:
        threads=8,
        mem='60G'
    shell: 
         """
         (gatk SelectVariants --java-options {params.memmax} -R {input.ref} -V {input.vcf} -select-type SNP -O {output}) &> {log} 
         """
         
rule select_INDELs: 
    input:
        ref=expand("{genome}.fasta", genome = config["reference"]), 
        vcf="genotype/genotype_out.sorted.vcf.gz"
    output: 
         "indels/genotype_out.indels.vcf.gz"
    params:
        memmax = "-Xmx60g"
    log:
        "logs/variants/select_indel.log"
    conda: 'env/env-gatk.yaml' 
    resources:
        threads=8,
        mem='60G'
    shell: 
         """
         (gatk SelectVariants --java-options {params.memmax} -R {input.ref} -V {input.vcf} -select-type INDEL -O {output}) &> {log} 
         """

rule SNP_filter:
    input:
        ref=expand("{genome}.fasta", genome = config["reference"]),
        snp="snps/genotype_out.snps.vcf.gz"
    output:
        "snps/genotype_out.filter_snps.vcf"
    params:
        memmax = "-Xmx60g",
        qd = config['QD'],
        sor = config['SNP_SOR'],
        fs = config['SNP_FS'],
        mq = config['SNP_MQ'], 
        mqranksum = config['SNP_MQRankSum'], 
        readposranksum = config['SNP_ReadPosRankSum']
    log:
        "logs/variants/snp_filter.log"
    conda: 'env/env-gatk.yaml' 
    resources:
        threads=8,
        mem='60G'
    shell:
        """
        (gatk --java-options {params.memmax} VariantFiltration \
           -R {input.ref} -V {input.snp} -O {output} \
           --filter-name "SNP_QDlt2" --filter-expression "QD < {params.qd}" \
           --filter-name "SNP_FSgt60" --filter-expression "FS > {params.fs}" \
           --filter-name "SNP_MQlt40" --filter-expression "MQ < {params.mq}" \
           --filter-name "SNP_MQRSneg12.5" --filter-expression "MQRankSum < {params.mqranksum}" \
           --filter-name "SNP_RPRSneg8" --filter-expression "ReadPosRankSum < {params.readposranksum}" \
           --filter-name "SNP_SORgt4" --filter-expression "SOR > {params.sor}") &> {log}
        """

rule INDEL_filter:
    input:
        ref=expand("{genome}.fasta", genome = config["reference"]),
        indel="indels/genotype_out.indels.vcf.gz"
    output:
        "indels/genotype_out.filter_indel.vcf"
    params:
        memmax = "-Xmx60g",
        qd = config['QD'],
        sor = config['INDEL_SOR'],
        fs = config['INDEL_FS'],
        readposranksum = config['INDEL_ReadPosRankSum']
    log:
        "logs/variants/indel_filter.log"
    conda: 'env/env-gatk.yaml' 
    resources:
        threads=8,
        mem='60G'
    shell:
        """
        (gatk --java-options {params.memmax} VariantFiltration \
           -R {input.ref} -V {input.indel} -O {output} \
           --filter-name "INDEL_QDlt2" --filter-expression "QD < {params.qd}" \
           --filter-name "INDEL_FSgt200" --filter-expression "FS > {params.fs}" \
           --filter-name "INDEL_RPRSneg20" --filter-expression "ReadPosRankSum < {params.readposranksum}" \
           --filter-name "INDEL_SORgt10" --filter-expression "SOR > {params.sor}") &> {log}
        """

rule passed_filter:
    input:
        vcf=lambda wildcards: config["Variants"][wildcards.variant]
    output:
        passed_vcf="{variant}/genotype_out.filterPASSED_{variant}.vcf.gz"
    log:
        "logs/variant/passed_{variant}.log"
    conda: 'env/env-tabix.yaml'
    resources:
        runtime='2h',
        threads=8,
        mem='20G'
    shell:
        """
        (grep -E '^#|PASS' {input.vcf} | bgzip > {output.passed_vcf}
        tabix -p vcf {output.passed_vcf}) &> {log}
        """
