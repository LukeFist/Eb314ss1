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
* **Raw Reads (Paired End):** 6,615,883 pairs

## 2. Trim Adaptors and Poor Quality Sequence with Trimmomatic
*Commands for quality assessment and trimming can be found in the script: **[sequence_data_quality_assessment_and_trimming.sh](./modules/sequence_data_quality_assessment_and_trimming.sh)***

* **Cleaned Reads Used for Assembly:** 5,906,576
* **Total Bases in Cleaned Reads:** 1,780,327,732

## 3. Generate an Optimized MyGenome Assembly using Velvet and SPAdes
*Commands for genome assembly can be found in the script: **[genome_assembly.sh](./modules/genome_assembly.sh)***

Based on k-mer optimization and algorithm comparison, the following assembly metrics were produced:
All N50 calculated using **[calculate_n50.sh](./calculate_n50.sh)**

| Metric | Velvet (k=10) | Velvet (k=2) | SPAdes (Paired+Unpaired) | SPAdes (Paired Only) |
| :--- | :--- | :--- | :--- | :--- |
| **Recommended k-mer** | 83 | 93 | Default | Default |
| **Genome Size** | 40,297,917 | 40,380,887 | 40,388,759 | 40,341,516 |
| **# Contigs** | 3,370 | 3,880 | 4,597 | 4,168 |
| **N50 Value** | 116,385 | 124,822 | 202,513 | 233,912 |

## 4. Perform Genome Post-Processing for NCBI Submission
* **Assembly Accession #:** SUB15999145 (Temporary)
* **Final Cleaned Genome Size:** 40,137,340
* **Final Contig Count:** 2,492
* **Final N50:** 232,638 

## 5. Assess Genome Quality using BUSCO
* **Fold Coverage:** 44.36
* **BUSCO Score (%):** 98.60%
* **BUSCO Score (Complete + Fragmented) (%):** 98.60%
