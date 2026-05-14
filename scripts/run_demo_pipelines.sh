#!/usr/bin/env bash
set -euo pipefail
source scripts/load_env.sh
mkdir -p "${EVIDENCE_ROOT}/06-phase-6-scenarios/cli-output"
cat > "${EVIDENCE_ROOT}/06-phase-6-scenarios/cli-output/demo-pipeline-run-plan.txt" <<EOF
Run these demo pipelines:
1. pipelines/Jenkinsfile.devops-only
2. pipelines/Jenkinsfile.artifact-promotion
3. pipelines/Jenkinsfile.full-auto-deploy
4. pipelines/Jenkinsfile.casc-automation
5. pipelines/Jenkinsfile.orchestrator
EOF
