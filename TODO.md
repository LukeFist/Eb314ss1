# MyGenome Notebook — Outstanding TODOs

Tracks remaining work for the class notebook. Each section is required to include: objectives, steps performed, code/commands, embedded images, and links to large files/output files.

---

## Priority 1 — Last Remaining IGV Screenshot

- [ ] **§6.4 IGV — SNAP + AUGUSTUS + MAKER + external evidence**: capture screenshot, record `contig:start-end`, save to `./Gene Prediction/igv/snap_augustus_maker_evidence.png`, replace placeholder at [README.md:315](README.md#L315)
- [ ] **§7.4 IGV — record coordinates** for `image-4.png` (largest B71 unique sequence block) at [README.md:416](README.md#L416)

## Priority 2 — Files to Fetch from MCC

These need to be copied down from `MCC.uky.edu:/project/farman_s26abt480/lefi229/Eb314ss1/` (or regenerated) before their placeholders can be filled.

- [ ] **BUSCO `short_summary*.txt`**: fetch from `Eb314ss1_final_busco/short_summary.specific.ascomycota_odb10.Eb314ss1_final.txt`, save to `./Assess Genome Quality using BUSCO/`. Then:
  - Link from [README.md:148](README.md#L148)
  - Paste into BUSCO commands § 3 placeholder ([line 87](Assess%20Genome%20Quality%20using%20BUSCO/Assess%20Genome%20Quality%20using%20BUSCO_commands.md#L87)) and link at line 92
- [ ] **Real BUSCO slurm tail**: fetch the actual `slurm-XXXXXXX.out` from the BUSCO run (the file previously misfiled in this folder was FCS_adaptor output and has been moved to Post-Processing). Paste into BUSCO commands § 2 placeholder ([line 68](Assess%20Genome%20Quality%20using%20BUSCO/Assess%20Genome%20Quality%20using%20BUSCO_commands.md#L68)).
- [ ] **`Eb314ss1_short_mitochondrial_hits.txt`**: hits that did NOT pass the 90% length filter. Generate with `awk '$4/$3 < 0.9' MoMitochondrion.Eb314ss1.BLAST > Eb314ss1_short_mitochondrial_hits.txt`. Then:
  - Save to `./Genome Post Processing for NCBI submission/`
  - Link from [README.md:346](README.md#L346) and Post-Processing commands § 2 ([line 107](Genome%20Post%20Processing%20for%20NCBI%20submission/Genome%20Post%20Processing%20for%20NCBI%20submission_commands.md#L107))
  - Paste `head -n 10` into Post-Processing commands placeholder at [line 100](Genome%20Post%20Processing%20for%20NCBI%20submission/Genome%20Post%20Processing%20for%20NCBI%20submission_commands.md#L100)
- [ ] **Eb314ss1 contigs lacking B71 matches list**: generate with `grep -B 2 "0 hits found" B71.Eb314ss1reverse.BLAST | grep "Query" > eb314ss1_no_b71_match.txt`. Save to `./Genome Interrogation using BLAST/` and link from [README.md:366](README.md#L366) and BLAST commands [line 63](Genome%20Interrogation%20using%20BLAST/Genome%20Interrogation%20using%20BLAST_commands.md#L63).
- [ ] **`MoMitochondrion.Eb314ss1.BLAST`**: paste `head -n 10` into Post-Processing commands § 2 placeholder at [line 65](Genome%20Post%20Processing%20for%20NCBI%20submission/Genome%20Post%20Processing%20for%20NCBI%20submission_commands.md#L65).

## Priority 3 — Remaining Numeric / Text Fills

- [ ] **§6.3 MAKER protein count**: run `grep -c "^>" Eb314ss1.all.maker.proteins.fasta` on MCC, fill in [README.md:272](README.md#L272) **and** Gene Prediction commands placeholder at [line 124](Gene%20Prediction/Gene%20Prediction_commands.md#L124) (must match gene count of 12,882).
- [ ] **§1/§2 Embedded FASTQC quality plots**: README currently only *links* FASTQC HTML/PDF reports. Add embedded pre- and post-trimming per-base quality summary screenshots to README §1 and §2.
- [ ] **Sequence Data commands § 2.1**: paste exact `scp` command (replace `# TODO` at [Sequence Data commands:10](Sequence%20Data,%20Quality%20Assessment%20and%20Trimming/Sequence%20Data,%20Quality%20Assessment%20and%20Trimming_commands.md#L10)).

## Priority 4 — Optional Additions

- [ ] **VelvetOptimiser slurm tail**: not currently included anywhere. Optional — could be added to Genome Assembly commands as evidence for the k=83/k=93 rows in the §3 table. The previously-believed velvet slurm in this repo was actually FCS output.
- [ ] **Gene Prediction commands** — paste `fathom -gene-stats` SNAP output, AUGUSTUS gene count output, and MAKER `awk` count output into the existing `<details>` blocks (currently those blocks already show the numbers but not the raw command output).

---

## Recently Completed ✓

- [x] Replaced `Eb314ss1_mitochondrion.csv` placeholder in README §7.1 (commit on 2026-05-07)
- [x] Replaced `B71_alignments.gff3` placeholder in README §7.3 (commit on 2026-05-07)
- [x] Pasted `BuscoSingularity.sh` contents into BUSCO commands § 1
- [x] Linked `velvetoptimiser.sh`, `spades.sh`, `spades-paired.sh` from Genome Assembly commands § 4.2
- [x] Linked `maker.sh` from Gene Prediction commands
- [x] Linked `GenomePostProcess.sh` from Post-Processing commands § 1; embedded FCS_adaptor slurm tail
- [x] Moved misfiled FCS slurm out of the BUSCO folder into Post-Processing as `slurm-34429226_GenomePostProcess_tail.txt`
- [x] Filled `cat Eb314ss1_mitochondrion.csv` block in Post-Processing commands § 2
- [x] Linked supplementary `Eb314ss1_mitochondrion_data.csv` (BLAST btop evidence for the 4 passing contigs)
- [x] **Class Worksheet** entry submitted: 12,882 MAKER gene models
- [x] **MCC Server**: `Eb314ss1-maker.gff3` copied to `CLASS_GFFs/`
- [x] **MCC Server**: `Eb314ss1.all.maker.proteins.fasta` copied to `CLASS_PROTEINs/`
- [x] Added IGV screenshots for: SNAP-only, AUGUSTUS-only, SNAP+AUGUSTUS same structure, SNAP+AUGUSTUS different structure, B71 unique block (image-4.png)
- [x] Filled gene count tables: SNAP (12,485), AUGUSTUS (17,447), MAKER (12,882)
- [x] BUSCO short_summary excerpt embedded in README §5
- [x] Eb314ss1 contigs lacking B71 matches: 1,111 (filled in §7.2)
- [x] Documentation links normalized (README ↔ commands split)
- [x] Bandage assembly graph embedded in §3
- [x] Assembly metrics table (Velvet k=83/93, SPAdes paired/all) in §3
