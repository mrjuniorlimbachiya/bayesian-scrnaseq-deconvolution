# ============================================================
# BayesPrism Deconvolution — Human Testicular Bulk RNA-seq
# Dataset: GSE216907 (bulk) + GSE254315 (scRNA-seq reference)
# Author: Manthan Limbachiya | MSc AI & ML | University of Limerick
# Date: 19 June 2026
# BayesPrism version: 2.2.3
# ============================================================

.libPaths(c("~/R/library", .libPaths()))

library(BayesPrism)
library(org.Hs.eg.db)
library(AnnotationDbi)

# 1. Load inputs ────────────────────────────────────────────────────────────

cat("Loading sc reference matrix...\n")
sc_matrix   <- readRDS("~/bulk_rna_seq_project/scrna/sc_ref_matrix.rds")
cell_labels <- readRDS("~/bulk_rna_seq_project/scrna/sc_cell_labels.rds")

cat("SC matrix dim:", dim(sc_matrix), "\n")
cat("Cell types:\n"); print(table(cell_labels))

cat("Loading bulk counts...\n")
bulk_raw <- read.csv("~/bulk_rna_seq_project/gene_counts_raw.csv", row.names = 1)

# 2. Convert bulk Ensembl IDs → HGNC gene symbols ──────────────────────────

# Bulk matrix uses Ensembl IDs; scRNA-seq reference uses HGNC symbols.
# Direct intersection yields 0 shared genes — conversion required.

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
keep         <- !is.na(symbols) & !duplicated(symbols)
bulk_conv    <- bulk_raw[keep, ]
rownames(bulk_conv) <- symbols[keep]

# Transpose: BayesPrism expects samples x genes
bulk_matrix  <- t(round(bulk_conv))

# 3. Align gene feature space ───────────────────────────────────────────────

shared_genes <- intersect(colnames(bulk_matrix), colnames(sc_matrix))
cat("Shared genes between bulk and scRNA:", length(shared_genes), "\n")

bulk_matrix <- bulk_matrix[, shared_genes]
sc_matrix   <- sc_matrix[,  shared_genes]

# Save harmonised bulk matrix
saveRDS(bulk_matrix, "~/bulk_rna_seq_project/bulk_matrix_symbols.rds")

# 4. Build BayesPrism object ────────────────────────────────────────────────

cat("Building BayesPrism object...\n")
bp_obj <- new.prism(
  reference         = sc_matrix,
  mixture           = bulk_matrix,
  input.type        = "count.matrix",
  cell.type.labels  = cell_labels,
  cell.state.labels = cell_labels,   # No sub-state resolution used
  key               = NULL,          # No tumour reference; all cell types treated equally
  outlier.cut       = 0.01,
  outlier.fraction  = 0.1
)

# 5. Run BayesPrism (two Gibbs sampling passes) ─────────────────────────────

cat("Running BayesPrism — started at:", format(Sys.time()), "\n")
bp_res <- run.prism(prism = bp_obj, n.cores = 16)

saveRDS(bp_res, "~/bulk_rna_seq_project/bayesprism_result.rds")
cat("BayesPrism complete at:", format(Sys.time()), "\n")

# 6. Extract final posterior cell-type fractions (theta) ────────────────────

theta <- get.fraction(
  bp             = bp_res,
  which.theta    = "final",
  state.or.type  = "type"
)

write.csv(theta, "~/bulk_rna_seq_project/bayesprism_cell_fractions.csv")
cat("Cell fractions saved. Dimensions:", dim(theta), "\n")
print(round(theta, 4))