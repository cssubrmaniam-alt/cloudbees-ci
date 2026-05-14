SHELL := /usr/bin/env bash

.PHONY: help init phase1 preflight infra-plan infra traditional modern apply-casc seed-jobs run-demo-pipelines evidence screenshots runbook all infra-destroy

help:
	@echo "make phase1              - local readiness validation"
	@echo "make infra-plan          - Terraform plan"
	@echo "make infra               - Terraform apply"
	@echo "make traditional         - Ansible Traditional install starter"
	@echo "make modern              - Helmfile CloudBees CI Modern install"
	@echo "make apply-casc          - package CasC bundles"
	@echo "make seed-jobs           - create Job DSL seed instructions"
	@echo "make run-demo-pipelines  - create demo pipeline run plan"
	@echo "make evidence            - capture all evidence"
	@echo "make screenshots         - Playwright UI screenshots"
	@echo "make runbook             - generate runbooks"
	@echo "make all                 - execute end-to-end flow"

init:
	@test -f .env || cp .env.example .env
	@test -f config/onboarding.json || cp config/onboarding.example.json config/onboarding.json
	@mkdir -p generated-config evidence generated-runbooks dist

preflight: init
	bash scripts/preflight.sh

phase1: init
	bash scripts/init_evidence_tree.sh
	bash scripts/validate_prereqs.sh
	python3 runbook-generator/generate_phase_runbook.py

infra-plan: init
	python3 scripts/render_config.py
	cd terraform/gcp-gke && terraform init && terraform plan -var-file=../../generated-config/gcp-gke.tfvars
	cd terraform/gcp-vm-traditional && terraform init && terraform plan -var-file=../../generated-config/gcp-vm-traditional.tfvars
	cd terraform/aws-dns-acm && terraform init && terraform plan -var-file=../../generated-config/aws-dns-acm.tfvars

infra: init
	python3 scripts/render_config.py
	cd terraform/gcp-gke && terraform init && terraform apply -auto-approve -var-file=../../generated-config/gcp-gke.tfvars
	cd terraform/gcp-vm-traditional && terraform init && terraform apply -auto-approve -var-file=../../generated-config/gcp-vm-traditional.tfvars
	cd terraform/aws-dns-acm && terraform init && terraform apply -auto-approve -var-file=../../generated-config/aws-dns-acm.tfvars

traditional:
	python3 scripts/render_config.py
	ansible-playbook -i generated-config/ansible-inventory.ini ansible/install-cloudbees-traditional.yml

modern:
	cd helmfile && helmfile apply

apply-casc:
	bash scripts/package_casc.sh

seed-jobs:
	bash scripts/seed_jobs_instructions.sh

run-demo-pipelines:
	bash scripts/run_demo_pipelines.sh

evidence:
	bash evidence-scripts/capture_all.sh

screenshots:
	python3 -m pip install -r requirements.txt
	python3 -m playwright install chromium
	python3 ui-evidence/capture_cloudbees_ui.py

runbook:
	python3 runbook-generator/generate_phase_runbook.py
	python3 runbook-generator/generate_master_runbook.py

all: phase1 infra traditional modern apply-casc seed-jobs run-demo-pipelines evidence screenshots runbook

infra-destroy:
	@echo "WARNING: This destroys Terraform-managed resources."
	@read -p "Type DESTROY to continue: " confirm; \
	if [[ "$$confirm" == "DESTROY" ]]; then \
	  python3 scripts/render_config.py; \
	  cd terraform/gcp-vm-traditional && terraform destroy -auto-approve -var-file=../../generated-config/gcp-vm-traditional.tfvars; \
	  cd ../gcp-gke && terraform destroy -auto-approve -var-file=../../generated-config/gcp-gke.tfvars; \
	  cd ../aws-dns-acm && terraform destroy -auto-approve -var-file=../../generated-config/aws-dns-acm.tfvars; \
	else echo "Cancelled."; fi

bootstrap-wsl:
	bash scripts/bootstrap_wsl_ubuntu.sh

phase1-auto: bootstrap-wsl phase1

phase2-plan: init
	python3 scripts/render_config.py
	cd terraform/gcp-vm-traditional && terraform init && terraform validate && terraform plan -var-file=../../generated-config/gcp-vm-traditional.tfvars

phase2-apply: init
	python3 scripts/render_config.py
	cd terraform/gcp-vm-traditional && terraform init && terraform validate && terraform apply -var-file=../../generated-config/gcp-vm-traditional.tfvars

phase2-traditional: init
	python3 scripts/render_config.py
	ansible-playbook -i generated-config/ansible-inventory.ini ansible/install-cloudbees-traditional.yml
