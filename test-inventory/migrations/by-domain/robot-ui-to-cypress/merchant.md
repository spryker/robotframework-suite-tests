### merchant · robot-ui-to-cypress · CC-39280 · 22 scenarios

MIGRATE 18 · OBSOLETE 1 · DROP 3   ▸ 0/18 verified

Batches: `merchant`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Create_New_Offer | ×2 | Checks that merchant is able to create new offer and it will be displayed on Yves. _(yves)_ | `cypress/e2e/mp/product-offer/offer-creation.cy.ts` | L | — |
| [ ] | Create_and_Approve_New_Merchant_Product | ×2 | Checks that merchant is able to create new multi-SKU product and marketplace operator is able to approve it in BO. _(yves)_ | `cypress/e2e/mp/marketplace-product-concretes/product-concrete-management.cy.ts::should return not found on the product detail page after a merchant product is denied` | L | — |
| [ ] | Approve_Offer | ×3 | Checks that marketplace operator is able to approve or deny merchant's offer and it will be available or not in store due to this status. _(yves)_ | `cypress/e2e/backoffice/product-offer/offer-approval.cy.ts` | L | — |
| [ ] | Fulfill_Order_from_Merchant_Portal | ×3 | Checks that merchant is able to process his order through OMS from merchant portal. _(yves)_ | `cypress/e2e/mp/marketplace-order-management/order-creation.cy.ts::merchant should ship and deliver each item of a multi merchant order` | L | — |
| [ ] | Manage_Merchant_Product | ×3 | Checks that MU and BO user can manage merchant abstract and concrete products + add new concrete product. _(yves)_ | `cypress/e2e/mp/marketplace-product-concretes/product-concrete-management.cy.ts::merchant should create and update a multi sku product concrete` | L | — |
| [ ] | Manage_Merchant_Users | ×3 | Checks that backoffice admin is able to create, activate, edit and delete merchant users. DMS-ON: https://spryker.atlassian.net/browse/FRW-7395. _(backoffice)_ | `cypress/e2e/backoffice/merchant-management/merchant-user-management.cy.ts` | M | — |
| [ ] | Manage_Merchants_from_Backoffice | ×3 | Checks that backoffice admin is able to create, approve, edit merchants. _(yves)_ | `cypress/e2e/backoffice/merchant-management/merchant-crud.cy.ts` | L | — |
| [ ] | Merchant_Portal_Customer_Specific_Prices | ×2 | Checks that customer will see product/offer prices specified by merchant for his business unit. _(yves)_ | `cypress/e2e/mp/merchant-portal/customer-specific-prices.cy.ts` | L | — |
| [ ] | Merchant_Portal_My_Account | ×3 | Checks that MU can edit personal data in MP. DMS-ON: https://spryker.atlassian.net/browse/FRW-7395. _(backoffice)_ | `cypress/e2e/mp/merchant-portal/merchant-user-account.cy.ts` | M | — |
| [ ] | Merchant_Portal_Offer_Volume_Prices | ×3 | Checks that merchant is able to create new offer with volume prices and it will be displayed on Yves. Fallback to default price after delete. _(yves)_ | `cypress/e2e/mp/product-offer/offer-volume-prices.cy.ts` | L | — |
| [ ] | Merchant_Portal_Product_Volume_Prices | ×3 | Checks that merchant is able to create new multi-SKU product with volume prices. Fallback to default price after delete. _(yves)_ | `cypress/e2e/mp/merchant-portal/product-volume-prices.cy.ts` | L | — |
| [ ] | Merchant_Product_Offer_in_Backoffice | ×3 | Check View action and filtration for Mproduct and Moffer in backoffice. _(backoffice)_ | `cypress/e2e/backoffice/product-offer/offer-view-and-filter.cy.ts` | L | — |
| [ ] | Merchant_Product_Original_Price | ×3 | checks that Original price is displayed on the PDP and in Catalog. _(yves)_ | `cypress/e2e/yves/product/original-price.cy.ts` | L | — |
| [ ] | Merchant_Profile_Set_to_Inactive_from_Backoffice | ×3 | Checks that backoffice admin is able to deactivate merchant and then it's profile, products and offers won't be displayed on Yves. _(yves)_ | `cypress/e2e/backoffice/merchant-management/merchant-deactivation.cy.ts` | L | — |
| [ ] | Merchant_Profile_Set_to_Offline_from_MP | ×3 | Checks that merchant is able to set store offline and then his profile, products and offers won't be displayed on Yves. _(yves)_ | `cypress/e2e/mp/merchant-portal/merchant-store-status.cy.ts` | L | — |
| [ ] | Merchant_Profile_Update | ×3 | Checks that merchant profile could be updated from merchant portal and that changes will be displayed on Yves. _(yves)_ | `cypress/e2e/mp/merchant-portal/merchant-profile-update.cy.ts` | L | — |
| [ ] | Offer_Availability_Calculation | suite | check offer availability. _(yves)_ | `cypress/e2e/yves/product-offer/offer-availability.cy.ts` | L | — |
| [ ] | Search_for_Merchant_Offers_and_Products | ×3 | Checks that through search customer is able to see the list of merchant's products and offers. _(yves)_ | `cypress/e2e/yves/catalog/merchant-search.cy.ts` | L | — |

#### OBSOLETE / DROP — delete the source, do not port
| ✓ | Scenario | Reason | Covered by |
|---|---|---|---|
| [ ] | Shopping_List_Contains_Offers | Duplicate journey — retired by the port of customer/Shopping_List_Contains_Offers; delete it in that sibling's batch, it needs no port of its own. | robot:tests/ui/suite/customers/customer.robot::Shopping_List_Contains_Offers |
| [ ] | Default_Merchants | Opens the back-office merchant table and asserts three seeded merchant names are present; a demo-data presence assertion, not a journey. | — |
| [ ] | Merchant_Portal_Dashboard | After a large back-office setup it clicks three dashboard buttons and checks URL fragments; a navigation smoke with no state change. | — |
| [ ] | Merchant_Portal_Unauthorized_Access_Redirects_To_Login_Page | Deletes cookies, opens the Merchant Portal root and asserts a login div plus the URL; a bare redirect check, and Merchant Portal login is covered by smoke/merchant-portal/login.cy.ts. | — |
