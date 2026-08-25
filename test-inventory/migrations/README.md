# Robot test migration

Robot Framework is being retired. Its API tests move to Codeception Glue in `spryker/suite`; its
UI tests move to Cypress in `spryker/cypress-tests`. This directory tracks every scenario through
that move and fails CI when the tracking drifts from reality.

| Matrix | Target repo | Canonical scenarios | Checklists |
|---|---|--:|---|
| `robot-api-to-codeception` | `spryker/suite` | 1,721 | `by-domain/robot-api-to-codeception/*.md` |
| `robot-ui-to-cypress` | `spryker/cypress-tests` | 105 | `by-domain/robot-ui-to-cypress/*.md` |

Start at [PROGRESS.md](PROGRESS.md).

---

# How to execute a batch

A batch is one canonical domain, or one numbered slice of a domain when it exceeds 40 scenarios.
One batch = one Jira sub-task = one PR in the target repo + one PR in this repo.

### 1. Claim the batch

Pick a batch from `PROGRESS.md` where `ported` is 0 and `blocked` is 0. Create a sub-task under
CC-39273, assign it to yourself, then write its key into every row of that batch in
`decisions.jsonl`:

```json
{"id": "robot:tests/api/b2c/glue/carts/positive.robot::Add_item_to_cart", "jira": "CC-XXXXX"}
```

Regenerate and commit that alone as your claim. Two people cannot hold the same batch.

### 2. Resolve every `REVIEW` and `DEFER` row first

The batch cannot close while any row is held. For each `REVIEW` row, decide and rewrite the
verdict with `"decided_by": "human"` and a one-line `rationale`. For each `DEFER` row, either fix
the blocker or move the row to a later batch by changing its `batch` value — do not leave it
blocking.

### 3. Write the target tests

Read `by-domain/<matrix>/<domain>.md`. Port only `MIGRATE` and `RESHAPE` rows. The `Contract`
column is the specification: reproduce that HTTP method, path and expected status, or that UI
journey. The `Var` column tells you how many variant clones the row stands for — cover them with
one test plus a data provider, not with copies.

**API → Codeception Glue** (`spryker/suite`)

Lean suite per resource. `tests/PyzTest/Glue/AccessToken/` is the reference: one `codeception.yml`
enabling only `Asserts`, `Environment` and `GlueRest`, one `_support/<Domain>ApiTester.php`, and
Cests under `RestApi/`. Do not copy the heavyweight older suites that enable fifteen modules.

```
tests/PyzTest/Glue/<Domain>/
    codeception.yml
    _support/<Domain>ApiTester.php
    RestApi/<Resource>Cest.php
```

**UI → Cypress** (`spryker/cypress-tests`)

Specs live under `cypress/e2e/<surface>/<domain>/<journey>.cy.ts` where surface is `yves`,
`backoffice` or `mp`. A new page object needs four edits: a symbol in
`cypress/support/utils/inversify/types.ts`, an import plus one binding per repository block in
`inversify.config.ts`, an export in `cypress/support/pages/<surface>/index.ts`, and a fixture per
repository id. `cypress/support/pages/yves/customer/overview/` is the reference shape.

Specs are discovered automatically from the installed package — there is no manifest to register
in. Sharding is generated from recorded timings at runtime.

**Rules that apply to both**

- Test names are Given/When/Then. Body comments are Arrange/Act/Assert. Never the other way round.
- No Jira keys in test code, comments, config or CI files.
- Never port a *live* test as skipped. Gate G4 refuses to count a skipped target as coverage: if it
  cannot be made to pass, the row is `DEFER` with a `blocked_by`, not a skipped placeholder that
  looks like coverage.
- A source already disabled by `markTestSkipped`, `@skip` or `$scenario->skip()` — including one
  skipped from the test file's `_before()`, which disables every test in it — was running nowhere,
  so deleting it loses nothing. Park it as `DEFER`; see Verdicts.
- If the source Robot test is itself skipped or quarantined, do not port it — set `DROP` and say
  so in the `rationale`.

### 4. Verify in CI and record the run

```bash
# Codeception: narrow to the Cest's @group, which is its class name
gh workflow run ci-focused.yml --ref <your-suite-branch> \
    -f framework=codeception -f narrow=<CestClassName>

# Cypress: no narrow exists, the whole suite runs per dispatch.
# Author the entire batch first, then dispatch once.
gh workflow run ci-focused.yml --ref <your-suite-branch> -f framework=cypress
```

Put the green run's URL in `verified_run` for every row it covers, along with `target_path`,
`target_test` and `pr_target`. A row without a real run URL stays `AUTHORED`; gate G3 rejects a
`verified_run` whose target it cannot find.

### 5. Delete the Robot sources

In this repo, delete the source tests for every row in the batch — the `MIGRATE`/`RESHAPE` rows you
just proved green, and the `OBSOLETE`/`DROP` rows, which never needed a port. Set `pr_source`.

Deleting the source is what moves a row to `SOURCE_REMOVED`/`DROPPED`. A batch where the targets
are green but the Robot tests still run is not finished — it is duplicated coverage.

### 6. Regenerate, gate, open the PRs

```bash
python3 scan.py --target spryker/suite=~/www/suite \
                --target spryker/cypress-tests=~/www/cypress-tests
python3 build.py && python3 render.py && python3 gate.py
```

`gate.py` must print `gates clean`. Commit the regenerated files with your `decisions.jsonl` edit.

Open the target-repo PR and this repo's deletion PR. Title both `CC-XXXXX Sentence-case summary`.
Paste `by-domain/<matrix>/<domain>.md` into both PR bodies — that rendered checklist is the review
artifact. Open suite PRs as **drafts**; marking one ready triggers the full E2E suite.

### 7. Merge order

Target PR first, this repo's deletion PR second. Never delete a Robot test before its replacement
is merged and green.

---

## What is in here

| File | Owner | Edit it? |
|---|---|---|
| `domains.yaml` | humans | yes — the canonical domain list, identical in all three repos |
| `decisions.jsonl` | humans | **yes — this is the only data file you edit** |
| `matrices.yaml` | humans | rarely — declares which matrices this repo owns |
| `<matrix>.jsonl` | `build.py` | no — regenerated, your edits are lost |
| `by-domain/<matrix>/<domain>.md` | `render.py` | no — regenerated |
| `PROGRESS.md` | `render.py` | no — regenerated |
| `scan.jsonl` | `scan.py` | no — regenerated |

One row = one **canonical scenario**, not one test case. Robot variant clones (`b2c`, `b2b`,
`mp_b2c`, `mp_b2b`, `suite`) are collapsed into their leader; the `Var` column tells you how many
clones ride along. Porting the leader ports all of them.

## Verdicts

Set in `decisions.jsonl`. Every row needs one.

| Verdict | Meaning | Also required |
|---|---|---|
| `MIGRATE` | real gap — port it to the target framework | `target_path`, `target_test` once ported |
| `OBSOLETE` | the target already covers this journey — delete the source, do not port | `covered_by` |
| `DROP` | low value — delete without replacement | `rationale` |
| `RESHAPE` | wrong framework entirely — keep it here in a different shape | `target_path` |
| `REVIEW` | thin smoke or partial overlap — a human call, blocks the batch until resolved | `recommended_action` |
| `DEFER` | parked on purpose — blocked on infrastructure, or skipped in the source and not worth rebuilding yet | `blocked_by` |

A source test that was already `@skip`/`markTestSkipped`/`$scenario->skip()` upstream was running
nowhere, so deleting it loses no coverage. Park it: `DEFER` with
`blocked_by: "Skipped in source, rebuild when there is a need for."`, and keep the ported spec as
`it.skip` with the same sentence as a comment. The row shows up under `blocked`, never as migrated,
and `gate.py` accepts the deletion because the reason is recorded.

Also set `decided_by`: `auto` (matcher), `ai` (classifier), `human`. Only `auto` and `ai` rows are
recomputed — a `human` verdict is never overwritten.

## Status is observed, never typed

`status` is derived by `scan.py` from what is actually on disk. You do not tick checkboxes; you
change reality and re-run the pipeline.

| Status | Means |
|---|---|
| `TODO` | not started |
| `AUTHORED` | target test exists but is skipped, or has no recorded CI run |
| `TARGET_GREEN` | target exists, is not skipped, and `verified_run` names a green CI run |
| `SOURCE_REMOVED` | green **and** the source test is gone — the row is finished |
| `DROPPED` | source deleted under an `OBSOLETE`/`DROP` verdict — also finished |
| `REVIEW` / `BLOCKED` | held; not counted as outstanding work |

A test ported as `it.skip` / `markTestSkipped` can never reach `TARGET_GREEN`. That is gate G4 and
it is deliberate: a skipped port is not coverage.

## Regenerate

```bash
python3 -m pip install -r requirements.txt   # once, PyYAML only
python3 scan.py <scan args for this repo>    # observe reality  -> scan.jsonl
python3 build.py                             # inventory + decisions -> <matrix>.jsonl
python3 render.py                            # -> by-domain/**/*.md, PROGRESS.md
python3 gate.py                              # must print "gates clean" before you push
```

Always commit the regenerated files together with your `decisions.jsonl` edit. `gate.py` fails if
they are stale.

## Gates

| Gate | Fails when |
|---|---|
| G1 coverage | an inventory scenario has no matrix row, a row has no inventory scenario, a domain is not in `domains.yaml`, a source is gone while the row still says TODO, or a generated file is stale |
| G2 no new source tests | a PR adds a test in the framework we are migrating away from, without the `allow-new-source-test` label |
| G3 parity | `verified_run` is recorded but the target test is not present |
| G4 skip honesty | a skipped target test is counted as ported |

G2 lives in the CI workflow because it needs the PR diff. G1, G3, G4 are `gate.py`.
