### discount · robot-api-to-codeception · 53 scenarios

MIGRATE 52 · REVIEW 1   ▸ 0/52 ported

Batches: `discount-1`, `discount-2`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Adding_not_existing_voucher_code_to_cart_of_logged_in_customer | ×2 | `POST ...` → 201 | — | M | — |
| [ ] | Adding_voucher_code_that_could_not_be_applied_to_cart_of_logged_in_customer | ×2 | `DELETE /carts/cart_id/vouchers/$` → 201 | — | M | — |
| [ ] | Adding_voucher_code_with_invalid_cart_id | ×2 | `DELETE /carts/invalidCartId/vouchers/$` → 404 | — | M | — |
| [ ] | Adding_voucher_with_invalid_access_token | ×2 | `DELETE /carts/invalidCartId/vouchers/$` → 401 | — | M | — |
| [ ] | Adding_voucher_without_access_token | ×2 | `DELETE /carts/invalidCartId/vouchers/$` → 403 | — | S | — |
| [ ] | Deleting_voucher_code_with_invalid_cart_id | ×2 | `DELETE /carts/invalidCartId/vouchers/$` → 404 | — | M | — |
| [ ] | Deleting_voucher_with_invalid_access_token | ×2 | `DELETE /carts/invalidCartId/vouchers/$` → 401 | — | S | — |
| [ ] | Deleting_voucher_without_access_token | ×2 | `DELETE /carts/invalidCartId/vouchers/$` → 403 | — | S | — |
| [ ] | Adding_voucher_code_to_cart_of_logged_in_customer | ×2 | `POST ...` → 201 | — | M | — |
| [ ] | Adding_voucher_with_cart_rule_with_to_the_same_cart | ×2 | `POST /carts/$` → 201 | — | M | — |
| [ ] | Checking_voucher_is_applied_after_order_is_placed | ×2 | `POST ...` → 201 | — | M | — |
| [ ] | Deleting_voucher_from_cart_of_logged_in_customer | ×2 | `DELETE /carts/$` → 201 | — | M | — |
| [ ] | Add_empty_voucher_code_to_cart | ×3 | `POST /guest-carts/fake_guest_cart_id/vouchers` → 422 | — | M | — |
| [ ] | Add_empty_voucher_code_to_guest_cart | ×3 | `POST /carts/$` → 422 | — | S | — |
| [ ] | Add_invalid_voucher_code_to_cart | ×3 | `POST /carts/fake_cart_id/vouchers` → 422 | — | M | — |
| [ ] | Add_invalid_voucher_code_to_guest_cart | ×3 | `POST /guest-carts/$` → 422 | — | S | — |
| [ ] | Add_voucher_code_from_another_customer_to_cart | ×3 | `DELETE /carts/$` → 404 | — | M | — |
| [ ] | Add_voucher_code_from_another_customer_to_guest_user_cart | ×3 | `DELETE /guest-carts/$` → 404 | — | S | — |
| [ ] | Add_voucher_code_from_another_discount_to_cart | ×2 | `POST /guest-carts/$` → 422 | — | M | — |
| [ ] | Add_voucher_code_from_another_discount_to_guest_user_cart | ×2 | `POST /guest-carts/$` → 422 | — | S | — |
| [ ] | Add_voucher_code_to_cart_with_invalid_access_token | ×3 | `POST /carts/$` → 401 | — | M | — |
| [ ] | Add_voucher_code_to_cart_with_invalid_cart_id | ×3 | `POST /guest-carts/$` → 404 | — | M | — |
| [ ] | Add_voucher_code_to_cart_without_access_token | ×3 | `POST /carts/$` → 403 | — | M | — |
| [ ] | Add_voucher_code_to_cart_without_voucher_discount | ×3 | `POST /carts/$` → 422 | — | M | — |
| [ ] | Add_voucher_code_to_empty_cart | ×3 | `DELETE /guest-carts/$` → 422 | — | M | — |
| [ ] | Add_voucher_code_to_empty_guest_user_cart | ×3 | `DELETE /carts/$` → 422 | — | S | — |
| [ ] | Add_voucher_code_to_guest_cart_with_invalid_anonymous_customer_id | ×3 | `POST /guest-carts/$` → 404 | — | S | — |
| [ ] | Add_voucher_code_to_guest_cart_with_invalid_cart_id | ×3 | `POST /carts/$` → 404 | — | S | — |
| [ ] | Add_voucher_code_to_guest_cart_without_anonymous_customer_id | ×3 | `POST /guest-carts/$` → 400 | — | S | — |
| [ ] | Add_voucher_code_to_guest_user_cart_without_voucher_discount | ×3 | `DELETE /carts` → 422 | — | S | — |
| [ ] | Add_voucher_to_cart_without_voucher_code | ×3 | `POST /carts/$` → 422 | — | M | — |
| [ ] | Add_voucher_to_guest_cart_without_voucher_code | ×3 | `POST /carts/$` → 422 | — | S | — |
| [ ] | Delete_empty_voucher_code_from_cart | ×3 | `DELETE /guest-carts/fake_guest_cart_id/vouchers/fake_discount_voucher_code` → 400 | — | M | — |
| [ ] | Delete_empty_voucher_code_from_guest_user_cart | ×3 | `DELETE /guest-carts/$` → 400 | — | S | — |
| [ ] | Delete_invalid_voucher_code_from_cart | ×3 | `DELETE /guest-carts/fake_guest_cart_id/vouchers/fake_discount_voucher_code` → 422 | — | M | — |
| [ ] | Delete_invalid_voucher_code_from_guest_user_cart | ×3 | `DELETE /guest-carts/$` → 422 | — | S | — |
| [ ] | Delete_voucher_code_from_another_customer_cart | ×3 | `DELETE /guest-carts/$` → 404 | — | M | — |
| [ ] | Delete_voucher_code_from_another_customer_guest_cart | ×3 | `DELETE /guest-carts/$` → 404 | — | S | — |
| [ ] | Delete_voucher_code_from_cart_with_invalid_access_token | ×3 | `DELETE /carts/$` → 401 | — | M | — |
| [ ] | Delete_voucher_code_from_cart_with_invalid_cart_id | ×3 | `DELETE /guest-carts/$` → 404 | — | M | — |
| [ ] | Delete_voucher_code_from_cart_without_access_token | ×3 | `DELETE /guest-carts/$` → 403 | — | M | — |
| [ ] | Delete_voucher_code_from_guest_cart_without_anonymous_customer_id | ×3 | `DELETE /guest-carts/$` → 400 | — | S | — |
| [ ] | Delete_voucher_code_from_guest_user_cart_with_invalid_anonymous_customer_id | ×3 | `DELETE /guest-carts/$` → 404 | — | S | — |
| [ ] | Delete_voucher_code_from_guest_user_cart_with_invalid_cart_id | ×3 | `DELETE /guest-carts/$` → 404 | — | S | — |
| [ ] | Delete_voucher_from_cart_without_voucher_code | ×3 | `DELETE /carts/$` → 400 | — | M | — |
| [ ] | Delete_voucher_from_guest_user_cart_without_voucher_code | ×3 | `DELETE /guest-carts/$` → 400 | — | S | — |
| [ ] | Add_voucher_code_to_cart | ×3 | `POST /guest-carts/$` → 201 | — | M | — |
| [ ] | Add_voucher_code_to_cart_including_vouchers | ×3 | `POST /guest-carts/$` → 201 | — | M | — |
| [ ] | Add_voucher_code_to_guest_user_cart | ×3 | `POST /carts/$` → 201 | — | S | — |
| [ ] | Add_voucher_code_to_guest_user_cart_including_vouchers | ×3 | `POST /guest-carts/$` → 201 | — | S | — |
| [ ] | Delete_voucher_code_from_cart | ×3 | `DELETE /guest-carts/$` → 204 | — | M | — |
| [ ] | Delete_voucher_code_from_guest_user_cart | ×3 | `DELETE /guest-carts/$` → 204 | — | S | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Adding_two_vouchers_with_different_priority_to_the_same_cart | drop | Glue already asserts POST /carts -> 201 in CartsRestApiCest::requestCreateCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
