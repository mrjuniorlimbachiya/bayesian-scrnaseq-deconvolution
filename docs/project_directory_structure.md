# MeluXina Project Directory Structure

Corresponds to Appendix A in the dissertation. This is the layout on the
MeluXina Tier-2 filesystem under project account p201238 (user u103869) - not
the layout of this supporting-material repository itself.

```
/mnt/tier2/users/u103869/bulk_rna_seq_project/
├── sra_files/              <- Downloaded SRA files
├── fastq_files/            <- Converted & compressed FASTQ (28 files, ~29GB)
├── results/                <- nf-core/rnaseq pipeline output
├── work/                   <- Nextflow working directory
├── counts/                 <- 14 Salmon quant.sf directories
├── scrna/                  <- scRNA-seq reference matrix and plots
│   ├── sc_ref_matrix.rds
│   ├── sc_cell_labels.rds
│   └── sample_id_lookup.csv       <- short-code to GEO accession mapping
├── figures/                <- DESeq2 outputs
├── bayesprism_figures/     <- BayesPrism PDFs
├── final_figures/          <- Integration and enrichment PDFs
├── integration/            <- DEG-cell type mapped CSVs
├── enrichment/             <- GO and KEGG result CSVs
├── transcript_index/       <- Salmon index (GENCODE v44, 194,142 targets)
├── txi.rds
├── dds.rds
├── gene_counts_raw.csv
├── bulk_matrix_symbols.rds        <- harmonised, gene-space-aligned bulk matrix
├── bayesprism_result.rds
├── bayesprism_cell_fractions.csv
├── bayesprism_statistics.csv
├── bayesprism_seed42.rds
├── bayesprism_seed123.rds
└── bayesprism_seed999.rds

/mnt/tier2/users/u103869/rna_seq_project/results/GSE254315/   <- scRNA-seq raw reference
```

## Key output files, by pipeline stage

| Stage | File | Description |
|---|---|---|
| Quantification | `txi.rds` | tximport gene-level count object |
| Differential expression | `dds.rds` | DESeq2 dataset post-`DESeq()` |
| Differential expression | `gene_counts_raw.csv` | Raw gene-level count matrix (34,486 genes x 14 samples) |
| Gene-ID harmonisation | `bulk_matrix_symbols.rds` | Bulk matrix, Ensembl->HGNC converted, gene-space-aligned |
| scRNA reference | `sc_ref_matrix.rds` | Annotated reference matrix (107,302 cells x shared genes) |
| scRNA reference | `sc_cell_labels.rds` | Cell-type label vector, matching sc_ref_matrix rows |
| scRNA reference | `sample_id_lookup.csv` | S01-S25 short code to GSM accession mapping |
| Deconvolution | `bayesprism_result.rds` | Full BayesPrism output (default run) |
| Deconvolution | `bayesprism_cell_fractions.csv` | Extracted posterior cell-type fractions |
| Deconvolution | `bayesprism_statistics.csv` | Summary statistics per cell type/group |
| Robustness | `bayesprism_seed{42,123,999}.rds` | Reseeded reruns for RQ2 reliability testing |

## Compute environment

All computationally intensive steps run via SLURM `salloc`/`srun`, 16 CPU
cores, 64GB RAM. R 4.5.1 loaded via the `env/staging/2023.1` module
environment; personal R libraries maintained at `~/R/library`.
