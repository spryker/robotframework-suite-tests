#!/usr/bin/env python3
"""Build the migration matrices for this repo.

Reads   tests.jsonl (test inventory), decisions.jsonl, domains.yaml, matrices.yaml, scan.jsonl
Writes  <matrix-name>.jsonl -- one canonical scenario per line

Never edit a generated <matrix-name>.jsonl by hand. Edit decisions.jsonl and re-run.

Usage:  python3 build.py [--dir .] [--check]
        --check exits non-zero instead of writing when the output would change.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.exit("PyYAML is required: python3 -m pip install -r requirements.txt")

AUTH_NEEDS_SETUP = {"customer", "admin", "merchant", "agent", "backend"}
DONE_STATUSES = {"TARGET_GREEN", "SOURCE_REMOVED", "DROPPED"}
NO_PORT_VERDICTS = {"OBSOLETE", "DROP"}
SURFACE_BY_SUBSYSTEM = {"yves": "yves", "zed": "backoffice", "mp": "mp"}


def load_jsonl(path: Path) -> list[dict]:
    if not path.exists():
        return []
    with path.open() as handle:
        return [json.loads(line) for line in handle if line.strip()]


def write_jsonl(path: Path, rows: list[dict]) -> None:
    with path.open("w") as handle:
        for row in rows:
            handle.write(json.dumps(row, ensure_ascii=False, sort_keys=True) + "\n")


def build_alias_index(domains: dict) -> dict[tuple[str, str], str]:
    """(framework, native domain name) -> canonical domain. Rejects duplicate aliases."""
    index: dict[tuple[str, str], str] = {}
    for entry in domains["domains"]:
        for framework, aliases in (entry.get("aliases") or {}).items():
            for alias in aliases:
                key = (framework, alias)
                if key in index:
                    sys.exit(
                        f"domains.yaml: alias {framework}:{alias} claimed by both "
                        f"'{index[key]}' and '{entry['domain']}'"
                    )
                index[key] = entry["domain"]
    return index


def derive_effort(row: dict) -> str:
    """S/M/L from the inventory's own difficulty signals. Deterministic, no judgement."""
    subsystems = set(row.get("subsystems") or [])
    auth = row.get("auth") or "none"
    if len(subsystems) >= 3 or "db" in subsystems:
        return "L"
    if len(subsystems) == 2 or auth in AUTH_NEEDS_SETUP:
        return "M"
    return "S"


def derive_contract(row: dict) -> dict:
    data = row.get("data") or {}
    if row.get("type") == "api":
        return {
            "http_method": data.get("method"),
            "endpoint": data.get("endpoint"),
            "expect_status": data.get("expect_status"),
            "auth": row.get("auth"),
            "mutation": row.get("mutation"),
        }
    subsystems = row.get("subsystems") or []
    surface = next(
        (SURFACE_BY_SUBSYSTEM[s] for s in subsystems if s in SURFACE_BY_SUBSYSTEM), None
    )
    return {"journey": row.get("purpose"), "surface": surface, "auth": row.get("auth")}


def derive_status(verdict: str, source_state: str, target_state: str, verified_run) -> str:
    if verdict == "REVIEW":
        return "REVIEW"
    if verdict == "DEFER":
        return "BLOCKED"
    if verdict in NO_PORT_VERDICTS:
        return "DROPPED" if source_state == "GONE" else "TODO"
    if target_state in ("MISSING", "UNKNOWN"):
        return "TODO"
    if target_state == "SKIPPED":
        return "AUTHORED"
    if not verified_run:
        return "AUTHORED"
    return "SOURCE_REMOVED" if source_state == "GONE" else "TARGET_GREEN"


def collapse_to_scenarios(rows: list[dict]) -> list[tuple[dict, list[dict]]]:
    """Group variant clones under their canonical leader (inventory field `dup_of`)."""
    leaders = {row["id"]: row for row in rows if not row.get("dup_of")}
    clones: dict[str, list[dict]] = {leader_id: [] for leader_id in leaders}
    orphans = []
    for row in rows:
        parent = row.get("dup_of")
        if not parent:
            continue
        if parent in clones:
            clones[parent].append(row)
        else:
            orphans.append(row["id"])
    if orphans:
        sys.exit(
            f"{len(orphans)} rows point at a dup_of leader that is not in this selection, "
            f"first: {orphans[0]}"
        )
    return [(leader, clones[leader_id]) for leader_id, leader in leaders.items()]


def selects(row: dict, criteria: dict) -> bool:
    return all(row.get(field) == value for field, value in criteria.items())


def build_matrix(matrix: dict, inventory: list[dict], decisions: dict, scan: dict,
                 alias_index: dict, unmapped: set) -> list[dict]:
    selected = [row for row in inventory if selects(row, matrix.get("select") or {})]
    out = []
    for leader, clones in collapse_to_scenarios(selected):
        framework = leader.get("framework")
        native_domain = leader.get("domain")
        domain = alias_index.get((framework, native_domain))
        if domain is None:
            unmapped.add(f"{framework}:{native_domain}")
            domain = "UNMAPPED"

        decision = decisions.get(leader["id"], {})
        observed = scan.get(leader["id"], {})
        source_state = observed.get("source_state", "UNKNOWN")
        target_state = observed.get("target_state", "UNKNOWN")
        verdict = decision.get("verdict", "UNDECIDED")
        verified_run = decision.get("verified_run")

        out.append(
            {
                "id": leader["id"],
                "matrix": matrix["name"],
                "source_path": leader.get("file"),
                "name": leader.get("name"),
                "domain": domain,
                "native_domain": native_domain,
                "suite": leader.get("suite"),
                "variants": sorted(
                    {leader.get("variant")} | {clone.get("variant") for clone in clones} - {None}
                ),
                "clones": len(clones),
                "effort": derive_effort(leader),
                "flags": leader.get("flags") or [],
                "contract": derive_contract(leader),
                "verdict": verdict,
                "decided_by": decision.get("decided_by"),
                "rationale": decision.get("rationale"),
                "recommended_action": decision.get("recommended_action"),
                "covered_by": decision.get("covered_by"),
                "target_repo": decision.get("target_repo", matrix.get("target_repo")),
                "target_path": decision.get("target_path"),
                "target_test": decision.get("target_test"),
                "batch": decision.get("batch"),
                "jira": decision.get("jira"),
                "blocked_by": decision.get("blocked_by"),
                "pr_target": decision.get("pr_target"),
                "pr_source": decision.get("pr_source"),
                "verified_run": verified_run,
                "source_state": source_state,
                "target_state": target_state,
                "status": derive_status(verdict, source_state, target_state, verified_run),
            }
        )
    out.sort(key=lambda row: (row["domain"], row["source_path"] or "", row["name"] or ""))
    return out


def assign_batches(rows: list[dict], cap: int) -> None:
    """Split oversized domains into numbered sub-batches so no PR exceeds the cap."""
    by_domain: dict[str, list[dict]] = {}
    for row in rows:
        by_domain.setdefault(row["domain"], []).append(row)
    for domain, domain_rows in by_domain.items():
        if len(domain_rows) <= cap:
            for row in domain_rows:
                row.setdefault("batch", None)
                row["batch"] = row["batch"] or domain
            continue
        for index, row in enumerate(domain_rows):
            row["batch"] = row["batch"] or f"{domain}-{index // cap + 1}"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dir", default=".", help="migrations directory")
    parser.add_argument("--check", action="store_true", help="fail if output would change")
    args = parser.parse_args()

    base = Path(args.dir).resolve()
    config = yaml.safe_load((base / "matrices.yaml").read_text())
    domains = yaml.safe_load((base / "domains.yaml").read_text())
    alias_index = build_alias_index(domains)

    inventory = load_jsonl(base / config["inventory"])
    decisions = {row["id"]: row for row in load_jsonl(base / "decisions.jsonl")}
    scan = {row["id"]: row for row in load_jsonl(base / "scan.jsonl")}

    unmapped: set[str] = set()
    exit_code = 0
    for matrix in config["matrices"]:
        rows = build_matrix(matrix, inventory, decisions, scan, alias_index, unmapped)
        assign_batches(rows, config.get("batch_cap", 40))
        target = base / f"{matrix['name']}.jsonl"
        if args.check:
            existing = load_jsonl(target)
            if existing != rows:
                print(f"STALE {target.name}: re-run build.py", file=sys.stderr)
                exit_code = 1
        else:
            write_jsonl(target, rows)
        done = sum(1 for row in rows if row["status"] in DONE_STATUSES)
        print(f"{matrix['name']}: {len(rows)} scenarios, {done} done")

    if unmapped:
        print(
            "\ndomains.yaml is missing aliases for:\n  "
            + "\n  ".join(sorted(unmapped)),
            file=sys.stderr,
        )
        exit_code = 1
    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())
