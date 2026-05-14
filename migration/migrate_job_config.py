#!/usr/bin/env python3
import os, sys, urllib.request, urllib.parse, base64
def auth(u,t): return {"Authorization": "Basic " + base64.b64encode(f"{u}:{t}".encode()).decode()}
def get(url,u,t):
    with urllib.request.urlopen(urllib.request.Request(url, headers=auth(u,t))) as r: return r.read()
def post(url,data,u,t):
    h=auth(u,t); h["Content-Type"]="application/xml"
    with urllib.request.urlopen(urllib.request.Request(url, data=data, headers=h, method="POST")) as r: return r.read()
if len(sys.argv)!=3: raise SystemExit("Usage: migrate_job_config.py <source-job-path> <target-job-name>")
src_url=os.environ["SOURCE_JENKINS_URL"].rstrip("/"); tgt_url=os.environ["TARGET_JENKINS_URL"].rstrip("/")
su=os.environ["SOURCE_JENKINS_USER"]; st=os.environ["SOURCE_JENKINS_TOKEN"]; tu=os.environ["TARGET_JENKINS_USER"]; tt=os.environ["TARGET_JENKINS_TOKEN"]
source_path="/job/".join([urllib.parse.quote(p) for p in sys.argv[1].strip("/").split("/")])
config=get(f"{src_url}/job/{source_path}/config.xml",su,st)
post(f"{tgt_url}/createItem?name={urllib.parse.quote(sys.argv[2])}",config,tu,tt)
print(f"Migrated {sys.argv[1]} -> {sys.argv[2]}")
