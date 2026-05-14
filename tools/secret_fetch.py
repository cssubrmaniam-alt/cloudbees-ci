#!/usr/bin/env python3
import os, sys, json, subprocess, re
def env_name(s): return re.sub(r"[^A-Za-z0-9_]","_",s).upper()
def run(cmd): return subprocess.check_output(cmd, text=True).strip()
if len(sys.argv)!=2: raise SystemExit("Usage: secret_fetch.py <secret-id>")
sid=sys.argv[1]; backend=os.environ.get("SECRETS_BACKEND","env")
if backend=="env":
    val=os.environ.get(env_name(sid)) or os.environ.get(sid)
elif backend=="aws":
    raw=run(["aws","secretsmanager","get-secret-value","--secret-id",sid,"--profile",os.environ.get("AWS_PROFILE","default"),"--region",os.environ.get("AWS_REGION","us-east-1"),"--output","json"])
    val=json.loads(raw).get("SecretString","")
elif backend=="gcp":
    val=run(["gcloud","secrets","versions","access","latest","--secret",sid,"--project",os.environ["GCP_PROJECT_ID"]])
else:
    raise SystemExit(f"Unsupported backend {backend}")
if not val: raise SystemExit(f"Secret not found: {sid}")
print(val)
