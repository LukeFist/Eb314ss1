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
6. [Gene Prediction with SNAP, AUGUSTUS, and MAKER](#6-gene-prediction-with-snap-augustus-and-maker)

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
| Results PDF | [Eb314ss1_Pretrimmed.pdf](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/FastqcResults/Eb314ss1_Pretrimmed.pdf) |

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
| Results PDF | [Eb314ss1_1_paired.pdf](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/FastqcResults/Eb314ss1_1_paired.pdf) |

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

---

## 6. Gene Prediction with SNAP, AUGUSTUS, and MAKER

Genes were predicted using two ab initio predictors (SNAP and AUGUSTUS) trained or parameterized on related *Magnaporthe* species, followed by an evidence-based consensus annotation using MAKER.

*Commands: [Gene Prediction_commands.md](./Gene%20Prediction/Gene%20Prediction_commands.md)*

---

### 6.1 SNAP — Training and Gene Prediction

A custom HMM was trained from the annotated *M. oryzae* B71 reference strain using the `fathom` / `forge` / `hmm-assembler.pl` pipeline, then applied to the Eb314ss1 assembly.

**Key commands:**

```bash
# Prepare training data
echo '##FASTA' | cat B71Ref2_a0.3.gff3 - B71Ref2.fasta > B71Ref2.gff3
maker2zff B71Ref2.gff3
fathom genome.ann genome.dna -categorize 1000
fathom uni.ann uni.dna -export 1000 -plus
forge export.ann export.dna
hmm-assembler.pl Moryzae . > Moryzae.hmm

# Run SNAP on Eb314ss1
snap-hmm Moryzae.hmm Eb314ss1_final.fasta > Eb314ss1-snap.zff
fathom Eb314ss1-snap.zff Eb314ss1_final.fasta -gene-stats
snap-hmm Moryzae.hmm Eb314ss1_final.fasta -gff > Eb314ss1-snap.gff2
```

**SNAP Gene Prediction Summary:**

| Metric | Value |
| :--- | :--- |
| **Number of Predicted Genes** | <!-- INSERT NUMBER FROM fathom -gene-stats --> |

---

### 6.2 AUGUSTUS — Gene Prediction

AUGUSTUS was run using the pre-trained `magnaporthe_grisea` parameter set, the closest available relative to Eb314ss1.

**Key commands:**

```bash
augustus --species=magnaporthe_grisea --gff3=on \
    --singlestrand=true --progress=true \
    ../snap/Eb314ss1_final.fasta > Eb314ss1-augustus.gff3
```

| Flag | Description |
| :--- | :--- |
| `--species=magnaporthe_grisea` | Pre-trained parameter file for closest available relative |
| `--gff3=on` | Output in GFF3 format |
| `--singlestrand=true` | Predict genes on each strand independently |
| `--progress=true` | Display progress per contig |

**AUGUSTUS Gene Prediction Summary:**

| Metric | Value |
| :--- | :--- |
| **Number of Predicted Genes** | <!-- INSERT NUMBER FROM GFF3 output --> |

---

### 6.3 MAKER — Consensus Annotation

MAKER integrated SNAP predictions, AUGUSTUS predictions, and NCBI *Magnaporthe* protein evidence to produce a unified, evidence-supported annotation.

**Key commands:**

```bash
# Generate config files
singularity exec /share/singularity/images/ccs/MAKER/amd-maker-debian10.sinf \
    maker -CTL

# Submit MAKER job
sbatch maker.sh /project/farman_s26abt480/lefi229/Eb314ss1/Eb314ss1_final.fasta

# Monitor progress
cat Eb314ss1_final_maker.log

# Merge results into single GFF3
gff3_merge \
    -d Eb314ss1_final.maker.output/Eb314ss1_final_master_datastore_index.log \
    -o Eb314ss1-maker.gff3
```

**Key `maker_opts.ctl` settings:**

| Option | Value |
| :--- | :--- |
| `genome` | `Eb314ss1_final.fasta` |
| `snaphmm` | `Moryzae.hmm` |
| `augustus_species` | `magnaporthe_grisea` |
| `keep_preds` | `1` |
| `protein` | `ncbi-protein-Magnaporthe_organism.fasta` |

**MAKER Gene Prediction Summary:**

| Metric | Value |
| :--- | :--- |
| **Number of Predicted Genes** | <!-- INSERT NUMBER FROM maker GFF3 --> |

---

### 6.4 IGV Visualization

All four tracks were loaded into IGV for comparison:
- `Eb314ss1_final.fasta` — genome assembly
- `Eb314ss1-snap.gff2` — SNAP predictions
- `Eb314ss1-augustus.gff3` — AUGUSTUS predictions
- `Eb314ss1-maker.gff3` — MAKER annotations

---

#### Gene predicted only by SNAP

<!-- INSERT IGV SCREENSHOT HERE -->
<!-- Coordinates: contig:start-end -->

---

#### Gene predicted only by AUGUSTUS

<!-- INSERT IGV SCREENSHOT HERE -->
<!-- Coordinates: contig:start-end -->

---

#### Gene where SNAP and AUGUSTUS predict the same exon/intron structure

<!-- INSERT IGV SCREENSHOT HERE -->
<!-- Coordinates: contig:start-end -->

---

#### Gene where SNAP and AUGUSTUS predict a different exon/intron structure

<!-- INSERT IGV SCREENSHOT HERE -->
<!-- Coordinates: contig:start-end -->

---

#### Gene successfully predicted by SNAP, AUGUSTUS, and MAKER with supporting external evidence

<!-- INSERT IGV SCREENSHOT HERE -->
<!-- Coordinates: contig:start-end -->
<!-- Note: external evidence track (protein alignment or EST) visible in IGV confirming the prediction -->
