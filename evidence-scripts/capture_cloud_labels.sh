#!/usr/bin/env bash
set -euo pipefail
source scripts/load_env.sh
mkdir -p "${EVIDENCE_ROOT}/00-cloud-governance/cli-output"
OUT="${EVIDENCE_ROOT}/00-cloud-governance/cli-output/cloud-label-evidence.txt"; : > "$OUT"
capture(){ echo "$ $*" | tee -a "$OUT"; "$@" 2>&1 | tee -a "$OUT" || true; echo "" | tee -a "$OUT"; }
capture gcloud compute instances list --project "${GCP_PROJECT_ID}" --format="table(name,zone,labels)"
capture gcloud container clusters list --project "${GCP_PROJECT_ID}" --format="table(name,location,resourceLabels)"
capture aws resourcegroupstaggingapi get-resources --region "${AWS_REGION}" --profile "${AWS_PROFILE}" --output table
