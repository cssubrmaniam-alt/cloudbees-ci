# Phase 2 — CloudBees CI Traditional Installation and Quickstart

## Objective
Provision and validate a CloudBees CI Traditional lab with Operations Center, Client Controller, Linux agent, sample jobs, backup/basic admin validation, Beekeeper/Advisor/RBAC review, and mentor/manager demo evidence.

## Current Status
| Area | Status |
|---|---|
| GCP project / VM / static IP / firewall | Completed |
| DNS / Route53 / ACM | Completed |
| Ansible base install | Completed |
| Operations Center install/dashboard | Completed |
| Client Controller install/dashboard | Completed |
| Client Controller attachment to OC | Completed |
| Linux agent setup | Completed |
| Quickstart demo | In progress — Freestyle and Pipeline validated |
| Mentor / manager sign-off | Pending |

## Lab Details
```text
Project: cloudbees-ci-ps-lab
VM: cbci-traditional-dev
Zone: us-east1-b
OS: Debian GNU/Linux 12 (bookworm)
CPU: 4 vCPU
Memory: 15 GiB
Disk: 99 GB
Public IP: 34.75.138.203
Internal IP: 10.20.0.2
DNS: traditional.ssubramaniam.ps.beescloud.com
```

## Access Method
Direct external access to ports 8888/8080 times out. Use SSH tunnels.

Operations Center:
```bash
gcloud compute ssh cbci-traditional-dev --project cloudbees-ci-ps-lab --zone us-east1-b -- -L 8888:localhost:8888
```
URL: `http://localhost:8888`

Client Controller:
```bash
gcloud compute ssh cbci-traditional-dev --project cloudbees-ci-ps-lab --zone us-east1-b -- -L 8080:localhost:8080
```
URL: `http://localhost:8080`

## Phase 2A — Infrastructure
Completed: GCP project, subnet, VM, static IP, firewall restricted to consultant /32, labels.

## Phase 2B — DNS Foundation
Completed: GCP child zone, ps-dev delegation, Traditional A record, AWS Route53 zone, GCP-to-AWS NS delegation, ACM wildcard certificate.

Supporting runbook: `docs/runbooks/phase-2-dns-foundation.md`

## Phase 2C — Base Install
Completed: base packages, cloudbees OS user, CloudBees home directories, Java validation.

## Phase 2D — Operations Center and Client Controller
Completed: `cloudbees-core-oc` and `cloudbees-core-cm` installed and aligned at version `2.555.2.36753`; Java runtime is Temurin Java 21.

Validation:
```bash
gcloud compute ssh cbci-traditional-dev --project cloudbees-ci-ps-lab --zone us-east1-b --command '
curl -sI http://localhost:8888/ | egrep "HTTP/|X-Jenkins|Server" || true
curl -sI http://localhost:8080/ | egrep "HTTP/|X-Jenkins|Server" || true
sudo ss -ltnp | egrep ":8080|:8888|:50000" || true
dpkg -l | egrep "cloudbees-core-(oc|cm)" || true
'
```

## Completed Task — Attach Client Controller to OC
1. Keep both tunnels open.
2. In OC, open `client-controller-01 -> Manage`.
3. Copy full connection details.
4. In Client Controller, open `Manage Jenkins -> System`.
5. Paste connection details into `Operations Center Connector`.
6. Save and restart Client Controller.
7. Refresh OC Controllers view.

Expected: version/job count/queue size populated and status online.

## Phase 2E — Linux Agent Setup
Pending. Create a Linux agent with label `traditional-linux`, validate online state, and run a sample build.

## Phase 2F — Quickstart Job Validation
Pending. Demonstrate Freestyle, Pipeline, Multibranch Pipeline, and Organization Folder.

## Phase 2G — Beekeeper / CloudBees Assurance
Pending. Review Beekeeper, update status, plugin warnings, recommended actions.

## Phase 2H — CloudBees Advisor
Pending. Review Advisor plugin/configuration and capture support/advisor evidence.

## Phase 2I — Basic RBAC
Pending. Demonstrate Admin, Developer, Viewer roles and folder/team access.

## Phase 2J — Authentication Integration Review
Pending. Document local user database for lab and LDAP/AD/SAML customer patterns.

## Phase 2K — Backup Validation
Pending. Review backup approach for OC and Client Controller.

## Phase 2L — CasC Concept for Traditional
Pending. Document CasC concept and apply/reload path.

## Phase 2M — Advanced Quickstart Features
Pending. Pipeline Policies, Cross Team Collaboration, External HTTP Endpoints, Pipeline Template Catalog.

## Phase 2N — Mentor / Manager Demo
Pending. Show OC, connected controller, Linux agent, sample job, Beekeeper, Advisor, RBAC, backup approach, and evidence.

## Exit Criteria
OC installed and accessible, Client Controller attached and online, Linux agent online, sample job executed, Quickstart features reviewed, evidence captured, mentor/manager demo completed.

## Phase 2D Controller Attach Completion

```text
Status: Completed
Controller item: client-controller-01
Operations Center version: 2.555.2.36753
Client Controller version: 2.555.2.36753
Job Count: 0
Queue Size: 0
Access method: SSH tunnel
```

## Phase 2F Quickstart Completion

```text
Status: Completed
Agent: linux-agent-01
Agent label: traditional-linux
Validated jobs:
  - Freestyle smoke test
  - Pipeline smoke test
  - Multibranch Pipeline smoke test
Access method: SSH tunnel
