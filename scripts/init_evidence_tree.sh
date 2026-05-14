#!/usr/bin/env bash
set -euo pipefail
source scripts/load_env.sh

PHASES=(
  "00-cloud-governance"
  "01-phase-1-access-tools"
  "02-phase-2-traditional-ci"
  "03-phase-3-modern-ci-gke"
  "04-phase-4-advanced-config"
  "05-phase-5-migration-topology"
  "06-phase-6-scenarios"
  "07-demo-scripts"
  "08-issues-and-troubleshooting"
  "09-final-signoff"
)

for phase in "${PHASES[@]}"; do
  mkdir -p "${EVIDENCE_ROOT}/${phase}/screenshots" "${EVIDENCE_ROOT}/${phase}/logs" "${EVIDENCE_ROOT}/${phase}/cli-output" "${EVIDENCE_ROOT}/${phase}/git"
  [[ -f "${EVIDENCE_ROOT}/${phase}/README.md" ]] || cat > "${EVIDENCE_ROOT}/${phase}/README.md" <<EOF
# ${phase}

## What was done
## Commands used
## Evidence captured
## Issues found
## Fixes applied
## Demo notes
## Sign-off
EOF
done
echo "Evidence folders created."
