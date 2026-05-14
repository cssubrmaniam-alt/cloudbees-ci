#!/usr/bin/env bash
set -euo pipefail
source scripts/load_env.sh
mkdir -p "${EVIDENCE_ROOT}/01-phase-1-access-tools/cli-output"
OUT="${EVIDENCE_ROOT}/01-phase-1-access-tools/cli-output/prerequisite-validation.txt"
: > "$OUT"

capture(){ echo "$ $*" | tee -a "$OUT"; "$@" 2>&1 | tee -a "$OUT" || true; echo "" | tee -a "$OUT"; }

echo "Phase 1 prerequisite validation - $(date -Iseconds)" | tee -a "$OUT"
for cmd in git python3 terraform helm helmfile ansible-playbook kubectl gcloud aws docker java node npm; do
  if command -v "$cmd" >/dev/null 2>&1; then echo "FOUND: $cmd -> $(command -v "$cmd")" | tee -a "$OUT"; else echo "MISSING: $cmd" | tee -a "$OUT"; fi
done
capture git --version
capture python3 --version
capture terraform version
capture helm version
capture helmfile --version
capture ansible-playbook --version
capture kubectl version --client=true
capture gcloud version
capture aws --version
capture docker --version
capture java -version
