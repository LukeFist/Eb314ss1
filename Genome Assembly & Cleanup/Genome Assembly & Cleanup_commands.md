# Module 4: Genome Assembly & Cleanup

This document covers the commands used to transfer data, run various genome assemblers (Velvet, SPAdes), and perform post-processing cleanup.

## 4.1 Transfer Data to MCC

Use scp (Secure Copy) to transfer the cleaned read files to the remote high-performance computing cluster.

```bash
scp Eb314ss1_*_paired.fastq.gz lefi229@MCC.uky.edu:/path/to/project/dir/
scp Eb314ss1_*_unpaired.fastq.gz lefi229@MCC.uky.edu:/path/to/project/dir/
```

## 4.2 Run Genome Assemblies

The following commands are run on the remote cluster.

### Interleave Reads for Velvet

Velvet requires interleaved paired-end reads. A helper script is used to produce them.

```bash
shuffleSequences_fastq.pl Eb314ss1_1_paired.fastq.gz Eb314ss1_2_paired.fastq.gz interleaved.fastq
```

### Velvet Assembly (k=83)

Using k=83 based on the "Recommended k-mer" value in the README.

```bash
velveth velvet_k83 83 -fastq -shortPaired interleaved.fastq
velvetg velvet_k83 -exp_cov auto -cov_cutoff auto
```

### Velvet Assembly (k=93)

Using k=93 based on the "Recommended k-mer" value in the README.

```bash
velveth velvet_k93 93 -fastq -shortPaired interleaved.fastq
velvetg velvet_k93 -exp_cov auto -cov_cutoff auto
```

### SPAdes Assembly (Paired + Unpaired)

```bash
spades.py --careful -t 8 -m 64 \
    -1 Eb314ss1_1_paired.fastq.gz -2 Eb314ss1_2_paired.fastq.gz \
    --unpaired Eb314ss1_1_unpaired.fastq.gz --unpaired Eb314ss1_2_unpaired.fastq.gz \
    -o spades_paired_unpaired
```

### SPAdes Assembly (Paired Only)

This assembly produced the best N50 value according to the README.

```bash
spades.py --careful -t 8 -m 64 \
    -1 Eb314ss1_1_paired.fastq.gz -2 Eb314ss1_2_paired.fastq.gz \
    -o spades_paired_only
```

## 4.3 Best Assembly Graph

The full assembly graph for the best genome (SPAdes Paired Only) is shown below.

![Entire Graph - Best Genome SPAdes](EntireGraphBestGenomeSpades.png)

## 4.4 Post-Processing Cleanup

The final contig count (2,492) is lower than the best assembly's output (4,168), suggesting that short contigs were removed. The following command filters out contigs below a minimum length threshold using awk.

```bash
awk '/^>/ {if (l) print s; s=$0; l=0; next} {s=s"\n"$0; l+=length($0)} END {if(l) print s}' spades_paired_only/contigs.fasta | \
    awk 'BEGIN {RS=">"; FS="\n"} NR>1 && length($2) >= 1000 {print ">"$0}' > Eb314ss1_final_assembly.fasta
```
