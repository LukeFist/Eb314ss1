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

## 4.5 Identify Optimal Assembly

Use seqkit stats to compare metrics (contig count, max contig size) across all three assemblies. For SPAdes, use the scaffolds file.

```bash
singularity run --app seqkit2900 /share/singularity/images/ccs/conda/amd-conda19-rocky9.sinf seqkit stats Eb314ss1.fasta
# For SPAdes:
singularity run --app seqkit2900 /share/singularity/images/ccs/conda/amd-conda19-rocky9.sinf seqkit stats Eb314ss1_scaffolds.fasta
```

Calculate the N50 value for the SPAdes assembly using a Python script that accepts the genome path as an argument.

```bash
python3 n50.py Eb314ss1_scaffolds.fasta
```

Choose the assembly with the fewest contigs, largest max contig size, and largest N50 value.

## 4.6 Standardize Sequence Headers

Sequence headers from assemblers are not in a standard format, which causes problems for downstream processing. Use `SimpleFastaHeaders.pl` to rename them.

```bash
# Copy script
cp /project/farman_s26abt480/SCRIPTs/SimpleFastaHeaders.pl .

perl SimpleFastaHeaders.pl path/to/Eb314ss1.fasta Eb314ss1
```

Output will be `Eb314ss1_newheader.fasta`. Verify the new file exists and that headers follow the expected format.

## 4.7 NCBI Post-Processing

NCBI rejects assemblies containing contigs shorter than 200 nt or with adapter contamination. Use the provided SLURM script to handle both.

```bash
# Copy script and update email address from LinkBlueID@uky.edu
cp /project/farman_s26abt480/SLURM_SCRIPTs/GenomePostProcess.sh .

sbatch GenomePostProcess.sh path/to/Eb314ss1_newheader.fasta
```

Output will be `Eb314ss1_final.fasta`.

## 4.8 Identify Mitochondrial Sequences

NCBI requires labeling which contigs correspond to the mitochondrial genome. BLAST the Mo mitochondrial reference against the final assembly.

```bash
# Copy reference
cp /project/farman_s26cs480/RESOURCES/MoMitochondrion.fasta .

singularity run --app blast2120 /share/singularity/images/ccs/conda/amd-conda1-centos8.sinf \
    blastn -query MoMitochondrion.fasta -subject Eb314ss1_final.fasta \
    -evalue 1e-50 -max_target_seqs 20000 \
    -outfmt '6 qseqid sseqid slen length qstart qend sstart send btop' \
    -out MoMitochondrion.Eb314ss1.BLAST
```

Export contigs where the BLAST hit covers >=90% of the contig length. This CSV is uploaded to NCBI.

```bash
awk '$4/$3 >= 0.9 {print $2 ",mitochondrion"}' MoMitochondrion.Eb314ss1.BLAST > Eb314ss1_mitochondrion.csv
```

Export hits that did NOT pass the filter for manual review. Check for split alignments that together cover >=90% of the contig and add those to the CSV.

```bash
awk '$4/$3 < 0.9' MoMitochondrion.Eb314ss1.BLAST > Eb314ss1_short_mitochondrial_hits.txt
```
