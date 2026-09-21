### platform · robot-ui-to-cypress · 6 scenarios

MIGRATE 3 · RESHAPE 2 · OBSOLETE 1   ▸ 0/5 verified

Batches: `platform`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Discounts | ×5 | Discounts, Promo Products, and Coupon Codes (includes guest checkout). _(yves)_ | `cypress/e2e/yves/discount/discounts-and-promotions.cy.ts` | L | — |
| [ ] | Fulfillment_app_e2e | ×3 | Fulfillment app e2e _(yves)_ | `cypress/e2e/backoffice/warehouse/warehouse-user-assignment.cy.ts` | L | — |
| [ ] | Minimum_Order_Value | ×5 | checks that global minimum and maximum order thresholds can be applied. _(yves)_ | `cypress/e2e/yves/checkout/minimum-order-value.cy.ts` | L | — |
| [ ] | Data_exchange_API_Configuration_in_Zed | ×5 | DMS-ON: https://spryker.atlassian.net/browse/FRW-7396. _(backoffice)_ | `cypress/e2e/backoffice/data-exchange/dynamic-entity-configuration.cy.ts` | L | — |
| [ ] | Data_exchange_API_download_specification | ×5 | DMS-ON: https://spryker.atlassian.net/browse/FRW-7396. _(backoffice)_ | `cypress/e2e/backoffice/data-exchange/api-specification-download.cy.ts` | M | — |

#### OBSOLETE / DROP — delete the source, do not port
| ✓ | Scenario | Reason | Covered by |
|---|---|---|---|
| [ ] | Click_and_collect | Duplicate journey — retired by the port of checkout/Click_and_collect; delete it in that sibling's batch, it needs no port of its own. | robot:tests/ui/suite/checkout/checkout.robot::Click_and_collect |
