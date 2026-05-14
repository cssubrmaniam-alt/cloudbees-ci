#!/usr/bin/env python3
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
cfg=json.loads((ROOT/"config/onboarding.json").read_text())
out=ROOT/"generated-config"; out.mkdir(exist_ok=True)
c=cfg["cloud"]; d=cfg["dns"]; cb=cfg["consultant"]; ci=cfg["cloudbees"]

labels = f'''{{
  cb-owner = "{cb['owner']}"
  cb-user = "{cb['user']}"
  cb-environment = "{cb['environment']}"
}}'''

(out/"gcp-gke.tfvars").write_text(f'''project_id = "{c['gcp_project_id']}"
region = "{c['gcp_region']}"
gke_cluster_name = "{c['gke_cluster_name']}"
node_count = {c['gke_node_count']}
machine_type = "{c['gke_machine_type']}"
labels = {labels}
''')

(out/"gcp-vm-traditional.tfvars").write_text(f'''project_id = "{c['gcp_project_id']}"
region = "{c['gcp_region']}"
zone = "{c['gcp_zone']}"
vm_name = "{c['traditional_vm_name']}"
machine_type = "{c['traditional_machine_type']}"
disk_gb = {c['traditional_disk_gb']}
labels = {labels}
''')

(out/"aws-dns-acm.tfvars").write_text(f'''aws_region = "{c['aws_region']}"
aws_profile = "{c['aws_profile']}"
aws_domain = "{d['aws_domain']}"
wildcard_cert_domain = "{d['wildcard_cert_domain']}"
create_route53_zone = {str(d.get('create_route53_zone', True)).lower()}
tags = {labels}
''')

(out/"ansible-inventory.ini").write_text(f'''[traditional]
{c['traditional_vm_name']} ansible_host=<replace-with-vm-ip-from-terraform-output> ansible_user=cloudbees

[traditional:vars]
cloudbees_home=/var/lib/cloudbees-core-cm
cloudbees_http_port=8080
''')
print(f"Generated config under {out}")
