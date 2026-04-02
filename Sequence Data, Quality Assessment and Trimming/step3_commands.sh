#!/bin/bash

#
# Module 3: Sequence Data, Quality Assessment and Trimming
#
# This script documents the likely commands used to download raw sequencing data,
# assess its quality with FASTQC, and trim it with Trimmomatic.
#

echo "--- Step 3: Quality Assessment and Trimming ---"


# --- 3.1 Assess Raw Sequence Quality with FASTQC ---
# Run FASTQC on the original, untrimmed reads to check initial quality.

echo "Running FASTQC on raw reads..."
mkdir -p fastqc_raw
fastqc -o fastqc_raw Eb314ss1_1.fastq.gz Eb314ss1_2.fastq.gz

# --- 3.2 Trim Adaptors and Poor Quality Sequence with Trimmomatic ---
# Use Trimmomatic to remove adaptors and low-quality bases.
# This command is for paired-end data and will produce four output files:
# two for the surviving paired reads, and two for reads that became unpaired.

echo "Running Trimmomatic to clean reads..."
java -jar /path/to/trimmomatic.jar PE -threads 4 \
    Eb314ss1_1.fastq.gz Eb314ss1_2.fastq.gz \
    Eb314ss1_1_paired.fastq.gz Eb314ss1_1_unpaired.fastq.gz \
    Eb314ss1_2_paired.fastq.gz Eb314ss1_2_unpaired.fastq.gz \
    ILLUMINACLIP:/path/to/adapters/TruSeq3-PE.fa:2:30:10 \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

echo "--- Module 3 Complete ---"