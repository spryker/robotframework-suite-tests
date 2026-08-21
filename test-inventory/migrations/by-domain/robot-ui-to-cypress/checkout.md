### checkout · robot-ui-to-cypress · CC-39280 · 16 scenarios

MIGRATE 13 · OBSOLETE 3   ▸ 0/13 verified

Batches: `checkout`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Unique_URL | ×3 | Bug: https://spryker.atlassian.net/browse/CC-12380. _(yves)_ | `cypress/e2e/yves/cart/shared-cart-external-link.cy.ts` | M | — |
| [ ] | Approval_Process | ×2 | Checks role permissions on checkout and Approval process. _(yves)_ | `cypress/e2e/yves/checkout/cart-approval-process.cy.ts` | L | — |
| [ ] | Business_Unit_Address_on_Checkout | ×3 | Checks that business unit address can be used during checkout. _(yves)_ | `cypress/e2e/yves/company-account/business-unit-address-checkout.cy.ts` | L | — |
| [ ] | Checkout_Address_Management | ×5 | Bug: CC-30439. Checks that user can change address during the checkout and save new into the address book. _(yves)_ | `cypress/e2e/yves/checkout/checkout-address-management.cy.ts` | L | — |
| [ ] | Click_and_collect | ×2 | checks that product offer is successfully replaced with a target product offer. _(yves)_ | `cypress/e2e/yves/checkout/click-and-collect.cy.ts` | L | — |
| [ ] | Comments_in_Cart | ×3 | Add comments to cart and verify comments in Yves and Zed. _(yves)_ | `cypress/e2e/yves/comments/cart-comments.cy.ts::should keep a cart comment on the order details page after checkout` | L | — |
| [ ] | Guest_Checkout | ×2 | Guest checkout with bundles, discounts and OMS. _(yves)_ | `cypress/e2e/yves/discount/discounts-and-promotions.cy.ts` | L | — |
| [ ] | Guest_Checkout_Addresses | ×2 | Guest checkout with different addresses and OMS. _(yves)_ | `cypress/e2e/yves/checkout/basic-checkout.cy.ts::guest should checkout with a distinct delivery address per item` | L | — |
| [ ] | Login_during_checkout | ×2 | Login during checkout _(yves)_ | `cypress/e2e/yves/checkout/checkout-authentication.cy.ts` | L | — |
| [ ] | Multiple_Merchants_Order | ×3 | Checks that order with products and offers of multiple merchants could be placed and it will be split per merchant. _(yves)_ | `cypress/e2e/yves/checkout/multi-merchant-order.cy.ts` | L | — |
| [ ] | Register_during_checkout | ×2 | Guest user email should be whitelisted from the AWS side before running the test. _(yves)_ | `cypress/e2e/yves/checkout/checkout-authentication.cy.ts` | L | — |
| [ ] | Request_for_Quote | ×3 | Checks user can request and receive quote. _(yves)_ | `cypress/e2e/yves/quote-request/quote-request-lifecycle.cy.ts` | L | — |
| [ ] | Split_Delivery | ×5 | Checks split delivery in checkout. _(yves)_ | `cypress/e2e/yves/checkout/basic-checkout.cy.ts::should split an order into three shipments each with its own carrier` | L | — |

#### OBSOLETE / DROP — delete the source, do not port
| ✓ | Scenario | Reason | Covered by |
|---|---|---|---|
| [ ] | Guest_Checkout_and_Addresses | Duplicate journey — retired by the port of checkout/Guest_Checkout_Addresses; delete it in that sibling's batch, it needs no port of its own. Also folds into checkout/Guest_Checkout; both siblings together cover this journey. | robot:tests/ui/suite/checkout/checkout.robot::Guest_Checkout_Addresses |
| [ ] | Comment_Management_in_the_Cart | Add, edit and delete a cart comment with a visibility assertion after each step — identical to the Cypress cart-comment edit and remove tests; the highest-scoring pair in the duplication report. | spryker/cypress-tests:cypress/e2e/yves/comments/cart-comments.cy.ts |
| [ ] | Configurable_Product_Checkout | Duplicate journey — retired by the port of product/Configurable_Product_Checkout; delete it in that sibling's batch, it needs no port of its own. | robot:tests/parallel_ui/suite/catalog/catalog_configurable_product.robot::Configurable_Product_Checkout |
