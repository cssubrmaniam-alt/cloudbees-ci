#!/usr/bin/env bash
set -euo pipefail
source scripts/load_env.sh
mkdir -p "${EVIDENCE_ROOT}/03-phase-3-modern-ci-gke/cli-output"
OUT="${EVIDENCE_ROOT}/03-phase-3-modern-ci-gke/cli-output/gke-evidence.txt"; : > "$OUT"
capture(){ echo "$ $*" | tee -a "$OUT"; "$@" 2>&1 | tee -a "$OUT" || true; echo "" | tee -a "$OUT"; }
capture gcloud container clusters list --project "${GCP_PROJECT_ID}"
if [[ "${GKE_LOCATION_TYPE}" == "zone" ]]; then capture gcloud container clusters get-credentials "${GKE_CLUSTER_NAME}" --zone "${GKE_LOCATION}" --project "${GCP_PROJECT_ID}"; else capture gcloud container clusters get-credentials "${GKE_CLUSTER_NAME}" --region "${GKE_LOCATION}" --project "${GCP_PROJECT_ID}"; fi
capture kubectl get nodes -o wide
capture kubectl get ns
capture kubectl get pods -A
capture kubectl get svc -A
capture kubectl get ingress -A
