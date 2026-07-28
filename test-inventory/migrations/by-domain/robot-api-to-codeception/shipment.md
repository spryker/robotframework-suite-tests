### shipment · robot-api-to-codeception · 32 scenarios

MIGRATE 21 · REVIEW 11   ▸ 0/21 ported

Batches: `shipment`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Retrive_list_of_shipment_types_with_valid_token_and_pagination | mp_b2c | `POST /shipment-types` → 200 | — | S | — |
| [ ] | Retrive_single_shipment_type_with_valid_token | mp_b2c | `POST /shipment-types` → 201 | — | S | — |
| [ ] | Update_sipment_type_change_name_store_relation_and_deactivate | mp_b2c | `GET /shipment-types?page[offset]=0&page[limit]=2` → 201 | — | S | — |
| [ ] | Create_shipment_type_with_already_used_key | ×2 | `PATCH /shipment-types/not-existing-key` → 400 | — | S | — |
| [ ] | Create_shipment_type_with_empty_body | ×2 | `POST /shipment-types` → 400 | — | S | — |
| [ ] | Create_shipment_type_with_empty_key_in_request | ×2 | `PATCH /shipment-types` → 400 | — | S | — |
| [ ] | Create_shipment_type_with_empty_token | ×2 | `PATCH /shipment-types/$` → 401 | — | S | — |
| [ ] | Create_shipment_type_with_incorrect_token | ×2 | `PATCH /shipment-types/$` → 401 | — | S | — |
| [ ] | Create_shipment_type_with_incorrect_type_in_body | ×2 | `POST /shipment-types` → 400 | — | S | — |
| [ ] | Create_shipment_type_without_key_in_request | ×2 | `PATCH /shipment-types` → 400 | — | S | — |
| [ ] | Retrieve_list_of_shipment_types_without_auth | ×2 | `GET /shipment-types/$` → 401 | — | S | — |
| [ ] | Retrieve_list_of_shipment_types_witt_incorrect_token | ×2 | `GET /shipment-types/$` → 401 | — | S | — |
| [ ] | Retrieve_single_shipment_type_with_incorrect_token | ×2 | `GET /shipment-types/$` → 401 | — | S | — |
| [ ] | Retrieve_single_shipment_type_without_auth | ×2 | `GET /shipment-types/$` → 401 | — | S | — |
| [ ] | Update_shipment_type_with_incorrect_token | ×2 | `GET /shipment-types/` → 401 | — | S | — |
| [ ] | Update_shipment_type_without_token | ×2 | `GET /shipment-types/incorrect_id` → 401 | — | S | — |
| [ ] | Create_new_shipment_type_with_existing_name | ×2 | `POST /shipment-types` → 201 | — | S | — |
| [ ] | Create_shipment_type | ×2 | `POST /shipment-types` → 201 | — | S | — |
| [ ] | Retrieve_list_of_shipment_types_with_valid_token_and_pagination | suite | `POST /shipment-types` → 200 | — | S | — |
| [ ] | Retrieve_single_shipment_type_with_valid_token | suite | `POST /shipment-types` → 201 | — | S | — |
| [ ] | Update_shipment_type_change_name_store_relation_and_deactivate | suite | `GET /shipment-types?page[offset]=0&page[limit]=2` → 201 | — | S | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Update_sipment_type_with_not_existing_key | drop | Glue already asserts GET /shipment-types/{id} -> 404 in ShipmentTypesRestApiCest::requestGetShipmentTypeByUndefinedUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrive_list_of_shipment_types_with_filtering | drop | Glue already asserts GET /shipment-types -> 200 in ShipmentTypesRestApiCest::requestGetShipmentTypes. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrive_list_of_shipment_types_with_sorting_by_key_ASC | drop | Glue already asserts GET /shipment-types -> 200 in ShipmentTypesRestApiCest::requestGetShipmentTypes. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrive_list_of_shipment_types_with_sorting_by_key_DESC | drop | Glue already asserts GET /shipment-types -> 200 in ShipmentTypesRestApiCest::requestGetShipmentTypes. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieve_single_shipment_type_with_incorrect_id | drop | Glue already asserts GET /shipment-types/{id} -> 404 in ShipmentTypesRestApiCest::requestGetShipmentTypeByUndefinedUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_shipment_type_with_empty_key | drop | Glue already asserts GET /shipment-types/{id} -> 404 in ShipmentTypesRestApiCest::requestGetShipmentTypeByUndefinedUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_shipment_type_with_not_existing_key | drop | Glue already asserts GET /shipment-types/{id} -> 404 in ShipmentTypesRestApiCest::requestGetShipmentTypeByUndefinedUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_shipment_type_without_key | drop | Glue already asserts GET /shipment-types/{id} -> 404 in ShipmentTypesRestApiCest::requestGetShipmentTypeByUndefinedUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieve_list_of_shipment_types_with_filtering | drop | Glue already asserts GET /shipment-types -> 200 in ShipmentTypesRestApiCest::requestGetShipmentTypes. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieve_list_of_shipment_types_with_sorting_by_key_ASC | drop | Glue already asserts GET /shipment-types -> 200 in ShipmentTypesRestApiCest::requestGetShipmentTypes. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieve_list_of_shipment_types_with_sorting_by_key_DESC | drop | Glue already asserts GET /shipment-types -> 200 in ShipmentTypesRestApiCest::requestGetShipmentTypes. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
