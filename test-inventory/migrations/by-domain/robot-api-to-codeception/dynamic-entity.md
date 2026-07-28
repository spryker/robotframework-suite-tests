### dynamic-entity · robot-api-to-codeception · 59 scenarios

MIGRATE 56 · UNDECIDED 3   ▸ 0/56 ported

Batches: `dynamic-entity-1`, `dynamic-entity-2`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Create_product_abstract_collection_with_child_contained_invalid_field: | ×5 | `POST /dynamic-entity/robot-tests-product-abstracts` → 400 | — | S | — |
| [ ] | Create_product_abstract_collection_with_child_contained_invalid_field_non_transactional: | ×5 | `POST /dynamic-entity/robot-tests-product-abstracts` → 400 | — | S | — |
| [ ] | Create_product_abstract_collection_with_correct_child_and_child_contained_invalid_field_non_transactional: | ×5 | `POST /dynamic-entity/robot-tests-product-abstracts` → 201 | — | S | — |
| [ ] | Create_product_abstract_collection_with_invalid_child: | ×5 | `POST /dynamic-entity/robot-tests-product-abstracts` | — | S | — |
| [ ] | Delete_country_collection_with_existing_child_entity | ×5 | `DELETE /dynamic-entity/robot-test-countries?filter[countries.iso2_code]=` → 201 | — | S | — |
| [ ] | Delete_product_abstract_by_id_with_existing_child_entity: | ×5 | `GET /dynamic-entity/robot-tests-product-abstracts/$` → 201 | — | S | — |
| [ ] | Delete_product_abstract_collection_with_existing_child_entity: | ×5 | `DELETE /dynamic-entity/robot-tests-product-abstracts?filter[product-abstracts.sku]=` → 200 | — | S | — |
| [ ] | Update_product_abstract_collection_with_child_contained_invalid_field: | ×5 | `PATCH /dynamic-entity/robot-tests-product-abstracts` → 201 | — | S | — |
| [ ] | Update_product_abstract_collection_with_invalid_child: | ×5 | `PATCH /dynamic-entity/robot-tests-product-abstracts` → 201 | — | S | — |
| [ ] | Update_product_abstract_collection_with_missing_required_field: | ×5 | `PATCH /dynamic-entity/robot-tests-product-abstracts` → 201 | — | S | — |
| [ ] | Upsert_product_abstract_collection_with_child_contained_invalid_field: | ×5 | `PUT /dynamic-entity/robot-tests-product-abstracts` → 201 | — | S | — |
| [ ] | Upsert_product_abstract_collection_with_invalid_child: | ×5 | `PUT /dynamic-entity/robot-tests-product-abstracts` → 201 | — | S | — |
| [ ] | Upsert_product_abstract_collection_with_missing_required_field: | ×5 | `PUT /dynamic-entity/robot-tests-product-abstracts` → 201 | — | S | — |
| [ ] | Create_and_update_product_abstract_collection_with_product_abstract_localized_attributes: | suite | `POST /dynamic-entity/robot-tests-product-abstracts` | — | S | — |
| [ ] | Create_country_with_empty_body | ×5 | `POST /dynamic-entity/countries` → 400 | — | S | — |
| [ ] | Create_country_with_empty_data | ×5 | `POST /dynamic-entity/robot-test-countries` → 400 | — | S | — |
| [ ] | Create_country_with_empty_json | ×5 | `POST /dynamic-entity/countries` → 400 | — | S | — |
| [ ] | Create_country_with_invalid_data | ×5 | `POST /dynamic-entity/robot-test-countries` → 400 | — | S | — |
| [ ] | Create_country_with_invalid_data_non_transactional | ×5 | `POST /dynamic-entity/robot-test-countries` → 400 | — | S | — |
| [ ] | Create_country_with_invalid_field | ×5 | `POST /dynamic-entity/robot-test-countries` → 400 | — | S | — |
| [ ] | Create_country_with_invalid_field_value | ×5 | `POST /dynamic-entity/robot-test-countries` → 400 | — | S | — |
| [ ] | Create_country_with_invalid_resource_name | ×5 | `POST /dynamic-entity/robot-test-countries` → 404 | — | S | — |
| [ ] | Create_country_with_valid_and_invalid_data_non_transactional | ×5 | `GET /dynamic-entity/robot-test-countries/$` → 201 | — | S | — |
| [ ] | Create_url_with_invalid_url_name | ×5 | `PATCH /dynamic-entity/robot-test-urls` → 400 | — | S | — |
| [ ] | Delete_country_by_id_is_deletable_false: | ×5 | `DELETE /dynamic-entity/robot-test-countries/$` → 201 | — | S | — |
| [ ] | Delete_country_by_id_is_deletable_null: | ×5 | `DELETE /dynamic-entity/robot-test-countries/$` → 201 | — | S | — |
| [ ] | Delete_country_by_id_without_is_deletable: | ×5 | `DELETE /dynamic-entity/robot-test-countries/$` → 201 | — | S | — |
| [ ] | Get_list_of_country_with_invalid_id | ×5 | `POST /dynamic-entity/countries` → 404 | — | S | — |
| [ ] | Get_list_of_country_with_invalid_resource_name | ×5 | `GET /dynamic-entity/countries/9999999` → 404 | — | S | — |
| [ ] | Get_list_of_country_with_invalid_resource_prefix | ×5 | `GET /dynamic-entity/invalid-resource` → 404 | — | S | — |
| [ ] | Get_list_of_country_with_invalid_token | ×5 | `GET /dynamic-entity-invalid/robot-test-countries` → 401 | — | S | — |
| [ ] | Update_country_collection_with_invalid_data | ×5 | `PATCH /dynamic-entity/robot-test-countries` → 201 | — | S | — |
| [ ] | Update_country_with_invalid_data | ×5 | `PATCH /dynamic-entity/robot-test-countries/$` → 201 | — | S | — |
| [ ] | Update_country_with_invalid_field | ×5 | `PATCH /dynamic-entity/robot-test-countries/$` → 201 | — | S | — |
| [ ] | Update_country_with_invalid_field_type | ×5 | `PATCH /dynamic-entity/robot-test-countries/$` → 201 | — | S | — |
| [ ] | Update_url_with_invalid_url_name | ×5 | `POST /dynamic-entity/robot-test-countries` → 400 | — | S | — |
| [ ] | Upsert_with_invalid_id | ×5 | `POST /dynamic-entity/robot-test-countries` → 400 | — | S | — |
| [ ] | Authorization_by_x_api_key | ×5 | `PATCH /dynamic-entity/stock-products/$` → 200 | — | S | — |
| [ ] | Availability_recalculation_after_stock_update | ×5 | `PATCH /dynamic-entity/stock-products/$` → 200 | — | M | — |
| [ ] | Create_and_update_country: | ×5 | `PATCH /dynamic-entity/robot-test-countries/$` → 201 | — | S | — |
| [ ] | Create_and_update_url: | ×5 | `GET /dynamic-entity/robot-test-urls/$` → 201 | — | S | — |
| [ ] | Create_country_collection: | ×5 | `PATCH /dynamic-entity/robot-test-countries` → 201 | — | S | — |
| [ ] | Create_country_collection_non_transactional: | ×5 | `PATCH /dynamic-entity/robot-test-countries` → 201 | — | S | — |
| [ ] | Delete_country_by_id: | ×5 | `GET /dynamic-entity/categories` → 201 | — | S | — |
| [ ] | Delete_country_collection: | ×5 | `DELETE /dynamic-entity/robot-test-countries?filter[countries.iso2_code]=` → 201 | — | S | — |
| [ ] | Get_country_Collection_with_filter_first_item | ×5 | `GET /dynamic-entity/robot-test-countries?filter[country.iso2_code]=UA` → 200 | — | S | — |
| [ ] | Get_country_by_id | ×5 | `GET /dynamic-entity/robot-test-countries/1` → 200 | — | S | — |
| [ ] | Get_country_collection | ×5 | `GET /dynamic-entity/robot-test-countries` → 200 | — | S | — |
| [ ] | Get_country_collection_with_filter | ×5 | `GET /dynamic-entity/robot-test-countries?filter[countries.iso2_code]=` → 200 | — | S | — |
| [ ] | Get_country_collection_with_filter_in_condition | ×5 | `GET /dynamic-entity/robot-test-countries?filter[countries.iso2_code]=` → 200 | — | S | — |
| [ ] | Get_country_collection_with_invalid_multiple_filter | ×5 | `GET /dynamic-entity/robot-test-countries?page[offset]=234&page[limit]=2` → 200 | — | S | — |
| [ ] | Get_country_collection_with_multiple_filter_fields | ×5 | `GET /dynamic-entity/robot-test-countries?filter[countries.iso2_code]=` → 200 | — | S | — |
| [ ] | Get_country_collection_with_paginations | ×5 | `GET /dynamic-entity/robot-test-countries?page[offset]=500&page[limit]=10` → 200 | — | S | — |
| [ ] | Get_country_collection_with_paginations_out_of_items | ×5 | `GET /dynamic-entity/robot-test-countries` → 200 | — | S | — |
| [ ] | Get_country_collection_with_short_configuration | ×5 | `GET /dynamic-entity/robot-test-cou` → 200 | — | S | — |
| [ ] | Upsert_country_collection: | ×5 | `GET /dynamic-entity/robot-test-countries/$` → 201 | — | S | — |

#### UNDECIDED — no verdict yet
| Scenario | Contract | Eff |
|---|---|---|
| Get_product_abstract_collection_with_invalid_query_parameter: | — | S |
| Create_and_publish_complex_product_with_child_relations: | — | M |
| Upsert_product_abstract_collection_with_child: | — | S |
