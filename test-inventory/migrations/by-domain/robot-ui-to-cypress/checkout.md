### checkout · robot-ui-to-cypress · 16 scenarios

MIGRATE 9 · OBSOLETE 1 · REVIEW 6   ▸ 0/9 verified

Batches: `checkout`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Unique_URL | ×3 | Bug: https://spryker.atlassian.net/browse/CC-12380. _(yves)_ | `cypress/e2e/yves/cart/shared-cart-external-link.cy.ts` | M | — |
| [ ] | Approval_Process | ×2 | Checks role permissions on checkout and Approval process. _(yves)_ | `cypress/e2e/yves/checkout/cart-approval-process.cy.ts` | L | — |
| [ ] | Business_Unit_Address_on_Checkout | ×3 | Checks that business unit address can be used during checkout. _(yves)_ | `cypress/e2e/yves/company-account/business-unit-address-checkout.cy.ts` | L | — |
| [ ] | Checkout_Address_Management | ×5 | Bug: CC-30439. Checks that user can change address during the checkout and save new into the address book. _(yves)_ | `cypress/e2e/yves/checkout/checkout-address-management.cy.ts` | L | — |
| [ ] | Click_and_collect | ×2 | checks that product offer is successfully replaced with a target product offer. _(yves)_ | `cypress/e2e/yves/checkout/click-and-collect.cy.ts` | L | — |
| [ ] | Login_during_checkout | ×2 | Login during checkout _(yves)_ | `cypress/e2e/yves/checkout/checkout-authentication.cy.ts` | L | — |
| [ ] | Multiple_Merchants_Order | ×3 | Checks that order with products and offers of multiple merchants could be placed and it will be split per merchant. _(yves)_ | `cypress/e2e/yves/checkout/multi-merchant-order.cy.ts` | L | — |
| [ ] | Register_during_checkout | ×2 | Guest user email should be whitelisted from the AWS side before running the test. _(yves)_ | `cypress/e2e/yves/checkout/checkout-authentication.cy.ts` | L | — |
| [ ] | Request_for_Quote | ×3 | Checks user can request and receive quote. _(yves)_ | `cypress/e2e/yves/quote-request/quote-request-lifecycle.cy.ts` | L | — |

#### OBSOLETE / DROP — delete the source, do not port
| ✓ | Scenario | Reason | Covered by |
|---|---|---|---|
| [ ] | Comment_Management_in_the_Cart | Add, edit and delete a cart comment with visibility assertions after each step - identical to the Cypress cart-comment edit/remove tests (duplication analysis scores this pair 0.58, the highest in the report). | cypress/e2e/yves/comments/cart-comments.cy.ts :: 'customer should be able to modify comment in cart with items' and 'customer should be able to remove comment in cart with items' |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Guest_Checkout_and_Addresses | merge into cypress/e2e/yves/checkout/basic-checkout.cy.ts | Merges the two suite guest journeys (voucher plus cart rule from Guest_Checkout, three delivery addresses and Zed address assertions from Guest_Checkout_Addresses) into one marketplace variant; basic-checkout.cy.ts already covers the guest multi-shipment flow itself. |
| Comments_in_Cart | merge into cypress/e2e/yves/comments/cart-comments.cy.ts | Adding a cart comment is covered by yves/comments/cart-comments.cy.ts; the uncovered delta is that the comment survives checkout and appears on the Yves order-details page and the Zed order page. |
| Configurable_Product_Checkout | merge into cypress/e2e/yves/product-configurator/configurable-product-checkout.cy.ts | Same journey as parallel_ui/suite/catalog/catalog_configurable_product.robot::Configurable_Product_Checkout (two-option configurator, reconfigure in cart, checkout, Zed grand total); that variant uses dynamic fixtures and is the better port source. |
| Guest_Checkout | port only the guest voucher/cart-rule/bundle delta into cypress/e2e/yves/discount/discounts-and-promotions.cy.ts | Guest checkout itself is covered by basic-checkout.cy.ts 'guest customer should checkout to single shipment' and the OMS tail by smoke/order-management/dummy-payment-oms-flow.cy.ts; the uncovered delta is the bundle plus voucher and cart-rule discounts in a guest cart. |
| Guest_Checkout_Addresses | merge into cypress/e2e/yves/checkout/basic-checkout.cy.ts | basic-checkout.cy.ts 'guest customer should checkout to multi shipment address' covers the flow; the delta is three distinct per-item delivery addresses plus per-shipment method choice and the Zed billing/shipping address assertions. |
| Split_Delivery | merge into cypress/e2e/yves/checkout/basic-checkout.cy.ts | Multi-address split delivery with three different shipment carriers and a Zed shipment count of 3; basic-checkout.cy.ts already exercises isMultiShipment but never asserts per-shipment carrier or the shipment count. |
