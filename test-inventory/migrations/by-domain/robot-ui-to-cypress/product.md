### product · robot-ui-to-cypress · 21 scenarios

MIGRATE 17 · REVIEW 4   ▸ 0/17 verified

Batches: `product`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Configurable_Product_Checkout | ×3 | Configurable product checkout _(yves)_ | `cypress/e2e/yves/product-configurator/configurable-product-checkout.cy.ts` | L | — |
| [ ] | Back_in_Stock_Notification | ×5 | Back in stock notification is sent and availability check. _(yves)_ | `cypress/e2e/yves/product/back-in-stock-notification.cy.ts` | M | — |
| [ ] | Catalog | ×5 | Checks that catalog options and search work. _(yves)_ | `cypress/e2e/yves/catalog/catalog-browsing.cy.ts` | L | — |
| [ ] | Catalog_Actions | ×3 | Checks quick add to cart and product groups. _(yves)_ | `cypress/e2e/yves/catalog/quick-add-to-cart.cy.ts` | L | — |
| [ ] | Configurable_Product_PDP_Shopping_List | ×3 | Configure products from both the PDP and the Shopping List. Verify the availability of five items. Ensure that products that have not been configured cannot be purchased. _(yves)_ | `cypress/e2e/yves/product-configurator/configurable-product-shopping-list.cy.ts` | M | — |
| [ ] | Configurable_Product_PDP_Wishlist_Availability | ×2 | Configure product from PDP and Wishlist + availability case. _(yves)_ | `cypress/e2e/yves/product-configurator/configurable-product-wishlist.cy.ts` | M | — |
| [ ] | Configurable_Product_RfQ_OMS | ×3 | Conf Product in RfQ, OMS, Merchant OMS and reorder. _(yves)_ | `cypress/e2e/yves/quote-request/configurable-product-rfq.cy.ts` | L | — |
| [ ] | Customer_Specific_Prices | ×3 | Checks that product price can be different for different customers. _(yves)_ | `cypress/e2e/yves/product/customer-specific-prices.cy.ts` | M | — |
| [ ] | Discontinued_Alternative_Products | ×5 | Checks discontinued and alternative products. _(yves)_ | `cypress/e2e/yves/product/discontinued-alternative-products.cy.ts` | L | — |
| [ ] | Manage_Product | ×3 | checks that BO user can manage abstract and concrete products + create new. _(yves)_ | `cypress/e2e/backoffice/product-management/product-lifecycle-management.cy.ts` | L | — |
| [ ] | Measurement_Units | ×3 | Checks checkout with Measurement Unit product. _(yves)_ | `cypress/e2e/yves/product-measurement-unit/measurement-unit-checkout.cy.ts` | L | — |
| [ ] | Packaging_Units | ×3 | Checks checkout with Packaging Unit product. _(yves)_ | `cypress/e2e/yves/product-measurement-unit/packaging-unit-checkout.cy.ts` | L | — |
| [ ] | Product_Availability_Calculation | ×5 | Check product availability + multistore. _(yves)_ | `cypress/e2e/yves/product/availability-calculation.cy.ts` | L | — |
| [ ] | Product_Bundles | ×4 | Checks checkout with Bundle product. _(yves)_ | `cypress/e2e/yves/product/product-bundle-checkout.cy.ts` | L | — |
| [ ] | Product_Original_Price | ×3 | checks that Original price is displayed on the PDP and in Catalog. _(yves)_ | `cypress/e2e/yves/product/original-price.cy.ts` | L | — |
| [ ] | Product_Restrictions | ×3 | Checks White and Black lists. _(yves)_ | `cypress/e2e/yves/catalog/product-restrictions.cy.ts` | L | — |
| [ ] | Volume_Prices | ×5 | Checks that volume prices are applied in cart. _(yves)_ | `cypress/e2e/yves/product/volume-prices.cy.ts` | L | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Configurable_Product_OMS | merge into cypress/e2e/backoffice/order-management/configurable-product-oms.cy.ts | Marketplace variant of tests/ui/b2c/sales/sales.robot::Configurable_Product_OMS with dynamic fixtures; the delta is the Merchant Portal order grand total and the merchant shipment states, while the b2c copy carries the return and reorder tail. |
| Quick_Order | merge into cypress/e2e/yves/quick-order/quick-order-to-checkout.cy.ts | B2B variant of tests/ui/suite/customers/customer.robot::Quick_Order - same textarea bulk add, cart and shopping list, checkout and reorder, only with B2B SKUs and without the merchant assertions. |
| Offer_Availability_Calculation | merge into cypress/e2e/yves/product-offer/offer-availability.cy.ts | Marketplace-B2C variant of tests/ui/suite/marketplace/marketplace.robot::Offer_Availability_Calculation - same offer stock/checkout/cancel availability cycle. |
| Product_PDP | port as a slim cypress/e2e/yves/product/product-detail-visibility.cy.ts | Body is a sequence of 'PDP contains/doesn't contain' element-presence checks for guest vs logged-in plus a variant switch; the guest/customer element delta is real but no Cypress spec covers PDP element visibility (product-attribute-visibility.cy.ts covers attribute badges only). |
