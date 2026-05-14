#!/usr/bin/env bash
set -euo pipefail
source scripts/load_env.sh

echo "Preflight validation"
for f in .env config/onboarding.json; do
  [[ -f "$f" ]] || { echo "Missing $f"; exit 1; }
done

python3 - <<'PY'
import json
from pathlib import Path
cfg=json.loads(Path("config/onboarding.json").read_text())
for s,k in [("consultant","user"),("cloud","gcp_project_id"),("cloud","gke_cluster_name"),("dns","oc_hostname"),("cloudbees","namespace")]:
    v=cfg.get(s,{}).get(k)
    if not v or str(v).startswith("your-"):
        raise SystemExit(f"Update config/onboarding.json: {s}.{k}")
print("Config file looks valid.")
PY

for cmd in git python3 terraform helm helmfile ansible-playbook kubectl gcloud aws docker java node npm; do
  if command -v "$cmd" >/dev/null 2>&1; then echo "FOUND: $cmd"; else echo "MISSING: $cmd"; fi
done
