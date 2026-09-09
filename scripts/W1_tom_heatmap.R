#!/usr/bin/env Rscript
# W1_tom_heatmap.R
#
# Purpose:
#   The main WGCNA run (05B) used saveTOMs=FALSE (WGCNA's own default), so the
#   topological overlap matrix was never persisted or visualised. This script
#   recomputes TOM for a representative gene subset -- the top 50 hub genes
#   from each of the 8 focus modules (400 genes total) -- using the same
#   network parameters as the main run, and produces a TOM heatmap. A full
#   20,042-gene TOM heatmap is not computationally or visually tractable;
#   this subsample matches standard published-figure scale while directly
#   representing the genes already central to this dissertation's findings.
#
# Outputs:
#   results/wgcna/plots/wgcna_TOM_heatmap_focus_modules.png

suppressPackageStartupMessages({
  library(WGCNA)
  library(dplyr)
  library(readr)
})

options(stringsAsFactors = FALSE)
allowWGCNAThreads()

project_dir <- getwd()

expr_file <- file.path(project_dir, "results", "wgcna", "tables", "wgcna_expression_input.tsv")
hub_file  <- file.path(project_dir, "results", "wgcna", "hubgenes", "tables", "wgcna_hub_genes_ranked_focus_modules.csv")
out_dir   <- file.path(project_dir, "results", "wgcna", "plots")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

cat("Loading expression matrix and hub gene rankings...\n")
expr <- read_tsv(expr_file, show_col_types = FALSE)
hub  <- read_csv(hub_file, show_col_types = FALSE)

# Top 50 hub genes per focus module
top_genes <- hub %>%
  arrange(module_color, hub_rank_all_genes) %>%
  group_by(module_color) %>%
  slice_head(n = 50) %>%
  ungroup()

cat("Focus modules and gene counts:\n")
print(table(top_genes$module_color))

gene_ids <- top_genes$gene_id
module_colors <- setNames(top_genes$module_color, top_genes$gene_id)

# Build expression matrix (samples x genes) restricted to these genes
datExpr <- expr %>%
  tibble::column_to_rownames("sampleid") %>%
  select(any_of(gene_ids)) %>%
  as.matrix()

# Preserve gene order matching top_genes / module_colors
datExpr <- datExpr[, gene_ids[gene_ids %in% colnames(datExpr)], drop = FALSE]
module_colors <- module_colors[colnames(datExpr)]

cat("Expression matrix for TOM: ", nrow(datExpr), "samples x", ncol(datExpr), "genes\n\n")

# Same network parameters as the main run (05B)
soft_power <- 8

cat("Computing adjacency matrix (power=8, bicor, signed)...\n")
adj <- adjacency(
  datExpr,
  power = soft_power,
  corFnc = "bicor",
  corOptions = "use = 'p', maxPOutliers = 0.1",
  type = "signed"
)

cat("Computing topological overlap matrix (signed)...\n")
TOM <- TOMsimilarity(adj, TOMType = "signed")
dissTOM <- 1 - TOM
rownames(dissTOM) <- colnames(datExpr)
colnames(dissTOM) <- colnames(datExpr)

cat("Clustering genes for dendrogram...\n")
geneTree <- hclust(as.dist(dissTOM), method = "average")

cat("Rendering TOM heatmap...\n")
png(file.path(out_dir, "wgcna_TOM_heatmap_focus_modules.png"),
    width = 2400, height = 2400, res = 300)

TOMplot(
  dissTOM^7,
  geneTree,
  as.character(module_colors),
  main = "Topological Overlap Matrix -- Top 50 Hub Genes per Focus Module",
  col = colorRampPalette(c("white", "#8B0000"))(100)
)

dev.off()

cat("\nSaved: ", file.path(out_dir, "wgcna_TOM_heatmap_focus_modules.png"), "\n", sep = "")
cat("\nW1 COMPLETE\n")
