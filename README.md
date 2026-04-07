# MyGenome
Repository for storing results from genome analysis - Sample Eb314ss1

# Genome Analysis Project: lefi229

---

| Metric | Details |
| :--- | :--- |
| **Researcher** | Fister, Luke |
| **Link/ID** | lefi229 |
| **Sample Name** | Eb314ss1 |
| **Assembly Accession #** | SUB15999145 |

---

# Table of Contents

1. [Assess Sequence Quality with FASTQC](#1-assess-sequence-quality-with-fastqc)
2. [Trim Adaptors and Poor Quality Sequence with Trimmomatic](#2-trim-adaptors-and-poor-quality-sequence-with-trimmomatic)
3. [Generate an Optimized MyGenome Assembly using Velvet and SPAdes](#3-generate-an-optimized-mygenome-assembly-using-velvet-and-spades)
4. [Perform Genome Post-Processing for NCBI Submission](#4-perform-genome-post-processing-for-ncbi-submission)
5. [Assess Genome Quality using BUSCO](#5-assess-genome-quality-using-busco)

---

## 1. Assess Sequence Quality with FASTQC

Raw paired-end reads were assessed for quality metrics (per-base quality, GC content, adapter content, etc.) using FASTQC before any trimming.

*Commands: [Sequence%20Data,%20Quality%20Assessment%20and%20Trimming_commands.md § 2.1](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/Sequence%20Data,%20Quality%20Assessment%20and%20Trimming_commands.md)*

* **Raw Reads (Paired End):** 6,615,883 pairs

**FASTQC Reports (Raw):**

| Report | Link |
| :--- | :--- |
| Read 1 | [Eb314ss1_1_fastqc.html](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/FastqcHTML/Eb314ss1_1_fastqc.html) |
| Read 2 | [Eb314ss1_2_fastqc.html](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/FastqcHTML/Eb314ss1_2_fastqc.html) |

---

## 2. Trim Adaptors and Poor Quality Sequence with Trimmomatic

Paired-end reads were trimmed to remove Illumina adapters and low-quality bases using Trimmomatic, producing cleaned paired and unpaired output files.

*Commands: [Sequence%20Data,%20Quality%20Assessment%20and%20Trimming_commands.md § 2.2](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/Sequence%20Data,%20Quality%20Assessment%20and%20Trimming_commands.md)*

* **Cleaned Reads Used for Assembly:** 5,906,576
* **Total Bases in Cleaned Reads:** 1,780,327,732

**FASTQC Reports (Post-Trimming):**

| Report | Link |
| :--- | :--- |
| Read 1 Paired | [Eb314ss1_1_paired_fastqc.html](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/FastqcHTML/Eb314ss1_1_paired_fastqc.html) |
| Read 1 Unpaired | [Eb314ss1_1_unpaired_fastqc.html](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/FastqcHTML/Eb314ss1_1_unpaired_fastqc.html) |
| Read 2 Paired | [Eb314ss1_2_paired_fastqc.html](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/FastqcHTML/Eb314ss1_2_paired_fastqc.html) |
| Read 2 Unpaired | [Eb314ss1_2_unpaired_fastqc.html](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/FastqcHTML/Eb314ss1_2_unpaired_fastqc.html) |

---

## 3. Generate an Optimized MyGenome Assembly using Velvet and SPAdes

Cleaned reads were assembled into contigs using both Velvet and SPAdes. Multiple k-mer values and read input combinations were tested to identify the best assembly by N50.

*Commands: [Genome%20Assembly%20%26%20Cleanup_commands.md § 4.2](./Genome%20Assembly%20%26%20Cleanup/Genome%20Assembly%20%26%20Cleanup_commands.md)*

All N50 values calculated using **[calculate_n50.sh](./calculate_n50.sh)**

| Metric | Velvet (k=83) | Velvet (k=93) | SPAdes (Paired+Unpaired) | SPAdes (Paired Only) |
| :--- | :--- | :--- | :--- | :--- |
| **Genome Size** | 40,297,917 | 40,380,887 | 40,388,759 | 40,341,516 |
| **# Contigs** | 3,370 | 3,880 | 4,597 | 4,168 |
| **N50 Value** | 116,385 | 124,822 | 202,513 | 233,912 |

![Entire Graph - Best Genome SPAdes](./Genome%20Assembly%20%26%20Cleanup/EntireGraphBestGenomeSpades.png)

---

## 4. Perform Genome Post-Processing for NCBI Submission

The best assembly (SPAdes Paired Only) was filtered to remove short contigs, producing a final cleaned genome submitted to NCBI.

*Commands: [Genome%20Assembly%20%26%20Cleanup_commands.md § 4.3](./Genome%20Assembly%20%26%20Cleanup/Genome%20Assembly%20%26%20Cleanup_commands.md)*

* **Assembly Accession #:** SUB15999145 (Temporary)
* **Final Cleaned Genome Size:** 40,137,340
* **Final Contig Count:** 2,492
* **Final N50:** 232,638

---

## 5. Assess Genome Quality using BUSCO

BUSCO evaluated the completeness of the final assembly by searching for conserved single-copy orthologs against a reference database.

* **Fold Coverage:** 44.36
* **BUSCO Score (%):** 98.60%
* **BUSCO Score (Complete + Fragmented) (%):** 98.60%
