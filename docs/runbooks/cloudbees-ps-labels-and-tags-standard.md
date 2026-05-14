# CloudBees PS Labels and Tags Standard

## Objective

All cloud resources created for CloudBees PS onboarding labs must include ownership, user, and environment labels/tags so resources can be identified, governed, cost-tracked, audited, and cleaned up safely.

## Required Labels / Tags

| Key | Required Value for This Lab | Purpose |
|---|---|---|
| `cb-owner` | `professional-services` | Identifies the owning CloudBees team |
| `cb-user` | `ssubramaniam` | Identifies the consultant/user who owns the lab |
| `cb-environment` | `development` | Identifies the environment type |

## Current Lab Values

```text
cb-owner        = professional-services
cb-user         = ssubramaniam
cb-environment = development
```

## Where Labels / Tags Apply

| Resource Type | Status | Notes |
|---|---|---|
| GCP VM | Completed | Terraform applies labels |
| GCP boot disk | Completed | Terraform applies labels through boot disk initialize params |
| GCP subnet | Recommended | Add labels if supported/needed |
| GCP firewall rule | Recommended | Add labels if supported/needed |
| AWS Route53 hosted zone | Pending | Blocked until AWS SSO access is fixed |
| AWS ACM certificate | Pending | Blocked until AWS SSO access is fixed |
| DNS records | Limited | DNS records usually do not support normal cloud tags |
| Jenkins / CloudBees agents | Pending | Different label type used for build routing |

## Validate GCP VM Labels

```bash
gcloud compute instances describe cbci-traditional-dev \
  --project cloudbees-ci-ps-lab \
  --zone us-east1-b \
  --format="yaml(labels)"
```

Expected:

```yaml
labels:
  cb-environment: development
  cb-owner: professional-services
  cb-user: ssubramaniam
```

Save evidence:

```bash
gcloud compute instances describe cbci-traditional-dev \
  --project cloudbees-ci-ps-lab \
  --zone us-east1-b \
  --format="yaml(labels)" \
  | tee evidence/02-phase-2-traditional-ci/cli-output/phase2-gcp-vm-labels.txt
```

## AWS Tagging Standard

When AWS access is available, Route53 and ACM resources should be tagged with:

```text
cb-owner = professional-services
cb-user  = ssubramaniam
```

Route53 hosted zone tagging example:

```bash
aws route53 change-tags-for-resource \
  --resource-type hostedzone \
  --resource-id "$HOSTED_ZONE_ID" \
  --add-tags Key=cb-owner,Value=professional-services Key=cb-user,Value=ssubramaniam \
  --profile "$AWS_PROFILE"
```

ACM certificate tagging example:

```bash
aws acm request-certificate \
  --region us-east-1 \
  --domain-name "*.aws.ssubramaniam.ps.beescloud.com" \
  --validation-method DNS \
  --tags Key=cb-owner,Value=professional-services Key=cb-user,Value=ssubramaniam \
  --profile "$AWS_PROFILE"
```

## Cloud Labels vs Jenkins / CloudBees Agent Labels

Cloud labels/tags are used for:

```text
ownership, governance, cost tracking, cleanup, and audit
```

Jenkins / CloudBees agent labels are used to route builds to the correct build agents.

Example Jenkins labels:

```text
linux
docker
gcp-agent
traditional-linux
```

## Status

```text
GCP VM labels: Completed
GCP disk labels: Completed
AWS Route53 tags: Pending AWS SSO access
AWS ACM tags: Pending AWS SSO access
Jenkins / CloudBees agent labels: Pending Phase 2D/agent setup
```