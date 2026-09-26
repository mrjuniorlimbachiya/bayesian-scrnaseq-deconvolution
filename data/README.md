# Data

No raw sequencing data is included in this repository (14 bulk samples ~29GB,
25 scRNA-seq samples considerably larger) — both source datasets are public
and should be cited/linked, not redistributed:

- **GSE216907** (bulk RNA-seq): https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE216907
- **GSE254315** (scRNA-seq reference): https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE254315

## sample_metadata/

Real, verified sample-level metadata extracted directly from the GEO series
records:

- `bulk_sample_metadata_GSE216907.csv` — all 14 bulk samples: diagnosis,
  age, GEO accession, SRR accession
- `scrna_donor_metadata_GSE254315.csv` — all 25 scRNA-seq donors: short
  code (S01-S25, used throughout the dissertation's figures), GEO accession,
  age
- `salmon_mapping_rates.csv` — real per-sample Salmon mapping rates
  (Table 6-1 in the dissertation)

Processed intermediate/output files (count matrices, DESeq2 results,
BayesPrism fractions) are **not** in this folder — see
`URGENT_PULL_FROM_MELUXINA_FIRST.md` in the repository root for the full list
of what still needs retrieving from MeluXina.
