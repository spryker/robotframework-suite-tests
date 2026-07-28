#!/usr/bin/env python3
"""Observe reality and write it back as scan.jsonl, which build.py folds into `status`.

Nobody ticks a checkbox. A row is done because the target test exists and is not skipped,
and the source test is gone.

Reads   tests.jsonl, decisions.jsonl, matrices.yaml, this repo's working tree, target checkouts
Writes  scan.jsonl  (id, source_state, target_state)

Deliberately reads the inventory rather than the generated matrices, so it works on a cold
checkout before build.py has ever run.

Usage:
    python3 scan.py --source-root ../.. --target spryker/suite=~/www/suite \
                    --target spryker/cypress-tests=~/www/cypress-tests

A target repo you do not pass is reported as UNKNOWN, never as MISSING -- an absent checkout
must not look like an absent test.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.exit("PyYAML is required: python3 -m pip install -r requirements.txt")

SUITE_SKIP = re.compile(r"^\s*(describe|context)\.skip\s*\(", re.MULTILINE)
PHP_NEXT_DECL = re.compile(r"\n    (?:public |protected |private )?function ")
ROBOT_NEXT_DECL = re.compile(r"\n(?=\S)")
ROBOT_SKIP = re.compile(
    r"^\s*(\[Tags\][^\n]*\bskip\b|Skip(\s+If)?\b)", re.IGNORECASE | re.MULTILINE
)


def load_jsonl(path: Path) -> list[dict]:
    if not path.exists():
        return []
    with path.open() as handle:
        return [json.loads(line) for line in handle if line.strip()]


def read(path: Path) -> str | None:
    try:
        return path.read_text(errors="replace")
    except OSError:
        return None


def find_test(text: str, name: str) -> bool | None:
    """Is `name` present in `text`, and is it skipped? None when the test is absent.

    Skip is decided at the declaration and inside that test's own body only. Scanning a fixed
    window instead would pick up a neighbouring `it.skip` and report a live test as skipped.
    """
    if not name:
        return False
    escaped = re.escape(name)

    # Cypress / Jest. The callee is captured rather than enumerated: this repo declares tests
    # through gating helpers such as `skipB2BIt(...)`, which are run-conditionally, not skipped.
    match = re.search(rf"\b([A-Za-z_$][\w$]*)((?:\.skip)?)\s*\(\s*['\"`]{escaped}['\"`]", text)
    if match:
        callee, suffix = match.group(1), match.group(2)
        return bool(suffix) or callee == "xit" or bool(SUITE_SKIP.search(text))

    # Codeception: @skip in the docblock above, or markTestSkipped in the body.
    match = re.search(rf"\n\s*(?:public |protected |private )?function\s+{escaped}\s*\(", text)
    if match:
        tail = text[match.end():]
        boundary = PHP_NEXT_DECL.search(tail)
        body = tail[: boundary.start()] if boundary else tail
        docblock = text[max(0, match.start() - 400) : match.start()]
        return "markTestSkipped" in body or "@skip" in docblock

    # Robot: a test-case heading starts at column zero; its body is indented.
    match = re.search(rf"^{escaped}[ \t]*$", text, re.MULTILINE)
    if match:
        tail = text[match.end():]
        boundary = ROBOT_NEXT_DECL.search(tail)
        body = tail[: boundary.start()] if boundary else tail
        return bool(ROBOT_SKIP.search(body))

    return None


def scan_source(root: Path, row: dict) -> str:
    path = row.get("source_path")
    if not path:
        return "UNKNOWN"
    text = read(root / path)
    if text is None:
        return "GONE"
    skipped = find_test(text, row.get("name"))
    if skipped is None:
        return "GONE"
    return "SKIPPED" if skipped else "ACTIVE"


def scan_target(roots: dict[str, Path], row: dict) -> str:
    repo = row.get("target_repo")
    path = row.get("target_path")
    if not path:
        return "UNKNOWN"
    root = roots.get(repo)
    if root is None:
        return "UNKNOWN"
    text = read(root / path)
    if text is None:
        return "MISSING"
    skipped = find_test(text, row.get("target_test"))
    if skipped is None:
        return "MISSING"
    return "SKIPPED" if skipped else "PRESENT"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dir", default=".")
    parser.add_argument("--source-root", default="../..", help="root of THIS repo")
    parser.add_argument(
        "--target", action="append", default=[],
        help="repeatable, <org/repo>=<path to a checkout>",
    )
    args = parser.parse_args()

    base = Path(args.dir).resolve()
    source_root = (base / args.source_root).resolve()
    config = yaml.safe_load((base / "matrices.yaml").read_text())

    target_roots: dict[str, Path] = {}
    for pair in args.target:
        repo, _, path = pair.partition("=")
        resolved = Path(path).expanduser().resolve()
        if not resolved.is_dir():
            sys.exit(f"--target {repo}: {resolved} is not a directory")
        target_roots[repo] = resolved

    declared = {matrix.get("target_repo") for matrix in config["matrices"]}
    for repo in sorted(declared - set(target_roots)):
        print(f"note: no checkout passed for {repo}, its rows stay UNKNOWN", file=sys.stderr)

    inventory = load_jsonl(base / config["inventory"])
    decisions = {row["id"]: row for row in load_jsonl(base / "decisions.jsonl")}
    default_target = {
        matrix["name"]: matrix.get("target_repo") for matrix in config["matrices"]
    }
    fallback_repo = next(iter(default_target.values()), None)

    observed = []
    for row in inventory:
        if row.get("dup_of"):
            continue
        decision = decisions.get(row["id"], {})
        target = {
            "target_repo": decision.get("target_repo", fallback_repo),
            "target_path": decision.get("target_path"),
            "target_test": decision.get("target_test"),
        }
        observed.append(
            {
                "id": row["id"],
                "source_state": scan_source(source_root, {"source_path": row.get("file"),
                                                          "name": row.get("name")}),
                "target_state": scan_target(target_roots, target),
            }
        )

    with (base / "scan.jsonl").open("w") as handle:
        for entry in sorted(observed, key=lambda item: item["id"]):
            handle.write(json.dumps(entry, sort_keys=True) + "\n")

    print(f"scanned {len(observed)} scenarios -> scan.jsonl (now re-run build.py && render.py)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
