#!/usr/bin/env python3
"""Render the generated matrices into reviewable markdown.

Reads   <matrix-name>.jsonl, matrices.yaml
Writes  by-domain/<matrix-name>/<domain>.md  -- paste into the PR body
        PROGRESS.md                          -- the one-screen rollup

Checkbox state is generated from `status`, never typed by hand.

Usage:  python3 render.py [--dir .] [--check]
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

DONE_STATUSES = {"SOURCE_REMOVED", "DROPPED"}
CHECKED_STATUSES = {"TARGET_GREEN", "SOURCE_REMOVED", "DROPPED"}
VERDICT_ORDER = ["MIGRATE", "RESHAPE", "OBSOLETE", "DROP", "REVIEW", "DEFER", "UNDECIDED"]


def load_jsonl(path: Path) -> list[dict]:
    if not path.exists():
        return []
    with path.open() as handle:
        return [json.loads(line) for line in handle if line.strip()]


def escape(value) -> str:
    return str(value if value is not None else "—").replace("|", "\\|")


def contract_cell(row: dict) -> str:
    contract = row.get("contract") or {}
    if contract.get("http_method") or contract.get("endpoint"):
        status = contract.get("expect_status")
        return f"`{contract.get('http_method') or '?'} {contract.get('endpoint') or '?'}`" + (
            f" → {status}" if status else ""
        )
    journey = contract.get("journey") or "—"
    surface = contract.get("surface")
    return f"{escape(journey)}" + (f" _({surface})_" if surface else "")


def target_cell(row: dict) -> str:
    if not row.get("target_path"):
        return "—"
    test = row.get("target_test")
    return f"`{row['target_path']}" + (f"::{test}`" if test else "`")


def variants_cell(row: dict) -> str:
    variants = row.get("variants") or []
    if not variants:
        return "—"
    return f"×{len(variants)}" if len(variants) > 1 else variants[0]


def pr_link(ref: str) -> str:
    """`spryker/suite#860` -> a clickable link. Anything else is passed through verbatim."""
    if "#" in ref:
        repo, _, number = ref.partition("#")
        if number.isdigit():
            return f"[{ref}](https://github.com/{repo}/pull/{number})"
    return ref


def run_cell(row: dict) -> str:
    run = row.get("verified_run")
    if not run:
        return "—"
    return f"[run]({run})" if str(run).startswith("http") else f"`{run}`"


def render_domain(matrix_name: str, domain: str, rows: list[dict]) -> str:
    counts = {verdict: 0 for verdict in VERDICT_ORDER}
    for row in rows:
        counts[row.get("verdict", "UNDECIDED")] = counts.get(row.get("verdict", "UNDECIDED"), 0) + 1
    portable = [row for row in rows if row.get("verdict") in ("MIGRATE", "RESHAPE")]
    green = sum(1 for row in portable if row["status"] in CHECKED_STATUSES)
    skipped = sum(1 for row in portable if row.get("target_state") == "SKIPPED")
    # A skipped target is authored code that never runs, so it is counted apart from the rest.
    authored = sum(1 for row in portable if row["status"] == "AUTHORED") - skipped
    jira = next((row.get("jira") for row in rows if row.get("jira")), None)
    batches = sorted({row.get("batch") or domain for row in rows})

    header = " · ".join(f"{verdict} {counts[verdict]}" for verdict in VERDICT_ORDER if counts[verdict])
    lines = [
        f"### {domain} · {matrix_name}" + (f" · {jira}" if jira else "") + f" · {len(rows)} scenarios",
        "",
        f"{header}   ▸ {green}/{len(portable)} verified"
        + (f" · {authored} awaiting a CI run" if authored else "")
        + (f" · {skipped} target skipped" if skipped else ""),
        "",
        f"Batches: {', '.join(f'`{batch}`' for batch in batches)}",
        "",
    ]

    for label, field in (("Target PR", "pr_target"), ("Source PR", "pr_source")):
        refs = sorted({row[field] for row in rows if row.get(field)})
        if refs:
            lines += [f"{label}: {' · '.join(pr_link(ref) for ref in refs)}", ""]

    def table(title: str, subset: list[dict], columns: list[str], cells) -> None:
        if not subset:
            return
        lines.append(f"#### {title}")
        lines.append("| " + " | ".join(columns) + " |")
        lines.append("|" + "|".join(["---"] * len(columns)) + "|")
        for row in subset:
            lines.append("| " + " | ".join(cells(row)) + " |")
        lines.append("")

    def by_verdict(*verdicts) -> list[dict]:
        return [row for row in rows if row.get("verdict") in verdicts]

    table(
        "MIGRATE / RESHAPE — port these",
        by_verdict("MIGRATE", "RESHAPE"),
        ["✓", "Scenario", "Var", "Contract", "Target", "Eff", "Run"],
        lambda row: [
            "[x]" if row["status"] in CHECKED_STATUSES else "[ ]",
            escape(row["name"]),
            variants_cell(row),
            contract_cell(row),
            target_cell(row),
            escape(row.get("effort")),
            run_cell(row),
        ],
    )
    table(
        "OBSOLETE / DROP — delete the source, do not port",
        by_verdict("OBSOLETE", "DROP"),
        ["✓", "Scenario", "Reason", "Covered by"],
        lambda row: [
            "[x]" if row["status"] in CHECKED_STATUSES else "[ ]",
            escape(row["name"]),
            escape(row.get("rationale")),
            escape(row.get("covered_by")),
        ],
    )
    table(
        "REVIEW — needs a call before this batch can close",
        by_verdict("REVIEW"),
        ["Scenario", "Recommended", "Why"],
        lambda row: [
            escape(row["name"]),
            escape(row.get("recommended_action")),
            escape(row.get("rationale")),
        ],
    )
    table(
        "DEFER — blocked",
        by_verdict("DEFER"),
        ["Scenario", "Blocked by"],
        lambda row: [escape(row["name"]), escape(row.get("blocked_by"))],
    )
    table(
        "UNDECIDED — no verdict yet",
        by_verdict("UNDECIDED"),
        ["Scenario", "Contract", "Eff"],
        lambda row: [escape(row["name"]), contract_cell(row), escape(row.get("effort"))],
    )
    return "\n".join(lines).rstrip() + "\n"


def render_progress(config: dict, matrices: dict[str, list[dict]]) -> str:
    lines = [
        "# Migration progress",
        "",
        "Generated by `render.py` — do not edit. Run `python3 build.py && python3 render.py`.",
        "",
        "| Matrix | Domains | Scenarios | MIGRATE | authored | skipped | verified | dropped "
        "| review | blocked | done % |",
        "|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|",
    ]
    for name, rows in matrices.items():
        domains = len({row["domain"] for row in rows})
        migrate = sum(1 for row in rows if row.get("verdict") in ("MIGRATE", "RESHAPE"))
        authored = sum(
            1
            for row in rows
            if row.get("verdict") in ("MIGRATE", "RESHAPE") and row["status"] == "AUTHORED"
        )
        skipped = sum(1 for row in rows if row.get("target_state") == "SKIPPED")
        authored -= skipped  # a skipped target never runs, so it is reported on its own
        ported = sum(
            1
            for row in rows
            if row.get("verdict") in ("MIGRATE", "RESHAPE") and row["status"] in CHECKED_STATUSES
        )
        dropped = sum(1 for row in rows if row["status"] == "DROPPED")
        review = sum(1 for row in rows if row["status"] == "REVIEW")
        blocked = sum(1 for row in rows if row["status"] == "BLOCKED")
        done = sum(1 for row in rows if row["status"] in DONE_STATUSES)
        percent = f"{100 * done // len(rows)}%" if rows else "—"
        lines += [
            f"| {name} | {domains} | {len(rows)} | {migrate} | {authored} | {skipped} "
            f"| {ported} | {dropped} | {review} | {blocked} | {percent} |"
        ]

    for name, rows in matrices.items():
        lines += ["", f"## {name} by domain", "",
                  "| Domain | Scenarios | MIGRATE | authored | skipped | verified | dropped "
                  "| review | blocked | batches |",
                  "|---|--:|--:|--:|--:|--:|--:|--:|--:|---|"]
        by_domain: dict[str, list[dict]] = {}
        for row in rows:
            by_domain.setdefault(row["domain"], []).append(row)
        for domain in sorted(by_domain):
            subset = by_domain[domain]
            migrate = sum(1 for row in subset if row.get("verdict") in ("MIGRATE", "RESHAPE"))
            authored = sum(
                1
                for row in subset
                if row.get("verdict") in ("MIGRATE", "RESHAPE") and row["status"] == "AUTHORED"
            )
            skipped = sum(1 for row in subset if row.get("target_state") == "SKIPPED")
            authored -= skipped
            ported = sum(
                1
                for row in subset
                if row.get("verdict") in ("MIGRATE", "RESHAPE")
                and row["status"] in CHECKED_STATUSES
            )
            batches = sorted({row.get("batch") or domain for row in subset})
            lines.append(
                f"| [{domain}](by-domain/{name}/{domain}.md) | {len(subset)} | {migrate} "
                f"| {authored} | {skipped} | {ported} "
                f"| {sum(1 for r in subset if r['status'] == 'DROPPED')} "
                f"| {sum(1 for r in subset if r['status'] == 'REVIEW')} "
                f"| {sum(1 for r in subset if r['status'] == 'BLOCKED')} | {len(batches)} |"
            )

    review_rows = [row for rows in matrices.values() for row in rows if row["status"] == "REVIEW"]
    blocked_rows = [row for rows in matrices.values() for row in rows if row["status"] == "BLOCKED"]

    if review_rows:
        lines += ["", "## Review — unresolved judgement calls", "",
                  "| Domain | Scenario | Recommended |", "|---|---|---|"]
        lines += [
            f"| {row['domain']} | {escape(row['name'])} | {escape(row.get('recommended_action'))} |"
            for row in review_rows
        ]
    if blocked_rows:
        lines += ["", "## Blocked", "", "| Domain | Scenario | Blocked by |", "|---|---|---|"]
        lines += [
            f"| {row['domain']} | {escape(row['name'])} | {escape(row.get('blocked_by'))} |"
            for row in blocked_rows
        ]
    return "\n".join(lines).rstrip() + "\n"


def emit(path: Path, content: str, check: bool, stale: list[str]) -> None:
    if check:
        if not path.exists() or path.read_text() != content:
            stale.append(str(path.name))
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dir", default=".")
    parser.add_argument("--check", action="store_true", help="fail if output would change")
    args = parser.parse_args()

    base = Path(args.dir).resolve()
    config = yaml.safe_load((base / "matrices.yaml").read_text())
    stale: list[str] = []
    matrices: dict[str, list[dict]] = {}

    for matrix in config["matrices"]:
        name = matrix["name"]
        rows = load_jsonl(base / f"{name}.jsonl")
        matrices[name] = rows
        by_domain: dict[str, list[dict]] = {}
        for row in rows:
            by_domain.setdefault(row["domain"], []).append(row)
        for domain, subset in by_domain.items():
            emit(
                base / "by-domain" / name / f"{domain}.md",
                render_domain(name, domain, subset),
                args.check,
                stale,
            )

    emit(base / "PROGRESS.md", render_progress(config, matrices), args.check, stale)

    if stale:
        print("STALE, re-run render.py: " + ", ".join(stale), file=sys.stderr)
        return 1
    print(f"rendered {sum(len(rows) for rows in matrices.values())} scenarios")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
