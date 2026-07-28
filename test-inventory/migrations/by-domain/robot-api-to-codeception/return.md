### return · robot-api-to-codeception · 54 scenarios

MIGRATE 52 · REVIEW 2   ▸ 0/52 ported

Batches: `return-1`, `return-2`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Get_return_reason | ×2 | `GET /return-reasons` → 200 | — | S | — |
| [ ] | Create_a_return_with_order_is_not_returnable | b2b | `GET /returns` → 201 | — | M | — |
| [ ] | Retrieves_a_return_with_missing_auth_token | b2b | `GET /returns` → 403 | — | S | — |
| [ ] | Retrieves_a_return_with_non_exists_id | b2b | `GET /returns` → 404 | — | M | — |
| [ ] | Retrieves_list_of_returns_with_missing_auth_token | b2b | `GET /returns` → 403 | — | S | — |
| [ ] | Create_a_return | ×2 | `POST /carts/$` → 201 | — | M | — |
| [ ] | Retrieves_list_of_returns | b2b | `GET /returns` → 201 | — | M | — |
| [ ] | Retrieves_return_by_id_with_returns_items_included | b2b | `GET /returns/$` → 201 | — | M | — |
| [ ] | Get_return_by_Id_with_Invalid_access_token | b2c | `GET /returns/$` → 401 | — | S | — |
| [ ] | Get_return_by_Id_without_access_token | b2c | `GET /returns/$` → 403 | — | S | — |
| [ ] | Create_a_return_with_order_is_not_returnable | mp_b2b | `GET /returns` → 404 | — | M | — |
| [ ] | Retrieves_a_return_with_missing_auth_token | mp_b2b | `GET /returns` → 403 | — | S | — |
| [ ] | Retrieves_a_return_with_non_exists_id | mp_b2b | `GET /returns` → 404 | — | M | — |
| [ ] | Retrieves_list_of_returns_with_missing_auth_token | mp_b2b | `GET /returns` → 403 | — | S | — |
| [ ] | Create_a_return_with_return_items | mp_b2b | `POST /returns?include=return-items` → 201 | — | M | — |
| [ ] | Retrieves_list_of_returns | mp_b2b | `GET /returns` → 200 | — | M | — |
| [ ] | Retrieves_list_of_returns_included_return_items | mp_b2b | `GET /returns?include=return-items` → 200 | — | M | — |
| [ ] | Create_a_return_with_Invalid_access_token | mp_b2c | `POST /returns` → 401 | — | S | — |
| [ ] | Create_a_return_with_without_access_token | mp_b2c | `POST /returns` → 403 | — | S | — |
| [ ] | Create_return_for_order_item_that_cannot_be_returned | mp_b2c | `POST /returns` → 422 | — | M | — |
| [ ] | Create_return_with_invalid_returnItems_uuid | mp_b2c | `GET /returns/$` → 422 | — | M | — |
| [ ] | Create_return_without_returnItems_reason | mp_b2c | `GET /returns/$` → 422 | — | M | — |
| [ ] | Create_return_without_returnItems_uuid | mp_b2c | `GET /returns/$` → 422 | — | M | — |
| [ ] | Get_lists_of_returns_with_Invalid_access_token | mp_b2c | `GET /returns/$` → 401 | — | S | — |
| [ ] | Get_lists_of_returns_without_access_token | mp_b2c | `GET /returns/$` → 403 | — | S | — |
| [ ] | Get_return_by_Id_with_Invalid_access_token | mp_b2c | `GET /returns/$` → 401 | — | S | — |
| [ ] | Get_return_by_Id_with_Invalid_return_reference | mp_b2c | `GET /returns/$` → 404 | — | M | — |
| [ ] | Get_return_by_Id_without_access_token | mp_b2c | `GET /returns/$` → 403 | — | S | — |
| [ ] | Create_a_return_include_return-items | mp_b2c | `POST /returns?include=return-items` → 201 | — | M | — |
| [ ] | Get_lists_of_returns | mp_b2c | `GET /returns` → 200 | — | M | — |
| [ ] | Get_lists_of_returns_include_return-items | mp_b2c | `GET /returns?include=return-items` → 200 | — | M | — |
| [ ] | Get_return_by_Id | mp_b2c | `POST /carts` → 200 | — | M | — |
| [ ] | Get_return_by_Id_include_return-items | mp_b2c | `GET /returns/$` → 200 | — | M | — |
| [ ] | Get_return_reason | ×3 | `GET /return-reasons` → 200 | — | S | — |
| [ ] | Create_a_return_with_Invalid_access_token | ×2 | `POST /returns` → 401 | — | S | — |
| [ ] | Create_a_return_with_order_is_not_returnable_for_merchant | suite | `POST /returns` → 422 | — | M | — |
| [ ] | Create_a_return_with_without_access_token | ×2 | `POST /carts/$` → 403 | — | S | — |
| [ ] | Create_return_with_invalid_returnItems_uuid | ×2 | `GET /returns/$` → 422 | — | M | — |
| [ ] | Create_return_without_returnItems_reason | ×2 | `GET /returns/$` → 422 | — | M | — |
| [ ] | Create_return_without_returnItems_uuid | ×2 | `GET /returns/$` → 422 | — | M | — |
| [ ] | Get_lists_of_returns_with_Invalid_access_token | ×2 | `GET /returns/$` → 401 | — | S | — |
| [ ] | Get_lists_of_returns_without_access_token | ×2 | `GET /returns/$` → 403 | — | S | — |
| [ ] | Get_return_by_Id_with_Invalid_return_reference | ×2 | `GET /returns/$` → 404 | — | M | — |
| [ ] | Create_a_return_include_return_items | ×2 | `POST /returns?include=return-items` → 201 | — | M | — |
| [ ] | Get_lists_of_returns | ×2 | `GET /returns` → 201 | — | M | — |
| [ ] | Get_lists_of_returns_include_return-items | ×2 | `GET /returns?include=return-items` → 201 | — | M | — |
| [ ] | Get_return_by_Id | ×2 | `GET /returns/$` → 201 | — | M | — |
| [ ] | Get_return_by_Id_include_return-items | ×2 | `GET /returns/$` → 201 | — | M | — |
| [ ] | Retrieves_list_of_returns_included_merchants | ×2 | `GET /returns?include=merchants` → 201 | — | M | — |
| [ ] | Retrieves_return_by_id_for_sales_order | ×2 | `GET /returns/$` → 200 | — | M | — |
| [ ] | Retrieves_return_by_id_with_merchants_included | ×2 | `GET /returns/$` → 200 | — | M | — |
| [ ] | Retrieves_return_by_id_with_returns_items_included | ×2 | `GET /returns/$` → 200 | — | M | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Create_return_for_order_item_that_cannot_be_returned | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_a_return | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
