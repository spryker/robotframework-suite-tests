### customer · robot-ui-to-cypress · 14 scenarios

MIGRATE 10 · DROP 1 · REVIEW 3   ▸ 0/10 verified · 3 awaiting a CI run

Batches: `customer`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Add_to_Wishlist | ×3 | Check creation of wishlist and adding to different wishlists. _(yves)_ | `cypress/e2e/yves/wishlist/wishlist-management.cy.ts` | M | — |
| [ ] | Business_on_Behalf | ×3 | Check that BoB user has possibility to change the business unit. _(yves)_ | `cypress/e2e/yves/company-account/business-on-behalf.cy.ts` | L | — |
| [ ] | Email_Confirmation | ×3 | Check that a new user cannot login if the email is not verified. _(yves)_ | `cypress/e2e/yves/customer-account-management/customer-auth.cy.ts` | M | — |
| [ ] | Quick_Order | suite | Checks Quick Order, checkout and Reorder. _(yves)_ | `cypress/e2e/yves/quick-order/quick-order-to-checkout.cy.ts` | L | — |
| [ ] | Share_Shopping_Carts | ×3 | Checks that cart can be shared and used for checkout. _(yves)_ | `cypress/e2e/yves/cart/shared-cart-checkout.cy.ts` | L | — |
| [ ] | Share_Shopping_Lists | ×3 | Checks that shopping list can be shared. _(yves)_ | `cypress/e2e/yves/shopping-list/shopping-list-sharing.cy.ts` | L | — |
| [ ] | Shopping_List_Contains_Offers | suite | Checks that customer is able to add merchant products and offers to list and merchant relation won't be lost in list and afterwards in cart. _(yves)_ | `cypress/e2e/yves/shopping-list/shopping-list-product-offers.cy.ts` | L | — |
| [ ] | Update_Customer_Data | ×5 | Checks customer data can be updated from Yves and Zed. _(yves)_ | `cypress/e2e/yves/customer-account-management/customer-profile-management.cy.ts` | M | — |
| [ ] | User_Account | ×5 | Checks user account pages work + address management. _(yves)_ | `cypress/e2e/yves/customer-account-management/customer-address-management.cy.ts` | M | — |
| [ ] | Wishlist_List_Supports_Offers | ×2 | Checks that customer is able to add merchant products and offers to list and merchant relation won't be lost in list and afterwards in cart. _(yves)_ | `cypress/e2e/yves/wishlist/wishlist-product-offers.cy.ts` | L | — |

#### OBSOLETE / DROP — delete the source, do not port
| ✓ | Scenario | Reason | Covered by |
|---|---|---|---|
| [ ] | Authorized_User_Access | Navigation smoke: header icons plus 'Overview / Order History / Wishlist page is displayed' assertions with one add-to-cart; no state change, and login itself is already covered by yves/customer-account-management/customer-auth.cy.ts. | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Guest_User_Access_Restrictions | port as a small cypress/e2e/yves/customer-account-management/guest-access-restrictions.cy.ts | Mostly presence assertions, but it does prove a guest is redirected to login for account overview and wishlist while cart and PDP stay reachable - an access-control behaviour no Cypress spec asserts. |
| New_Customer_Registration | merge into cypress/e2e/yves/customer-account-management/customer-auth.cy.ts | Registers a customer and asserts only the confirm-your-email flash; customer-auth.cy.ts 'guest should be able to register and login as new customer' covers registration, so the delta is just the confirmation-required message (duplication analysis scores this pair 0.52). |
| Reorder | drop; merchant-preserving reorder is already asserted in cypress/e2e/yves/reorder/reorder-product-offers.cy.ts - only keep if that spec's b2c/b2b skip matters | Places an order and reorders it asserting the merchant is preserved - yves/reorder/reorder-product-offers.cy.ts asserts exactly that ('Sold by <merchant>' after reorderAll), but that spec is skipped on b2c/b2b repos while this Robot test runs on suite. |
