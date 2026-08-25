# Cross-framework duplication (Robot ↔ Cypress)

Each Cypress UI test scored against every Robot UI scenario (variant clones excluded) by IDF-weighted shared canonical-helper overlap (rare shared helpers dominate) plus name-token overlap. A match at score ≥ 0.30 means the Cypress test likely already covers a Robot scenario — i.e. that Robot test may be redundant or is the migration source.

Full detail: `cross-framework-duplication.jsonl` (top 3 Robot matches per Cypress test).

## Cypress UI tests with a likely Robot counterpart, by domain

| coarse domain | cypress UI tests | with ≥1 Robot match |
|---|---|---|
| marketplace | 84 | 3 |
| ssp | 76 | 1 |
| product | 39 | 1 |
| order | 34 | 1 |
| company | 18 | 3 |
| admin | 17 | 0 |
| auth | 16 | 0 |
| checkout | 16 | 0 |
| catalog | 10 | 0 |
| customer | 9 | 2 |
| other | 9 | 0 |
| content | 8 | 6 |
| cart | 4 | 2 |
| navigation | 3 | 0 |

**Total:** 19 of 343 Cypress UI tests have at least one likely Robot counterpart at score ≥ 0.30.

## Strongest matches (score ≥ 0.55)

- **0.58** · Cypress `customer should be able to modify comment in cart with items`  ↔  Robot `Comment_Management_in_the_Cart`  (shared: edit_cart_comment, add_cart_comment, assert_cart_comments_visible)
- **0.58** · Cypress `customer should be able to remove comment in cart with items`  ↔  Robot `Comment_Management_in_the_Cart`  (shared: delete_cart_comment, add_cart_comment, assert_cart_comments_visible)
- **0.58** · Cypress `customer should be able to modify comment in empty cart`  ↔  Robot `Comment_Management_in_the_Cart`  (shared: edit_cart_comment, add_cart_comment, assert_cart_comments_visible)
- **0.58** · Cypress `customer should be able to remove comment in empty cart`  ↔  Robot `Comment_Management_in_the_Cart`  (shared: delete_cart_comment, add_cart_comment, assert_cart_comments_visible)

## Limitations

- **Composite vs granular helpers suppress real matches.** Cypress wraps flows in one scenario call (`CheckoutScenario.execute` → a single canonical), while Robot spells out ~15 granular steps. Low helper overlap then hides genuine duplication — checkout shows 0 strong matches here even though the domain-count view is **384 Robot vs 16 Cypress** checkout tests. Treat this list as a *floor*, not a complete dup set.
- Robot side compared at scenario-leader granularity (variant clones excluded); multiply by ~3 for raw Robot test count via `dup_of`.
- Threshold 0.30 is deliberately conservative to keep precision high. Lower it in the script to surface more (noisier) candidates.
