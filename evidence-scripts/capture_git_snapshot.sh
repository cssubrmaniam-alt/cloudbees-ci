#!/usr/bin/env bash
set -euo pipefail
source scripts/load_env.sh
mkdir -p "${EVIDENCE_ROOT}/06-phase-6-scenarios/git"
OUT="${EVIDENCE_ROOT}/06-phase-6-scenarios/git/git-snapshot.txt"
{ git status --short || true; git log --oneline -n 20 || true; find casc job-dsl pipelines shared-library -type f | sort; } > "$OUT"
