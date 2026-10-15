### platform · robot-ui-to-cypress · CC-39280 · 6 scenarios

MIGRATE 2 · RESHAPE 1 · OBSOLETE 2 · DROP 1   ▸ 3/3 verified

Batches: `platform`

Target PR: https://github.com/spryker/cypress-tests/pull/396

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [x] | Discounts | ×5 | Discounts, Promo Products, and Coupon Codes (includes guest checkout). _(yves)_ | `cypress/e2e/yves/discount/discounts-and-promotions.cy.ts::given a cart rule, a voucher and a promotional product discount when both codes are redeemed and the promotional product is added then all three are applied and the order is placed` | L | `local 2026-08-24 · 1 passing · 31s` |
| [x] | Data_exchange_API_Configuration_in_Zed | ×5 | DMS-ON: https://spryker.atlassian.net/browse/FRW-7396. _(backoffice)_ | `cypress/e2e/backoffice/data-exchange/dynamic-entity-configuration.cy.ts::given a data exchange api configuration for a table when its resource name and fields are configured and saved then the reloaded form renders back what was saved` | L | `local 2026-08-24 · 1 passing · 22s` |
| [x] | Data_exchange_API_download_specification | ×5 | DMS-ON: https://spryker.atlassian.net/browse/FRW-7396. _(backoffice)_ | `cypress/e2e/backoffice/data-exchange/api-specification-download.cy.ts::given a table exposed under a resource name the specification does not know when its data exchange api configuration is enabled and the specification is regenerated then the downloaded specification gains the resource` | M | `local 2026-08-24 · 1 passing · 44s` |

#### OBSOLETE / DROP — delete the source, do not port
| ✓ | Scenario | Reason | Covered by |
|---|---|---|---|
| [ ] | Click_and_collect | Duplicate journey — retired by the port of checkout/Click_and_collect; delete it in that sibling's batch, it needs no port of its own. | robot:tests/ui/suite/checkout/checkout.robot::Click_and_collect |
| [ ] | Fulfillment_app_e2e | Duplicate journey — retired by the port of fulfillment_app/Fulfillment_app_e2e; delete it in that sibling's batch, it needs no port of its own. Same warehouse-user checkbox, same BAPI warehouse assignment, same Glue order, same back-office OMS walk to ready for picking, same variants; only the SKUs differ. The sibling's port walks Pay and Skip timeout through the UI rather than updating the database, so it covers this variant's browser half in full. | robot:tests/ui/b2c/fulfillment_app/fultillment_app.robot::Fulfillment_app_e2e |
| [ ] | Minimum_Order_Value | Dropped in code review of the Cypress port: the global thresholds it changes need a cleanup and kept the test quarantined, so it was removed rather than carried as a test that never runs. | — |
