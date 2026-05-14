# Phase 2 DNS Foundation Runbook — ps.beescloud.com, AWS Route53, and ACM

## Objective

All CloudBees PS lab services must use a CloudBees-controlled DNS domain under:

~~~text
ps.beescloud.com
~~~

For this lab:

~~~text
GCP child zone: ssubramaniam.ps.beescloud.com
AWS delegated zone: aws.ssubramaniam.ps.beescloud.com
Traditional VM DNS: traditional.ssubramaniam.ps.beescloud.com
Traditional VM IP: 34.75.138.203
~~~

## DNS Architecture

~~~text
ps.beescloud.com
└── ssubramaniam.ps.beescloud.com
    ├── traditional.ssubramaniam.ps.beescloud.com -> 34.75.138.203
    └── aws.ssubramaniam.ps.beescloud.com
        └── *.aws.ssubramaniam.ps.beescloud.com
~~~

---

## Step 1 — Create Zone in GCP

### 1.1 Create GCP Cloud DNS child zone

Project:

~~~text
cloudbees-ci-ps-lab
~~~

Zone:

~~~text
ssubramaniam-ps-beescloud-com
~~~

DNS name:

~~~text
ssubramaniam.ps.beescloud.com.
~~~

Command:

~~~bash
gcloud dns managed-zones create ssubramaniam-ps-beescloud-com \
  --project cloudbees-ci-ps-lab \
  --dns-name "ssubramaniam.ps.beescloud.com." \
  --description "CloudBees PS lab zone for ssubramaniam" \
  --visibility public
~~~

### 1.2 Capture GCP nameservers

~~~bash
gcloud dns record-sets list \
  --project cloudbees-ci-ps-lab \
  --zone ssubramaniam-ps-beescloud-com \
  --name "ssubramaniam.ps.beescloud.com." \
  --type NS \
  --format="table(name,type,ttl,rrdatas)"
~~~

Current nameservers:

~~~text
ns-cloud-b1.googledomains.com.
ns-cloud-b2.googledomains.com.
ns-cloud-b3.googledomains.com.
ns-cloud-b4.googledomains.com.
~~~

### 1.3 Add NS delegation in ps-dev parent zone

Parent project:

~~~text
ps-dev
~~~

Parent zone:

~~~text
ps-beescloud-com
~~~

Required parent NS record:

~~~text
DNS name: ssubramaniam.ps.beescloud.com.
Type: NS
TTL: 300
Nameservers:
  ns-cloud-b1.googledomains.com.
  ns-cloud-b2.googledomains.com.
  ns-cloud-b3.googledomains.com.
  ns-cloud-b4.googledomains.com.
~~~

Status:

~~~text
Ops ticket created / pending CloudBees Ops or PS admin
~~~

Validate after Ops completes:

~~~bash
dig NS ssubramaniam.ps.beescloud.com +short
~~~

### 1.4 Create Traditional VM A record

~~~bash
gcloud dns record-sets create traditional.ssubramaniam.ps.beescloud.com. \
  --project cloudbees-ci-ps-lab \
  --zone ssubramaniam-ps-beescloud-com \
  --type A \
  --ttl 300 \
  --rrdatas 34.75.138.203
~~~

Validate:

~~~bash
dig traditional.ssubramaniam.ps.beescloud.com +short
~~~

Expected:

~~~text
34.75.138.203
~~~

---

## Step 2 — Create Hosted Zone in AWS Route53

AWS public hosted zone:

~~~text
aws.ssubramaniam.ps.beescloud.com
~~~

Use CloudBees-approved AWS SSO profile.

~~~bash
export AWS_PROFILE="<cloudbees-aws-sso-profile>"
aws sso login --profile "$AWS_PROFILE"
~~~

Create public hosted zone:

~~~bash
CALLER_REF="aws-ssubramaniam-ps-beescloud-$(date +%Y%m%d%H%M%S)"

aws route53 create-hosted-zone \
  --name "aws.ssubramaniam.ps.beescloud.com" \
  --caller-reference "$CALLER_REF" \
  --hosted-zone-config Comment="CloudBees PS lab AWS delegated zone for ssubramaniam",PrivateZone=false \
  --profile "$AWS_PROFILE"
~~~

Capture hosted zone ID:

~~~bash
HOSTED_ZONE_ID=$(aws route53 list-hosted-zones-by-name \
  --dns-name "aws.ssubramaniam.ps.beescloud.com" \
  --profile "$AWS_PROFILE" \
  --query "HostedZones[0].Id" \
  --output text | sed 's#/hostedzone/##')

echo "$HOSTED_ZONE_ID"
~~~

Tag hosted zone:

~~~bash
aws route53 change-tags-for-resource \
  --resource-type hostedzone \
  --resource-id "$HOSTED_ZONE_ID" \
  --add-tags Key=cb-owner,Value=professional-services Key=cb-user,Value=ssubramaniam \
  --profile "$AWS_PROFILE"
~~~

Capture AWS nameservers:

~~~bash
aws route53 get-hosted-zone \
  --id "$HOSTED_ZONE_ID" \
  --profile "$AWS_PROFILE" \
  --query "DelegationSet.NameServers" \
  --output text
~~~

Save the 4 AWS nameservers for Step 3.

---

## Step 3 — Add AWS NS Record Set to GCP Zone

After AWS Route53 zone is created, add its 4 nameservers into the GCP child zone.

DNS name:

~~~text
aws.ssubramaniam.ps.beescloud.com.
~~~

Record type:

~~~text
NS
~~~

Command format:

~~~bash
gcloud dns record-sets create aws.ssubramaniam.ps.beescloud.com. \
  --project cloudbees-ci-ps-lab \
  --zone ssubramaniam-ps-beescloud-com \
  --type NS \
  --ttl 300 \
  --rrdatas "AWS_NS_1.,AWS_NS_2.,AWS_NS_3.,AWS_NS_4."
~~~

Validate:

~~~bash
dig NS aws.ssubramaniam.ps.beescloud.com +short
~~~

Expected:

~~~text
The 4 AWS Route53 nameservers
~~~

---

## Step 4 — TLS/SSL with AWS ACM

ACM public wildcard certificate must be requested in:

~~~text
us-east-1
~~~

Certificate domain:

~~~text
*.aws.ssubramaniam.ps.beescloud.com
~~~

Request certificate:

~~~bash
CERT_ARN=$(aws acm request-certificate \
  --region us-east-1 \
  --domain-name "*.aws.ssubramaniam.ps.beescloud.com" \
  --validation-method DNS \
  --tags Key=cb-owner,Value=professional-services Key=cb-user,Value=ssubramaniam \
  --profile "$AWS_PROFILE" \
  --query CertificateArn \
  --output text)

echo "$CERT_ARN"
~~~

Get DNS validation record:

~~~bash
aws acm describe-certificate \
  --region us-east-1 \
  --certificate-arn "$CERT_ARN" \
  --profile "$AWS_PROFILE" \
  --query "Certificate.DomainValidationOptions[0].ResourceRecord"
~~~

Preferred validation method:

~~~text
AWS Console -> ACM -> Certificate -> Create records in Route53
~~~

Validate certificate status:

~~~bash
aws acm describe-certificate \
  --region us-east-1 \
  --certificate-arn "$CERT_ARN" \
  --profile "$AWS_PROFILE" \
  --query "Certificate.Status" \
  --output text
~~~

Expected:

~~~text
ISSUED
~~~

---

## Evidence Checklist

Capture:

~~~text
1. GCP child zone record list
2. GCP child zone NS records
3. ps-dev parent delegation ticket
4. Traditional VM A record
5. AWS Route53 hosted zone details
6. AWS Route53 NS records
7. GCP NS record delegating aws.ssubramaniam.ps.beescloud.com to AWS
8. ACM wildcard certificate request
9. ACM DNS validation record
10. ACM certificate status = ISSUED
~~~

Evidence directory:

~~~text
evidence/02-phase-2-traditional-ci/cli-output/
~~~

---

## Current Status

~~~text
Step 1 — GCP child zone: Completed
Step 1 — ps-dev parent NS delegation: Completed
Step 2 — AWS Route53 hosted zone: Completed
Step 3 — GCP NS delegation to AWS Route53: Completed
Step 4 — ACM wildcard certificate: Blocked until AWS SSO and Route53 access are available
~~~


## Latest Phase 2 DNS Validation

~~~text
Static IP: Completed
Static IP name: cbci-traditional-dev-public-ip
Static IP value: 34.75.138.203
Static IP status: IN_USE

GCP child zone A record: Completed
traditional.ssubramaniam.ps.beescloud.com. -> 34.75.138.203

Public DNS resolution: Completed
AWS Route53: Completed; ACM: Pending
~~~


## ps-dev Parent Delegation Completion

~~~text
Status: Completed
Completed by: CloudBees Ops
Delegated zone: ssubramaniam.ps.beescloud.com.
Nameservers:
  ns-cloud-b1.googledomains.com.
  ns-cloud-b2.googledomains.com.
  ns-cloud-b3.googledomains.com.
  ns-cloud-b4.googledomains.com.

Traditional VM DNS:
traditional.ssubramaniam.ps.beescloud.com -> 34.75.138.203
~~~


## AWS Route53 Delegation Completion

~~~text
Status: Completed
AWS delegated zone: aws.ssubramaniam.ps.beescloud.com
Route53 nameservers:
  ns-1731.awsdns-24.co.uk.
  ns-919.awsdns-50.net.
  ns-1358.awsdns-41.org.
  ns-9.awsdns-01.com.

GCP child zone delegation:
aws.ssubramaniam.ps.beescloud.com. NS -> Route53 nameservers
~~~
