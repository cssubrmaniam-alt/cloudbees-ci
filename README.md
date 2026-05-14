# CloudBees CI PS Full Automation Repository

This repository is a ready-to-upload Git repo skeleton for automating the CloudBees CI Professional Services onboarding playbook from Phase 1 to Phase 6.

## Automation stack

- Terraform
- Ansible
- Helmfile
- CloudBees CasC
- Jenkins Job DSL
- Jenkinsfile / Shared Library
- Python
- Secrets Manager
- GitHub Actions or Jenkins Pipeline
- Playwright

## What this repo automates

| Phase | Automation Coverage |
|---|---|
| Phase 1 | Tool validation, evidence folders, access checklist evidence |
| Phase 2 | GCP VM provisioning + Ansible Traditional install starter |
| Phase 3 | GKE provisioning + Helmfile CloudBees CI Modern install + Kubernetes evidence |
| Phase 4 | CasC bundles, RBAC model, shared library, Job DSL, Playwright UI evidence |
| Phase 5 | Multi-cluster scaffold, migration helpers, external Jenkinsfile pattern |
| Phase 6 | DevOps pipeline, pipeline review starter, artifact promotion, full auto deployment, CasC automation |
| Final | Evidence capture, phase runbooks, master runbook, sign-off evidence |

## Human inputs still required

Automation cannot bypass security or human governance approvals:

- Okta, VPN, GitHub, Slack, 1Password, Salesforce, Zoom access approval
- CloudBees license/entitlement
- Ops-approved CIDR or DNS delegation where required
- Training completion
- Mentor/manager demo and sign-off
- Phase 6 Scenario 4 confirmation because the source playbook leaves it TBD

## Quick start

```bash
git clone <your-new-repo-url>
cd cloudbees-ci-ps-full-automation-repo

cp .env.example .env
cp config/onboarding.example.json config/onboarding.json

vi .env
vi config/onboarding.json

make phase1
make infra-plan
make infra
make traditional
make modern
make apply-casc
make seed-jobs
make run-demo-pipelines
make evidence
make screenshots
make runbook
```

Or after approvals/configuration:

```bash
make all
```

## Safe execution notes

- Do not commit `.env`, `*.tfvars`, or generated secrets.
- Use AWS SSO profiles or federated cloud credentials.
- Terraform destroy is intentionally separate and asks for confirmation.
- Evidence scripts are read-only wherever possible.
