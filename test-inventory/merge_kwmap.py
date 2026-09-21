#!/usr/bin/env python3
"""Merge the per-bucket keyword maps in _kwmap/ into:
  - keyword_map.json : {raw_keyword: canonical_name}   (consumed by enrich.py)
  - helpers.jsonl    : one record per canonical helper  (the migration glossary)

Drops extractor-noise canonicals (endpoint_/json_field_/error_message_/
message_text_/control_ prefixes) so the glossary only holds real helpers.

Usage: python3 merge_kwmap.py
"""
import os, json, glob
from collections import defaultdict, Counter

D = os.path.dirname(os.path.abspath(__file__))
NOISE_PREFIX = ("endpoint_", "json_field_", "error_message_", "message_text_", "control_")

raw_to_canon = {}
canon = defaultdict(lambda: {"kinds": Counter(), "descs": Counter(),
                             "notes": Counter(), "examples": []})

for f in sorted(glob.glob(os.path.join(D, "_kwmap", "*.json"))):
    data = json.load(open(f))
    for raw, info in data.items():
        cn = info.get("canonical_name", "").strip()
        if not cn or cn.startswith(NOISE_PREFIX):
            continue
        raw_to_canon[raw] = cn
        c = canon[cn]
        c["kinds"][info.get("kind", "")] += 1
        if info.get("description"):
            c["descs"][info["description"]] += 1
        if info.get("migration_note"):
            c["notes"][info["migration_note"]] += 1
        if len(c["examples"]) < 5:
            c["examples"].append(raw)

# raw keyword usage counts + sources from helpers_raw.json
raw_cat = json.load(open(os.path.join(D, "helpers_raw.json")))


def top(counter, default=""):
    return counter.most_common(1)[0][0] if counter else default


json.dump(raw_to_canon, open(os.path.join(D, "keyword_map.json"), "w"),
          ensure_ascii=False, indent=0)

with open(os.path.join(D, "helpers.jsonl"), "w") as fh:
    for cn in sorted(canon):
        c = canon[cn]
        # representative raw keyword = most-used example
        ex = sorted(c["examples"], key=lambda k: -raw_cat.get(k, {}).get("count", 0))
        rep = ex[0] if ex else ""
        src = (raw_cat.get(rep, {}).get("sources") or [""])[0]
        rec = {
            "canonical_name": cn,
            "kind": top(c["kinds"]),
            "description": top(c["descs"]),
            "robot_keyword": rep,
            "cypress_fn": None,
            "source": src,
            "migration_note": top(c["notes"]),
        }
        fh.write(json.dumps(rec, ensure_ascii=False) + "\n")

print("raw->canonical entries:", len(raw_to_canon))
print("distinct canonical helpers (glossary):", len(canon))
