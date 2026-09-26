#!/bin/bash
# Bulk RNA-seq processing via nf-core/rnaseq.
# Uses Salmon selective-alignment mode rather than full STAR alignment,
# because a full STAR workflow (FASTQ ~29GB + genome index ~28GB + BAMs ~84GB
# = ~141GB) exceeded the 100GB MeluXina Tier-2 storage quota after 11+ failed
# attempts. Salmon quantifies directly against a transcriptome index without
# writing intermediate BAM files, avoiding the largest line item entirely.
#
# Run from an interactive MeluXina compute session (see ../environment/).

set -euo pipefail

nextflow run nf-core/rnaseq \
    -profile singularity \
    --input samplesheet_template.csv \
    --outdir ~/bulk_rna_seq_project/results \
    --genome GRCh38 \
    --pseudo_aligner salmon \
    --skip_alignment \
    --max_cpus 16 \
    --max_memory 64.GB \
    -work-dir ~/bulk_rna_seq_project/work \
    -resume

# -resume is essential on a walltime-limited HPC system: Nextflow caches
# completed processes and restarts cleanly after interruption rather than
# re-running the whole pipeline from scratch.
