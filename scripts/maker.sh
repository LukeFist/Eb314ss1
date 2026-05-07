#!/bin/bash

#SBATCH --time 48:00:00
#SBATCH --job-name=maker
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=8
#SBATCH --partition=normal
#SBATCH --mem=500GB
#SBATCH -A cea_farman_s26abt480
#SBATCH --mail-type ALL
#SBATCH --mail-user lefi229@uky.edu

genome=$1

singularity exec /share/singularity/images/ccs/MAKER/amd-maker-debian10.sinf maker --genome $genome 2>&1 | tee -- ${genome/\.fasta}_maker.log
