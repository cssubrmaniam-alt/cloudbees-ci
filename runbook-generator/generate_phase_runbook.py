#!/usr/bin/env python3
import json
from pathlib import Path
from datetime import datetime
root=Path(__file__).resolve().parents[1]
out=root/"generated-runbooks"; out.mkdir(exist_ok=True)
evidence=root/"evidence"
all_files=sorted(p.relative_to(root).as_posix() for p in evidence.rglob("*") if p.is_file()) if evidence.exists() else []
for f in sorted((root/"runbook-generator/phase-data").glob("phase*.json")):
    d=json.loads(f.read_text()); key=d["phase_id"].lower().replace(" ","-")
    lines=[f"# {d['phase_id']} — {d['title']}","",f"Generated: {datetime.now().isoformat(timespec='seconds')}","","## Objective","",d["objective"],"","## Evidence Files",""]
    hits=[x for x in all_files if key[-1] in x or d["phase_id"].lower().replace(" ","-") in x]
    lines += [f"- `{x}`" for x in hits] if hits else ["_No evidence captured yet._"]
    lines += ["","## Demo Notes","","## Sign-off",""]
    (out/f"{key}-runbook.md").write_text("\n".join(lines))
    print(f"Generated {out/f'{key}-runbook.md'}")
