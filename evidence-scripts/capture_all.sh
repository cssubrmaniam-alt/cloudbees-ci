#!/usr/bin/env bash
set -euo pipefail
bash scripts/init_evidence_tree.sh
bash scripts/validate_prereqs.sh
bash evidence-scripts/capture_dns_tls.sh || true
bash evidence-scripts/capture_cloud_labels.sh || true
bash evidence-scripts/capture_gke.sh || true
bash evidence-scripts/capture_cloudbees_modern.sh || true
bash evidence-scripts/capture_traditional.sh || true
bash evidence-scripts/capture_git_snapshot.sh || true
