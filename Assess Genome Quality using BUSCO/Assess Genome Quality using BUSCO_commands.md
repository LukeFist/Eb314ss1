# BUSCO Commands

This document covers commands used to assess genome completeness with BUSCO (Benchmarking Using Single-Copy Orthologs) against the `odb10_ascomycota` database.

---

## 1. Submit BUSCO via SLURM

Copy the BUSCO SLURM script into the working directory under `/project/farman_s26abt480/lefi229/`, set the email address, then submit using a **relative** path to the final assembly.

```bash
cp /project/farman_s26abt480/SLURM_SCRIPTs/BuscoSingularity.sh .

# Edit the script and replace LinkBlueID@uky.edu with your email
nano BuscoSingularity.sh

sbatch BuscoSingularity.sh Eb314ss1_final.fasta
```

In-repo copy: [BuscoSingularity.sh](../scripts/BuscoSingularity.sh)

<details>
<summary><code>BuscoSingularity.sh</code> contents</summary>

```bash
#!/bin/bash

#SBATCH --time 8:00:00
#SBATCH --job-name=busco
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --partition=normal
#SBATCH --mem=180GB
#SBATCH --mail-type ALL
#SBATCH	-A cea_farman_s26abt480
#SBATCH --mail-type ALL
#SBATCH --mail-user lefi229@uky.edu

echo "SLURM_NODELIST: "$SLURM_NODELIST
echo "PWD :" $PWD

in=$1
out=${in/\.fasta/}_busco

singularity run --app busco570 /share/singularity/images/ccs/conda/amd-conda14-rocky8.sinf busco \
 --in $in --out $out --mode genome --lineage_dataset ascomycota_odb10 -f
```

</details>

---

## 2. Monitor Progress

```bash
# Find recent slurm output and BUSCO logfile
ls -lrt

# Watch slurm output
tail -f slurm-XXXXXXX.out
```

<details>
<summary>Sample <code>slurm-XXXXXXX.out</code> tail</summary>

```
<!-- INSERT slurm output tail here -->
```

</details>

---

## 3. View Results

The completeness summary is in the `short_summary` file inside the BUSCO output directory.

```bash
cat Eb314ss1_final_busco/short_summary*.txt
```

<details>
<summary><code>short_summary*.txt</code> excerpt</summary>

```
<!-- INSERT contents of short_summary*.txt here -->
```

</details>

- short_summary file: <!-- INSERT path to short_summary file once uploaded -->
