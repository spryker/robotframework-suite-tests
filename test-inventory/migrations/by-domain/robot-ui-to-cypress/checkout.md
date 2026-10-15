### checkout · robot-ui-to-cypress · CC-39280 · 16 scenarios

MIGRATE 11 · OBSOLETE 3 · DROP 2   ▸ 11/11 verified

Batches: `checkout`

Target PR: https://github.com/spryker/cypress-tests/pull/397

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [x] | Unique_URL | ×3 | Bug: https://spryker.atlassian.net/browse/CC-12380. _(yves)_ | `cypress/e2e/yves/cart/shared-cart.cy.ts::given a cart shared by external link when an anonymous visitor opens it then the cart is shown as a read-only preview` | M | `local 2026-08-24 · 1 passing · 9s` |
| [x] | Approval_Process | ×2 | Checks role permissions on checkout and Approval process. _(yves)_ | `cypress/e2e/yves/checkout/cart-approval-process.cy.ts::given a cart above the buyer spend limit when the approver approves the request then the buyer can place the order` | L | `local 2026-08-24 · 1 passing · 23s` |
| [x] | Business_Unit_Address_on_Checkout | ×3 | Checks that business unit address can be used during checkout. _(yves)_ | `cypress/e2e/yves/company-account/business-unit-address-checkout.cy.ts::given a company user with no personal address when the business unit address is chosen at checkout then the order ships to it` | L | `local 2026-08-24 · 1 passing · 16s` |
| [x] | Click_and_collect | ×2 | checks that product offer is successfully replaced with a target product offer. _(yves)_ | `cypress/e2e/yves/checkout/click-and-collect.cy.ts::given an offer collected at a service point when the order is placed then it ships to the service point as a single pickup shipment` | L | `local 2026-08-24 · 1 passing · 25s` |
| [x] | Comments_in_Cart | ×3 | Add comments to cart and verify comments in Yves and Zed. _(yves)_ | `cypress/e2e/yves/comments/cart-comments.cy.ts::given a cart carrying a comment when the order is placed then the comment is on the order in the storefront and in the back office` | L | `local 2026-08-24 · 7 passing · 48s` |
| [x] | Guest_Checkout_Addresses | ×2 | Guest checkout with different addresses and OMS. _(yves)_ | `cypress/e2e/yves/checkout/split-delivery.cy.ts::given a guest cart of three items when each item is given its own delivery address then the order is split into one shipment per address` | L | `local 2026-08-24 · 2 passing · 1m06s` |
| [x] | Login_during_checkout | ×2 | Login during checkout _(yves)_ | `cypress/e2e/yves/checkout/checkout-authentication.cy.ts::given a guest cart when the customer logs in at the checkout customer step then the order is placed on that account` | L | `local 2026-08-24 · 2 passing · 28s` |
| [x] | Multiple_Merchants_Order | ×3 | Checks that order with products and offers of multiple merchants could be placed and it will be split per merchant. _(yves)_ | `cypress/e2e/yves/checkout/multi-merchant-order.cy.ts::given a cart holding the main merchant product and an offer from each of two merchants when the order is placed then it is split into one shipment per merchant` | L | `local 2026-08-24 · 1 passing · 27s` |
| [x] | Register_during_checkout | ×2 | Guest user email should be whitelisted from the AWS side before running the test. _(yves)_ | `cypress/e2e/yves/checkout/checkout-authentication.cy.ts::given a guest cart when the customer registers at the checkout customer step then the account is created and the order is placed on it` | L | `local 2026-08-24 · 2 passing · 28s` |
| [x] | Request_for_Quote | ×3 | Checks user can request and receive quote. _(yves)_ | `cypress/e2e/yves/quote-request/quote-request-lifecycle.cy.ts::given a quote request revised by an agent when the customer converts it to a cart and checks out then the order is placed at the revised price` | L | `local 2026-08-24 · 1 passing · 25s` |
| [x] | Split_Delivery | ×5 | Checks split delivery in checkout. _(yves)_ | `cypress/e2e/yves/checkout/split-delivery.cy.ts::given a customer cart of three items when each item is given its own delivery address then the order is split into one shipment per address` | L | [run](https://github.com/spryker/suite/actions/runs/32571880620) |

#### OBSOLETE / DROP — delete the source, do not port
| ✓ | Scenario | Reason | Covered by |
|---|---|---|---|
| [ ] | Guest_Checkout_and_Addresses | Duplicate journey — retired by the port of checkout/Guest_Checkout_Addresses; delete it in that sibling's batch, it needs no port of its own. Also folds into checkout/Guest_Checkout; both siblings together cover this journey. | robot:tests/ui/suite/checkout/checkout.robot::Guest_Checkout_Addresses |
| [ ] | Checkout_Address_Management | Dropped in code review of the Cypress port: a long journey of low value (changing addresses on a return to the address step); placing an order with addresses stays covered by the checkout specs. | — |
| [ ] | Comment_Management_in_the_Cart | Add, edit and delete a cart comment with a visibility assertion after each step — identical to the Cypress cart-comment edit and remove tests; the highest-scoring pair in the duplication report. | spryker/cypress-tests:cypress/e2e/yves/comments/cart-comments.cy.ts |
| [ ] | Configurable_Product_Checkout | Duplicate journey — retired by the port of product/Configurable_Product_Checkout; delete it in that sibling's batch, it needs no port of its own. | robot:tests/parallel_ui/suite/catalog/catalog_configurable_product.robot::Configurable_Product_Checkout |
| [ ] | Guest_Checkout | Dropped in code review of the Cypress port: guest orders are a low-priority feature; guest checkout itself stays covered by yves/checkout/basic-checkout.cy.ts and the discounts by yves/discount/discounts-and-promotions.cy.ts. | — |
