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

Output will be `Eb314ss1_final.fasta`.

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

Export contigs where the BLAST hit covers ≥90% of the contig length. This CSV is uploaded to NCBI.

```bash
awk '$4/$3 >= 0.9 {print $2 ",mitochondrion"}' MoMitochondrion.Eb314ss1.BLAST > Eb314ss1_mitochondrion.csv
```

Export hits that did NOT pass the filter for manual review. Check for split alignments that together cover ≥90% of the contig and add those to the CSV.

```bash
awk '$4/$3 < 0.9' MoMitochondrion.Eb314ss1.BLAST > Eb314ss1_short_mitochondrial_hits.txt
```

- Mitochondrial CSV (NCBI submission): <!-- INSERT path to Eb314ss1_mitochondrion.csv once uploaded -->
- Short hits (manual review): <!-- INSERT path to Eb314ss1_short_mitochondrial_hits.txt once uploaded -->
