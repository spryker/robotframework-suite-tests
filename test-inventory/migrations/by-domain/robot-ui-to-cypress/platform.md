### platform · robot-ui-to-cypress · 6 scenarios

MIGRATE 3 · RESHAPE 2 · REVIEW 1   ▸ 0/5 ported

Batches: `platform`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Discounts | ×5 | Discounts, Promo Products, and Coupon Codes (includes guest checkout). _(yves)_ | `cypress/e2e/yves/discount/discounts-and-promotions.cy.ts` | L | — |
| [ ] | Fulfillment_app_e2e | ×3 | Fulfillment app e2e _(yves)_ | — | L | — |
| [ ] | Minimum_Order_Value | ×5 | checks that global minimum and maximum order thresholds can be applied. _(yves)_ | `cypress/e2e/yves/checkout/minimum-order-value.cy.ts` | L | — |
| [ ] | Data_exchange_API_Configuration_in_Zed | ×5 | DMS-ON: https://spryker.atlassian.net/browse/FRW-7396. _(backoffice)_ | — | L | — |
| [ ] | Data_exchange_API_download_specification | ×5 | DMS-ON: https://spryker.atlassian.net/browse/FRW-7396. _(backoffice)_ | `cypress/e2e/backoffice/data-exchange/api-specification-download.cy.ts` | M | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Click_and_collect | merge into cypress/e2e/yves/checkout/click-and-collect.cy.ts | Marketplace-B2C variant of tests/ui/suite/checkout/checkout.robot::Click_and_collect with dynamic fixtures; same three-offer service-point pickup journey. |
