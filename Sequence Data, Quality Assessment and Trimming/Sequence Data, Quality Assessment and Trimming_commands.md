# Module 2: Sequence Data, Quality Assessment and Trimming

This document covers the commands used to assess raw sequencing data quality with FASTQC and trim it with Trimmomatic.

## 2.1 Download Raw Reads

Raw paired-end reads were copied from the course server to the local machine using `scp`.

```bash
# TODO: add scp command used to download raw reads
```

## 2.2 Assess Raw Sequence Quality with FASTQC

Run FASTQC on the original, untrimmed reads to check initial quality.

```bash
mkdir -p fastqc_raw
fastqc -o fastqc_raw Eb314ss1_1.fastq.gz Eb314ss1_2.fastq.gz
```

## 2.3 Trim Adaptors and Poor Quality Sequence with Trimmomatic

Use Trimmomatic to remove adaptors and low-quality bases. This command is for paired-end data and will produce four output files: two for the surviving paired reads, and two for reads that became unpaired.

```bash
java -jar /path/to/trimmomatic.jar PE -threads 4 \
    Eb314ss1_1.fastq.gz Eb314ss1_2.fastq.gz \
    Eb314ss1_1_paired.fastq.gz Eb314ss1_1_unpaired.fastq.gz \
    Eb314ss1_2_paired.fastq.gz Eb314ss1_2_unpaired.fastq.gz \
    ILLUMINACLIP:/path/to/adapters/TruSeq3-PE.fa:2:30:10 \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
```

## 2.4 Results

FASTQC generates HTML reports for each input file. The reports below show quality metrics before and after trimming.

### Pre-Trimming Reports

- [Eb314ss1_1_fastqc.html](FastqcHTML/Eb314ss1_1_fastqc.html)
- [Eb314ss1_2_fastqc.html](FastqcHTML/Eb314ss1_2_fastqc.html)

### Post-Trimming Reports

- [Eb314ss1_1_paired_fastqc.html](FastqcHTML/Eb314ss1_1_paired_fastqc.html)
- [Eb314ss1_1_unpaired_fastqc.html](FastqcHTML/Eb314ss1_1_unpaired_fastqc.html)
- [Eb314ss1_2_paired_fastqc.html](FastqcHTML/Eb314ss1_2_paired_fastqc.html)
- [Eb314ss1_2_unpaired_fastqc.html](FastqcHTML/Eb314ss1_2_unpaired_fastqc.html)
