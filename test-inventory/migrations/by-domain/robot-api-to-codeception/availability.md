### availability · robot-api-to-codeception · 22 scenarios

MIGRATE 21 · REVIEW 1   ▸ 0/21 verified

Batches: `availability`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Retrieves_my_availability_notifications_without_auth_token | b2c | `GET /my-availability-notifications` → 403 | — | S | — |
| [ ] | Subscribe_to_availability_notifications_with_non_existent_sku | mp_b2b | `DELETE /availability-notifications/$` → 404 | — | S | — |
| [ ] | Delete_availability_notifications_with_invalid_availability_notification_id | ×5 | `DELETE /availability-notifications/$` → 201 | — | S | — |
| [ ] | Delete_availability_notifications_without_availability_notification_id | ×5 | `DELETE /availability-notifications/$` → 201 | — | S | — |
| [ ] | Get_availability_notifications_with_invalid_access_token | ×5 | `POST /availability-notifications` → 201 | — | S | — |
| [ ] | Get_availability_notifications_without_access_token | ×5 | `POST /availability-notifications` → 201 | — | S | — |
| [ ] | Get_availability_notifications_without_customerId | ×5 | `POST /availability-notifications` → 201 | — | M | — |
| [ ] | Subscribe_to_availability_notifications_with_empty_sku_and_email | ×5 | `POST /availability-notifications` → 422 | — | S | — |
| [ ] | Subscribe_to_availability_notifications_with_empty_type | ×4 | `POST /availability-notifications` → 400 | — | S | — |
| [ ] | Subscribe_to_availability_notifications_with_existing_subscription | ×5 | `DELETE /availability-notifications/$` → 201 | — | S | — |
| [ ] | Subscribe_to_availability_notifications_with_invalid_email | ×5 | `DELETE /availability-notifications/7fc6ebf` → 422 | — | S | — |
| [ ] | Subscribe_to_availability_notifications_with_invalid_sku | ×4 | `DELETE /availability-notifications/$` → 404 | — | S | — |
| [ ] | Subscribe_to_availability_notifications_without_sku_and_email | ×5 | `DELETE /availability-notifications/$` → 422 | — | S | — |
| [ ] | Subscribe_to_availability_notifications_without_type | ×4 | `POST /availability-notifications` → 400 | — | S | — |
| [ ] | Delete_availability_notifications_for_customer | ×5 | `GET /customers/$` → 201 | — | M | — |
| [ ] | Get_availability_notifications_for_customer | ×5 | `POST /availability-notifications` → 201 | — | M | — |
| [ ] | Subscribe_to_availability_notifications_for_customer | ×5 | `GET /customers/$` → 201 | — | S | — |
| [ ] | Subscribe_to_availability_notifications_with_non_existing_email | ×5 | `GET /customers/$` → 201 | — | S | — |
| [ ] | Retrieves_my_availability_notifications_with_invalid_auth_token | ×5 | `GET /my-availability-notifications` → 401 | — | S | — |
| [ ] | Retrieves_my_availability_notifications_with_missing_auth_token | ×4 | `GET /my-availability-notifications` → 403 | — | S | — |
| [ ] | Get_my_availability_notifications | ×5 | `DELETE /availability-notifications/$` → 201 | — | M | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Get_empty_list_of_availability_notifications_for_customer | drop | Glue already asserts GET /customers/{id} -> 200 in CustomerReadCest::requestGetCustomerByIdReturnsOneResource. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
