#!/usr/bin/env python3
"""G2 -- refuse a pull request that adds a Robot test case.

Both matrices in this repository retire Robot tests, so every new one makes the
migration longer. G2 is the only gate that needs a view of the diff, which is why it
lives here rather than in `gate.py`: it compares the test-case names in each changed
`.robot` file against the same file at the merge base and fails on any name that is new.

A pull request that genuinely needs a new Robot test carries the
`allow-new-source-test` label; the workflow checks the label and never calls this script
when it is present.

Usage:  gate_no_new_source_tests.py --base <ref> --head <ref> [--repo-root <path>]
Exit 0 clean, 1 when a test case was added. Every added test prints as `<path>::<name>`.
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

SECTION_RE = re.compile(r"^\*\*\*\s*(.+?)\s*\*\*\*")
CELL_SPLIT_RE = re.compile(r"\t|[ ]{2,}")


def git(repo_root: Path, *args: str) -> str:
    result = subprocess.run(
        ["git", "-C", str(repo_root), *args],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        sys.exit(f"git {' '.join(args)} failed: {result.stderr.strip()}")
    return result.stdout


def test_case_names(text: str) -> set[str]:
    """Every test-case heading in a Robot file.

    A heading is a non-blank line at column zero inside `*** Test Cases ***` that is not
    a `...` continuation. This is the rule `extract.py` uses, so the gate and the
    inventory agree on what counts as a test.
    """
    names: set[str] = set()
    section = None
    for line in text.splitlines():
        match = SECTION_RE.match(line)
        if match:
            section = match.group(1).lower()
            continue
        if section != "test cases":
            continue
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if line[:1] in (" ", "\t") or line.startswith("..."):
            continue
        names.add(CELL_SPLIT_RE.split(line.strip())[0])
    return names


def file_at(repo_root: Path, ref: str, path: str) -> str:
    """The file's content at a revision, or empty when it did not exist there."""
    result = subprocess.run(
        ["git", "-C", str(repo_root), "show", f"{ref}:{path}"],
        capture_output=True,
        text=True,
    )
    return result.stdout if result.returncode == 0 else ""


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--base", required=True, help="the pull request's base revision")
    parser.add_argument("--head", required=True, help="the pull request's head revision")
    parser.add_argument("--repo-root", default=".", type=Path)
    args = parser.parse_args()

    repo_root = args.repo_root.resolve()
    merge_base = git(repo_root, "merge-base", args.base, args.head).strip()

    changed = [
        line
        for line in git(
            repo_root, "diff", "--name-only", "--diff-filter=AM", merge_base, args.head, "--", "*.robot"
        ).splitlines()
        if line.strip()
    ]

    added: list[str] = []
    for path in changed:
        before = test_case_names(file_at(repo_root, merge_base, path))
        after = test_case_names(file_at(repo_root, args.head, path))
        added.extend(f"{path}::{name}" for name in sorted(after - before))

    if not added:
        print(f"G2 clean: {len(changed)} changed Robot file(s) add no test case.")
        return 0

    print(
        f"G2: this pull request adds {len(added)} Robot test case(s). Both matrices are "
        f"retiring Robot tests, so a new one has to be justified.\n"
        f"Write the test in the target framework instead -- Cypress for UI, Codeception "
        f"for API -- or add the `allow-new-source-test` label to say this one belongs here.",
        file=sys.stderr,
    )
    for entry in added:
        print(f"  {entry}", file=sys.stderr)
    return 1


if __name__ == "__main__":
    sys.exit(main())
