### quote-request · robot-api-to-codeception · 31 scenarios

MIGRATE 22 · REVIEW 9   ▸ 0/22 verified

Batches: `quote-request`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Create_quote_request_for_cart_with_read_only_access | suite | `GET /quote-requests/test123` → 201 | — | M | — |
| [ ] | Create_quote_request_from_another_customer | suite | `DELETE /carts/$` → 404 | — | M | — |
| [ ] | Create_quote_request_with_empty_cart_id | suite | `GET /carts/$` → 422 | — | M | — |
| [ ] | Create_quote_request_with_empty_type | suite | `POST /quote-requests` → 400 | — | M | — |
| [ ] | Create_quote_request_with_invalid_access_token | suite | `POST /quote-requests` → 401 | — | M | — |
| [ ] | Create_quote_request_with_invalid_cartId | suite | `POST /carts/$` → 404 | — | M | — |
| [ ] | Create_quote_request_with_invalid_type | suite | `POST /quote-requests` → 400 | — | M | — |
| [ ] | Create_quote_request_without_access_token | suite | `POST /carts/$` → 403 | — | M | — |
| [ ] | Retrieve_quote_request_by_id_with_incorrect_url | suite | `PATCH /quote-requests/test123` → 404 | — | M | — |
| [ ] | Retrieve_quote_request_with_incorrect_id | suite | `POST /carts` → 404 | — | M | — |
| [ ] | Retrieve_quote_requests_with_incorrect_url | suite | `DELETE /carts/$` → 404 | — | M | — |
| [ ] | Retrieve_quote_requests_with_invalid_access_token | suite | `DELETE /carts/$` → 401 | — | M | — |
| [ ] | Retrieve_quote_requests_without_token | suite | `PATCH /quote-requests/` → 403 | — | S | — |
| [ ] | Update_quote_request_with_another_user_token | suite | `DELETE /carts/$` → 201 | — | M | — |
| [ ] | Update_quote_request_with_empty_cart_id | suite | `POST /carts/$` → 201 | — | M | — |
| [ ] | Update_quote_request_with_empty_id | suite | `POST /carts` → 400 | — | M | — |
| [ ] | Update_quote_request_with_empty_type | suite | `DELETE /carts/$` → 201 | — | M | — |
| [ ] | Update_quote_request_with_incorrect_id | suite | `PATCH /quote-requests/$` → 404 | — | M | — |
| [ ] | Update_quote_request_without_token | suite | `DELETE /carts/$` → 201 | — | M | — |
| [ ] | Retrieve_quote_request_version | suite | `GET /quote-requests/$` → 201 | — | M | — |
| [ ] | Retrieves_quote_request_by_requestId | suite | `GET /quote-requests/$` → 201 | — | M | — |
| [ ] | Update_quote_request | suite | `PATCH /quote-requests/$` → 201 | — | M | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Update_quote_request_with_invalid_cart_id | drop | Glue already asserts POST /quote-requests -> 201 in QuoteRequestsRestApiCest::testShouldCreateQuoteRequest. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_quote_request_with_invalid_type | drop | Glue already asserts POST /quote-requests -> 201 in QuoteRequestsRestApiCest::testShouldCreateQuoteRequest. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_quote_request | drop | Glue already asserts POST /quote-requests -> 201 in QuoteRequestsRestApiCest::testShouldCreateQuoteRequest. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_quote_request_for_cart_with_full_access_permissions | drop | Glue already asserts POST /quote-requests -> 201 in QuoteRequestsRestApiCest::testShouldCreateQuoteRequest. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_quote_request_with_empty_meta_data | drop | Glue already asserts POST /quote-requests -> 201 in QuoteRequestsRestApiCest::testShouldCreateQuoteRequest. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_quote_request_with_included_customers_&_comapny_users_&_company_business_units_and_concrete_products | drop | Glue already asserts POST /quote-requests -> 201 in QuoteRequestsRestApiCest::testShouldCreateQuoteRequest. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_quote_request_without_delivery_date_and_note | drop | Glue already asserts POST /quote-requests -> 201 in QuoteRequestsRestApiCest::testShouldCreateQuoteRequest. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieves_quote_request_list | drop | Glue already asserts GET /quote-requests -> 200 in QuoteRequestsRestApiCest::testShouldGetPaginatedQuoteRequests. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieves_quote_request_list_when_no_RFQ | drop | Glue already asserts GET /quote-requests -> 200 in QuoteRequestsRestApiCest::testShouldGetPaginatedQuoteRequests. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
