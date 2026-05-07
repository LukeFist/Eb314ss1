# Gene Prediction Commands

---

## SNAP

Train a custom HMM from the *M. oryzae* B71 reference, then predict genes on the Eb314ss1 assembly.

```bash
# Append genome FASTA to annotation file
echo '##FASTA' | cat B71Ref2_a0.3.gff3 - B71Ref2.fasta > B71Ref2.gff3

# Convert to ZFF, categorize, export training set, train HMM
maker2zff B71Ref2.gff3
fathom genome.ann genome.dna -categorize 1000
fathom uni.ann uni.dna -export 1000 -plus
forge export.ann export.dna
hmm-assembler.pl Moryzae . > Moryzae.hmm

# Predict genes and convert to GFF2
snap-hmm Moryzae.hmm Eb314ss1_final.fasta > Eb314ss1-snap.zff
fathom Eb314ss1-snap.zff Eb314ss1_final.fasta -gene-stats
snap-hmm Moryzae.hmm Eb314ss1_final.fasta -gff > Eb314ss1-snap.gff2
```

<details>
<summary>Predicted gene count (<code>awk '{print $9}' Eb314ss1-snap.gff3 | uniq | wc -l</code>)</summary>

```
12485
```

</details>

---

## AUGUSTUS

Predict genes using the pre-trained `magnaporthe_grisea` parameter set.

```bash
augustus --species=magnaporthe_grisea --gff3=on \
    --singlestrand=true --progress=true \
    ../snap/Eb314ss1_final.fasta > Eb314ss1-augustus.gff3
```

<details>
<summary>Predicted gene count (<code>grep -c 'start gene' Eb314ss1-augustus.gff3</code>)</summary>

```
17447
```

</details>

---

## MAKER

Combine SNAP, AUGUSTUS, and protein evidence into a consensus annotation. SLURM script: [maker.sh](../scripts/maker.sh).

```bash
# Generate config files, then edit maker_opts.ctl with settings below
singularity exec /share/singularity/images/ccs/MAKER/amd-maker-debian10.sinf maker -CTL

# Submit job (SLURM script: ../scripts/maker.sh)
sbatch maker.sh /project/farman_s26abt480/lefi229/Eb314ss1/Eb314ss1_final.fasta

# Monitor progress
cat Eb314ss1_final_maker.log

# Merge results into a single GFF3
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

**`maker_opts.ctl` key settings:**

```
genome=Eb314ss1_final.fasta
snaphmm=Moryzae.hmm
augustus_species=magnaporthe_grisea
keep_preds=1
protein=ncbi-protein-Magnaporthe_organism.fasta
```

<details>
<summary>Key <code>maker_opts.ctl</code> settings (table)</summary>

| Option | Value |
| :--- | :--- |
| `genome` | `Eb314ss1_final.fasta` |
| `snaphmm` | `Moryzae.hmm` |
| `augustus_species` | `magnaporthe_grisea` |
| `keep_preds` | `1` |
| `protein` | `ncbi-protein-Magnaporthe_organism.fasta` |

</details>

<details>
<summary>Predicted gene count (<code>awk '$3 == "gene"' ... | wc -l</code>)</summary>

```
12882
```

</details>

<details>
<summary>Predicted protein count (<code>grep -c "^>" Eb314ss1.all.maker.proteins.fasta</code>)</summary>

```
<!-- INSERT MAKER protein count here (should match gene count above) -->
```

</details>
