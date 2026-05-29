#!/usr/bin/env python3
"""Deterministic enrichment: turns skeleton.jsonl into the final v2 tests.jsonl.

Deterministic here:
  - dup_of      group (domain,name,type); leader = has-doc, then variant/ui priority
  - helpers     map raw_helpers -> canonical via keyword_map.json (if present)
  - purpose     [Documentation] if present; else purposes.json[leader_id]; clones inherit leader
  - data        heuristic from raw step text (endpoint/method/skus/payment)
  - mutation    heuristic for negative tests from the name tokens
  - subsystems/auth/variant/tags/gating carried from skeleton

AI inputs (optional, produced separately and dropped in next to this script):
  - keyword_map.json : {raw_keyword: canonical_name}
  - purposes.json    : {leader_id: "one-line purpose"}

Usage: python3 enrich.py <worktree_root>
"""
import os, re, json, sys
from collections import defaultdict

ROOT = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()
D = os.path.dirname(os.path.abspath(__file__))
V2 = ["id", "framework", "file", "name", "suite", "domain", "variant", "gating",
      "type", "subsystems", "auth", "purpose", "data", "mutation", "helpers",
      "tags", "dup_of", "flags"]
VAR_PRI = {"suite": 0, "b2c": 1, "b2b": 2, "mp_b2c": 3, "mp_b2b": 4}


def load(p, default):
    return json.load(open(p)) if os.path.exists(p) else default


def clean_purpose(doc):
    return re.sub(r"\s+", " ", doc).strip().rstrip(".") + "." if doc.strip() else ""


def synth_purpose(r):
    d = r["data"]
    ep, meth = d.get("endpoint"), d.get("method")
    if r["type"] == "api" and ep:
        s = "%s %s" % (meth or "request", ep)
        if r["mutation"]:
            s += " with %s %s" % (r["mutation"]["mode"], r["mutation"]["target"])
        if d.get("expect_status"):
            s += " → expects %s" % d["expect_status"]
        return s
    return r["name"].replace("_", " ").strip().capitalize()


def extract_data(rec):
    raw = "\n".join(rec.get("_raw", []))
    data = {}
    if rec["type"] == "api":
        reqs = re.findall(r"I send a (\w+) request:\s*([^\s{]+)", raw)
        if reqs:
            # primary = last 'When' request if any, else last
            data["method"], data["endpoint"] = reqs[-1][0], reqs[-1][1]
        codes = re.findall(r"status code should be:\s*(\d{3})", raw)
        if codes:
            data["expect_status"] = codes[0]
    else:
        skus = re.findall(r"sku:?\s*\|?\s*0*(\d{2,4})\b", raw)
        skus = re.findall(r"with sku:\s*(\S+)", raw) or re.findall(r"sku:\s*(\d{2,4})", raw)
        if skus:
            data["products"] = sorted(set(skus))[:6]
        pay = re.search(r"payment method on the checkout[^\n]*?:\s*(\w+)", raw)
        if pay:
            data["payment"] = pay.group(1)
    return data


NEG_MODES = [
    (r"non[_-]?existent|not[_-]?exist|wrong|unknown|fake", "invalid"),
    (r"invalid|incorrect|malformed|bad", "invalid"),
    (r"empty", "empty"),
    (r"without|missing|no[_-]", "missing"),
    (r"duplicate|already", "duplicate"),
    (r"unauthor|forbidden|not[_-]?allowed|permission", "unauthorized"),
    (r"expired", "expired"),
]


def extract_mutation(rec):
    is_neg = "negative" in rec["file"] or rec["expect_status_neg"]
    if not is_neg:
        return None
    nm = rec["name"].lower()
    mode = None
    for pat, m in NEG_MODES:
        if re.search(pat, nm):
            mode = m
            break
    if not mode:
        return None
    # crude target: token after the mode keyword
    m = re.search(r"(?:invalid|incorrect|empty|without|missing|wrong|non[_-]?existent|"
                  r"fake|expired|duplicate|unauthorized)[_-]?(\w+)", nm)
    target = m.group(1) if m else "request"
    return {"target": target, "mode": mode}


def main():
    recs = [json.loads(l) for l in open(os.path.join(D, "skeleton.jsonl"))]
    kmap = load(os.path.join(D, "keyword_map.json"), {})
    purposes = load(os.path.join(D, "purposes.json"), {})

    # need raw step text + expect_status for heuristics: re-read is costly, so
    # the skeleton kept `doc`; raw steps were dropped. Re-derive light signals
    # from raw_helpers + (re-open file once per file for data/mutation).
    by_file = defaultdict(list)
    for r in recs:
        by_file[r["file"]].append(r)
    for f, rs in by_file.items():
        try:
            text = open(os.path.join(ROOT, f), encoding="utf-8", errors="replace").read()
        except OSError:
            text = ""
        # split per test case crudely by name occurrence
        for r in rs:
            idx = text.find("\n" + r["name"])
            seg = text[idx: idx + 4000] if idx >= 0 else ""
            r["_raw"] = seg.splitlines()
            r["expect_status_neg"] = bool(re.search(r"status code should be:\s*[45]\d\d", seg))

    # ---- dup_of: group and pick leader ----
    groups = defaultdict(list)
    for r in recs:
        groups[(r["domain"], r["name"], r["type"])].append(r)

    def leader_key(r):
        has_doc = 0 if r["doc"].strip() else 1
        ui_pri = 0 if "/parallel_ui/" not in "/" + r["file"] else 1
        return (has_doc, VAR_PRI.get(r["variant"], 5), ui_pri, r["file"])

    leaders = {}
    for key, rs in groups.items():
        rs_sorted = sorted(rs, key=leader_key)
        leader = rs_sorted[0]
        leaders[key] = leader
        for r in rs:
            r["dup_of"] = None if r is leader else leader["id"]

    # ---- enrich each record ----
    for r in recs:
        key = (r["domain"], r["name"], r["type"])
        leader = leaders[key]
        # helpers via canonical map
        mapped, seen = [], set()
        for k in r["raw_helpers"]:
            c = kmap.get(k, kmap.get(k.rstrip(":"), None))
            name = c if c else k  # fallback: keep raw name until mapped
            if name not in seen:
                seen.add(name); mapped.append(name)
        r["helpers"] = mapped
        # data + mutation (needed before purpose synthesis)
        r["data"] = extract_data(r)
        r["mutation"] = extract_mutation(r)
        # purpose
        if r["doc"].strip():
            r["purpose"] = clean_purpose(r["doc"])
        elif leader["doc"].strip():
            r["purpose"] = clean_purpose(leader["doc"])
        elif leader["id"] in purposes:
            r["purpose"] = purposes[leader["id"]]
        else:
            r["purpose"] = synth_purpose(r)
            r["flags"] = r["flags"] + ["synth-purpose"]

    # ---- write final v2 tests.jsonl ----
    with open(os.path.join(D, "tests.jsonl"), "w") as fh:
        for r in recs:
            fh.write(json.dumps({k: r[k] for k in V2}, ensure_ascii=False) + "\n")

    # stats
    leader_ids = {lead["id"] for lead in leaders.values()}
    leaders_no_purpose = sorted({lead["id"] for lead in leaders.values()
                                 if not lead["doc"].strip() and lead["id"] not in purposes})
    json.dump(leaders_no_purpose, open(os.path.join(D, "leaders_need_purpose.json"), "w"), indent=1)
    n = len(recs)
    print("records:", n)
    print("dup_of set (variant clones):", sum(1 for r in recs if r["dup_of"]))
    print("distinct scenario leaders:", len(leader_ids))
    print("purpose filled:", sum(1 for r in recs if r["purpose"]))
    print("helpers mapped (any canonical):", sum(1 for r in recs if r["helpers"]))
    print("mutation set:", sum(1 for r in recs if r["mutation"]))
    print("leaders still needing AI purpose:", len(leaders_no_purpose))
    print("keyword_map entries loaded:", len(kmap))


if __name__ == "__main__":
    main()
