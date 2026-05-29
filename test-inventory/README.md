# Robot test inventory (FRW-11703)

Machine- and human-readable inventory of every Robot Framework test, built to plan the
migration of Robot tests to Cypress (UI) or Codeception (API). The migration *decision*
is out of scope; this is the catalogue those decisions are made from.

## Deliverables
| File | What |
|------|------|
| `tests.jsonl` | One record per test case (**5,630** across 910 files). |
| `helpers.jsonl` | Canonical helper glossary (**494** reusable keywords). |
| `migration-helper-map.jsonl` | Cross-framework map: `canonical_name` → Robot keyword + Cypress fn (**104** shared with Cypress). |

## `tests.jsonl` schema (one JSON object per line)
| field | meaning |
|-------|---------|
| `id` | `robot:<relpath>::<TestCaseName>` |
| `framework` | `robot` |
| `file`, `name`, `suite`, `domain` | location + domain (from path) |
| `variant` | `b2c` \| `b2b` \| `mp_b2c` \| `mp_b2b` \| `suite` |
| `gating` | always `null` for Robot |
| `type` | `ui` \| `api` \| `other` |
| `subsystems` | which layers the test touches: `yves` \| `zed` \| `mp` \| `oms` \| `glue` \| `db` — **the migration-difficulty signal** |
| `auth` | `guest` \| `customer` \| `admin` \| `merchant` \| `none` |
| `purpose` | one line. From `[Documentation]` where present; otherwise synthesised (see flags) |
| `data` | short object (endpoint/method/status for API; products/payment for UI) |
| `mutation` | for negative tests: `{target, mode}` (`mode` ∈ empty/missing/invalid/duplicate/unauthorized/expired) |
| `helpers` | canonical helper names → join key into `helpers.jsonl` |
| `tags` | Robot tags, verbatim |
| `dup_of` | `id` of the canonical test this one clones (variant/parallel_ui copies), else `null` |
| `flags` | `synth-purpose` (purpose auto-generated, not curated), plus `obsolete?`/`flaky`/`over-broad`/`env-coupled` |

## How it was built (regenerable)
1. `extract.py <repo>` — parses every `.robot`, fills all structural fields deterministically → `skeleton.jsonl` + `helpers_raw.json`.
2. Canonical keyword map — `helpers_raw.json` bucketed (`_kwbuckets/`), each bucket mapped to canonical names by an AI pass (`_kwmap/`), merged by `merge_kwmap.py` → `keyword_map.json` + `helpers.jsonl`.
3. `enrich.py <repo>` — applies the map; computes `dup_of`, `data`, `mutation`; uses `[Documentation]` or synthesises `purpose` → `tests.jsonl`.

Re-run after a test change: `python3 extract.py <repo> && python3 enrich.py <repo>`.
(`extract.py`, `enrich.py`, `merge_kwmap.py`, `keyword_map.json` are the durable pipeline;
`skeleton.jsonl`, `helpers_raw.json`, `_kwbuckets/`, `_kwmap/` are regenerable intermediates.)

## Known limitations (v1)
- **87% of purposes are synthesised** (only 13% of tests carry `[Documentation]`). API purposes are derived from `method + endpoint + mutation + status` and are accurate; flagged `synth-purpose`.
- `dup_of` links variant/parallel_ui clones by `(domain, name, type)` exact match — 3,804 of 5,630 records are clones of 1,826 distinct scenarios.
- A handful of negative-test `mutation` targets are coarse (`request`) where the name didn't name the field.
- Cross-framework duplication is domain-name based; Robot/Cypress use different domain folder names, so the overlap view undercounts (e.g. Robot `general_product` vs Cypress `product`).
