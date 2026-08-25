#!/usr/bin/env python3
"""Cross-framework duplication detector (Robot <-> Cypress).

Folder-agnostic: scores each Cypress UI test against each Robot UI scenario by
IDF-weighted shared canonical-helper overlap (rare shared helpers dominate),
boosted by name-token overlap. Emits the top Robot matches per Cypress test as
migration / duplication candidates.

Usage: python3 cross_framework_dup.py <robot_inv_dir> <cypress_inv_dir>
Writes cross-framework-duplication.{jsonl,md} into BOTH dirs.
"""
import json, os, sys, re, math
from collections import Counter

RG, CG = sys.argv[1], sys.argv[2]
STOP = {"the", "a", "an", "to", "should", "be", "is", "are", "with", "and", "of",
        "in", "on", "for", "as", "can", "that", "able", "see", "customer", "user"}


def loadl(p):
    return [json.loads(l) for l in open(p)]


def toks(name):
    return {w for w in re.split(r"[^a-z0-9]+", name.lower()) if w and w not in STOP and len(w) > 2}


def coarse(domain):
    d = domain.lower()
    table = [("checkout", "checkout"), ("cart", "cart"), ("catalog", "catalog"),
             ("product", "product"), ("merchand", "product"), ("order", "order"),
             ("sales", "order"), ("amendment", "order"), ("return", "order"),
             ("reorder", "order"), ("customer", "customer"), ("account", "customer"),
             ("company", "company"), ("purchasing", "company"), ("marketplace", "marketplace"),
             ("merchant", "marketplace"), ("agent", "marketplace"), ("offer", "marketplace"),
             ("ssp", "ssp"), ("cms", "content"), ("content", "content"),
             ("comment", "content"), ("acl", "admin"), ("users", "admin"),
             ("administration", "admin"), ("permission", "admin"), ("config", "admin"),
             ("multi-factor", "auth"), ("multistore", "store"), ("category", "catalog"),
             ("navigation", "navigation"), ("comparison", "product")]
    for key, c in table:
        if key in d:
            return c
    return "other"


def main():
    rt = [r for r in loadl(os.path.join(RG, "tests.jsonl"))
          if r["type"] == "ui" and not r["dup_of"]]   # Robot UI scenario leaders
    ct = [c for c in loadl(os.path.join(CG, "tests.jsonl")) if c["type"] == "ui"]

    # IDF over canonical helpers across both UI corpora
    df = Counter()
    for t in rt + ct:
        for h in set(t["helpers"]):
            df[h] += 1
    N = len(rt) + len(ct)
    idf = {h: math.log(1 + N / c) for h, c in df.items()}

    def vec(t):
        return {h: idf.get(h, 0) for h in set(t["helpers"]) if idf.get(h, 0) > 0}

    rvecs = [(r, vec(r), toks(r["name"])) for r in rt]

    rows, strong = [], 0
    for c in ct:
        cv, ctk = vec(c), toks(c["name"])
        cnorm = math.sqrt(sum(v * v for v in cv.values())) or 1
        scored = []
        for r, rv, rtk in rvecs:
            shared = set(cv) & set(rv)
            if not shared:
                continue
            dot = sum(cv[h] * rv[h] for h in shared)
            rnorm = math.sqrt(sum(v * v for v in rv.values())) or 1
            cos = dot / (cnorm * rnorm)
            ntok = len(ctk & rtk) / len(ctk | rtk) if (ctk | rtk) else 0
            score = round(0.8 * cos + 0.2 * ntok, 3)
            if score >= 0.30:
                scored.append((score, r, sorted(shared, key=lambda h: -idf[h])[:6]))
        scored.sort(key=lambda x: -x[0])
        top = scored[:3]
        if top:
            strong += 1
        rows.append({
            "cypress_id": c["id"], "cypress_name": c["name"],
            "coarse_domain": coarse(c["domain"]),
            "robot_matches": [{"score": s, "robot_id": r["id"],
                               "robot_name": r["name"], "shared_helpers": sh}
                              for s, r, sh in top],
        })

    for d in (RG, CG):
        with open(os.path.join(d, "cross-framework-duplication.jsonl"), "w") as fh:
            for row in rows:
                fh.write(json.dumps(row, ensure_ascii=False) + "\n")

    # markdown summary
    by_dom = Counter()
    by_dom_strong = Counter()
    for row in rows:
        by_dom[row["coarse_domain"]] += 1
        if row["robot_matches"]:
            by_dom_strong[row["coarse_domain"]] += 1
    lines = [
        "# Cross-framework duplication (Robot ↔ Cypress)", "",
        "Each Cypress UI test scored against every Robot UI scenario (variant clones excluded) "
        "by IDF-weighted shared canonical-helper overlap (rare shared helpers dominate) plus "
        "name-token overlap. A match at score ≥ 0.30 means the Cypress test likely already covers "
        "a Robot scenario — i.e. that Robot test may be redundant or is the migration source.", "",
        "Full detail: `cross-framework-duplication.jsonl` (top 3 Robot matches per Cypress test).", "",
        "## Cypress UI tests with a likely Robot counterpart, by domain", "",
        "| coarse domain | cypress UI tests | with ≥1 Robot match |", "|---|---|---|",
    ]
    for d in sorted(by_dom, key=lambda x: -by_dom[x]):
        lines.append(f"| {d} | {by_dom[d]} | {by_dom_strong[d]} |")
    lines += ["",
              f"**Total:** {strong} of {len(ct)} Cypress UI tests have at least one likely Robot "
              f"counterpart at score ≥ 0.30.", "",
              "## Strongest matches (score ≥ 0.55)", ""]
    flat = sorted(
        ([m["score"], row["cypress_name"], m["robot_name"], m["robot_id"], m["shared_helpers"]]
         for row in rows for m in row["robot_matches"] if m["score"] >= 0.55),
        key=lambda x: -x[0])[:40]
    for s, cn, rn, rid, sh in flat:
        lines.append(f"- **{s}** · Cypress `{cn}`  ↔  Robot `{rn}`  (shared: {', '.join(sh[:4])})")
    lines += ["", "## Limitations", "",
              "- **Composite vs granular helpers suppress real matches.** Cypress wraps flows in one "
              "scenario call (`CheckoutScenario.execute` → a single canonical), while Robot spells out "
              "~15 granular steps. Low helper overlap then hides genuine duplication — checkout shows 0 "
              "strong matches here even though the domain-count view is **384 Robot vs 16 Cypress** "
              "checkout tests. Treat this list as a *floor*, not a complete dup set.",
              "- Robot side compared at scenario-leader granularity (variant clones excluded); multiply "
              "by ~3 for raw Robot test count via `dup_of`.",
              "- Threshold 0.30 is deliberately conservative to keep precision high. Lower it in the "
              "script to surface more (noisier) candidates."]
    for d in (RG, CG):
        open(os.path.join(d, "cross-framework-duplication.md"), "w").write("\n".join(lines) + "\n")

    print(f"Cypress UI tests: {len(ct)} | Robot UI scenarios compared: {len(rt)}")
    print(f"Cypress tests with >=1 Robot match (>=0.30): {strong}")
    print("by coarse domain:", dict(by_dom_strong))
    print("strong matches (>=0.55):", len(flat))


if __name__ == "__main__":
    main()
