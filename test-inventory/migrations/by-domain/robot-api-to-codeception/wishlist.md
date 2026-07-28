### wishlist · robot-api-to-codeception · 83 scenarios

MIGRATE 83   ▸ 0/83 verified

Batches: `wishlist-1`, `wishlist-2`, `wishlist-3`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Add_a_configurable_product_with_negative_availableQuantity_to_the_wishlist | b2c | `DELETE /wishlists/$` → 201 | — | M | — |
| [ ] | Add_configurable_product_with_missing_availableQuantity_value_of_to_the_wishlist | b2c | `POST /wishlists` → 201 | — | M | — |
| [ ] | Adding_item_with_invalid_wishlist_id | b2c | `DELETE /wishlists/mywishlist/wishlist-items/$` → 422 | — | M | — |
| [ ] | Adding_item_without_wishlist_id | b2c | `DELETE /wishlists/mywishlist/wishlist-items/$` → 404 | — | M | — |
| [ ] | Deleting_item_after_enter_space_in_sku | b2c | `DELETE /wishlists/Mywishlist/wishlist-items/$` → 201 | — | M | — |
| [ ] | Deleting_item_which_is_not_exist_in_wishlist | b2c | `POST /wishlists/$` → 201 | — | M | — |
| [ ] | Deleting_item_with_invalid_wishlist_id | b2c | `DELETE /wishlists/$` → 404 | — | M | — |
| [ ] | Deleting_item_without_wishlist_id | b2c | `POST /wishlists/$` → 400 | — | M | — |
| [ ] | Add_2_product_variant_of_Configurable_products_without_configurations_and_set_configuration | ×2 | `GET /wishlists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_first_product_variant_to_the_wishlist | ×2 | `POST /wishlists` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_second_product_variant_to_the_wishlist | ×2 | `POST /wishlists` → 201 | — | M | — |
| [ ] | Creating_wishlist_by_invalid_Access_Token | b2c | `POST /wishlists` → 401 | — | S | — |
| [ ] | Creating_wishlist_with_invalid_name | b2c | `Patch /wishlists/$` → 400 | — | M | — |
| [ ] | Creating_wishlist_with_space_in_name | ×3 | `DELETE /wishlists` → 400 | — | M | — |
| [ ] | Creating_wishlist_without_Access_Token | b2c | `Delete /wishlists/123` → 403 | — | S | — |
| [ ] | Delete_already_deleted_wishlist | b2c | `Patch /wishlists/123` → 201 | — | M | — |
| [ ] | Deleting_wishlist_by_invalid_Access_Token | b2c | `Patch /wishlists/123` → 401 | — | S | — |
| [ ] | Deleting_wishlist_without_Access_Token | b2c | `Patch /wishlists/123` → 403 | — | S | — |
| [ ] | Updating_wishlist_by_invalid_Access_Token | b2c | `Patch /wishlists/123` → 401 | — | S | — |
| [ ] | Updating_wishlist_with_invalid_name | b2c | `Patch /wishlists/123` → 201 | — | M | — |
| [ ] | Updating_wishlist_with_missing_name | b2c | `Patch /wishlists/123` → 201 | — | M | — |
| [ ] | Updating_wishlist_without_Access_Token | b2c | `Patch /wishlists/123` → 403 | — | S | — |
| [ ] | Wishlist_id_not_specified | b2c | `Patch /wishlists/123` → 400 | — | M | — |
| [ ] | Creates_wishlist | b2c | `GET /wishlists/$` → 201 | — | M | — |
| [ ] | Retrieves_all_customer_wishlists | b2c | `DELETE /wishlists/$` → 200 | — | M | — |
| [ ] | Retrieves_wishlist_with_items_in_concrete | b2c | `DELETE /wishlists/$` → 201 | — | M | — |
| [ ] | Retrieves_wishlist_with_items_in_concreate | mp_b2c | `DELETE /wishlists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_to_the_wishlist_with_missing_price | ×3 | `DELETE /wishlists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_empty_availableQuantity_value_of_to_the_wishlist | ×3 | `DELETE /wishlists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_empty_price_value_of_to_the_wishlist | ×3 | `POST /wishlists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_missing_isComplete_value_of_to_the_wishlist | ×3 | `DELETE /wishlists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_negative_price_value_of_to_the_wishlist | ×3 | `POST /wishlists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_numeric_isComplete_value_of_to_the_wishlist | ×3 | `POST /wishlists` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_string_availableQuantity_value_of_to_the_wishlist | ×3 | `POST /wishlists` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_string_isComplete_value_of_to_the_wishlist | ×3 | `POST /wishlists` → 201 | — | M | — |
| [ ] | Add_a_non-configurable_product_to_the_wishlist_with_configuration | ×3 | `POST /wishlists/$` → 201 | — | M | — |
| [ ] | Add_a_non-configurable_product_to_the_wishlist_with_configuration_and_configurable_product | ×3 | `POST /wishlists` → 201 | — | M | — |
| [ ] | Add_aconfigurable_product_with_missing_availableQuantity_value_of_to_the_wishlist | ×2 | `POST /wishlists` → 201 | — | M | — |
| [ ] | Adding_item_after_enter_space_in_sku | ×3 | `POST /wishlists` → 201 | — | M | — |
| [ ] | Adding_item_in_wishlist_by_invalid_Access_Token | ×3 | `DELETE /wishlists/$` → 401 | — | S | — |
| [ ] | Adding_item_in_wishlist_by_without_Access_Token | ×3 | `POST /wishlists` → 403 | — | S | — |
| [ ] | Adding_item_with_abstract_sku | ×3 | `POST /wishlists/$` → 201 | — | M | — |
| [ ] | Adding_item_with_deactivated_item_sku | ×3 | `DELETE /wishlists/$` → 201 | — | M | — |
| [ ] | Adding_item_with_empty_sku | ×3 | `POST /wishlists/$` → 201 | — | M | — |
| [ ] | Adding_item_with_invalid_sku | ×3 | `POST /wishlists//wi` → 201 | — | M | — |
| [ ] | Adding_item_with_invalid_wishilist_id | ×2 | `DELETE /wishlists/mywishlist/wishlist-items/$` → 422 | — | M | — |
| [ ] | Adding_item_without_wishilist_id | ×2 | `POST /wishlists` → 404 | — | M | — |
| [ ] | Adding_items_in_wishlist_by_another_customer_wishlist | ×3 | `DELETE /wishlists/$` → 422 | — | M | — |
| [ ] | Delete_wishlist_item_from_already_deleted_wishlist | ×3 | `DELETE /wishlists/$` → 201 | — | M | — |
| [ ] | Deleting_concrete_product_by_abstract_product_sku | ×3 | `POST /wishlists/$` → 201 | — | M | — |
| [ ] | Deleting_item_in_wishlist_by_invalid_Access_Token | ×3 | `DELETE /wishlists//wishlist-items/$` → 401 | — | S | — |
| [ ] | Deleting_item_in_wishlist_by_without_Access_Token | ×3 | `DELETE /wishlists//wishlist-items/$` → 403 | — | S | — |
| [ ] | Deleting_item_in_wishlist_with_empty_sku | ×3 | `POST /wishlists/$` → 201 | — | M | — |
| [ ] | Deleting_item_with_invalid_wishilist_id | ×2 | `DELETE /wishlists/$` → 404 | — | M | — |
| [ ] | Deleting_item_without_wishilist_id | ×2 | `POST /wishlists/$` → 400 | — | M | — |
| [ ] | Deleting_items_in_wishlist_by_another_customer_wishlist | ×3 | `POST /wishlists/$` → 404 | — | M | — |
| [ ] | Add_2_Configurable_products_but_with_different_configurations | ×3 | `GET /wishlists/$` → 201 | — | M | — |
| [ ] | Add_Configurable_products_and_regular_product | ×3 | `POST /wishlists/$` → 201 | — | M | — |
| [ ] | Add_Configurable_products_without_configurations_and_set_configuration | suite | `DELETE /wishlists/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_to_the_wishlist | suite | `POST /wishlists` → 201 | — | M | — |
| [ ] | Adding_item_in_wishlist | ×3 | `DELETE /wishlists/$` → 201 | — | M | — |
| [ ] | Adding_item_in_wishlist_with_offer | ×2 | `GET /wishlists/$` → 201 | — | M | — |
| [ ] | Adding_multiple_variant_of_abstract_product_in_wishlist | ×3 | `POST /wishlists/$` → 201 | — | M | — |
| [ ] | Change_preferred_date_of_the_configurable_product_in_the_wishlist | ×3 | `POST /wishlists` → 201 | — | M | — |
| [ ] | Change_preferred_time_of_the_day_of_the_configurable_product_in_the_wishlist | ×3 | `POST /wishlists` → 201 | — | M | — |
| [ ] | Deleting_item_from_wishlist | ×3 | `GET /wishlists/$` → 201 | — | M | — |
| [ ] | Remove_a_configurable_product_from_the_wishlist | ×3 | `DELETE /wishlists/$` → 201 | — | M | — |
| [ ] | Remove_a_configurable_product_from_the_wishlist_and_leave_a_regular_product | ×3 | `DELETE /wishlists/$` → 201 | — | M | — |
| [ ] | Set_configuration_for_the_configurable_product_in_the_wishlist | ×3 | `DELETE /wishlists/$` → 201 | — | M | — |
| [ ] | Creating_Wishlist_with_a_name_that_already_exists | ×3 | `DELETE /wishlists/$` → 400 | — | M | — |
| [ ] | Creating_wishlist_with_missing_name | ×3 | `DELETE /wishlists/$` → 422 | — | M | — |
| [ ] | Getting_wishlist_by_invalid_Access_Token | ×3 | `DELETE /wishlists/$` → 401 | — | S | — |
| [ ] | Getting_wishlist_with_invalid_id | ×3 | `DELETE /wishlists/$` → 404 | — | M | — |
| [ ] | Getting_wishlist_without_Access_Token | ×3 | `DELETE /wishlists/$` → 403 | — | S | — |
| [ ] | Create_a_wishlist | ×2 | `GET /wishlists/$` → 201 | — | M | — |
| [ ] | Getting_wishlists_for_customer_with_no_wishlists | ×2 | `Post /wishlists` → 200 | — | M | — |
| [ ] | Removes_customer_wishlist | ×3 | `GET /wishlists/$` → 201 | — | M | — |
| [ ] | Retrieves_wishlist_data_by_id | ×3 | `PATCH /wishlists/$` → 201 | — | M | — |
| [ ] | Retrieves_wishlist_with_items | ×3 | `Post /wishlists` → 201 | — | M | — |
| [ ] | Retrieves_wishlist_with_items_including_concrete_products | suite | `DELETE /wishlists/$` → 201 | — | M | — |
| [ ] | Retrieves_wishlists | ×2 | `GET /wishlists/$` → 201 | — | M | — |
| [ ] | Updates_customer_wishlist | ×3 | `Post /wishlists` → 201 | — | M | — |
| [ ] | Wishlist_Product_Labels | ×3 | `GET /wishlists/$` → 201 | — | M | — |
