# MyGenome
Repository for storing results from genome analysis - Sample Eb314ss1

# Genome Analysis Project: lefi229

---

| Metric | Details |
| :--- | :--- |
| **Researcher** | Fister, Luke |
| **Link/ID** | lefi229 |
| **Sample Name** | Eb314ss1 |
| **NCBI Assembly Accession #** | SUB15999145 |
| **NCBI SRA Run Accession** | SRR37267536 |
| **Library Strategy / Source / Selection** | WGS / genomic / random |
| **Layout** | Paired-end |
| **Platform / Instrument** | Illumina / NovaSeq X |
| **Library Prep** | Twist Library Preparation EF2.0 with Enzymatic Fragmentation |
| **Raw Read Files** | [Eb314ss1_1.fq.gz], [Eb314ss1_2.fq.gz] |

---

# Table of Contents

1. [Assess Sequence Quality with FASTQC](#1-assess-sequence-quality-with-fastqc)
2. [Trim Adaptors and Poor Quality Sequence with Trimmomatic](#2-trim-adaptors-and-poor-quality-sequence-with-trimmomatic)
3. [Generate an Optimized MyGenome Assembly using Velvet and SPAdes](#3-generate-an-optimized-mygenome-assembly-using-velvet-and-spades)
4. [Perform Genome Post-Processing for NCBI Submission](#4-perform-genome-post-processing-for-ncbi-submission)
5. [Assess Genome Quality using BUSCO](#5-assess-genome-quality-using-busco)
6. [Gene Prediction with SNAP, AUGUSTUS, and MAKER](#6-gene-prediction-with-snap-augustus-and-maker)
7. [BLASTing MyGenome](#7-blasting-mygenome)

---

## 1. Assess Sequence Quality with FASTQC

Raw paired-end reads were assessed for quality metrics (per-base quality, GC content, adapter content, etc.) using FASTQC before any trimming.

*[View commands →](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/Sequence%20Data,%20Quality%20Assessment%20and%20Trimming_commands.md) § 2.1*

* **Raw Reads (Paired End):** 6,615,883 pairs

**FASTQC Reports (Raw):**

| Report | Link |
| :--- | :--- |
| Read 1 | [Eb314ss1_1_fastqc.html](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/FastqcHTML/Eb314ss1_1_fastqc.html) |
| Read 2 | [Eb314ss1_2_fastqc.html](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/FastqcHTML/Eb314ss1_2_fastqc.html) |

Pre-trimmed Results
![alt text](image-7.png)

---

## 2. Trim Adaptors and Poor Quality Sequence with Trimmomatic

Paired-end reads were trimmed to remove Illumina adapters and low-quality bases using Trimmomatic, producing cleaned paired and unpaired output files.

*[View commands →](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/Sequence%20Data,%20Quality%20Assessment%20and%20Trimming_commands.md) § 2.2*

* **Cleaned Reads Used for Assembly:** 5,906,576
* **Total Bases in Cleaned Reads:** 1,780,327,732

**FASTQC Reports (Post-Trimming):**

| Report | Link |
| :--- | :--- |
| Read 1 Paired | [Eb314ss1_1_paired_fastqc.html](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/FastqcHTML/Eb314ss1_1_paired_fastqc.html) |
| Read 1 Unpaired | [Eb314ss1_1_unpaired_fastqc.html](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/FastqcHTML/Eb314ss1_1_unpaired_fastqc.html) |
| Read 2 Paired | [Eb314ss1_2_paired_fastqc.html](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/FastqcHTML/Eb314ss1_2_paired_fastqc.html) |
| Read 2 Unpaired | [Eb314ss1_2_unpaired_fastqc.html](./Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/FastqcHTML/Eb314ss1_2_unpaired_fastqc.html) |

Post-Trimmed Results
![alt text](image-8.png)

---

## 3. Generate an Optimized MyGenome Assembly using Velvet and SPAdes

Cleaned reads were assembled into contigs using both Velvet and SPAdes. Multiple k-mer values and read input combinations were tested to identify the best assembly by N50.

*[View commands →](./Genome%20Assembly%20%26%20Cleanup/Genome%20Assembly%20%26%20Cleanup_commands.md) § 4.2*

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

*[View commands →](./Genome%20Assembly%20%26%20Cleanup/Genome%20Assembly%20%26%20Cleanup_commands.md) § 4.3, [View commands →](./Genome%20Post%20Processing%20for%20NCBI%20submission/Genome%20Post%20Processing%20for%20NCBI%20submission_commands.md)*

* **Assembly Accession #:** SUB15999145 (Temporary)
* **Final Cleaned Genome Size:** 40,137,340
* **Final Contig Count:** 2,492
* **Final N50:** 232,638

---

## 5. Assess Genome Quality using BUSCO

BUSCO evaluated the completeness of the final assembly by searching for conserved single-copy orthologs against the `odb10_ascomycota` reference database.

*[View commands →](./Assess%20Genome%20Quality%20using%20BUSCO/Assess%20Genome%20Quality%20using%20BUSCO_commands.md)*

* **Fold Coverage:** 44.36
* **BUSCO Score (%):** 98.60%
* **BUSCO Score (Complete + Fragmented) (%):** 98.60%

<details>
<summary>BUSCO <code>short_summary</code> excerpt</summary>

```
# BUSCO version is: 5.7.0
# The lineage dataset is: ascomycota_odb10 (Creation date: 2024-01-08, number of genomes: 365, number of BUSCOs: 1706)
# Summarized benchmarking in BUSCO notation for file /project/farman_s26abt480/lefi229/Eb314ss1/Eb314ss1_final.fasta
# BUSCO was run in mode: euk_genome_min
# Gene predictor used: miniprot

        ***** Results: *****

        C:98.6%[S:98.3%,D:0.3%],F:0.0%,M:1.4%,n:1706,E:3.9%
        1682    Complete BUSCOs (C)     (of which 65 contain internal stop codons)
        1677    Complete and single-copy BUSCOs (S)
        5       Complete and duplicated BUSCOs (D)
        0       Fragmented BUSCOs (F)
        24      Missing BUSCOs (M)
        1706    Total BUSCO groups searched

Assembly Statistics:
        2492    Number of scaffolds
        2568    Number of contigs
        40137340        Total length
        0.013%  Percent gaps
        232 KB  Scaffold N50
        179 KB  Contigs N50

Dependencies and versions:
        hmmsearch: 3.1
        bbtools: 39.06
        miniprot_index: 0.13-r248
        miniprot_align: 0.13-r248
        python: sys.version_info(major=3, minor=7, micro=12, releaselevel='final', serial=0)
        busco: 5.7.0
```

</details>

* **Full short_summary file:** <!-- INSERT path to short_summary file once uploaded -->

---

## 6. Gene Prediction with SNAP, AUGUSTUS, and MAKER

Genes were predicted using two ab initio predictors (SNAP and AUGUSTUS) trained or parameterized on related *Magnaporthe* species, followed by an evidence-based consensus annotation using MAKER.

*[View commands →](./Gene%20Prediction/Gene%20Prediction_commands.md)*

---

### 6.1 SNAP — Training and Gene Prediction

A custom HMM was trained from the annotated *M. oryzae* B71 reference strain using the `fathom` / `forge` / `hmm-assembler.pl` pipeline, then applied to the Eb314ss1 assembly.

**Headline command (gene count):**

```bash
fathom Eb314ss1-snap.zff Eb314ss1_final.fasta -gene-stats
```

<details>
<summary>Full SNAP training + prediction pipeline</summary>

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

</details>

**SNAP Gene Prediction Summary:**

| Metric | Value |
| :--- | :--- |
| **Number of Predicted Genes** | 12,485 |

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
| **Number of Predicted Genes** | 17,447 |

---

### 6.3 MAKER — Consensus Annotation

MAKER integrated SNAP predictions, AUGUSTUS predictions, and NCBI *Magnaporthe* protein evidence to produce a unified, evidence-supported annotation.

**Headline command (gene count):**

```bash
awk '$3 == "gene"' igvFiles/Eb314ss1-maker.gff3 | wc -l
```

<details>
<summary>Full MAKER setup + merge + count pipeline</summary>

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

# Count predicted genes in the MAKER GFF3
awk '$3 == "gene"' igvFiles/Eb314ss1-maker.gff3 | wc -l

# Generate proteins.fasta and verify count matches the gene count above
singularity exec /share/singularity/images/ccs/MAKER/amd-maker-debian10.sinf \
    fasta_merge \
    -d Eb314ss1_final.maker.output/Eb314ss1_final_master_datastore_index.log \
    -o Eb314ss1
grep -c "^>" Eb314ss1.all.maker.proteins.fasta
```

</details>

**MAKER Gene Prediction Summary:**

| Metric | Value |
| :--- | :--- |
| **Number of Predicted Genes**  | 12,882 |
| **Number of Predicted Proteins**  | 12,882|

---

### 6.4 IGV Visualization

All four tracks were loaded into IGV for comparison:
- `Eb314ss1_final.fasta` — genome assembly
- `Eb314ss1-snap.gff2` — SNAP predictions
- `Eb314ss1-augustus.gff3` — AUGUSTUS predictions
- `Eb314ss1-maker.gff3` — MAKER annotations

---

#### Gene predicted only by SNAP

![alt text](image.png)
contig1:555846-556197

---

#### Gene predicted only by AUGUSTUS

![alt text](image-1.png)
contig1:1703850-1704328
---

#### Gene where SNAP and AUGUSTUS predict the same exon/intron structure

![alt text](image-2.png)
contig1:1588496-1589518

---

#### Gene where SNAP and AUGUSTUS predict a different exon/intron structure

![alt text](image-3.png)
contig1:522509-524073

---

#### Gene successfully predicted by SNAP, AUGUSTUS, and MAKER supported by RNA Seq Reads

![alt text](image-5.png)
contig1:915539-916615

---

#### Gene showing strong prediction inPlanta, but not inCulture

![alt text](image-6.png)
contig1:981489-982843

---

## 7. BLASTing MyGenome

The Eb314ss1 assembly was BLASTed against the *M. oryzae* B71v2sh reference to identify Eb314ss1 contigs absent from B71 and large B71 regions absent from Eb314ss1. 

The mitochondrial-contig CSV submitted to NCBI was generated by the same workflow.

*[View commands →](./Genome%20Interrogation%20using%20BLAST/Genome%20Interrogation%20using%20BLAST_commands.md)*

---

### 7.1 Mitochondrial Contig Identification

Contigs covered ≥90% by hits to `MoMitochondrion.fasta` were exported as the NCBI submission CSV. Short hits below the threshold were retained for manual review of split alignments.

*[View commands →](./Genome%20Post%20Processing%20for%20NCBI%20submission/Genome%20Post%20Processing%20for%20NCBI%20submission_commands.md)*

| Output | Link |
| :--- | :--- |
| Mitochondrial CSV (submitted to NCBI) | [Eb314ss1_mitochondrion.csv](./Genome%20Post%20Processing%20for%20NCBI%20submission/Eb314ss1_mitochondrion.csv) |
| Short hits (manual review) | <!-- INSERT path to Eb314ss1_short_mitochondrial_hits.txt once uploaded --> |

---

### 7.2 BLAST Eb314ss1 vs B71 Reference

The B71 reference was used as both query (to find B71 regions absent from Eb314ss1) and subject (to find Eb314ss1 contigs absent from B71).

**Headline command (contig count):**

```bash
grep -c "0 hits found" blast/B71.Eb314ss1reverse.BLAST
```

| Metric | Value |
| :--- | :--- |
| **Eb314ss1 contigs lacking B71 matches** | 1,111 |

| Output | Link |
| :--- | :--- |
| List of Eb314ss1 contigs without B71 matches | <!-- INSERT path to file once uploaded --> |

---

### 7.3 Convert BLAST Output to GFF3 for IGV

The B71-as-query BLAST output was converted to a GFF3 feature track so that alignments can be plotted on the B71 chromosomes in IGV. Strand is inferred from whether the subject start coordinate is less than the subject end.

<details>
<summary>Conversion pipeline</summary>

```bash
echo "##gff-version 3" > blast/B71_alignments.gff3
grep -v "^#" blast/B71.Eb314ss1.BLAST | \
    awk '{if ($9 < $10) {strand="+"} else {strand="-"}; printf "%s\t.\tblast\t%s\t%s\t.\t%s\t.\tID=%s\n", $1, $7, $8, strand, $2}' \
    >> blast/B71_alignments.gff3
head -n 10 blast/B71_alignments.gff3
```

</details>

<details>
<summary>First 10 lines of <code>B71_alignments.gff3</code></summary>

```
##gff-version 3
Chr1    .    blast    3252578    3436802    .    -    .    ID=Eb314ss1_contig50
Chr1    .    blast    3436827    3471467    .    -    .    ID=Eb314ss1_contig50
Chr1    .    blast    3471453    3485179    .    -    .    ID=Eb314ss1_contig50
Chr1    .    blast    746643     862341     .    -    .    ID=Eb314ss1_contig11
Chr1    .    blast    1007190    1080656    .    -    .    ID=Eb314ss1_contig11
Chr1    .    blast    1098067    1144259    .    -    .    ID=Eb314ss1_contig11
Chr1    .    blast    951763     985039     .    -    .    ID=Eb314ss1_contig11
Chr1    .    blast    864431     891547     .    -    .    ID=Eb314ss1_contig11
Chr1    .    blast    1408887    1433782    .    -    .    ID=Eb314ss1_contig11
```

</details>

| Output | Link |
| :--- | :--- |
| Full BLAST GFF3 | [B71_alignments.gff3](./Genome%20Interrogation%20using%20BLAST/B71_alignments.gff3) |

---

### 7.4 IGV — B71 Unique Sequence Block

The B71 reference was loaded into IGV with `B71_alignments.gff3` as a feature track to visualize chromosome regions lacking matches in Eb314ss1.

![alt text](image-4.png)
Chromosome8:981408-1003073
