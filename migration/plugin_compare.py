#!/usr/bin/env python3
import csv, sys
def read(path):
    data={}
    with open(path, newline="") as f:
        for row in csv.reader(f):
            if len(row)>=2: data[row[0]]=row[1:]
    return data
if len(sys.argv)!=3: raise SystemExit("Usage: plugin_compare.py source.csv target.csv")
src,tgt=read(sys.argv[1]),read(sys.argv[2])
print("# Missing on target")
for k in sorted(set(src)-set(tgt)): print(k, src[k])
print("\n# Different versions")
for k in sorted(k for k in set(src)&set(tgt) if src[k][0]!=tgt[k][0]): print(k, "source=", src[k], "target=", tgt[k])
