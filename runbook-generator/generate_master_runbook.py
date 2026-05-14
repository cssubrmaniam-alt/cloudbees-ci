#!/usr/bin/env python3
from pathlib import Path
from datetime import datetime
root=Path(__file__).resolve().parents[1]; out=root/"generated-runbooks"; out.mkdir(exist_ok=True)
files=sorted(out.glob("phase-*-runbook.md"))
lines=["# CloudBees CI PS Master Execution Runbook","",f"Generated: {datetime.now().isoformat(timespec='seconds')}","","## Phase Index",""]
for f in files: lines.append(f"- [{f.stem}](./{f.name})")
lines.append("\n---\n")
for f in files: lines += [f.read_text(), "\n---\n"]
(out/"cloudbees-ci-ps-master-execution-runbook.md").write_text("\n".join(lines))
print("Generated master runbook")
