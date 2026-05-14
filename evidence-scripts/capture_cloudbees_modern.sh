#!/usr/bin/env bash
set -euo pipefail
source scripts/load_env.sh
BASE="${EVIDENCE_ROOT}/03-phase-3-modern-ci-gke"; mkdir -p "${BASE}/cli-output" "${BASE}/logs"
OUT="${BASE}/cli-output/cloudbees-modern-evidence.txt"; : > "$OUT"
capture(){ echo "$ $*" | tee -a "$OUT"; "$@" 2>&1 | tee -a "$OUT" || true; echo "" | tee -a "$OUT"; }
capture kubectl get pods -n "${CBCI_NAMESPACE}" -o wide
capture kubectl get svc -n "${CBCI_NAMESPACE}"
capture kubectl get ingress -n "${CBCI_NAMESPACE}"
capture kubectl get pvc -n "${CBCI_NAMESPACE}"
capture kubectl get events -n "${CBCI_NAMESPACE}" --sort-by=.lastTimestamp
PODS=$(kubectl get pods -n "${CBCI_NAMESPACE}" -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' 2>/dev/null || true)
for pod in ${PODS}; do
  kubectl describe pod "$pod" -n "${CBCI_NAMESPACE}" > "${BASE}/logs/${pod}.describe.txt" 2>&1 || true
  kubectl logs "$pod" -n "${CBCI_NAMESPACE}" --all-containers=true > "${BASE}/logs/${pod}.logs.txt" 2>&1 || true
done
