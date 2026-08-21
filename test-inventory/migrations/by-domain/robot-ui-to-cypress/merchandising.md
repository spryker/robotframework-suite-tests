### merchandising · robot-ui-to-cypress · CC-39280 · 6 scenarios

MIGRATE 5 · OBSOLETE 1   ▸ 0/5 verified

Batches: `merchandising`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | CRUD_Product_Set | ×3 | CRUD operations for product sets. DMS-ON: https://spryker.atlassian.net/browse/FRW-7393. _(yves)_ | `cypress/e2e/backoffice/merchandising/product-set-management.cy.ts` | L | — |
| [ ] | Configurable_Bundle | ×3 | Check the usage of configurable bundles (includes authorized checkout). _(yves)_ | `cypress/e2e/yves/product-bundle/configurable-bundle-checkout.cy.ts` | L | — |
| [ ] | Product_Relations | ×5 | Checks related product on PDP and upsell products in cart. _(yves)_ | `cypress/e2e/yves/merchandising/product-relations.cy.ts` | M | — |
| [ ] | Product_Sets | ×3 | Check the usage of product sets. _(yves)_ | `cypress/e2e/yves/merchandising/product-sets.cy.ts` | M | — |
| [ ] | Product_labels | ×5 | Checks that products have labels on PLP and PDP. _(yves)_ | `cypress/e2e/yves/merchandising/product-labels.cy.ts` | M | — |

#### OBSOLETE / DROP — delete the source, do not port
| ✓ | Scenario | Reason | Covered by |
|---|---|---|---|
| [ ] | Discounts | Duplicate journey — retired by the port of platform/Discounts; delete it in that sibling's batch, it needs no port of its own. | robot:tests/parallel_ui/suite/misc/static_demodata_set.robot::Discounts |
