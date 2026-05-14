#!/usr/bin/env python3
import os
from pathlib import Path
from playwright.sync_api import sync_playwright
base=os.environ.get("CLOUDBEES_URL","").rstrip("/")
user=os.environ.get("CLOUDBEES_ADMIN_USER","admin")
password=os.environ.get("CLOUDBEES_ADMIN_PASSWORD","")
out=Path(os.environ.get("EVIDENCE_ROOT","evidence"))/"screenshots"
out.mkdir(parents=True, exist_ok=True)
if not base: raise SystemExit("Set CLOUDBEES_URL")
with sync_playwright() as p:
    browser=p.chromium.launch()
    page=browser.new_page(ignore_https_errors=True)
    page.goto(base, wait_until="domcontentloaded")
    page.screenshot(path=out/"cloudbees-home.png", full_page=True)
    if password and page.locator('input[name="j_username"]').count():
        page.fill('input[name="j_username"]', user)
        page.fill('input[name="j_password"]', password)
        page.click('button[name="Submit"], input[name="Submit"]')
        page.wait_for_load_state("networkidle", timeout=15000)
    for name,path in {"manage":"/manage","plugin-manager":"/pluginManager/","people":"/asynchPeople/"}.items():
        try:
            page.goto(base+path, wait_until="domcontentloaded", timeout=30000)
            page.screenshot(path=out/f"{name}.png", full_page=True)
        except Exception as e:
            print(f"Screenshot failed {name}: {e}")
    browser.close()
