### product · robot-ui-to-cypress · 21 scenarios

MIGRATE 18 · OBSOLETE 3   ▸ 0/18 verified

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
| [ ] | Product_PDP | ×5 | Checks that PDP contains required elements. _(yves)_ | `cypress/e2e/yves/product/product-detail-visibility.cy.ts` | M | — |
| [ ] | Product_Restrictions | ×3 | Checks White and Black lists. _(yves)_ | `cypress/e2e/yves/catalog/product-restrictions.cy.ts` | L | — |
| [ ] | Volume_Prices | ×5 | Checks that volume prices are applied in cart. _(yves)_ | `cypress/e2e/yves/product/volume-prices.cy.ts` | L | — |

#### OBSOLETE / DROP — delete the source, do not port
| ✓ | Scenario | Reason | Covered by |
|---|---|---|---|
| [ ] | Configurable_Product_OMS | Duplicate journey — retired by the port of order/Configurable_Product_OMS; delete it in that sibling's batch, it needs no port of its own. | robot:tests/ui/b2c/sales/sales.robot::Configurable_Product_OMS |
| [ ] | Quick_Order | Duplicate journey — retired by the port of customer/Quick_Order; delete it in that sibling's batch, it needs no port of its own. | robot:tests/ui/suite/customers/customer.robot::Quick_Order |
| [ ] | Offer_Availability_Calculation | Duplicate journey — retired by the port of merchant/Offer_Availability_Calculation; delete it in that sibling's batch, it needs no port of its own. | robot:tests/ui/suite/marketplace/marketplace.robot::Offer_Availability_Calculation |
