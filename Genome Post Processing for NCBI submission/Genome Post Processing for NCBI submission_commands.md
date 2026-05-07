# Genome Post-Processing for NCBI Submission Commands

This document covers commands used to prepare the Eb314ss1 assembly for NCBI submission: removing short contigs and adapter contamination, and identifying mitochondrial contigs.

---

## 1. NCBI Post-Processing

NCBI rejects assemblies containing contigs shorter than 200 nt or with adapter contamination. Use the provided SLURM script to handle both.

```bash
# Copy script and update email address from LinkBlueID@uky.edu
cp /project/farman_s26abt480/SLURM_SCRIPTs/GenomePostProcess.sh .

sbatch GenomePostProcess.sh path/to/Eb314ss1_newheader.fasta
```

In-repo copy: [GenomePostProcess.sh](../scripts/GenomePostProcess.sh). Output will be `Eb314ss1_final.fasta`.

<details>
<summary>Slurm output tail (FCS_adaptor + <code>fcs.py clean</code>)</summary>

Full file: [slurm-34429226_GenomePostProcess_tail.txt](./slurm-34429226_GenomePostProcess_tail.txt)

```
[workflow GenerateReport] starting step calls_step
[step calls_step] start
[job calls_step] /tmp/nvunouyp$ pbcalls2tsv < /tmp/gr8qt8yt/stg26a46200-9025-4d64-849e-91a3ae05c368/combined.calls.jsonl > /tmp/nvunouyp/fcs_adaptor_report.txt
[job calls_step] Max memory used: 17MiB
[job calls_step] completed success
[step calls_step] completed success
[workflow GenerateReport] completed success
[step GenerateReport] completed success
[workflow ] completed success
Output will be placed in: /output-volume
Executing the workflow

Warning: Ns at the beginning or end of the sequence: >Eb314ss1_contig24
Applied 0 actions; 0 seqs dropped; 0 bps dropped; 0 bps lowercased; 0 bps hardmasked.
```

</details>

---

## 2. Identify Mitochondrial Sequences

NCBI requires labeling which contigs correspond to the mitochondrial genome. BLAST the *M. oryzae* mitochondrial reference against the final assembly.

```bash
# Copy reference
cp /project/farman_s26cs480/RESOURCES/MoMitochondrion.fasta .

singularity run --app blast2120 /share/singularity/images/ccs/conda/amd-conda1-centos8.sinf \
    blastn -query MoMitochondrion.fasta -subject Eb314ss1_final.fasta \
    -evalue 1e-50 -max_target_seqs 20000 \
    -outfmt '6 qseqid sseqid slen length qstart qend sstart send btop' \
    -out MoMitochondrion.Eb314ss1.BLAST
```

<details>
<summary>First lines of <code>MoMitochondrion.Eb314ss1.BLAST</code></summary>

```
<!-- INSERT head -n 10 MoMitochondrion.Eb314ss1.BLAST output here -->
```

</details>

Export contigs where the BLAST hit covers ≥90% of the contig length. This CSV is uploaded to NCBI.

```bash
awk '$4/$3 >= 0.9 {print $2 ",mitochondrion"}' MoMitochondrion.Eb314ss1.BLAST > Eb314ss1_mitochondrion.csv
```

<details>
<summary>Contents of <code>Eb314ss1_mitochondrion.csv</code></summary>

```
Eb314ss1_contig280,mitochondrion
Eb314ss1_contig320,mitochondrion
Eb314ss1_contig744,mitochondrion
Eb314ss1_contig777,mitochondrion
```

</details>

Supplementary BLAST evidence (BTOP strings, raw `outfmt 6` rows for the 4 passing contigs) is preserved in [Eb314ss1_mitochondrion_data.csv](./Eb314ss1_mitochondrion_data.csv).

Export hits that did NOT pass the filter for manual review. Check for split alignments that together cover ≥90% of the contig and add those to the CSV.

```bash
awk '$4/$3 < 0.9' MoMitochondrion.Eb314ss1.BLAST > Eb314ss1_short_mitochondrial_hits.txt
```

<details>
<summary>Contents of <code>Eb314ss1_short_mitochondrial_hits.txt</code></summary>

```
<!-- INSERT head -n 10 Eb314ss1_short_mitochondrial_hits.txt output here -->
```

</details>

- Mitochondrial CSV (NCBI submission): [Eb314ss1_mitochondrion.csv](./Eb314ss1_mitochondrion.csv)
- Mitochondrial BLAST btop evidence (4 passing contigs): [Eb314ss1_mitochondrion_data.csv](./Eb314ss1_mitochondrion_data.csv)
- Short hits (manual review): <!-- INSERT path to Eb314ss1_short_mitochondrial_hits.txt once uploaded -->
