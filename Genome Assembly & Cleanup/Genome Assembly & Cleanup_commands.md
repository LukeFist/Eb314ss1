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

### Velvet Assembly via VelvetOptimiser

Velvet k-mer sweeps were submitted via SLURM script [velvetoptimiser.sh](../scripts/velvetoptimiser.sh), which wraps `VelvetOptimiser.pl` in singularity. The script accepts `strainID lowK highK step` and produces an output directory `velvet_<strainID>_<lowK>_<highK>_<step>_noclean/`. The two best assemblies in the README §3 table (k=83 and k=93) were drawn from this sweep.

```bash
sbatch velvetoptimiser.sh Eb314ss1 71 99 2
```

The equivalent manual invocations (for reference) are:

```bash
velveth velvet_k83 83 -fastq -shortPaired interleaved.fastq
velvetg velvet_k83 -exp_cov auto -cov_cutoff auto

velveth velvet_k93 93 -fastq -shortPaired interleaved.fastq
velvetg velvet_k93 -exp_cov auto -cov_cutoff auto
```

### SPAdes Assembly (Paired + Unpaired)

Submitted via SLURM script [spades.sh](../scripts/spades.sh) (paired + unpaired reads).

```bash
sbatch spades.sh /path/to/readsdir Eb314ss1
```

Equivalent direct invocation:

```bash
spades.py --careful -t 8 -m 64 \
    -1 Eb314ss1_1_paired.fastq.gz -2 Eb314ss1_2_paired.fastq.gz \
    --unpaired Eb314ss1_1_unpaired.fastq.gz --unpaired Eb314ss1_2_unpaired.fastq.gz \
    -o spades_paired_unpaired
```

### SPAdes Assembly (Paired Only)

Submitted via SLURM script [spades-paired.sh](../scripts/spades-paired.sh). This assembly produced the best N50 value.

```bash
sbatch spades-paired.sh /path/to/readsdir Eb314ss1
```

Equivalent direct invocation:

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

> NCBI post-processing (short-contig + adapter removal) and mitochondrial-contig identification have moved to [Genome%20Post%20Processing%20for%20NCBI%20submission_commands.md](../Genome%20Post%20Processing%20for%20NCBI%20submission/Genome%20Post%20Processing%20for%20NCBI%20submission_commands.md).
