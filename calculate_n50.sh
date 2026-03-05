#!/bin/bash

# Check if a filename was provided
if [ -z "$1" ]; then
    echo "Usage: bash calculate_n50.sh <filename.fasta>"
    exit 1
fi

FILE=$1

# 1. Generate sorted list of contig lengths
# This skips headers and sums up the sequence lines for each record
lengths=$(awk '/^>/ {if (seqlen){print seqlen}; seqlen=0; next} {seqlen += length($0)} END {print seqlen}' "$FILE" | sort -nr)

# 2. Calculate the Total Assembly Size and the 50% Target
total_bases=$(echo "$lengths" | awk '{sum+=$1} END {print sum}')
target=$((total_bases / 2))

# 3. Find the N50
# Loop through the sorted lengths until the running sum hits the target
running_sum=0
echo "$lengths" | while read -r len; do
    running_sum=$((running_sum + len))
    if [ "$running_sum" -ge "$target" ]; then
        echo "-----------------------------------"
        echo "Total Assembly Size: $total_bases bp"
        echo "N50 Target (50%):    $target bp"
        echo "Final N50 Value:     $len bp"
        echo "-----------------------------------"
        break
    fi
done
