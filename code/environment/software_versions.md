# Software Environment

Full computational environment used on MeluXina compute nodes, corresponding
to Table 5-1 in the dissertation.

| Component | Version | Purpose |
|---|---|---|
| Nextflow | 25.04.8 | Workflow orchestration |
| Apptainer | 1.4.2-GCCcore-14.2.0 | Container runtime |
| SRA Toolkit | 3.3.0 | Data acquisition and FASTQ conversion |
| FastQC | 0.12.1 (manually installed) | Read quality assessment |
| Java (OpenJDK) | 21 (manually installed) | Required Nextflow runtime (system default was v11, insufficient) |
| R | 4.5 (Bioconductor 3.22) | Seurat, DESeq2, BayesPrism |
| Seurat | v5 | scRNA-seq processing |
| DESeq2 | v1.42 | Differential expression |
| BayesPrism | v2.2.3 | Bayesian deconvolution |
| Salmon | 1.10.0 | Transcript quantification (selective-alignment mode) |
| clusterProfiler | (Bioconductor 3.22-compatible) | GO/KEGG functional enrichment |

## Container caching

Singularity/Apptainer container images were cached outside the home directory
to avoid quota pressure:

```bash
export NXF_SINGULARITY_CACHEDIR=/mnt/tier2/users/u103869/singularity_cache
export APPTAINER_CACHEDIR=/mnt/tier2/users/u103869/singularity_cache
```

## Java installation

Manually installed to `/mnt/tier2/users/u103869/jdk-21`; `JAVA_HOME` and
`PATH` updated persistently in `~/.bashrc`.

## R / Bioconductor version pinning

The default Bioconductor release resolved to 3.18, while R 4.5 required 3.22
- this mismatch produced cascading package installation failures (`00LOCK`
errors, a broken `rtracklayer` -> `GenomicFeatures` dependency chain). Fixed
by pinning explicitly:

```r
BiocManager::install(version = "3.22")
```

and consolidating to a single user library path rather than allowing R to
resolve packages from two library paths with conflicting Bioconductor
version assumptions.
