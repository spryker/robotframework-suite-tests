### customer · robot-ui-to-cypress · CC-39280 · 14 scenarios

MIGRATE 10 · OBSOLETE 3 · DROP 1   ▸ 0/10 verified · 2 awaiting a CI run

Batches: `customer`

Target PR: https://github.com/spryker/cypress-tests/pull/392

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Add_to_Wishlist | ×3 | Check creation of wishlist and adding to different wishlists. _(yves)_ | `cypress/e2e/yves/wishlist/wishlist-management.cy.ts` | M | — |
| [ ] | Business_on_Behalf | ×3 | Check that BoB user has possibility to change the business unit. _(yves)_ | `cypress/e2e/yves/company-account/business-on-behalf.cy.ts` | L | — |
| [ ] | Guest_User_Access_Restrictions | ×5 | Checks that guest users see products info and cart but not profile. _(yves)_ | `cypress/e2e/yves/customer-account-management/guest-access-restrictions.cy.ts` | S | — |
| [ ] | Quick_Order | suite | Checks Quick Order, checkout and Reorder. _(yves)_ | `cypress/e2e/yves/quick-order/quick-order-to-checkout.cy.ts` | L | — |
| [ ] | Share_Shopping_Carts | ×3 | Checks that cart can be shared and used for checkout. _(yves)_ | `cypress/e2e/yves/cart/shared-cart-checkout.cy.ts` | L | — |
| [ ] | Share_Shopping_Lists | ×3 | Checks that shopping list can be shared. _(yves)_ | `cypress/e2e/yves/shopping-list/shopping-list-sharing.cy.ts` | L | — |
| [ ] | Shopping_List_Contains_Offers | suite | Checks that customer is able to add merchant products and offers to list and merchant relation won't be lost in list and afterwards in cart. _(yves)_ | `cypress/e2e/yves/shopping-list/shopping-list-product-offers.cy.ts` | L | — |
| [ ] | Update_Customer_Data | ×5 | Checks customer data can be updated from Yves and Zed. _(yves)_ | `cypress/e2e/yves/customer-account-management/customer-profile-management.cy.ts::customer should see a profile change an administrator made in the back office` | M | — |
| [ ] | User_Account | ×5 | Checks user account pages work + address management. _(yves)_ | `cypress/e2e/yves/customer-account-management/customer-address-management.cy.ts::customer should see an address an administrator added in the back office` | M | — |
| [ ] | Wishlist_List_Supports_Offers | ×2 | Checks that customer is able to add merchant products and offers to list and merchant relation won't be lost in list and afterwards in cart. _(yves)_ | `cypress/e2e/yves/wishlist/wishlist-product-offers.cy.ts` | L | — |

#### OBSOLETE / DROP — delete the source, do not port
| ✓ | Scenario | Reason | Covered by |
|---|---|---|---|
| [ ] | Authorized_User_Access | Navigation smoke: header icons and page-is-displayed assertions with one add-to-cart; no state change, and login is already covered by yves/customer-account-management/customer-auth.cy.ts. | — |
| [ ] | Email_Confirmation | Asserts that an unconfirmed customer cannot log in, which suite's configuration does not do: isDoubleOptInEnabled() defaults to false and suite adds no override, so registration is followed by a successful login. The sibling Cypress test proves exactly that in the same run. The gate itself is covered by the facade test, whose data provider mocks the config on and off and includes the unconfirmed-login case. A browser test cannot assert it without flipping a config the E2E environment does not flip. | src/Spryker/Customer/tests/SprykerTest/Zed/Customer/Business/Facade/TryAuthorizeCustomerByEmailAndPasswordTest.php::testTryAuthorizeCustomerByEmailAndPassword |
| [ ] | New_Customer_Registration | Already covered. That test registers a customer through the storefront form and asserts getRegistrationCompletedMessage(), which is verbatim the flash string this Robot test asserts. Confirmed passing in suite run 32512608457. | cypress/e2e/yves/customer-account-management/customer-auth.cy.ts::guest should be able to register and login as new customer |
| [ ] | Reorder | Both halves of this journey are already covered, in the repositories the Robot copies run in. The mp_b2c copy asserts merchant preservation, and reorder-product-offers.cy.ts skips only b2c and b2b, so it still runs in b2c-mp. The b2c-demo-shop copy does not assert a merchant at all despite its documentation line — it replaces that assertion with a plain product-presence check — and reorder-concrete-products.cy.ts covers exactly that, ungated, with an isB2c() helper that explicitly handles b2c and b2c-mp. No port needed. | spryker/cypress-tests:cypress/e2e/yves/reorder/reorder-concrete-products.cy.ts + cypress/e2e/yves/reorder/reorder-product-offers.cy.ts |
