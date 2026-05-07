# BLAST Genome Interrogation Commands

This document covers commands used to BLAST Eb314ss1 against the *M. oryzae* B71v2sh reference, identify Eb314ss1 contigs lacking B71 matches, and produce an IGV-ready GFF3 of the alignments.

---

## 1. Stage BLAST Inputs

On the VM, change into the `blast/` directory. Copy the final Eb314ss1 assembly down from MCC and copy the B71 reference from the course share.

```bash
cd blast

# Pull final assembly from MCC
scp lefi229@MCC.uky.edu:/project/farman_s26abt480/lefi229/Eb314ss1/Eb314ss1_final.fasta .

# Copy B71 reference
cp /project/farman_s26abt480/BLAST/B71.fasta .
```

---

## 2. BLAST B71 (query) vs Eb314ss1 (subject)

Use the B71 reference as the query so that GFF3 features can be plotted on B71 chromosomes in IGV.

```bash
blastn -query B71.fasta -subject Eb314ss1_final.fasta \
    -evalue 1e-100 -outfmt 7 \
    > B71.Eb314ss1.BLAST
```

---

## 3. Identify Eb314ss1 Contigs Lacking B71 Matches

Run a reverse query (Eb314ss1 as query, B71 as subject) and grep for `0 hits found`.

```bash
blastn -query Eb314ss1_final.fasta -subject B71.fasta \
    -evalue 1e-100 -outfmt 7 \
    > B71.Eb314ss1reverse.BLAST

# Count contigs with no hits
grep -c "0 hits found" B71.Eb314ss1reverse.BLAST

# List contigs with no hits
grep -B 2 "0 hits found" B71.Eb314ss1reverse.BLAST | grep "Query"
```

<details>
<summary>Contig count lacking B71 matches (<code>grep -c "0 hits found"</code>)</summary>

```
1111
```

</details>

<details>
<summary>List of Eb314ss1 contigs lacking B71 matches</summary>

Full list: <!-- INSERT path to contig list file once uploaded -->

</details>

---

## 4. Convert BLAST Output to GFF3 for IGV

```bash
echo "##gff-version 3" > B71_alignments.gff3
grep -v "^#" B71.Eb314ss1.BLAST | \
    awk '{if ($9 < $10) {strand="+"} else {strand="-"}; printf "%s\t.\tblast\t%s\t%s\t.\t%s\t.\tID=%s\n", $1, $7, $8, strand, $2}' \
    >> B71_alignments.gff3

head -n 10 B71_alignments.gff3
```

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

Full GFF3: [B71_alignments.gff3](./B71_alignments.gff3)

</details>

---

## 5. Visualize in IGV

Load `B71.fasta` as the reference genome in IGV, then load `B71_alignments.gff3` as a feature track. Walk each B71 chromosome and zoom in on the largest block of unique sequence (the largest gap in the alignment track).
