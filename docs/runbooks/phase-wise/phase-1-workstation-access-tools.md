# Phase 1 — Workstation, Access, and Tool Readiness

## Objective
Prepare the consultant workstation and validate all tools required for CloudBees CI PS onboarding automation.

## Scope
GitHub access, WSL2 Ubuntu workstation readiness, CLI tools, Docker validation, automation repo bootstrap, evidence folders, and generated runbooks.

## Required Tools
`git`, `python3`, `terraform`, `helm`, `helmfile`, `ansible-playbook`, `kubectl`, `gcloud`, `aws`, `docker`, `java`, `node`, `npm`

## Automation Targets
```bash
make bootstrap-wsl
make phase1
make phase1-auto
```

## Validation
```bash
cat evidence/01-phase-1-access-tools/cli-output/prerequisite-validation.txt
```

Expected: all required tools show `FOUND`.

## Completed Lab Notes
- WSL2 Ubuntu used as automation terminal.
- ARM64/aarch64 architecture required ARM64-compatible AWS CLI, kubectl, helmfile.
- Docker Desktop for Windows ARM64 installed with WSL integration.
- README updated with Phase 1 bootstrap instructions.

## Exit Criteria
All prerequisite tools validated, Docker works, runbooks generated, repo clean and pushed.

## Status
Completed
