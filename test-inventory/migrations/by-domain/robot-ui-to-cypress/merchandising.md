### merchandising · robot-ui-to-cypress · 6 scenarios

MIGRATE 5 · REVIEW 1   ▸ 0/5 ported

Batches: `merchandising`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | CRUD_Product_Set | ×3 | CRUD operations for product sets. DMS-ON: https://spryker.atlassian.net/browse/FRW-7393. _(yves)_ | `cypress/e2e/backoffice/merchandising/product-set-management.cy.ts` | L | — |
| [ ] | Configurable_Bundle | ×3 | Check the usage of configurable bundles (includes authorized checkout). _(yves)_ | `cypress/e2e/yves/product-bundle/configurable-bundle-checkout.cy.ts` | L | — |
| [ ] | Product_Relations | ×5 | Checks related product on PDP and upsell products in cart. _(yves)_ | `cypress/e2e/yves/merchandising/product-relations.cy.ts` | M | — |
| [ ] | Product_Sets | ×3 | Check the usage of product sets. _(yves)_ | `cypress/e2e/yves/merchandising/product-sets.cy.ts` | M | — |
| [ ] | Product_labels | ×5 | Checks that products have labels on PLP and PDP. _(yves)_ | `cypress/e2e/yves/merchandising/product-labels.cy.ts` | M | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Discounts | merge into cypress/e2e/yves/discount/discounts-and-promotions.cy.ts | Same journey as parallel_ui/suite/misc/static_demodata_set.robot::Discounts (voucher, cart rule, promotional product, exact discount amounts, checkout grand total); that variant uses dynamic fixtures and DB-level discount deactivation and is the better port source. |
