### order · robot-ui-to-cypress · 6 scenarios

MIGRATE 6   ▸ 0/6 verified

Batches: `order`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Configurable_Product_OMS | ×2 | Conf Product OMS check and reorder. _(yves)_ | `cypress/e2e/backoffice/order-management/configurable-product-oms.cy.ts` | L | — |
| [ ] | Comment_Management_in_Order | ×3 | Add comments in Yves and check in Zed. _(yves)_ | `cypress/e2e/yves/comments/order-comments.cy.ts` | L | — |
| [ ] | Manage_Shipments | ×5 | Checks create/edit shipment functions from backoffice. _(yves)_ | `cypress/e2e/backoffice/order-management/shipment-management.cy.ts` | L | — |
| [ ] | Order_Cancellation | ×5 | Check that customer is able to cancel order. _(yves)_ | `cypress/e2e/yves/order-management/order-cancellation.cy.ts` | L | — |
| [ ] | Refunds | ×5 | Checks that refund can be created for one item and the whole order. _(yves)_ | `cypress/e2e/backoffice/order-management/order-refund.cy.ts` | L | — |
| [ ] | Return_Management | ×5 | Checks that returns work and oms process is checked. _(yves)_ | `cypress/e2e/yves/return-management/return-creation-storefront.cy.ts` | L | — |
