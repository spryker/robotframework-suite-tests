### shopping-list · robot-api-to-codeception · 117 scenarios

MIGRATE 111 · REVIEW 6   ▸ 0/111 verified

Batches: `shopping-list-1`, `shopping-list-2`, `shopping-list-3`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Add_aconfigurable_product_with_missing_availableQuantity_value_of_to_the_shopping_list | ×2 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Update_product_quntity_at_the_shopping_list_to_a_negative_number | b2b | `PATCH ...` → 422 | — | M | — |
| [ ] | Update_product_quntity_at_the_shopping_list_to_non_digit_value | ×3 | `PATCH ...` → 422 | — | M | — |
| [ ] | Update_product_quntity_at_the_shopping_list_to_not_allowed_qty | b2b | `PATCH /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId` → 422 | — | M | — |
| [ ] | Add_a_concrete_product_with_random_weight_to_the_shopping_list | b2b | `POST ...` → 201 | — | M | — |
| [ ] | Update_a_shopping_list_name_with_includes | ×3 | `GET /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_concrete_product_invalid_data_for_quantity_to_the_shopping_list | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_concrete_product_to_the_shared_shopping_list_without_write_access_permission | ×3 | `PATCH /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId` → 403 | — | M | — |
| [ ] | Add_a_concrete_product_to_the_shopping_list_with_empty_request_body | ×3 | `GET /shopping-lists/` → 201 | — | M | — |
| [ ] | Add_a_concrete_product_to_the_shopping_list_with_wrong_access_token | ×3 | `POST /shopping-lists/$` → 401 | — | M | — |
| [ ] | Add_a_concrete_product_to_the_shopping_list_without_access_token | ×3 | `POST /shopping-lists` → 403 | — | S | — |
| [ ] | Add_a_concrete_product_with_empty_sku_value_to_the_shopping_list | ×3 | `POST /shopping-lists` → 201 | — | M | — |
| [ ] | Add_a_concrete_product_with_empty_type_in_request_to_the_shopping_list | ×3 | `PATCH /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId` → 201 | — | M | — |
| [ ] | Add_a_concrete_product_without_quantity_to_the_shopping_list | ×3 | `POST /shopping-lists/shopping-list-items` → 201 | — | M | — |
| [ ] | Add_a_concrete_product_without_shopping_list_id_to_the_shopping_list | ×3 | `DELETE /shopp` → 404 | — | M | — |
| [ ] | Add_a_concrete_product_without_sku_to_the_shopping_list | ×3 | `POST /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_concrete_product_without_type_in_request_to_the_shopping_list | ×3 | `PATCH /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_to_the_shopping_list_with_missing_price | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_empty_availableQuantity_value_of_to_the_shopping_list | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_empty_price_value_of_to_the_shopping_list | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_empty_quantity_value_of_to_the_shopping_list | ×3 | `POST /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_missing_availableQuantity_value_of_to_the_shopping_list | suite | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_missing_isComplete_value_of_to_the_shopping_list | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_missing_quantity_to_the_shopping_list | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_negative_price_value_of_to_the_shopping_list | ×3 | `POST /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_negative_quantity_to_the_shopping_list | ×3 | `POST /shopping-lists` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_numeric_isComplete_value_of_to_the_shopping_list | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_string_isComplete_value_of_to_the_shopping_list | ×3 | `POST /sho` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_string_quantity_to_the_shopping_list | ×3 | `POST /shopping-lists` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_zero_quantity_to_the_shopping_list | ×3 | `POST /shopping-lists` → 201 | — | M | — |
| [ ] | Add_a_non-configurable_product_to_the_shopping_list_with_configuration | ×3 | `POST /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_non-configurable_product_to_the_shopping_list_with_configuration_and_configurable_product | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_product_to_the_non_existing_shopping_list | ×3 | `POST /shopping-lists/$` → 404 | — | M | — |
| [ ] | Add_a_product_with_empty_quantity_value_of_to_the_shopping_list | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_product_with_negaive_quantity_to_the_shopping_list | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_product_with_non_existing_sku_to_the_shopping_list | ×3 | `POST /shopping-lists` → 201 | — | M | — |
| [ ] | Add_a_product_with_zero_quantity_to_the_shopping_list | ×3 | `POST /shopping-lists` → 201 | — | M | — |
| [ ] | Add_aconfigurable_product_with_string_availableQuantity_value_of_to_the_shopping_list | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_an_abstract_product_to_the_shopping_list | ×3 | `POST /shopping-lists` → 201 | — | M | — |
| [ ] | Add_too_big_amount_of_concrete_product_to_the_shopping_list | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Change_quantity_of_a_concrete_product_at_the_shared_shopping_list_without_write_access_permission | ×3 | `POST /shopping-lists` → 201 | — | M | — |
| [ ] | Remove_a_concrete_product_from_the_shared_shopping_list_without_write_access_permission | ×3 | `DELETE /shopping-lists/$` → 200 | — | M | — |
| [ ] | Remove_a_product_from_the_non_existing_shopping_list | ×3 | `DELETE /shoppin` → 404 | — | M | — |
| [ ] | Remove_a_product_from_the_shopping_list_with_wrong_access_token | ×3 | `GET /shopping-lists/` → 401 | — | M | — |
| [ ] | Remove_a_product_from_the_shopping_list_without_access_token | ×3 | `DELETE /shopping-lists/shoppingListId/shopping-list-items/` → 403 | — | S | — |
| [ ] | Remove_a_product_from_the_shopping_list_without_shopping_list_id_in_url | ×3 | `POST /shopping-lists/$` → 400 | — | M | — |
| [ ] | Remove_a_product_from_the_shopping_list_without_shopping_list_item_id_in_url | ×3 | `POST /shopping-lists/$` → 400 | — | M | — |
| [ ] | Remove_a_product_with_non_existing_id_from_the_shopping_list | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Update_product_at_the_shopping_list_with_empty_type_in_request | ×3 | `DELETE /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId` → 400 | — | M | — |
| [ ] | Update_product_at_the_shopping_list_without_type_in_request | ×3 | `DELETE /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId` → 400 | — | M | — |
| [ ] | Update_product_in_the_non_existing_shopping_list | ×3 | `PATCH /shopping-lists/shoppingListId/shopping-list-items/` → 404 | — | M | — |
| [ ] | Update_product_in_the_shopping_list_with_empty_request_body | ×3 | `DELETE /shopping-lists/$` → 400 | — | M | — |
| [ ] | Update_product_in_the_shopping_list_withot_shopping_list_id | ×3 | `PATCH /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId` → 400 | — | M | — |
| [ ] | Update_product_in_the_shopping_list_withot_shopping_list_item_id | ×3 | `POST /shopping-lists/$` → 400 | — | M | — |
| [ ] | Update_product_in_the_shopping_list_without_quantity_in_the_request | ×3 | `PATCH /shopping-lists/$` → 422 | — | M | — |
| [ ] | Update_product_to_the_shopping_list_with_wrong_access_token | ×3 | `PATCH /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId` → 401 | — | M | — |
| [ ] | Update_product_to_the_shopping_list_without_access_token | ×3 | `PATCH /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId` → 403 | — | S | — |
| [ ] | Update_quantity_of_the_product_at_the_shopping_list_to_zero | ×3 | `PATCH /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId` → 422 | — | M | — |
| [ ] | Add_2_Configurable_products_but_with_different_configurations | ×3 | `GET /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_Configurable_products_and_regular_product | ×3 | `POST /shopping-lists` → 201 | — | M | — |
| [ ] | Add_a_bundle_concrete_product_to_the_shopping_list_with_includes | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_concrete_product_to_the_shared_shopping_list | ×3 | `POST /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_concrete_product_to_the_shopping_list | ×3 | `GET /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_concrete_product_to_the_shopping_list_with_includes | ×3 | `POST /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_to_the_shopping_list | ×3 | `POST /shopping-lists` → 201 | — | M | — |
| [ ] | Add_an_unavailable_product_to_the_shopping_list | ×3 | `PATCH /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_one_more_product_to_the_shopping_list | ×3 | `POST /shopping-lists/$` → 201 | — | M | — |
| [ ] | Add_the_same_product_to_the_shopping_list | ×3 | `POST /shopping-lists/$` → 201 | — | M | — |
| [ ] | Change_preferred_date_of_the_configurable_product_in_the_shopping_list | ×3 | `POST /shopping-lists/$` → 201 | — | M | — |
| [ ] | Change_preferred_time_of_the_day_of_the_configurable_product_in_the_shopping_list | ×3 | `POST /shopping-lists` → 201 | — | M | — |
| [ ] | Change_quantity_of_a_concrete_product_at_the_shared_shopping_list | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Change_quantity_of_the_bundle_concrete_product_in_the_shopping_list | ×3 | `POST /shopping-lists/$` → 201 | — | M | — |
| [ ] | Change_quantity_of_the_bundle_concrete_product_in_the_shopping_list_with_includes | ×3 | `POST /shopping-lists/$` → 201 | — | M | — |
| [ ] | Change_quantity_of_the_concrete_product_in_the_shopping_list | ×3 | `POST /shopping-lists` → 201 | — | M | — |
| [ ] | Change_quantity_of_the_concrete_product_in_the_shopping_list_with_includes | ×3 | `POST /shopping-lists` → 201 | — | M | — |
| [ ] | Change_the_quantity_of_the_Configured_Product_so_Volume_price_is_applied | ×3 | `POST /shopping-lists/$` → 201 | — | M | — |
| [ ] | Remove_a_bundle_concrete_product_from_the_shopping_list | ×3 | `POST /shopping-lists/$` → 201 | — | M | — |
| [ ] | Remove_a_concrete_product_from_the_shopping_list | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Remove_a_configurable_product_from_the_shopping_list | ×3 | `POST /shopping-lists/$` → 201 | — | M | — |
| [ ] | Remove_a_configurable_product_from_the_shopping_list_and_leave_a_regular_product | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Set_configuration_for_the_configurable_product_in_the_shopping_list | ×3 | `POST /shopping-lists` → 201 | — | M | — |
| [ ] | Create_a_shopping_list_with_absent_type | ×3 | `DELETE /shopping-lists/$` → 400 | — | S | — |
| [ ] | Create_a_shopping_list_with_already_existing_name | ×3 | `DELETE /shopping-lists/shoppingListId` → 422 | — | M | — |
| [ ] | Create_a_shopping_list_with_empty_type | ×3 | `POST /shopping-lists` → 400 | — | S | — |
| [ ] | Create_a_shopping_list_with_empty_values_for_required_fields | ×3 | `POST /shopping-lists` → 422 | — | M | — |
| [ ] | Create_a_shopping_list_with_non_autorized_user | ×3 | `DELETE /shopping-lists/test12345` → 403 | — | S | — |
| [ ] | Create_a_shopping_list_with_too_long_name | ×3 | `DELETE /shopping-lists` → 422 | — | M | — |
| [ ] | Delete_a_shopping_list_withouth_shopping_list_id | ×3 | `PATCH /shopping-lists/shoppingListId` → 400 | — | S | — |
| [ ] | Delete_existing_shopping_list_of_another_customer | ×3 | `PATCH /shopping-lists/$` → 404 | — | M | — |
| [ ] | Delete_not_existing_shopping_list | ×3 | `PATCH /shopping-lists/$` → 404 | — | M | — |
| [ ] | Delete_shopping_list_with_wrong_access_token | ×3 | `PATCH /shopping-lists/shoppingListId` → 401 | — | M | — |
| [ ] | Delete_shopping_list_without_access_token | ×3 | `PATCH /shopping-lists/shoppingListId` → 403 | — | S | — |
| [ ] | Get_existing_shopping_list_with_wrong_access_token | ×3 | `GET /shopping-lists/shoppingListId` → 401 | — | M | — |
| [ ] | Get_shopping_list_with_non_autorized_user | ×3 | `GET /shopping-lists/shoppingListId` → 403 | — | S | — |
| [ ] | Update_a_shopping_list_with_absent_type | ×3 | `GET /shopping-lists/shoppingListId` → 400 | — | S | — |
| [ ] | Update_a_shopping_list_with_invalid_type | ×3 | `GET /shopping-lists/shoppingListId` → 400 | — | S | — |
| [ ] | Update_shopping_list_for_the_customer_with_empty_attribute_section | ×3 | `PATCH /shopping-lists/` → 422 | — | M | — |
| [ ] | Update_shopping_list_name_with_too_long_value | ×3 | `PATCH /shopping-lists/shoppingListId` → 422 | — | M | — |
| [ ] | Update_shopping_list_with_empty_name | ×3 | `GET /shopping-lists` → 422 | — | M | — |
| [ ] | Update_shopping_list_with_existing_name_of_another_available_shopping_list | ×3 | `PATCH /shopping-lists/shoppingListId` → 422 | — | M | — |
| [ ] | Update_shopping_list_with_non_autorized_user | ×3 | `GET /shopping-lists/$` → 403 | — | S | — |
| [ ] | Update_shopping_list_with_wrong_shopping_list_id | ×3 | `GET /shopping-lists/test12345` → 404 | — | M | — |
| [ ] | Update_shopping_list_withouth_shopping_list_id | ×3 | `GET /shopping-lists/shoppingListId` → 400 | — | M | — |
| [ ] | Create_a_shopping_list | ×3 | `POST /shopping-lists` → 201 | — | M | — |
| [ ] | Delete_a_shopping_list | ×3 | `POST /shopping-lists/$` → 201 | — | M | — |
| [ ] | Get_a_shopping_list_info | ×3 | `DELETE /shopping-lists/$` → 201 | — | M | — |
| [ ] | Get_several_shopping_lists_info | ×3 | `GET /shopping-lists` → 201 | — | M | — |
| [ ] | Get_shopping_lists_info_with_non_zero_quantity_of_number_of_items | ×3 | `GET /shopping-lists/$` → 201 | — | M | — |
| [ ] | Get_single_shopping_list_info_with_includes | ×3 | `GET /shopping-lists?include=shopping-list-items,concrete-products` → 201 | — | M | — |
| [ ] | Update_a_shopping_list | ×3 | `PATCH /shopping-lists/$` → 201 | — | M | — |
| [ ] | Update_a_shopping_list_name | ×3 | `PATCH /shopping-lists/$` → 201 | — | M | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Remove_a_concrete_product_from_the_shared_shopping_list | drop | Glue already asserts GET /shopping-lists/{id} -> 200 in ShoppingListRestApiCest::requestShoppingListByUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_existing_shopping_list_of_another_customer | drop | Glue already asserts GET /shopping-lists/{id} -> 404 in ShoppingListRestApiCest::requestShoppingListByNotExistingShoppingListUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_not_existing_shopping_list | drop | Glue already asserts GET /shopping-lists/{id} -> 404 in ShoppingListRestApiCest::requestShoppingListByNotExistingShoppingListUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_existing_shopping_list_of_another_customer | drop | Glue already asserts GET /shopping-lists/{id} -> 404 in ShoppingListRestApiCest::requestShoppingListByNotExistingShoppingListUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_several_shopping_lists_info_with_includes | drop | Glue already asserts GET /shopping-lists -> 200 in ShoppingListRestApiCest::requestShoppingLists. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_shopping_lists_info_for_user_with_zero_quantity_of_number_of_shopping_lists | drop | Glue already asserts GET /shopping-lists -> 200 in ShoppingListRestApiCest::requestShoppingLists. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
