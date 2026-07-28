### merchant · robot-ui-to-cypress · 22 scenarios

MIGRATE 14 · DROP 3 · REVIEW 5   ▸ 0/14 ported

Batches: `merchant`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Create_New_Offer | ×2 | Checks that merchant is able to create new offer and it will be displayed on Yves. _(yves)_ | `cypress/e2e/mp/product-offer/offer-creation.cy.ts` | L | — |
| [ ] | Approve_Offer | ×3 | Checks that marketplace operator is able to approve or deny merchant's offer and it will be available or not in store due to this status. _(yves)_ | `cypress/e2e/backoffice/product-offer/offer-approval.cy.ts` | L | — |
| [ ] | Manage_Merchant_Product | ×3 | Checks that MU and BO user can manage merchant abstract and concrete products + add new concrete product. _(yves)_ | `cypress/e2e/mp/marketplace-product-concretes/product-concrete-management.cy.ts` | L | — |
| [ ] | Manage_Merchants_from_Backoffice | ×3 | Checks that backoffice admin is able to create, approve, edit merchants. _(yves)_ | `cypress/e2e/backoffice/merchant-management/merchant-crud.cy.ts` | L | — |
| [ ] | Merchant_Portal_Customer_Specific_Prices | ×2 | Checks that customer will see product/offer prices specified by merchant for his business unit. _(yves)_ | `cypress/e2e/mp/merchant-portal/customer-specific-prices.cy.ts` | L | — |
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
| [ ] | Default_Merchants | Opens the BO merchant table and asserts three seeded merchant names are present; a demo-data presence assertion, not a journey. | — |
| [ ] | Merchant_Portal_Dashboard | After a large BO setup it only clicks three dashboard buttons and checks the resulting URL fragments; a navigation smoke with no state change. | — |
| [ ] | Merchant_Portal_Unauthorized_Access_Redirects_To_Login_Page | Deletes cookies, opens the MP root URL and asserts a login div plus the resulting URL - a bare redirect/render check with no journey; MP login itself is covered by smoke/merchant-portal/login.cy.ts. | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Shopping_List_Contains_Offers | merge into cypress/e2e/yves/shopping-list/shopping-list-product-offers.cy.ts | Marketplace-B2B variant of tests/ui/suite/customers/customer.robot::Shopping_List_Contains_Offers - identical steps with a different merchant name. |
| Create_and_Approve_New_Merchant_Product | merge the approve/deny path into cypress/e2e/mp/marketplace-product-concretes/product-concrete-management.cy.ts | Merchant creates a multi-SKU product, BO approves, PDP shows it, BO denies and the PDP 404s - a strict subset of Manage_Merchant_Product plus a deny path, and mp/data-import/merchant-combined-product.cy.ts already covers merchant product to PDP via import. |
| Fulfill_Order_from_Merchant_Portal | port the per-item state and multi-merchant delta into cypress/e2e/mp/marketplace-order-management/order-creation.cy.ts | Merchant-side OMS in MP overlaps mp/marketplace-order-management/order-creation.cy.ts, which already closes an order as a merchant user; the delta is the four-line multi-merchant cart, the MP grand total and per-item Ship/Deliver states on the Items tab. |
| Manage_Merchant_Users | port the BO CRUD half as cypress/e2e/backoffice/merchant-management/merchant-user-management.cy.ts | BO merchant-user create/activate/edit/deactivate with MP login allowed then refused; mp/marketplace-agent-assist/agent-login.cy.ts already asserts deactivated and deleted merchant users cannot log in, so only the BO CRUD half is new. |
| Merchant_Portal_My_Account | port as cypress/e2e/mp/merchant-portal/merchant-user-account.cy.ts | Merchant user edits name and password in MP, re-logs in with the new password and the change is visible in the BO user table; mp/multi-factor-authentication/merchant-user-mfa-auth.cy.ts already covers MP password change and re-login, so only the name edit and BO verification are new. |
