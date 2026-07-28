#!/usr/bin/env python3
"""Migration drift gates. Run in CI; run locally before you push.

G1 coverage      every inventory test is in exactly one matrix row (or is a clone of one),
                 a deleted source has a recorded target and a settled verdict,
                 every framework-native domain resolves through domains.yaml,
                 the generated files are not stale.
G3 parity        a row with verified_run recorded must have its target test present.
G4 skip honesty  a skipped target test can never count as ported, and deleting a source
                 whose target is skipped leaves the scenario untested everywhere.
D   decisions    each verdict carries the field that makes it reviewable.

A deleted source whose target is present but has no verified_run yet is a warning, not a
violation: that is an unfinished batch, not drift. Only a lost or skipped target fails.

G2 (no new source-framework tests) is a diff-scoped check and lives in the CI workflow,
not here -- this script has no view of the pull request.

Usage:  python3 gate.py [--dir .]
Exit 0 clean, 1 on any violation. Every violation prints the row id.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.exit("PyYAML is required: python3 -m pip install -r requirements.txt")

SETTLED_STATUSES = {"SOURCE_REMOVED", "DROPPED"}
PORTED_STATUSES = {"TARGET_GREEN", "SOURCE_REMOVED"}
PORTING_VERDICTS = {"MIGRATE", "RESHAPE"}
REQUIRED_BY_VERDICT = {
    "OBSOLETE": "covered_by",
    "DEFER": "blocked_by",
    "REVIEW": "recommended_action",
}


def load_jsonl(path: Path) -> list[dict]:
    if not path.exists():
        return []
    with path.open() as handle:
        return [json.loads(line) for line in handle if line.strip()]


def selects(row: dict, criteria: dict) -> bool:
    return all(row.get(field) == value for field, value in criteria.items())


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dir", default=".")
    args = parser.parse_args()

    base = Path(args.dir).resolve()
    config = yaml.safe_load((base / "matrices.yaml").read_text())
    inventory = load_jsonl(base / config["inventory"])
    failures: list[str] = []
    warnings: list[str] = []

    for script in ("build.py", "render.py"):
        result = subprocess.run(
            [sys.executable, str(base / script), "--dir", str(base), "--check"],
            capture_output=True, text=True,
        )
        if result.returncode != 0:
            failures.append(f"G1 stale output: {result.stderr.strip() or script}")

    for matrix in config["matrices"]:
        name = matrix["name"]
        rows = load_jsonl(base / f"{name}.jsonl")
        row_ids = {row["id"] for row in rows}
        if len(row_ids) != len(rows):
            failures.append(f"G1 {name}: duplicate row ids")

        expected = {
            row["id"] for row in inventory
            if selects(row, matrix.get("select") or {}) and not row.get("dup_of")
        }
        for missing in sorted(expected - row_ids):
            failures.append(f"G1 {name}: inventory scenario absent from the matrix — {missing}")
        for extra in sorted(row_ids - expected):
            failures.append(f"G1 {name}: matrix row not in the inventory — {extra}")

        for row in rows:
            row_id = row["id"]
            if row["domain"] == "UNMAPPED":
                failures.append(f"G1 {row_id}: domain '{row['native_domain']}' not in domains.yaml")
            if row["source_state"] == "GONE" and row["status"] not in SETTLED_STATUSES:
                # A deleted source is only safe once something covers it. Which of the three
                # things went wrong decides whether this blocks the merge or just isn't finished.
                if row.get("verdict") not in PORTING_VERDICTS:
                    failures.append(
                        f"G1 {row_id}: source deleted while the verdict is still "
                        f"{row['verdict']} — settle the verdict before deleting"
                    )
                elif row["target_state"] in ("MISSING", "UNKNOWN"):
                    failures.append(
                        f"G1 {row_id}: source deleted but no target is recorded — that coverage "
                        "is gone. Port it, or change the verdict to DROP/OBSOLETE with a reason"
                    )
                elif row["target_state"] == "SKIPPED":
                    failures.append(
                        f"G4 {row_id}: source deleted but the target test is skipped — "
                        "nothing runs this scenario in any variant"
                    )
                else:
                    warnings.append(
                        f"{row_id}: ported, awaiting a verified CI run before it counts as done"
                    )
            if row.get("verified_run") and row["target_state"] != "PRESENT":
                failures.append(
                    f"G3 {row_id}: verified_run recorded but target_state is {row['target_state']}"
                )
            if row["target_state"] == "SKIPPED" and row["status"] in PORTED_STATUSES:
                failures.append(f"G4 {row_id}: target test is skipped, it cannot count as ported")
            required = REQUIRED_BY_VERDICT.get(row.get("verdict"))
            if required and not row.get(required):
                failures.append(f"D  {row_id}: verdict {row['verdict']} requires `{required}`")
            if row.get("verdict") in ("MIGRATE", "RESHAPE") and row["status"] != "TODO" \
                    and not row.get("target_path"):
                failures.append(f"D  {row_id}: {row['status']} without a target_path")

    if warnings:
        print(f"{len(warnings)} row(s) ported but not yet verified by a CI run:")
        for warning in warnings:
            print(f"  {warning}")
    if failures:
        print(f"{len(failures)} violation(s):\n  " + "\n  ".join(failures), file=sys.stderr)
        return 1
    print("gates clean")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
