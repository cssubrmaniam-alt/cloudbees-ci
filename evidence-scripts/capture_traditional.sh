#!/usr/bin/env bash
set -euo pipefail
source scripts/load_env.sh
mkdir -p "${EVIDENCE_ROOT}/02-phase-2-traditional-ci/cli-output"
OUT="${EVIDENCE_ROOT}/02-phase-2-traditional-ci/cli-output/traditional-evidence.txt"; : > "$OUT"
echo "TRADITIONAL_OC_HOST=${TRADITIONAL_OC_HOST}" | tee -a "$OUT"
[[ -n "${TRADITIONAL_OC_HOST}" ]] && curl -k -I "${TRADITIONAL_OC_HOST}" 2>&1 | tee -a "$OUT" || true
