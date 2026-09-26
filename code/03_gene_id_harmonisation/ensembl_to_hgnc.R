# Harmonises the bulk RNA-seq count matrix (Ensembl gene IDs) with the
# scRNA-seq reference matrix (HGNC gene symbols) so BayesPrism has a shared
# gene space to work with. Without this step there are zero overlapping
# genes between the two matrices.
#
# Requires: org.Hs.eg.db (Bioconductor)
# Input:  bulk_raw  - genes x samples count matrix, rownames = Ensembl IDs
#         sc_matrix - cells x genes count matrix, colnames = HGNC symbols
# Output: bulk_matrix_symbols.rds - harmonised, gene-space-aligned bulk matrix

library(org.Hs.eg.db)

cat("Converting Ensembl IDs to gene symbols...\n")
symbols <- mapIds(
  org.Hs.eg.db,
  keys      = rownames(bulk_raw),
  column    = "SYMBOL",
  keytype   = "ENSEMBL",
  multiVals = "first"
)
cat("Mapped:", sum(!is.na(symbols)), "of", length(symbols), "Ensembl IDs\n")

# Keep only successfully mapped, non-duplicate symbols
keep      <- !is.na(symbols) & !duplicated(symbols)
bulk_conv <- bulk_raw[keep, ]
rownames(bulk_conv) <- symbols[keep]

# BayesPrism expects samples x genes
bulk_matrix <- t(round(bulk_conv))

# Align to the shared gene space with the scRNA-seq reference
shared_genes <- intersect(colnames(bulk_matrix), colnames(sc_matrix))
cat("Shared genes between bulk and scRNA:", length(shared_genes), "\n")

bulk_matrix <- bulk_matrix[, shared_genes]
sc_matrix   <- sc_matrix[,  shared_genes]

saveRDS(bulk_matrix, "~/bulk_rna_seq_project/bulk_matrix_symbols.rds")
