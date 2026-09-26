# Regenerates clean, single-metric QC figures from the annotated Seurat
# object, with short S01-S25 sample codes instead of full GSM accession
# strings on axis labels. Produces one PNG per metric plus a shared legend,
# replacing the cramped three-panel screenshots used as a stopgap in
# figures/scrna_qc_cleaned/.
#
# Requires: Seurat, ggplot2, cowplot, dplyr
# Run this against the real annotated Seurat object once retrieved from
# MeluXina (see URGENT_PULL_FROM_MELUXINA_FIRST.md).

library(Seurat)
library(ggplot2)
library(cowplot)
library(dplyr)

# ---- 1. Short sample codes + lookup table ----
# NOTE: data/sample_metadata/scrna_donor_metadata_GSE254315.csv already
# contains the real S01-S25 <-> GSM accession mapping used throughout the
# dissertation - use that file directly rather than regenerating codes here,
# so the labels stay consistent with the thesis text.
long_ids  <- levels(factor(seurat_obj$orig.ident))     # adjust to your metadata column
short_ids <- paste0("S", sprintf("%02d", seq_along(long_ids)))
names(short_ids) <- long_ids

seurat_obj$plot_id          <- short_ids[seurat_obj$orig.ident]
seurat_obj_filtered$plot_id <- short_ids[seurat_obj_filtered$orig.ident]

# ---- 2. Shared clean theme ----
qc_theme <- theme_minimal(base_size = 12) +
  theme(
    legend.position    = "none",
    axis.text.x        = element_text(angle = 45, hjust = 1, size = 9),
    axis.title          = element_text(size = 11),
    plot.title          = element_text(hjust = 0.5, face = "bold", size = 13),
    panel.grid.minor    = element_blank(),
    panel.grid.major.x  = element_blank()
  )

# ---- 3. One function, six clean single-metric violin plots ----
save_qc_violin <- function(obj, feature, title, ylab, file, ylim = NULL) {
  p <- VlnPlot(obj, features = feature, group.by = "plot_id", pt.size = 0) +
    ggtitle(title) + ylab(ylab) + xlab(NULL) + qc_theme
  if (!is.null(ylim)) p <- p + coord_cartesian(ylim = ylim)
  ggsave(file, p, width = 9, height = 4.5, dpi = 300, bg = "white")
}

out <- "~/bulk_rna_seq_project/scrna/"
save_qc_violin(seurat_obj,          "nFeature_RNA", "Genes per Cell - Before Filtering", "nFeature_RNA", paste0(out, "qc_before_nFeature.png"))
save_qc_violin(seurat_obj,          "nCount_RNA",   "UMIs per Cell - Before Filtering",  "nCount_RNA",   paste0(out, "qc_before_nCount.png"))
save_qc_violin(seurat_obj,          "percent.mt",   "Mitochondrial %% - Before Filtering", "percent.mt", paste0(out, "qc_before_mt.png"))
save_qc_violin(seurat_obj_filtered, "nFeature_RNA", "Genes per Cell - After Filtering",  "nFeature_RNA", paste0(out, "qc_after_nFeature.png"))
save_qc_violin(seurat_obj_filtered, "nCount_RNA",   "UMIs per Cell - After Filtering",   "nCount_RNA",   paste0(out, "qc_after_nCount.png"))
save_qc_violin(seurat_obj_filtered, "percent.mt",   "Mitochondrial %% - After Filtering", "percent.mt", paste0(out, "qc_after_mt.png"))

# ---- 4. Genes vs UMIs scatter, legend split into its own file ----
make_scatter <- function(obj, title) {
  ggplot(obj@meta.data, aes(x = nCount_RNA, y = nFeature_RNA, colour = plot_id)) +
    geom_point(size = 0.3, alpha = 0.4) +
    ggtitle(title) + xlab("nCount_RNA") + ylab("nFeature_RNA") +
    theme_minimal(base_size = 12) +
    theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 13))
}

p_before <- make_scatter(seurat_obj,          "Genes vs UMIs - Before Filtering")
p_after  <- make_scatter(seurat_obj_filtered, "Genes vs UMIs - After Filtering")

ggsave(paste0(out, "genes_vs_umis_before.png"), p_before + theme(legend.position = "none"), width = 6, height = 5, dpi = 300, bg = "white")
ggsave(paste0(out, "genes_vs_umis_after.png"),  p_after  + theme(legend.position = "none"), width = 6, height = 5, dpi = 300, bg = "white")

legend_only <- get_legend(
  p_before + guides(colour = guide_legend(ncol = 3, override.aes = list(size = 3, alpha = 1))) +
    theme(legend.title = element_blank(), legend.text = element_text(size = 8))
)
ggsave(paste0(out, "sample_legend.png"), legend_only, width = 5, height = 4, dpi = 300, bg = "white")
