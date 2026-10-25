# Pancreatic Islet T2D Co-expression & lncRNA Prioritisation

An integrative RNA-seq analysis of human pancreatic islet transcriptomes across the normoglycaemic → impaired glucose tolerance → type 2 diabetes (ND–IGT–T2D) disease continuum. Combines differential expression, long non-coding RNA (lncRNA) prioritisation, weighted gene co-expression network analysis (WGCNA), functional enrichment, and machine learning classification into a single reproducible pipeline, built on the publicly available dataset from Wigger et al. (2021, *Nature Metabolism*, GSE164416).

This repository extends that original study's dataset with analyses not present in the source paper: a composite lncRNA prioritisation score, a network-integration score linking lncRNAs to WGCNA hub genes, ML-based disease-stage classification, and a nested cross-validation robustness check.

## Repository structure

```
.
├── scripts/               # Numbered analysis pipeline (see Pipeline Workflow below)
├── data/
│   ├── raw/                # Downloaded GEO count matrix, GENCODE annotation, metadata (gitignored: large files)
│   ├── metadata/            # Sample/clinical metadata, gene annotation tables
│   ├── processed/           # Filtered counts, VST-normalised matrices, DESeq2 objects
│   └── reference/           # STAR index (gitignored — regenerate via scripts/00A)
├── results/
│   ├── de/                  # Differential expression tables & plots
│   ├── lncrna/               # lncRNA prioritisation & network integration tables/plots
│   ├── wgcna/                # Co-expression modules, module-trait correlations, hub genes
│   ├── enrichment/            # GO/KEGG enrichment tables & plots
│   ├── ml/                   # Classifier metrics, feature importances, SHAP rankings
│   ├── nested_validation/     # 5-fold robustness check (independent re-runs of the full pipeline)
│   ├── qc/                   # QC diagnostics
│   ├── figures/               # Final polished manuscript figures (fig1–fig9, PNG + PDF)
│   ├── all_plots/             # All exploratory plots from every pipeline stage, consolidated in one place for browsing
│   └── reports/                # Submission bundle, supplementary tables
├── docs/                   # Dissertation deliverables (Word/PowerPoint/Excel — not analysis code)
├── RMarkdowns/              # R Markdown writeups of results/appendix tables
├── config/, envs/           # Project config and reproducible environment specs (renv.lock, environment.yml)
└── logs/                   # Pipeline run logs
```

## Data used for machine learning

The ML classifiers (Section `08_ml_models.py`) are trained on:

| File | Role |
|---|---|
| `results/wgcna/tables/wgcna_expression_input.tsv` | VST-normalised expression matrix (feature matrix, 98 samples) |
| `results/wgcna/tables/wgcna_traits_input.csv` | Sample-level disease status and clinical traits (labels) |
| `results/wgcna/hubgenes/tables/wgcna_top20_hub_genes_per_focus_module.csv` | Candidate feature set (top hub genes per focus module) |
| `results/wgcna/modules/wgcna_gene_module_assignments.csv` | Gene → WGCNA module mapping, used for feature grouping |

All four files are present in this repository under `results/wgcna/`. Nothing the ML step depends on is missing or external.

## Pipeline workflow

The numbered scripts in `scripts/` run in order and form three linked stages: **differential expression → lncRNA/WGCNA co-expression → machine learning**, with functional enrichment and a robustness check layered on top.

### Stage 1 — Data preparation
| Script | Purpose |
|---|---|
| `00A_fastq_to_counts.sh` | Reproducibility-only dry-run of the original FASTQ→counts pipeline (SRA fetch → FastQC → fastp → STAR 2-pass → HTSeq). Not used to regenerate data — the GEO-deposited count matrix is used directly. |
| `00_download_data.R` | Downloads the GSE164416 count matrix, GENCODE v46 annotation, and sample metadata from GEO. |
| `01_prepare_metadata.R` | Merges donor clinical metadata (disease status, age, BMI, HbA1c, 2-hour glycaemia) with the count matrix. |
| `02_qc_filter_normalise.R` | Subsets to the 98 ND/IGT/T2D samples, applies low-count gene filtering (20,042 genes retained), and VST-normalises via DESeq2. |

### Stage 2 — Differential expression
| Script | Purpose |
|---|---|
| `03_differential_expression.R` | DESeq2 pairwise contrasts (T2D vs ND, IGT vs ND, T2D vs IGT); Wald test, BH-FDR correction. |
| `C1_de_covariate_adjusted.R` | Sensitivity model (`~age + bmi + status`) testing whether DEGs survive adjustment for confounding clinical variables. |

### Stage 3 — lncRNA prioritisation
| Script | Purpose |
|---|---|
| `04_lncrna_prioritisation.R` | Filters DEGs to GENCODE-annotated lncRNAs; computes the composite prioritisation score (rescaled statistical confidence + effect size + expression magnitude) and cross-comparison recurrence score. |
| `06_lncrna_annotation.R` | Resolves missing gene symbols via Ensembl BioMart; maps prioritised lncRNAs onto WGCNA module assignments and computes the network-integration score. |

### Stage 4 — Co-expression network (WGCNA)
| Script | Purpose |
|---|---|
| `05A_prepare_wgcna_inputs.R` | Builds the VST expression matrix and clinical trait table used as WGCNA input. |
| `05B_wgcna_construct_network.R` | Signed WGCNA network construction (soft-thresholding power selection, `blockwiseModules()`, 30 modules identified). |
| `05C_hub_gene_prioritisation.R` | Module-trait correlation (with BH correction), module eigengene/Gene Significance calculation, and composite hub-gene scoring (kME + GS + DE evidence) within the 8 focus modules. |
| `W1_tom_heatmap.R` | Topological overlap matrix heatmap visualisation for focus-module hub genes. |

### Stage 5 — Functional enrichment
| Script | Purpose |
|---|---|
| `07_enrichment_analysis.R` | GO (BP/MF) and KEGG over-representation analysis via clusterProfiler, run on each DE gene set and each WGCNA focus module. |

### Stage 6 — Machine learning classification
| Script | Purpose |
|---|---|
| `08_ml_models.py` | Trains Random Forest, Logistic Regression, SVM (RBF), and XGBoost classifiers (binary ND vs T2D, and 3-class ND/IGT/T2D) on the VST expression matrix restricted to WGCNA hub-gene features, inside a nested cross-validation scheme. Reports AUC, balanced accuracy, Gini/SHAP feature importance. |

### Stage 7 — Robustness check (nested validation)
| Script | Purpose |
|---|---|
| `N1_nested_split.R` | Generates 5 independent train/test sample splits. |
| `N0_de_train_only.R`, `N2_wgcna_train_only.R`, `N3_hub_genes_train_only.R` | Re-run DE, WGCNA, and hub-gene identification on each training split only. |
| `N4_nested_ml_validation.py` | Re-trains and evaluates classifiers on each split (out-of-fold performance). |
| `N5_aggregate_nested_runs.py` | Aggregates AUC/balanced accuracy across all 5 runs with t-distribution confidence intervals. |
| `N_run_all.sh` | Orchestrates the full nested-validation stage end to end. |

### Reporting
| Script | Purpose |
|---|---|
| `09_figures_tables.R` | Generates the final manuscript figures and summary tables from all upstream results. |
| `10_report_writer.py` | Compiles results into the submission bundle. |

## Reproducing this analysis

```bash
# R dependencies (renv-managed)
Rscript -e 'renv::restore()'   # uses envs/renv.lock

# Python dependencies
pip install -r envs/requirements.txt

# Run the full pipeline in order
Rscript scripts/00_download_data.R
Rscript scripts/01_prepare_metadata.R
Rscript scripts/02_qc_filter_normalise.R
Rscript scripts/03_differential_expression.R
Rscript scripts/C1_de_covariate_adjusted.R
Rscript scripts/04_lncrna_prioritisation.R
Rscript scripts/05A_prepare_wgcna_inputs.R
Rscript scripts/05B_wgcna_construct_network.R
Rscript scripts/05C_hub_gene_prioritisation.R
Rscript scripts/06_lncrna_annotation.R
Rscript scripts/07_enrichment_analysis.R
python3 scripts/08_ml_models.py
Rscript scripts/09_figures_tables.R

# Optional: nested cross-validation robustness check
bash scripts/N_run_all.sh
```

## Data source

Wigger, L., Barović, M., Brunner, A.-D. et al. Multi-omics profiling of living human pancreatic islet donors reveals heterogeneous beta cell trajectories toward type 2 diabetes. *Nature Metabolism* 3, 1017–1031 (2021). GEO accession: [GSE164416](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE164416).

## Notes on repository contents

- `data/raw/` reference downloads (GENCODE GTF, STAR index) are gitignored — they are large (>1GB) and fully regenerable via `scripts/00_download_data.R` / `00A_fastq_to_counts.sh`.
- `.RData` and `.rds` intermediate objects are gitignored for the same reason; all human-readable derived tables (`.tsv`/`.csv`) used by downstream scripts are tracked.
- `results/all_plots/` is a convenience folder consolidating every plot generated across all pipeline stages for quick browsing; each stage's plots also remain in their native `results/<stage>/plots/` location, which is what the scripts read/write.
