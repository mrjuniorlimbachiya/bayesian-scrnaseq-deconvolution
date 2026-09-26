# Differential gene expression across the three infertility phenotypes
# (NOA, OA, VA) versus fertile Control, from the tximport-derived gene-level
# count matrix.
#
# Requires: DESeq2, tximport, ashr (Bioconductor)
# Input:  txi     - tximport object built from Salmon quant.sf files
#         coldata - sample metadata data.frame with a `condition` column
#                   (levels: "NOA", "OA", "VA", "Control"; Control as reference)

library(DESeq2)

dds <- DESeqDataSetFromTximport(txi, colData = coldata, design = ~ condition)

# Relevel so Control is the reference for every contrast
dds$condition <- relevel(dds$condition, ref = "Control")

# Low-count filtering: at least 10 counts in at least 3 samples
dds <- dds[rowSums(counts(dds) >= 10) >= 3, ]

dds <- DESeq(dds)
saveRDS(dds, "~/bulk_rna_seq_project/dds.rds")

# Three contrasts, each with ashr log-fold-change shrinkage
res_noa <- lfcShrink(dds, contrast = c("condition", "NOA", "Control"), type = "ashr")
res_oa  <- lfcShrink(dds, contrast = c("condition", "OA",  "Control"), type = "ashr")
res_va  <- lfcShrink(dds, contrast = c("condition", "VA",  "Control"), type = "ashr")

write.csv(as.data.frame(res_noa), "~/bulk_rna_seq_project/figures/deseq2_NOA_vs_Control.csv")
write.csv(as.data.frame(res_oa),  "~/bulk_rna_seq_project/figures/deseq2_OA_vs_Control.csv")
write.csv(as.data.frame(res_va),  "~/bulk_rna_seq_project/figures/deseq2_VA_vs_Control.csv")

# Diagnostic plots — worth generating alongside the volcano plots already in
# the thesis, since reviewers typically expect these to confirm the
# negative-binomial model fit reasonably:
pdf("~/bulk_rna_seq_project/figures/deseq2_diagnostics.pdf")
plotDispEsts(dds)
plotMA(res_noa, main = "NOA vs Control")
plotMA(res_oa,  main = "OA vs Control")
plotMA(res_va,  main = "VA vs Control")
hist(res_noa$pvalue, breaks = 50, main = "p-value distribution: NOA vs Control")
hist(res_oa$pvalue,  breaks = 50, main = "p-value distribution: OA vs Control")
hist(res_va$pvalue,  breaks = 50, main = "p-value distribution: VA vs Control")
dev.off()
