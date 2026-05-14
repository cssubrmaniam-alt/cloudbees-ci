#!/usr/bin/env bash
set -euo pipefail
if [[ -f ".env" ]]; then
  set -a
  source ".env"
  set +a
fi
: "${EVIDENCE_ROOT:=evidence}"
: "${GENERATED_ROOT:=generated-runbooks}"
: "${CBCI_NAMESPACE:=cloudbees-core}"
: "${AWS_PROFILE:=default}"
: "${AWS_REGION:=us-east-1}"
