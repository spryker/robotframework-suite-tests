### merchandising · robot-ui-to-cypress · CC-39280 · 6 scenarios

MIGRATE 5 · OBSOLETE 1   ▸ 5/5 verified

Batches: `merchandising`

Target PR: https://github.com/spryker/cypress-tests/pull/400

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [x] | CRUD_Product_Set | ×3 | CRUD operations for product sets. DMS-ON: https://spryker.atlassian.net/browse/FRW-7393. _(yves)_ | `cypress/e2e/backoffice/merchandising/product-set-management.cy.ts::given three products when a product set is created for them in the back office then the storefront serves the set and its whole content reaches the cart, and deleting the set retires the page` | L | `local 2026-08-25 · 1 passing · 34s` |
| [x] | Configurable_Bundle | ×3 | Check the usage of configurable bundles (includes authorized checkout). _(yves)_ | `cypress/e2e/yves/product-bundle/configurable-bundle-checkout.cy.ts::given two configurations of one bundle template when one of them is doubled in the cart and the order is placed then the order carries three bundles` | L | `local 2026-08-25 · 1 passing · 30s` |
| [x] | Product_Relations | ×5 | Checks related product on PDP and upsell products in cart. _(yves)_ | `cypress/e2e/yves/merchandising/product-relations.cy.ts::given one product carries a related-products relation and another carries none when both detail pages are opened then only the first shows the related products carousel` | M | `local 2026-08-25 · 1 passing · 18s` |
| [x] | Product_Sets | ×3 | Check the usage of product sets. _(yves)_ | `cypress/e2e/yves/merchandising/product-sets.cy.ts::given a product set holding a variant product and a simple one when the set is opened from the overview and the variant is picked then the whole set reaches the cart with the picked variant` | M | `local 2026-08-25 · 1 passing · 31s` |
| [x] | Product_labels | ×5 | Checks that products have labels on PLP and PDP. _(yves)_ | `cypress/e2e/yves/merchandising/product-labels.cy.ts::given a published label is assigned to a product when the catalog listing and the detail page are opened then both render the label` | M | `local 2026-08-25 · 1 passing · 13s` |

#### OBSOLETE / DROP — delete the source, do not port
| ✓ | Scenario | Reason | Covered by |
|---|---|---|---|
| [ ] | Discounts | Duplicate journey — retired by the port of platform/Discounts; delete it in that sibling's batch, it needs no port of its own. | robot:tests/parallel_ui/suite/misc/static_demodata_set.robot::Discounts |
