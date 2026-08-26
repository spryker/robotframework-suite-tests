### order · robot-ui-to-cypress · CC-39280 · 6 scenarios

MIGRATE 6   ▸ 6/6 verified

Batches: `order`

Target PR: https://github.com/spryker/cypress-tests/pull/402

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [x] | Configurable_Product_OMS | ×2 | Conf Product OMS check and reorder. _(yves)_ | `cypress/e2e/backoffice/order-management/configurable-product-oms.cy.ts::given a configured product ordered and shipped when the order is reordered then the configuration is on the order but not in the new cart` | L | `local 2026-08-25 · 1 passing · 36s` |
| [x] | Comment_Management_in_Order | ×3 | Add comments in Yves and check in Zed. _(yves)_ | `cypress/e2e/yves/comments/order-comments.cy.ts::given a placed order when the customer comments on it in the storefront then the comment is shown there and in the back office` | L | `local 2026-08-25 · 1 passing · 24s` |
| [x] | Manage_Shipments | ×5 | Checks create/edit shipment functions from backoffice. _(yves)_ | `cypress/e2e/backoffice/order-management/shipment-management.cy.ts::given an order delivered as one shipment when a second shipment is created and then edited then the item moves and the edited address is kept` | L | `local 2026-08-25 · 1 passing · 31s` |
| [x] | Order_Cancellation | ×5 | Check that customer is able to cancel order. _(yves)_ | `cypress/e2e/yves/order-management/order-cancellation.cy.ts::given every item of an order is cancellable when the customer cancels it then the order is cancelled` | L | `local 2026-08-25 · 2 passing · 36s` |
| [x] | Refunds | ×5 | Checks that refund can be created for one item and the whole order. _(yves)_ | `cypress/e2e/backoffice/order-management/order-refund.cy.ts::given a delivered order of three items when they are refunded one by one then each refund is recorded and the grand total reaches zero` | L | `local 2026-08-25 · 1 passing · 36s` |
| [x] | Return_Management | ×5 | Checks that returns work and oms process is checked. _(yves)_ | `cypress/e2e/yves/return-management/return-creation-storefront.cy.ts::given a shipped order of three items when the customer returns two of them then only those move to waiting for return` | L | `local 2026-08-25 · 1 passing · 1m33s` |
