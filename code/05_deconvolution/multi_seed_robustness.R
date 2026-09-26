# Reliability assessment (RQ2): reruns the full BayesPrism deconvolution
# under three additional explicit random seeds, using an identical model
# configuration to the default run in BayesPrism_Deconvolution.R.
#
# Compares posterior cell-type fractions across all runs to test whether
# the BayesPrism posterior is stable to random initialisation.
#
# Requires: myPrism object already constructed (see BayesPrism_Deconvolution.R)

library(BayesPrism)

for (s in c(42, 123, 999)) {
  set.seed(s)
  bp.seed <- run.prism(prism = myPrism, n.cores = 16)
  saveRDS(bp.seed, sprintf("~/bulk_rna_seq_project/bayesprism_seed%d.rds", s))
}

# --- Comparison against the default (unseeded) run ---
default_res <- readRDS("~/bulk_rna_seq_project/bayesprism_result.rds")
theta_default <- get.fraction(bp = default_res, which.theta = "final", state.or.type = "type")

diffs <- list()
for (s in c(42, 123, 999)) {
  bp.seed <- readRDS(sprintf("~/bulk_rna_seq_project/bayesprism_seed%d.rds", s))
  theta_seed <- get.fraction(bp = bp.seed, which.theta = "final", state.or.type = "type")
  diffs[[as.character(s)]] <- abs(theta_default - theta_seed)
}

for (s in names(diffs)) {
  cat(sprintf("Seed %s: max abs diff = %.4f, mean abs diff = %.4f\n",
              s, max(diffs[[s]]), mean(diffs[[s]])))
}

# Reported in the dissertation: max absolute difference 0.0000 and mean
# absolute difference 0.0000 across all 14 samples and 11 cell types for
# every reseeded run — full concordance with the default run.
