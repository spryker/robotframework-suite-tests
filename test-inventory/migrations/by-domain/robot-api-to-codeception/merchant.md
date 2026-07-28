### merchant · robot-api-to-codeception · 11 scenarios

MIGRATE 11   ▸ 0/11 ported

Batches: `merchant`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Retrieves_merchant_with_non_existent_id | mp_b2c | `GET /merchants/NonExistId` → 404 | — | S | — |
| [ ] | Retrieves_merchant_addresses_by_non_exist_merchant_id | ×3 | `GET /merchants//merchant-addresses` → 404 | — | S | — |
| [ ] | Retrieves_merchant_addresses_witout_pass_merchant_id | ×3 | `GET /merchants//merchant-addresses` → 400 | — | S | — |
| [ ] | Retrieves_merchant_addresses | ×3 | `GET /merchants/$` → 200 | — | S | — |
| [ ] | Retrieves_merchant_with_include_merchant_addresses | ×3 | `GET /merchants/$` → 200 | — | S | — |
| [ ] | Retrieves_merchant_opening_hours_by_non_exist_merchant_id | ×3 | `GET /merchants//merchant-opening-hours` → 404 | — | S | — |
| [ ] | Retrieves_merchant_opening_hours | ×3 | `GET /merchants/$` → 200 | — | S | — |
| [ ] | Retrieves_merchant_with_include_merchant_opening_hours | ×3 | `GET /merchants/$` → 200 | — | S | — |
| [ ] | Retrieves_merchant_by_non_exist_id | ×2 | `GET /merchants/NonExistId` → 404 | — | S | — |
| [ ] | Retrieves_a_merchant_by_id | ×3 | `GET /merchants/$` → 200 | — | S | — |
| [ ] | Retrieves_list_of_merchants | ×3 | `GET /merchants/$` → 200 | — | S | — |
