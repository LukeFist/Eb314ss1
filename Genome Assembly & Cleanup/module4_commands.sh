#!/bin/bash

#
# Module 4: Genome Assembly
#
# This script documents the likely commands used to transfer data, run various
# genome assemblers (Velvet, SPAdes), and perform post-processing cleanup.
#

echo "--- Step 4: Genome Assembly ---"

# --- 4.1 Transfer Data to MCC ---
# Use scp (Secure Copy) to transfer the cleaned read files to a remote
# high-performance computing cluster.
# NOTE: Replace 'username' and 'mcc.cluster.edu' with your actual credentials.

echo "Transferring cleaned reads to cluster..."
scp Eb314ss1_*_paired.fastq.gz username@mcc.cluster.edu:/path/to/project/dir/
scp Eb314ss1_*_unpaired.fastq.gz username@mcc.cluster.edu:/path/to/project/dir/

# --- 4.2 Run Genome Assemblies ---
# The following commands would be run on the remote cluster.

# Velvet requires interleaved paired-end reads. A helper script is often used.
echo "Interleaving reads for Velvet..."
shuffleSequences_fastq.pl Eb314ss1_1_paired.fastq.gz Eb314ss1_2_paired.fastq.gz interleaved.fastq

# --- Velvet Assembly (k=83) ---
# NOTE: Using k=83 based on the "Recommended k-mer" value in the README.
echo "Running Velvet with k=83..."
velveth velvet_k83 83 -fastq -shortPaired interleaved.fastq
velvetg velvet_k83 -exp_cov auto -cov_cutoff auto

# --- Velvet Assembly (k=93) ---
# NOTE: Using k=93 based on the "Recommended k-mer" value in the README.
echo "Running Velvet with k=93..."
velveth velvet_k93 93 -fastq -shortPaired interleaved.fastq
velvetg velvet_k93 -exp_cov auto -cov_cutoff auto

# --- SPAdes Assembly (Paired + Unpaired) ---
echo "Running SPAdes with paired and unpaired reads..."
spades.py --careful -t 8 -m 64 \
    -1 Eb314ss1_1_paired.fastq.gz -2 Eb314ss1_2_paired.fastq.gz \
    --unpaired Eb314ss1_1_unpaired.fastq.gz --unpaired Eb314ss1_2_unpaired.fastq.gz \
    -o spades_paired_unpaired

# --- SPAdes Assembly (Paired Only) ---
# This assembly produced the best N50 value according to the README.
echo "Running SPAdes with paired reads only..."
spades.py --careful -t 8 -m 64 \
    -1 Eb314ss1_1_paired.fastq.gz -2 Eb314ss1_2_paired.fastq.gz \
    -o spades_paired_only

# --- 4.3 Perform Post-Processing Clean-up ---
# The final contig count (2,492) is lower than the best assembly's output (4,168),
# suggesting that short contigs were removed. Here's a way to do that with awk.

echo "Cleaning final assembly by removing short contigs..."
INPUT_ASSEMBLY="spades_paired_only/contigs.fasta"
OUTPUT_ASSEMBLY="Eb314ss1_final_assembly.fasta"
MIN_LENGTH=1000 # A common threshold for removing short contigs

awk '/^>/ {if (l) print s; s=$0; l=0; next} {s=s"\n"$0; l+=length($0)} END {if(l) print s}' "$INPUT_ASSEMBLY" | awk -v min="$MIN_LENGTH" 'BEGIN {RS=">"; FS="\n"} NR>1 && length($2) >= min {print ">"$0}' > "$OUTPUT_ASSEMBLY"

echo "--- Module 4 Complete ---"