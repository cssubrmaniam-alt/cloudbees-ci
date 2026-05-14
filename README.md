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
| Phase 1 | WSL2 Ubuntu bootstrap, tool validation, evidence folders, access checklist evidence, generated runbooks |
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

Clone the repository and create local configuration files:

```bash
git clone <your-new-repo-url>
cd cloudbees-ci

cp .env.example .env
cp config/onboarding.example.json config/onboarding.json

vi .env
vi config/onboarding.json
```

For local WSL2 Ubuntu workstation setup and Phase 1 validation:

```bash
make bootstrap-wsl
make phase1
```

Or run both together:

```bash
make phase1-auto
```

After approvals/configuration, continue with the later automation targets:

```bash
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

Or after all required approvals/configuration are complete:

```bash
make all
```

## Phase 1 — WSL2 Ubuntu ARM64 Bootstrap and Workstation Validation

Phase 1 validates the local consultant workstation before any CloudBees CI infrastructure is created.

The repository supports automated WSL2 Ubuntu bootstrap:

```bash
make bootstrap-wsl
make phase1
```

Or run both together:

```bash
make phase1-auto
```

### Recommended local environment

Use WSL2 Ubuntu as the primary automation terminal.

Recommended workspace:

```bash
~/cloudbees/cloudbees-ci
```

Avoid running automation from Windows paths such as:

```bash
/mnt/c/Users/<user>/OneDrive/Desktop
```

This avoids Windows path, permission, line-ending, and OneDrive sync issues.

### Bootstrap target

Run:

```bash
make bootstrap-wsl
```

The bootstrap script detects the CPU architecture automatically.

| Architecture | Example | Handling |
|---|---|---|
| ARM64 | `aarch64` / `arm64` | Installs ARM64-compatible binaries |
| AMD64 | `x86_64` / `amd64` | Installs AMD64-compatible binaries |

For ARM64 WSL2 machines, the bootstrap installs compatible binaries for:

- `kubectl`
- `helmfile`
- AWS CLI

This avoids `Exec format error` issues caused by x64 binaries on ARM64 Ubuntu.

### Phase 1 validation

Run:

```bash
make phase1
```

This performs:

```bash
bash scripts/init_evidence_tree.sh
bash scripts/validate_prereqs.sh
python3 runbook-generator/generate_phase_runbook.py
```

Phase 1 does not create cloud infrastructure. It validates workstation readiness and generates evidence/runbooks.

### Tools validated

Phase 1 validates:

- `git`
- `python3`
- `terraform`
- `helm`
- `helmfile`
- `ansible-playbook`
- `kubectl`
- `gcloud`
- `aws`
- `docker`
- `java`
- `node`
- `npm`

A successful run should show all tools as `FOUND`.

### Docker for WSL2

Docker should be provided by Docker Desktop for Windows with WSL integration enabled.

For ARM64 Windows laptops, install Docker Desktop for Windows ARM64.

Validate inside WSL:

```bash
docker --version
docker run --rm hello-world
```

Expected result:

```text
Hello from Docker!
```

### Evidence and generated output

After Phase 1, review:

```bash
cat evidence/01-phase-1-access-tools/cli-output/prerequisite-validation.txt
ls generated-runbooks
```

Expected generated files:

```text
phase-1-runbook.md
phase-2-runbook.md
phase-3-runbook.md
phase-4-runbook.md
phase-5-runbook.md
phase-6-runbook.md
```

### Git safety

Do not commit local or sensitive files:

- `.env`
- `config/onboarding.json`
- private keys
- cloud credentials
- kubeconfig files
- tokens

### Phase 1 completion criteria

Phase 1 is complete when:

- `make bootstrap-wsl` completes successfully
- `make phase1` completes successfully
- all tools are `FOUND` in `prerequisite-validation.txt`
- Docker `hello-world` works inside WSL
- Phase 1 through Phase 6 runbooks are generated

## Safe execution notes

- Do not commit `.env`, `*.tfvars`, or generated secrets.
- Use AWS SSO profiles or federated cloud credentials.
- Terraform destroy is intentionally separate and asks for confirmation.
- Evidence scripts are read-only wherever possible.

## Phase 2 — CloudBees CI Traditional VM, DNS Foundation, and Base Install

Phase 2 provisions the CloudBees CI Traditional lab VM, prepares the base operating system, captures evidence, and tracks DNS delegation required for a CloudBees-controlled service URL.

### Phase 2 current status

| Area | Status |
|---|---|
| GCP project | Completed |
| Region policy alignment | Completed |
| Traditional VM infrastructure | Completed |
| Firewall restriction | Completed |
| Ansible base install | Completed |
| VM base validation | Completed |
| DNS child zone | Completed |
| ps-dev parent NS delegation | Ticket created / pending Ops |
| CloudBees CI Traditional install source | Pending |
| Operations Center setup | Pending |
| Controller attach | Pending |
| Linux agent setup | Pending |
| Quickstart demo | Pending |

### GCP project

The Phase 2 lab project is:

```text
cloudbees-ci-ps-lab

### CloudBees PS Labels and Tags Standard

Cloud resource labels/tags for PS onboarding labs are documented here:

```text
docs/runbooks/cloudbees-ps-labels-and-tags-standard.md
