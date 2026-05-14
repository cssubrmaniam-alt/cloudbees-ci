#!/usr/bin/env bash
set -euo pipefail
source scripts/load_env.sh
mkdir -p "${EVIDENCE_ROOT}/00-cloud-governance/cli-output"
OUT="${EVIDENCE_ROOT}/00-cloud-governance/cli-output/dns-tls-evidence.txt"; : > "$OUT"
capture(){ echo "$ $*" | tee -a "$OUT"; "$@" 2>&1 | tee -a "$OUT" || true; echo "" | tee -a "$OUT"; }
capture dig NS "${USER_DOMAIN}"
capture dig NS "${AWS_DOMAIN}"
capture dig A "${OC_HOSTNAME}"
capture aws acm list-certificates --region "${AWS_REGION}" --profile "${AWS_PROFILE}" --output table
