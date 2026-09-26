# DESeq2 Results

Copy these real files from your MeluXina backup into this folder:

From `meluxina_backup/bulk_rna_seq_project/`:
- `DESeq2_NOA_vs_Control.csv`
- `DESeq2_OA_vs_Control.csv`
- `DESeq2_VA_vs_Control.csv`
- `dds.rds`
- `txi.rds`
- `gene_counts_raw.csv` (or place in `data/raw_outputs/` instead — either is fine, just be consistent and note it in your dissertation appendix)
- `gene_tpm.csv`
- `tx2gene.csv`

## Column headers (CSV export note)

These CSVs export without proper column headers (R's `write.csv()` behaviour) —
if you or anyone re-opens them in R/pandas/Excel and needs to assign names,
the correct 6 columns in order are:

`GeneID, baseMean, log2FoldChange, lfcSE, pvalue, padj`

(No `stat` column in this particular export — confirmed against the actual
file during MeluXina retrieval, so don't assume the standard DESeq2 7-column
`results()` layout without checking.)

## Confirmed significant DEG counts (padj < 0.05)

- **NOA vs Control: 14** — confirmed directly from this file
- OA vs Control: not yet independently re-confirmed (see dissertation note)
- VA vs Control: not yet independently re-confirmed (see dissertation note)
