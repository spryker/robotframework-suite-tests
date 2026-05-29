#!/usr/bin/env python3
"""Deterministic structural extractor for the Robot test inventory.

Walks tests/**/*.robot, parses every test case, and emits a skeleton record
with all STRUCTURAL fields filled. Judgement fields (purpose, data, mutation,
dup_of, canonical helper mapping) are left for the thin AI pass:
  - purpose: ""        (AI fills from `doc` + raw_helpers)
  - data: {}           (AI fills)
  - mutation: null     (AI fills for negative tests)
  - dup_of: null       (AI/algorithmic cross-ref)
  - helpers: []         -> raw_helpers holds the unmapped keyword names

Outputs (next to this script):
  - skeleton.jsonl       one record per test case
  - helpers_raw.json     {raw_keyword: {count, sources:[...]}} catalog

Usage: python3 extract.py <worktree_root>
"""
import os, re, json, sys

ROOT = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()
TESTS = os.path.join(ROOT, "tests")
OUT_DIR = os.path.dirname(os.path.abspath(__file__))

VARIANTS = ("mp_b2c", "mp_b2b", "b2c", "b2b", "suite")  # order: match longest first
SECTION_RE = re.compile(r"^\*\*\*\s*(.+?)\s*\*\*\*")
SPLIT_RE = re.compile(r"\s{2,}|\t+")
BDD = {"given", "when", "then", "and", "but"}
RUNKW = {"run keywords", "run keyword", "run keyword and continue on failure",
         "run keyword and return status", "run keyword if"}
CONTROL = {"if", "else", "else if", "end", "for", "var", "try", "except",
           "finally", "while", "return", "break", "continue", "set variable"}


def variant_from_path(rel):
    parts = rel.split("/")
    for p in parts:
        if p in ("b2c", "b2b", "mp_b2c", "mp_b2b", "suite"):
            return p
    return "suite"


def type_from_path(rel):
    if "/api/" in "/" + rel:
        return "api"
    if rel.startswith("tests/ui/") or rel.startswith("tests/parallel_ui/"):
        return "ui"
    return "other"


def domain_from_path(rel):
    parts = rel.split("/")
    # tests/<ui|parallel_ui>/<variant>/<domain>/...   domain = parts[3]
    # tests/api/<variant>/<glue|bapi|sapi>/<domain>_endpoints/...  domain = after api-type
    if parts[1] in ("ui", "parallel_ui") and len(parts) > 3:
        return parts[3]
    if parts[1] == "api":
        for i, p in enumerate(parts):
            if p in ("glue", "bapi", "sapi") and i + 1 < len(parts):
                d = parts[i + 1]
                return d[:-10] if d.endswith("_endpoints") else d
    return parts[3] if len(parts) > 3 else "unknown"


def api_flavour(rel):
    for f in ("glue", "bapi", "sapi"):
        if "/%s/" % f in "/" + rel:
            return f
    return None


def split_cells(line):
    return [c for c in SPLIT_RE.split(line.strip()) if c != ""]


ARG_PREFIX = ("${", "{", "[", "|", "#", "/", "@", "&", "%", "\\", "*", "=")


def keyword_candidates(cells, cont=False):
    """From a step's cells, yield keyword-name candidates.

    Handles BDD prefixes and Run Keywords ... AND ... chains. On a `...`
    continuation line, only the cell right after an explicit AND is a keyword
    (everything else is a wrapped argument), so pure-argument continuations
    yield nothing."""
    out = []
    has_and = any(c.lower() == "and" for c in cells)
    if cont and not has_and:
        return out
    expect_kw = not cont  # continuation: keyword only expected after AND
    for c in cells:
        cl = c.lower().rstrip(":")
        if cl == "and" or cl in BDD or cl in RUNKW:
            expect_kw = True
            continue
        if cl in CONTROL:
            expect_kw = False
            continue
        if expect_kw:
            if c.startswith(ARG_PREFIX) or c[:1].isdigit() or "=>" in c:
                expect_kw = False
                continue
            out.append(c)
            expect_kw = False
    return out


def parse_file(path, rel):
    with open(path, encoding="utf-8", errors="replace") as fh:
        lines = fh.read().splitlines()

    suite_tags, section = [], None
    # ---- settings pass: suite-level Test Tags / Force Tags ----
    for ln in lines:
        m = SECTION_RE.match(ln)
        if m:
            section = m.group(1).lower()
            continue
        if section == "settings":
            cells = split_cells(ln)
            if cells and cells[0].lower() in ("test tags", "force tags", "default tags"):
                suite_tags = cells[1:]

    # ---- test cases pass ----
    tests, section = [], None
    cur = None

    def flush():
        if cur:
            tests.append(cur)

    for ln in lines:
        m = SECTION_RE.match(ln)
        if m:
            flush()
            cur = None
            section = m.group(1).lower()
            continue
        if section != "test cases":
            continue
        if not ln.strip() or ln.lstrip().startswith("#"):
            continue
        is_header = ln[:1] not in (" ", "\t") and not ln.startswith("...")
        if is_header:
            flush()
            cur = {"name": split_cells(ln)[0], "doc": "", "tags": list(suite_tags),
                   "kw": [], "raw": []}
        elif cur is not None:
            stripped = ln.strip()
            cont = stripped.startswith("...")
            if cont:
                stripped = stripped[3:].strip()
            cells = split_cells(stripped)
            if not cells:
                continue
            head = cells[0].lower()
            if head == "[documentation]":
                cur["doc"] = (cur["doc"] + " " + " ".join(cells[1:])).strip()
            elif head == "[tags]":
                cur["tags"] += cells[1:]
            elif head in ("[setup]", "[teardown]"):
                cur["kw"] += keyword_candidates(cells[1:], cont=cont)
            elif head.startswith("["):
                pass  # [Template], [Timeout], etc.
            else:
                cur["kw"] += keyword_candidates(cells, cont=cont)
            cur["raw"].append(stripped)
    flush()
    return tests


def signals(kw_list, raw_text, rel, name):
    kws = " || ".join(kw_list).lower()
    raw = raw_text.lower()
    # subsystems
    subs = []
    if any(k.lower().startswith("yves:") for k in kw_list):
        subs.append("yves")
    if any(k.lower().startswith("zed:") for k in kw_list):
        subs.append("zed")
    if any(k.lower().startswith(("mp:", "mp ")) for k in kw_list) or "merchant portal" in kws:
        subs.append("mp")
    if "i send a" in kws or "access token" in kws or "i send" in raw and "request" in raw:
        subs.append("glue")
    if any(t in raw for t in ("oms", "trigger", "state machine", "queue worker", "run the queue")):
        subs.append("oms")
    if any(t in raw for t in ("execute sql", "connect to database", " from spy_", "select ", "delete from", "insert into")):
        subs.append("db")
    if type_from_path(rel) == "api" and "glue" not in subs:
        subs.append("glue")
    # de-dupe preserving order
    seen, subs2 = set(), []
    for s in subs:
        if s not in seen:
            seen.add(s); subs2.append(s)
    # auth
    nm = name.lower()
    guest = ("guest" in nm or "x-anonymous" in raw or "guest-cart" in raw
             or "anonymous-customer" in raw)
    customer = ("login on yves" in kws or "access token for the customer" in raw
                or "login on yves" in raw)
    admin_only = ("login on zed" in kws or "login on zed" in raw) and not customer
    merchant = ("login on mp" in raw or "merchant portal" in raw or "login on the merchant" in raw)
    if customer:
        auth = "customer"
    elif guest:
        auth = "guest"
    elif merchant:
        auth = "merchant"
    elif admin_only:
        auth = "admin"
    else:
        auth = "none"
    return subs2 or ["yves"], auth


def main():
    skeleton, helper_cat = [], {}
    files = []
    for dp, _, fns in os.walk(TESTS):
        for fn in fns:
            if fn.endswith(".robot"):
                files.append(os.path.join(dp, fn))
    files.sort()

    for path in files:
        rel = os.path.relpath(path, ROOT)
        tcs = parse_file(path, rel)
        v, t, d = variant_from_path(rel), type_from_path(rel), domain_from_path(rel)
        flav = api_flavour(rel)
        for tc in tcs:
            raw_text = "\n".join(tc["raw"])
            subs, auth = signals(tc["kw"], raw_text, rel, tc["name"])
            for k in tc["kw"]:
                e = helper_cat.setdefault(k, {"count": 0, "sources": set()})
                e["count"] += 1
                e["sources"].add(rel)
            rec = {
                "id": "robot:%s::%s" % (rel, tc["name"]),
                "framework": "robot",
                "file": rel,
                "name": tc["name"],
                "suite": d,
                "domain": d,
                "variant": v,
                "gating": None,
                "type": t,
                "subsystems": subs,
                "auth": auth,
                "purpose": "",
                "data": {},
                "mutation": None,
                "helpers": [],
                "raw_helpers": tc["kw"],
                "tags": tc["tags"],
                "dup_of": None,
                "flags": [],
                "doc": tc["doc"],
                "api_flavour": flav,
            }
            skeleton.append(rec)

    with open(os.path.join(OUT_DIR, "skeleton.jsonl"), "w") as fh:
        for r in skeleton:
            fh.write(json.dumps(r, ensure_ascii=False) + "\n")
    cat = {k: {"count": v["count"], "sources": sorted(v["sources"])[:5]}
           for k, v in sorted(helper_cat.items(), key=lambda x: -x[1]["count"])}
    with open(os.path.join(OUT_DIR, "helpers_raw.json"), "w") as fh:
        json.dump(cat, fh, ensure_ascii=False, indent=1)

    print("files:", len(files), "test records:", len(skeleton),
          "distinct raw keywords:", len(cat))
    from collections import Counter
    print("by type:", dict(Counter(r["type"] for r in skeleton)))
    print("by variant:", dict(Counter(r["variant"] for r in skeleton)))
    print("by auth:", dict(Counter(r["auth"] for r in skeleton)))
    print("top domains:", Counter(r["domain"] for r in skeleton).most_common(12))


if __name__ == "__main__":
    main()
