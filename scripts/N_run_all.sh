#!/bin/bash
# N_run_all.sh
# Runs the full leakage-free nested validation chain (N1->N0->N2->N3->N4)
# across multiple random train/test splits, to check whether the held-out
# AUC is stable or was just a lucky/unlucky single split.
set -e

cd "$(dirname "$0")/.."

RUNS=("run1:42" "run2:123" "run3:7" "run4:2024" "run5:99")

for entry in "${RUNS[@]}"; do
  RUN_ID="${entry%%:*}"
  SEED="${entry##*:}"
  echo "=========================================="
  echo "STARTING $RUN_ID (seed $SEED)"
  echo "=========================================="

  Rscript scripts/N1_nested_split.R "$RUN_ID" "$SEED"
  Rscript scripts/N0_de_train_only.R "$RUN_ID"
  Rscript scripts/N2_wgcna_train_only.R "$RUN_ID"
  Rscript scripts/N3_hub_genes_train_only.R "$RUN_ID"
  python3 scripts/N4_nested_ml_validation.py "$RUN_ID"

  echo "=========================================="
  echo "FINISHED $RUN_ID"
  echo "=========================================="
done

echo "ALL RUNS COMPLETE"
