# Phase 3 — CloudBees CI Modern on GKE

## Objective
Install and validate CloudBees CI Modern on a GKE cluster.

## Outcome
Consultant can provision GKE, install CloudBees CI Modern with Helmfile, create managed controllers, configure Kubernetes agents, inspect logs, and explain Kubernetes operations.

## Prerequisites
GCP project access, allowed region/zone, GKE API, kubectl, helm, helmfile, CloudBees namespace, license/entitlement path, DNS/ingress approach.

## Planned Steps
1. Provision GKE with Terraform.
2. Configure kubectl credentials.
3. Install CloudBees CI Modern using Helmfile.
4. Validate namespaces, pods, services, and ingress.
5. Access Operations Center.
6. Create Managed Controller.
7. Configure Kubernetes pod template.
8. Run pipeline using Kubernetes agent.
9. Capture logs/events/evidence.

## Example Commands
```bash
cd ~/cloudbees/cloudbees-ci
python3 scripts/render_config.py
cd terraform/gcp-gke
terraform init
terraform validate
terraform plan -var-file=../../generated-config/gcp-gke.tfvars
terraform apply -var-file=../../generated-config/gcp-gke.tfvars
```

```bash
kubectl get nodes
kubectl get pods -n cloudbees-core
kubectl get svc -n cloudbees-core
kubectl get ingress -n cloudbees-core
```

## Evidence
Cluster details, kubectl outputs, helmfile output, OC dashboard, Managed Controller online, Kubernetes agent pod, successful pipeline.

## Exit Criteria
GKE cluster available, CloudBees Modern installed, OC accessible, Managed Controller online, Kubernetes agent pipeline successful, evidence captured.

## Status
Not started
