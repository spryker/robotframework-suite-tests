### platform · robot-ui-to-cypress · CC-39280 · 6 scenarios

MIGRATE 2 · RESHAPE 1 · OBSOLETE 1 · DEFER 2   ▸ 0/3 verified

Batches: `platform`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Discounts | ×5 | Discounts, Promo Products, and Coupon Codes (includes guest checkout). _(yves)_ | `cypress/e2e/yves/discount/discounts-and-promotions.cy.ts` | L | — |
| [ ] | Fulfillment_app_e2e | ×3 | Fulfillment app e2e _(yves)_ | `cypress/e2e/backoffice/warehouse/warehouse-user-assignment.cy.ts` | L | — |
| [ ] | Minimum_Order_Value | ×5 | checks that global minimum and maximum order thresholds can be applied. _(yves)_ | `cypress/e2e/yves/checkout/minimum-order-value.cy.ts` | L | — |

#### OBSOLETE / DROP — delete the source, do not port
| ✓ | Scenario | Reason | Covered by |
|---|---|---|---|
| [ ] | Click_and_collect | Duplicate journey — retired by the port of checkout/Click_and_collect; delete it in that sibling's batch, it needs no port of its own. | robot:tests/ui/suite/checkout/checkout.robot::Click_and_collect |

#### DEFER — parked, not counted as migrated
| Scenario | Placeholder | Blocked by |
|---|---|---|
| Data_exchange_API_Configuration_in_Zed | `cypress/e2e/backoffice/data-exchange/dynamic-entity-configuration.cy.ts` | Needs the Zed console command glue api:generate:documentation to run in the middle of the test, three times. cypress-tests registers only an isFileExists task, and in CI the Cypress runner has no route into the application container, so there is nothing to run it with. The API half also belongs in a Glue suite rather than a browser test. |
| Data_exchange_API_download_specification | `cypress/e2e/backoffice/data-exchange/api-specification-download.cy.ts` | Needs the Zed console command glue api:generate:documentation to run in the middle of the test, three times. cypress-tests registers only an isFileExists task, and in CI the Cypress runner has no route into the application container, so there is nothing to run it with. |
