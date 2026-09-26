#!/bin/bash
# Converts downloaded SRA files to compressed paired FASTQ.
# Run per-sample; parallelise across samples with xargs -P on the caller side.
# Requires: SRA Toolkit 3.3.0 (fasterq-dump), pigz.
#
# Usage: ./fastq_conversion.sh <SRR_accession>

set -euo pipefail

SRR=$1
SRA_DIR=~/bulk_rna_seq_project/sra_files
FASTQ_DIR=~/bulk_rna_seq_project/fastq_files
TMP_DIR=~/bulk_rna_seq_project/tmp

mkdir -p "$FASTQ_DIR" "$TMP_DIR/$SRR"

fasterq-dump "$SRA_DIR/$SRR" \
    --outdir "$FASTQ_DIR" \
    --temp "$TMP_DIR/$SRR" \
    --split-files \
    --threads 2 \
    --progress

# Compress immediately to control peak disk usage against the 100GB Tier-2 quota
pigz -p 2 "$FASTQ_DIR/${SRR}"_*.fastq

# Clean up the per-sample temp directory once compression succeeds
rm -rf "${TMP_DIR:?}/$SRR"

echo "Done: $SRR"
