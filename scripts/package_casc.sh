#!/usr/bin/env bash
set -euo pipefail
source scripts/load_env.sh
mkdir -p dist/casc-bundles "${EVIDENCE_ROOT}/04-phase-4-advanced-config/cli-output"
tar -czf dist/casc-bundles/operations-center-casc.tgz -C casc operations-center
tar -czf dist/casc-bundles/controllers-casc.tgz -C casc controllers
cat > "${EVIDENCE_ROOT}/04-phase-4-advanced-config/cli-output/casc-package.txt" <<EOF
CasC bundles packaged.
Configure CloudBees CasC bundle service or bundle location to point to this Git repo.
Attach controller bundles to managed controllers from Operations Center.
EOF
echo "CasC bundles packaged under dist/casc-bundles"
