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

<!-- INSERT BuscoSingularity.sh contents (or link to copy in repo) -->

---

## 2. Monitor Progress

```bash
# Find recent slurm output and BUSCO logfile
ls -lrt

# Watch slurm output
tail -f slurm-XXXXXXX.out
```

---

## 3. View Results

The completeness summary is in the `short_summary` file inside the BUSCO output directory.

```bash
cat Eb314ss1_final_busco/short_summary*.txt
```

- short_summary file: <!-- INSERT path to short_summary file once uploaded -->
