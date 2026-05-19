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
Completed. Review Beekeeper, update status, plugin warnings, recommended actions.

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

## Phase 2G Beekeeper Assurance Completion

```text
Status: Completed
Reviewed:
  - CloudBees Assurance Program / Beekeeper
  - Plugin Manager
  - Update center status
  - Plugin warnings
  - Administrative monitors

Operations Center:
http://localhost:18888

Client Controller:
http://localhost:18080

Access method:
SSH tunnel

## Phase 2H CloudBees Advisor Completion

```text
Status: Completed
Reviewed:
  - CloudBees Advisor / support readiness
  - Support bundle availability
  - Advisor/support-related administrative monitors
  - Relevant OC and Client Controller logs

Operations Center:
http://localhost:18888

Client Controller:
http://localhost:18080

Access method:
SSH tunnel

## Phase 2I Basic RBAC Completion

```text
Status: Completed
Validated:
  - Basic RBAC role model
  - Local lab users
  - Folder/job access behavior

Roles:
  - admin-role
  - developer-role
  - viewer-role

Sample folder:
team-a

Sample job:
team-a-rbac-smoke-test

Client Controller:
http://localhost:18080

Access method:
SSH tunnel

## Phase 2J Authentication Integration Review Completion

```text
Status: Completed
Reviewed:
  - Operations Center security realm
  - Client Controller security realm
  - Local lab users
  - RBAC relationship
  - Enterprise authentication options

Current lab authentication:
Local Jenkins / CloudBees user database

Enterprise authentication patterns documented:
  - LDAP / Active Directory
  - SAML SSO
  - OIDC / OAuth
  - Group-based RBAC mapping

Operations Center:
http://localhost:18888

Client Controller:
http://localhost:18080

Access method:
SSH tunnel

## Phase 2K Backup Validation Completion

```text
Status: Completed
Reviewed:
  - Operations Center home directory
  - Client Controller home directory
  - Service status
  - Package versions
  - Backup inventory manifest
  - Lab-only backup archive approach
  - Restore considerations

Home directories:
  - /var/lib/cloudbees-core-oc
  - /var/lib/cloudbees-core-cm

Lab backup inventory location on VM:
  - /tmp/cloudbees-phase2k-backup-validation/backup-inventory.txt

Important note:
  - Backup archives may contain secrets and must not be committed to Git.

Operations Center:
  - http://localhost:18888

Client Controller:
  - http://localhost:18080

Access method:
  - SSH tunnel
```

## Phase 2L CasC Concept Completion

```text
Status: Completed
Reviewed:
  - Configuration as Code concept
  - Operations Center CasC / bundle visibility
  - Client Controller CasC visibility
  - Sample Traditional CasC bundle structure

Sample repo path:
  - docs/runbooks/phase-wise/examples/phase2l-casc-traditional/

Sample files:
  - client-controller-01/bundle.yaml
  - client-controller-01/plugins.yaml
  - client-controller-01/jenkins.yaml

Operations Center:
  - http://localhost:18888

Client Controller:
  - http://localhost:18080

Access method:
  - SSH tunnel

Important note:
  - Sample CasC files are documentation/example only and were not applied to the running lab.
```

## Phase 2M Advanced Quickstart Features Completion

```text
Status: Completed
Reviewed:
  - Pipeline Policies
  - Cross Team Collaboration
  - External HTTP Endpoints
  - Pipeline Template Catalog

Validation approach:
  - UI review in Operations Center and Client Controller
  - Plugin/feature visibility review
  - REST/API endpoint behavior reviewed
  - Advanced/customer-specific features documented where not enabled

Operations Center:
  - http://localhost:18888

Client Controller:
  - http://localhost:18080

Access method:
  - SSH tunnel

Lab notes:
  - Cross-team collaboration reviewed using folder/RBAC/shared-library model.
  - External HTTP endpoint concept reviewed using REST/API and remote trigger pattern.
  - Pipeline Policies and Pipeline Template Catalog may require additional plugin/configuration enablement depending on customer requirements.
```

## Phase 2N Mentor Manager Demo Completion

```text
Status: Ready for review
Demo scope:
  - Operations Center dashboard
  - Client Controller dashboard
  - Controller relationship
  - Linux agent
  - Quickstart jobs
  - Beekeeper / Assurance
  - Advisor
  - RBAC
  - Authentication integration review
  - Backup validation
  - CasC concept
  - Advanced Quickstart features

Operations Center:
  - http://localhost:18888

Client Controller:
  - http://localhost:18080

Access method:
  - SSH tunnel

Known issue:
  - Direct external access to 8888/8080 times out from laptop; SSH tunnel used.
```
