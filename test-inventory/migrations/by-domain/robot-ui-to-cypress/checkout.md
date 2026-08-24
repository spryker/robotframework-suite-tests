### checkout · robot-ui-to-cypress · CC-39280 · 16 scenarios

MIGRATE 13 · OBSOLETE 3   ▸ 12/13 verified

Batches: `checkout`

Target PR: https://github.com/spryker/cypress-tests/pull/392

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [x] | Unique_URL | ×3 | Bug: https://spryker.atlassian.net/browse/CC-12380. _(yves)_ | `cypress/e2e/yves/cart/shared-cart-external-link.cy.ts::given a cart shared by external link when an anonymous visitor opens it then the cart is shown as a read-only preview` | M | `local 2026-08-24 · 1 passing · 9s` |
| [x] | Approval_Process | ×2 | Checks role permissions on checkout and Approval process. _(yves)_ | `cypress/e2e/yves/checkout/cart-approval-process.cy.ts::given a cart above the buyer spend limit when the approver approves the request then the buyer can place the order` | L | `local 2026-08-24 · 1 passing · 23s` |
| [x] | Business_Unit_Address_on_Checkout | ×3 | Checks that business unit address can be used during checkout. _(yves)_ | `cypress/e2e/yves/company-account/business-unit-address-checkout.cy.ts::given a company user with no personal address when the business unit address is chosen at checkout then the order ships to it` | L | `local 2026-08-24 · 1 passing · 16s` |
| [x] | Checkout_Address_Management | ×5 | Bug: CC-30439. Checks that user can change address during the checkout and save new into the address book. _(yves)_ | `cypress/e2e/yves/checkout/checkout-address-management.cy.ts::given a separate billing address when the customer returns to the address step and changes both addresses then the order takes the changed ones and only the address marked for saving is added to the address book` | L | `local 2026-08-24 · 1 passing · 28s` |
| [ ] | Click_and_collect | ×2 | checks that product offer is successfully replaced with a target product offer. _(yves)_ | `cypress/e2e/yves/checkout/click-and-collect.cy.ts` | L | — |
| [x] | Comments_in_Cart | ×3 | Add comments to cart and verify comments in Yves and Zed. _(yves)_ | `cypress/e2e/yves/comments/cart-comments.cy.ts::should keep a cart comment on the order details page after checkout` | L | `local 2026-08-24 · 7 passing · 48s` |
| [x] | Guest_Checkout | ×2 | Guest checkout with bundles, discounts and OMS. _(yves)_ | `cypress/e2e/yves/discount/discounts-and-promotions.cy.ts::given a guest cart holding a product bundle when a voucher and a cart rule both collect then both discounts apply and the guest order is placed` | L | `local 2026-08-24 · 2 passing · 41s` |
| [x] | Guest_Checkout_Addresses | ×2 | Guest checkout with different addresses and OMS. _(yves)_ | `cypress/e2e/yves/checkout/split-delivery.cy.ts::guest should checkout with a distinct delivery address per item` | L | `local 2026-08-24 · 2 passing · 1m06s` |
| [x] | Login_during_checkout | ×2 | Login during checkout _(yves)_ | `cypress/e2e/yves/checkout/checkout-authentication.cy.ts::given a guest cart when the customer logs in at the checkout customer step then the order is placed on that account` | L | `local 2026-08-24 · 2 passing · 28s` |
| [x] | Multiple_Merchants_Order | ×3 | Checks that order with products and offers of multiple merchants could be placed and it will be split per merchant. _(yves)_ | `cypress/e2e/yves/checkout/multi-merchant-order.cy.ts::given a cart holding the main merchant product and an offer from each of two merchants when the order is placed then it is split into one shipment per merchant` | L | `local 2026-08-24 · 1 passing · 27s` |
| [x] | Register_during_checkout | ×2 | Guest user email should be whitelisted from the AWS side before running the test. _(yves)_ | `cypress/e2e/yves/checkout/checkout-authentication.cy.ts::given a guest cart when the customer registers at the checkout customer step then the account is created and the order is placed on it` | L | `local 2026-08-24 · 2 passing · 28s` |
| [x] | Request_for_Quote | ×3 | Checks user can request and receive quote. _(yves)_ | `cypress/e2e/yves/quote-request/quote-request-lifecycle.cy.ts::given a quote request sent to an agent when the agent revises the item price then the customer converts it to a cart and orders at the revised price` | L | `local 2026-08-24 · 1 passing · 25s` |
| [x] | Split_Delivery | ×5 | Checks split delivery in checkout. _(yves)_ | `cypress/e2e/yves/checkout/split-delivery.cy.ts::should create one shipment per delivery address when the cart is split` | L | [run](https://github.com/spryker/suite/actions/runs/32571880620) |

#### OBSOLETE / DROP — delete the source, do not port
| ✓ | Scenario | Reason | Covered by |
|---|---|---|---|
| [ ] | Guest_Checkout_and_Addresses | Duplicate journey — retired by the port of checkout/Guest_Checkout_Addresses; delete it in that sibling's batch, it needs no port of its own. Also folds into checkout/Guest_Checkout; both siblings together cover this journey. | robot:tests/ui/suite/checkout/checkout.robot::Guest_Checkout_Addresses |
| [ ] | Comment_Management_in_the_Cart | Add, edit and delete a cart comment with a visibility assertion after each step — identical to the Cypress cart-comment edit and remove tests; the highest-scoring pair in the duplication report. | spryker/cypress-tests:cypress/e2e/yves/comments/cart-comments.cy.ts |
| [ ] | Configurable_Product_Checkout | Duplicate journey — retired by the port of product/Configurable_Product_Checkout; delete it in that sibling's batch, it needs no port of its own. | robot:tests/parallel_ui/suite/catalog/catalog_configurable_product.robot::Configurable_Product_Checkout |
