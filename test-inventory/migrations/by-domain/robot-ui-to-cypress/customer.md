### customer · robot-ui-to-cypress · CC-39280 · 14 scenarios

MIGRATE 6 · OBSOLETE 3 · DROP 5   ▸ 6/6 verified

Batches: `customer`

Target PR: https://github.com/spryker/cypress-tests/pull/399

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [x] | Business_on_Behalf | ×3 | Check that BoB user has possibility to change the business unit. _(yves)_ | `cypress/e2e/yves/company-account/business-on-behalf.cy.ts::given a customer attached to two business units when they use the selector then they can act for either one` | L | `local 2026-08-25 · 1 passing · 7s` |
| [x] | Quick_Order | suite | Checks Quick Order, checkout and Reorder. _(yves)_ | `cypress/e2e/yves/quick-order/quick-order-to-checkout.cy.ts::given an order of offers from two merchants when it is reordered then the cart keeps both merchants` | L | `local 2026-08-25 · 1 passing · 23s` |
| [x] | Share_Shopping_Carts | ×3 | Checks that cart can be shared and used for checkout. _(yves)_ | `cypress/e2e/yves/cart/shared-cart.cy.ts::given a cart shared with a colleague at full access when the colleague orders it then the order is placed and keeps the merchant relation` | L | `local 2026-08-25 · 1 passing · 24s` |
| [x] | Share_Shopping_Lists | ×3 | Checks that shopping list can be shared. _(yves)_ | `cypress/e2e/yves/shopping-list/shopping-list-sharing.cy.ts::given a shopping list shared with a colleague at full access when the colleague opens it then it is on their overview and its products reach their cart` | L | `local 2026-08-25 · 1 passing · 20s` |
| [x] | Shopping_List_Contains_Offers | suite | Checks that customer is able to add merchant products and offers to list and merchant relation won't be lost in list and afterwards in cart. _(yves)_ | `cypress/e2e/yves/shopping-list/shopping-list-product-offers.cy.ts::given a product sold by two merchants when both offers are added to one shopping list then the list and the cart keep a line per merchant` | L | `local 2026-08-25 · 1 passing · 19s` |
| [x] | User_Account | ×5 | Checks user account pages work + address management. _(yves)_ | `cypress/e2e/yves/customer-account-management/customer-address-management.cy.ts::customer should be able to delete an address` | M | [run](https://github.com/spryker/suite/actions/runs/32559721207) |

#### OBSOLETE / DROP — delete the source, do not port
| ✓ | Scenario | Reason | Covered by |
|---|---|---|---|
| [ ] | Add_to_Wishlist | Dropped in code review of the Cypress port: wishlists are a low-value, low-priority feature. | — |
| [ ] | Authorized_User_Access | Navigation smoke: header icons and page-is-displayed assertions with one add-to-cart; no state change, and login is already covered by yves/customer-account-management/customer-auth.cy.ts. | — |
| [ ] | Email_Confirmation | Asserts that an unconfirmed customer cannot log in, which suite's configuration does not do: isDoubleOptInEnabled() defaults to false and suite adds no override, so registration is followed by a successful login. The sibling Cypress test proves exactly that in the same run. The gate itself is covered by the facade test, whose data provider mocks the config on and off and includes the unconfirmed-login case. A browser test cannot assert it without flipping a config the E2E environment does not flip. | src/Spryker/Customer/tests/SprykerTest/Zed/Customer/Business/Facade/TryAuthorizeCustomerByEmailAndPasswordTest.php::testTryAuthorizeCustomerByEmailAndPassword |
| [ ] | Guest_User_Access_Restrictions | Dropped in code review of the Cypress port: low value, and the guest add-to-cart it asserted does not exist on the B2B shops. | — |
| [ ] | New_Customer_Registration | Already covered. That test registers a customer through the storefront form and asserts getRegistrationCompletedMessage(), which is verbatim the flash string this Robot test asserts. Confirmed passing in suite run 32512608457. | cypress/e2e/yves/customer-account-management/customer-auth.cy.ts::guest should be able to register and login as new customer |
| [ ] | Reorder | Both halves of this journey are already covered, in the repositories the Robot copies run in. The mp_b2c copy asserts merchant preservation, and reorder-product-offers.cy.ts skips only b2c and b2b, so it still runs in b2c-mp. The b2c-demo-shop copy does not assert a merchant at all despite its documentation line — it replaces that assertion with a plain product-presence check — and reorder-concrete-products.cy.ts covers exactly that, ungated, with an isB2c() helper that explicitly handles b2c and b2c-mp. No port needed. | spryker/cypress-tests:cypress/e2e/yves/reorder/reorder-concrete-products.cy.ts + cypress/e2e/yves/reorder/reorder-product-offers.cy.ts |
| [ ] | Update_Customer_Data | Dropped in code review of the Cypress port: the back-office-to-storefront profile round trip was judged unnecessary; the storefront profile update stays covered by yves/customer-account-management/customer-profile-management.cy.ts. | — |
| [ ] | Wishlist_List_Supports_Offers | Dropped in code review of the Cypress port: wishlists are a low-value, low-priority feature. | — |
