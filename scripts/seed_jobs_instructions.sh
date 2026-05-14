#!/usr/bin/env bash
set -euo pipefail
source scripts/load_env.sh
mkdir -p "${EVIDENCE_ROOT}/04-phase-4-advanced-config/cli-output"
cat > "${EVIDENCE_ROOT}/04-phase-4-advanced-config/cli-output/job-dsl-seed-instructions.txt" <<EOF
Run Job DSL scripts through a seed job:
- job-dsl/folders.groovy
- job-dsl/pipelines.groovy
- job-dsl/multibranch.groovy
- job-dsl/artifact-promotion.groovy
- job-dsl/migration-demo-jobs.groovy
Capture generated folder/job screenshots as evidence.
EOF
