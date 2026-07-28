### platform · robot-api-to-codeception · 21 scenarios

MIGRATE 11 · REVIEW 10   ▸ 0/11 verified

Batches: `platform`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Get_all_available_stores | ×5 | `GET /stores` → 200 | — | S | — |
| [ ] | Get_store_by_id | ×5 | `GET /stores/$` → 200 | — | S | — |
| [ ] | Get_health_check_with_disabled_services | ×4 | `GET /health-check/1` → 403 | — | S | — |
| [ ] | Get_health_check_with_empty_service_name | ×4 | `GET /health-check/1` → 400 | — | S | — |
| [ ] | Get_health_check_with_invalid_service_name | ×4 | `GET /health-check/1` → 400 | — | S | — |
| [ ] | Get_store_by_id_dms_on | ×4 | `GET /stores/$` → 200 | — | S | — |
| [ ] | Get_all_available_stores_dms_on | ×4 | `GET /stores/$` → 200 | — | S | — |
| [ ] | Get_store_by_non_exist_id | ×5 | `GET /stores/NON_EXIST_STORE` → 404 | — | S | — |
| [ ] | DMS_Get_all_available_stores | suite | `GET /stores/$` → 200 | — | S | — |
| [ ] | DMS_Get_store_by_id | suite | `GET /stores/$` → 200 | — | S | — |
| [ ] | Get_all_availiable_stores | ×2 | `GET /stores/$` → 200 | — | S | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Get_absent_url_collections | drop | Glue already asserts GET /url-resolver -> 422 in UrlsRestApiCest::requestUrlWithoutUrlParameter. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_url_collection_by_non_exist_url | drop | Glue already asserts GET /url-resolver -> 404 in UrlsRestApiCest::requestNonExistingUrl. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_url_collections_by_url_paramater | drop | Glue already asserts GET /url-resolver -> 200 in UrlsRestApiCest::requestExistingProductAbstractUrl. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_url_collection_by_empty_url | drop | Glue already asserts GET /url-resolver -> 422 in UrlsRestApiCest::requestUrlWithoutUrlParameter. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_url_collection_when_requested_url_does_not_exist | drop | Glue already asserts GET /url-resolver -> 404 in UrlsRestApiCest::requestNonExistingUrl. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_url_collections_by_url_paramater_of_category_nodes | drop | Glue already asserts GET /url-resolver -> 200 in UrlsRestApiCest::requestExistingProductAbstractUrl. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_url_collections_by_url_paramater_of_cms_page | drop | Glue already asserts GET /url-resolver -> 200 in UrlsRestApiCest::requestExistingProductAbstractUrl. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_url_collections_by_url_paramater_of_merchant_page | drop | Glue already asserts GET /url-resolver -> 200 in UrlsRestApiCest::requestExistingProductAbstractUrl. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_url_collections_by_url_paramater_of_product | drop | Glue already asserts GET /url-resolver -> 200 in UrlsRestApiCest::requestExistingProductAbstractUrl. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_url_collections_by_url_parameters_returns_id | drop | Glue already asserts GET /url-resolver -> 200 in UrlsRestApiCest::requestExistingProductAbstractUrl. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
