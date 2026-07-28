### cart · robot-api-to-codeception · 213 scenarios

MIGRATE 155 · REVIEW 58   ▸ 0/155 ported

Batches: `cart-1`, `cart-2`, `cart-3`, `cart-4`, `cart-5`, `cart-6`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Add_item_without_storage_category_and_2_discounts | ×3 | `PATCH ...` → 201 | — | M | — |
| [ ] | Add_random_weight_product_to_cart_with_included_sales_units_and_measurenet_units | ×2 | `POST ...` → 201 | — | M | — |
| [ ] | Change_configuration_and_quantity_in_the_cart | ×2 | `DELETE /carts/$` → 201 | — | M | — |
| [ ] | Create_cart_when_cart_already_exists | ×2 | `PATCH /carts/$` → 401 | — | M | — |
| [ ] | Add_item_to_guest_cart_with_invalid_properties | b2c | `PATCH /guest-carts//guest-cart-items/fake` → 422 | — | S | — |
| [ ] | Delete_cart_item_with_not_matching_anonymous_customer_id | b2c | `POST /guest-cart-items?include=items` → 404 | — | S | — |
| [ ] | Update_item_in_guest_cart_with_invalid_parameters | b2c | `DELETE /guest-carts/$` → 422 | — | S | — |
| [ ] | Update_item_in_guest_cart_with_invalid_properties | b2c | `POST /gu` → 422 | — | S | — |
| [ ] | Update_item_in_guest_cart_with_no_cart_id | b2c | `DELETE /guest-carts/$` → 400 | — | S | — |
| [ ] | Update_item_in_guest_cart_with_no_item_id | b2c | `DELETE /guest-carts/$` → 400 | — | S | — |
| [ ] | Update_item_in_guest_cart_with_non_existing_cart_id | b2c | `DELETE /guest-carts//guest-cart-items/$` → 404 | — | S | — |
| [ ] | Update_item_in_guest_cart_with_non_existing_item_id | b2c | `PATCH /guest-carts/$` → 404 | — | S | — |
| [ ] | Update_item_in_guest_cart_with_not_matching_anonymous_customer_id | b2c | `PATCH /guest-carts/$` → 404 | — | S | — |
| [ ] | Add_items_to_guest_cart_with_included_bundle_items | b2c | `POST /guest-carts/$` → 201 | — | S | — |
| [ ] | Change_item_qty_in_guest_cart | b2c | `POST /guest-cart-items?include=items,concrete-products,abstract-products` → 200 | — | S | — |
| [ ] | Remove_item_from_guest_cart | b2c | `POST /guest-cart-items?include=items,concrete-products,abstract-products` → 204 | — | S | — |
| [ ] | Update_item_without_changing_qty | ×3 | `DELETE /carts//items/fake` → 422 | — | M | — |
| [ ] | Add_bundle_to_cart_with_included_bundle_items_and_bundled_items | ×2 | `POST /carts/$` → 201 | — | M | — |
| [ ] | Add_ten_items_to_cart_with_included_cart_rules_and_promotional_items | b2c | `POST /carts/$` → 201 | — | M | — |
| [ ] | Add_an_item_to_the_guest_cart_with_cart_rules_and_promotional_items_includes | mp_b2c | `POST /guest-carts/$` → 201 | — | S | — |
| [ ] | Update_configurable_product_quantity_in_the_cart | mp_b2c | `PATCH /guest-carts/$` → 201 | — | S | — |
| [ ] | Adding_invalid_cart_code | suite | `POST /carts/$` → 201 | — | M | — |
| [ ] | Create_git_card_code_with_invalid_access_token | suite | `POST /carts/$` → 401 | — | S | — |
| [ ] | Create_git_card_code_with_invalid_cart_id | suite | `POST /checkout` → 404 | — | M | — |
| [ ] | Create_git_card_code_without_access_token | suite | `POST /checkout` → 403 | — | S | — |
| [ ] | Gift_card_fully_used | suite | `POST /carts/$` → 201 | — | M | — |
| [ ] | Add_gift_card_code_to_cart | suite | `POST /carts/$` → 201 | — | M | — |
| [ ] | Add_gift_card_code_to_empty_cart | suite | `POST /carts/$` → 201 | — | M | — |
| [ ] | Add_gift_card_code_to_the_guest_cart | suite | `DELETE /guest-carts/$` → 201 | — | S | — |
| [ ] | Delete_gift_card_code_from_the_guest_cart | suite | `POST /carts/$` → 201 | — | S | — |
| [ ] | Delete_gift_card_from_cart | suite | `POST /guest-carts/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_to_the_cart_with_0_quantity | ×5 | `GET /carts/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_to_the_cart_with_empty_price | ×5 | `POST /carts/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_to_the_cart_with_empty_quantity | ×5 | `GET /carts/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_to_the_cart_with_negative_price | ×5 | `POST /carts/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_to_the_cart_with_negative_quantity | ×5 | `POST /carts/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_with_missing_isComplete_value_of_to_the_cart | ×5 | `PATCH /carts/fake/items/fake` → 201 | — | M | — |
| [ ] | Add_item_to_cart_non_existing_sku | ×5 | `POST /carts/$` → 422 | — | M | — |
| [ ] | Add_item_to_cart_with_invalid_properties | ×5 | `POST /carts/$` → 422 | — | M | — |
| [ ] | Add_item_to_cart_with_invalid_token | ×5 | `POST /carts/$` → 401 | — | M | — |
| [ ] | Add_item_to_cart_with_missing_properties | ×5 | `GET /carts/$` → 422 | — | M | — |
| [ ] | Add_item_to_cart_with_missing_token | ×5 | `POST /carts/$` → 403 | — | S | — |
| [ ] | Add_item_to_cart_with_wrong_type | ×5 | `POST /carts/$` → 400 | — | M | — |
| [ ] | Add_item_to_missing_cart | ×5 | `POST /carts/$` → 400 | — | M | — |
| [ ] | Add_item_to_non_existing_cart | ×5 | `POST /carts/$` → 404 | — | M | — |
| [ ] | Delete_cart_item_with_empty_item_id | ×5 | `DELETE /carts//items/fake` → 400 | — | M | — |
| [ ] | Delete_cart_item_with_missing_cart | ×5 | `DELETE /carts//items/fake` → 400 | — | M | — |
| [ ] | Delete_cart_item_with_non_existing_cart | ×5 | `DELETE /carts//items/fake` → 404 | — | M | — |
| [ ] | Delete_cart_item_with_non_existing_item_id | ×5 | `DELETE /carts//items/fake` → 404 | — | M | — |
| [ ] | Update_item_in_cart_with_another_user_token | ×5 | `DELETE /carts/$` → 404 | — | M | — |
| [ ] | Update_item_in_cart_with_no_cart_id | ×5 | `DELETE /carts/$` → 400 | — | M | — |
| [ ] | Update_item_in_cart_with_no_item_id | ×5 | `POST /carts/$` → 400 | — | M | — |
| [ ] | Update_item_in_cart_with_non_existing_cart_id | ×5 | `PATCH /carts/$` → 404 | — | M | — |
| [ ] | Update_item_in_cart_with_non_existing_item_id | ×5 | `PATCH /carts/$` → 404 | — | M | — |
| [ ] | Update_item_with_invalid_parameters | ×5 | `DELETE /carts//items/fake` → 422 | — | M | — |
| [ ] | Add_five_items_to_cart_with_included_cart_rules_and_promotional_items | ×4 | `DELETE /carts/$` → 201 | — | M | — |
| [ ] | Add_item_with_storage_category_and_2_discounts | ×4 | `POST /carts/$` → 201 | — | M | — |
| [ ] | Add_one_item_to_cart | ×5 | `POST /carts/$` → 201 | — | M | — |
| [ ] | Add_product_with_options_to_cart | ×5 | `POST /carts/$` → 201 | — | M | — |
| [ ] | Add_two_items_to_cart_with_included_items_concrete_products_and_abstract_products | ×5 | `POST /carts/$` → 201 | — | M | — |
| [ ] | Change_item_amount_in_cart | ×4 | `POST /carts/$` → 200 | — | M | — |
| [ ] | Change_item_qty_in_cart | ×5 | `DELETE /carts/$` → 200 | — | M | — |
| [ ] | Delete_configurable_product_item_form_the_cart | ×5 | `GET /carts/$` → 201 | — | M | — |
| [ ] | Delete_item_form_cart | ×5 | `GET /carts/$` → 204 | — | M | — |
| [ ] | Get_a_cart_with_included_items_and_concrete_products | ×5 | `GET /carts/$` → 201 | — | M | — |
| [ ] | Update_configurable_product_quantity_in_the_cart | ×3 | `DELETE /carts/$` → 201 | — | M | — |
| [ ] | Get_cart_permission_group_by_non_exist_id | ×3 | `GET /cart-permission-groups/111111` → 404 | — | M | — |
| [ ] | Get_cart_permission_group_with_unauthenicated_user | ×3 | `GET /cart-permission-groups/111111` → 403 | — | S | — |
| [ ] | Get_all_cart_permission_groups | ×3 | `GET /cart-permission-groups/$` → 200 | — | M | — |
| [ ] | Get_cart_permission_groups_by_cart_id | ×3 | `DELETE /carts/$` → 201 | — | M | — |
| [ ] | Get_cart_permission_groups_by_id | ×3 | `GET /cart-permission-groups/$` → 200 | — | M | — |
| [ ] | Create_cart_with_invalid_access_token | ×5 | `POST /carts` → 401 | — | S | — |
| [ ] | Create_cart_with_invalid_priceMod_and_currency | ×3 | `PATCH /carts/not-existing-cart` → 422 | — | M | — |
| [ ] | Create_cart_with_invalid_type | ×3 | `POST /carts` → 400 | — | M | — |
| [ ] | Create_cart_without_type | ×3 | `POST /carts` → 400 | — | M | — |
| [ ] | Delete_cart_from_another_customer_id | ×3 | `DELETE /carts/$` → 201 | — | M | — |
| [ ] | Delete_cart_with_invalid_access_token | ×3 | `DELETE /carts/$` → 401 | — | S | — |
| [ ] | Delete_cart_with_invalid_cart_id | ×3 | `DELETE /carts/$` → 404 | — | M | — |
| [ ] | Delete_cart_without_cart_id | ×3 | `DELETE /carts/$` → 400 | — | M | — |
| [ ] | Get_cart_by_cart_id_from_another_customer | ×5 | `GET /customers/$` → 201 | — | M | — |
| [ ] | Get_cart_by_cart_id_with_invalid_access_token | ×5 | `GET /customers//carts` → 401 | — | S | — |
| [ ] | Get_cart_by_customer_id_with_invalid_access_token | ×5 | `POST /carts` → 401 | — | S | — |
| [ ] | Get_cart_with_non_existing_cart_id | ×5 | `POST /carts` → 404 | — | M | — |
| [ ] | Update_cart_from_another_customer_cart_id | ×5 | `DELETE /carts/$` → 201 | — | M | — |
| [ ] | Update_cart_with_empty_name | ×3 | `DELETE /carts/88ca6f79` → 201 | — | M | — |
| [ ] | Update_cart_with_invalid_access_token | ×5 | `POST /carts` → 401 | — | S | — |
| [ ] | Update_cart_with_non_existing_cart_id | ×5 | `DELETE /carts/$` → 200 | — | M | — |
| [ ] | Update_cart_without_cart_id | ×5 | `DELETE /carts/$` → 200 | — | M | — |
| [ ] | Update_cart_without_type | ×5 | `GET /carts/$` → 201 | — | M | — |
| [ ] | Create_cart_with_existing_name | ×3 | `PATCH /carts/$` → 201 | — | M | — |
| [ ] | Delete_cart_by_cart_id | ×5 | `GET /carts/$` → 201 | — | M | — |
| [ ] | Get_cart_by_cart_id | ×5 | `GET /carts` → 201 | — | M | — |
| [ ] | Get_cart_with_included_cart_rules | ×3 | `GET /carts/$` → 201 | — | M | — |
| [ ] | Get_cart_with_included_promotional_items | ×3 | `PATCH /carts/$` → 201 | — | M | — |
| [ ] | Get_cart_without_cart_id | ×5 | `GET /carts/$` → 201 | — | M | — |
| [ ] | Update_cart_by_cart_id_with_all_attributes | ×5 | `PATCH /carts/$` → 201 | — | M | — |
| [ ] | Update_cart_with_empty_priceMod_currency_store | ×5 | `PATCH /carts/$` → 201 | — | M | — |
| [ ] | Update_cart_with_existing_name | ×3 | `GET /carts/$` → 201 | — | M | — |
| [ ] | Update_cart_with_name_attribute | ×3 | `GET /carts/$` → 201 | — | M | — |
| [ ] | Get_guest_cart_wth_non_existing_cart_id | ×3 | `PATCH /guest-carts/$` → 404 | — | S | — |
| [ ] | Update_guest_cart_with_wrong_guest_cart_id | ×3 | `PATCH /guest-carts/$` → 404 | — | S | — |
| [ ] | Update_guest_cart_with_wrong_x_anonymous_customer_id | ×3 | `PATCH /guest-carts/$` → 404 | — | S | — |
| [ ] | Create_guest_cart | ×3 | `GET /guest-carts/$` → 201 | — | S | — |
| [ ] | Remove_an_item_from_the_shared_shopping_cart_by_user_without_access | ×3 | `DELETE /carts/$` → 201 | — | M | — |
| [ ] | Remove_the_already_deleted_shared_shopping_cart_by_user_with_access | ×3 | `DELETE /shared-carts/$` → 201 | — | M | — |
| [ ] | Remove_the_shared_shopping_cart_by_user_without_access | ×3 | `DELETE /shared-carts/$` → 201 | — | M | — |
| [ ] | Share_not_owned_shopping_cart | ×3 | `POST /carts/$` → 403 | — | M | — |
| [ ] | Share_shopping_cart_to_non_existing_company_user | ×3 | `PATCH /shared-carts/$` → 404 | — | M | — |
| [ ] | Share_shopping_cart_to_the_other_company_user | ×3 | `POST /carts/$` → 403 | — | M | — |
| [ ] | Share_shopping_cart_with_empty_cart_id | ×3 | `PATCH /shared-carts/sharedCardId` → 400 | — | M | — |
| [ ] | Share_shopping_cart_with_empty_permission_group_value_and_company_user_value | ×3 | `POST /carts/$` → 204 | — | M | — |
| [ ] | Share_shopping_cart_with_incorrect_cart_permission_id | ×3 | `PATCH /shared-carts` → 422 | — | M | — |
| [ ] | Share_shopping_cart_with_non_existing_permission_group | ×3 | `POST /carts/$` → 422 | — | M | — |
| [ ] | Share_shopping_cart_with_wrong_access_token | ×3 | `PATCH /shared-carts/sharedCardId` → 401 | — | M | — |
| [ ] | Share_shopping_cart_without_company_user_attribute_and_cart_permission_group_attribute | ×3 | `POST /carts/shoppingCartId/shared-carts` → 204 | — | M | — |
| [ ] | Update_an_item_quantity_at_the_shared_shopping_cart_by_user_without_access | ×3 | `DELETE /carts/$` → 201 | — | M | — |
| [ ] | Update_permissions_of_shared_shopping_cart_with_extra_attribute | ×3 | `GET /company-users` → 200 | — | M | — |
| [ ] | Update_permissions_of_shared_shopping_cart_with_incorrect_permission_group | ×3 | `POST /carts/$` → 422 | — | M | — |
| [ ] | Update_permissions_of_shared_shopping_cart_with_wrong_access_token | ×3 | `DELETE /carts/$` → 401 | — | M | — |
| [ ] | Update_permissions_of_shared_shopping_cart_without_access_token | ×3 | `PATCH /shared-carts/$` → 403 | — | S | — |
| [ ] | Update_permissions_of_shared_shopping_cart_without_shared_cart_id | ×3 | `POST /carts` → 400 | — | M | — |
| [ ] | Add_an_item_to_the_shared_shopping_cart_by_user_with_access | ×3 | `PATCH /carts/$` → 201 | — | M | — |
| [ ] | Create_a_shared_shopping_cart_with_full_access_permissions | ×3 | `GET /carts/$` → 201 | — | M | — |
| [ ] | Delete_a_shared_shopping_cart_by_cart_owner | ×3 | `DELETE /shared-carts/$` → 204 | — | M | — |
| [ ] | Delete_a_shared_shopping_cart_with_full_access_permissions_by_user_with_access | ×3 | `DELETE /shared-carts/$` → 201 | — | M | — |
| [ ] | Delete_an_item_from_the_shared_shopping_cart_with_full_access_permissions_by_user_with_access | ×3 | `POST /carts/$` → 201 | — | M | — |
| [ ] | Update_an_item_quantity_at_the_shared_shopping_cart_with_full_access_permissions_by_user_with_access | ×3 | `GET /carts/$` → 201 | — | M | — |
| [ ] | Update_permissions_of_shared_shopping_cart_by_Cart_owner | ×3 | `POST /carts/$` → 201 | — | M | — |
| [ ] | Add_a_configurable_product_to_the_cart_with_empty_price | ×2 | `GET /guest-carts/$` → 422 | — | S | — |
| [ ] | Add_a_configurable_product_to_the_cart_with_empty_quantity | ×2 | `GET /guest-carts/$` → 422 | — | S | — |
| [ ] | Add_a_configurable_product_to_the_cart_with_negative_price | ×2 | `GET /guest-carts/$` → 422 | — | S | — |
| [ ] | Add_a_configurable_product_to_the_cart_with_negative_quantity | ×2 | `GET /guest-carts/$` → 422 | — | S | — |
| [ ] | Add_a_configurable_product_with_missing_isComplete_value_of_to_the_cart | ×2 | `GET /guest-carts/$` → 422 | — | S | — |
| [ ] | Add_an_item_to_the_guest_cart_of_another_anonymous_customer | ×2 | `POST /guest-carts/$` → 404 | — | S | — |
| [ ] | Add_an_item_to_the_guest_cart_without_x_anonymous_customer_unique_id | ×2 | `POST /guest-carts/$` → 400 | — | S | — |
| [ ] | Add_an_item_to_the_non_existing_guest_cart | ×2 | `POST /guest-carts/$` → 404 | — | S | — |
| [ ] | Add_item_to_guest_cart_with_wrong_type | suite | `POST /guest-carts/$` → 400 | — | S | — |
| [ ] | Remove_an_item_from_the_guest_cart_of_another_anonymous_customer | ×2 | `POST /guest-carts/$` → 404 | — | S | — |
| [ ] | Remove_an_item_from_the_guest_cart_without_x_anonymous_customer_unique_id | ×2 | `POST /guest-carts/$` → 400 | — | S | — |
| [ ] | Remove_an_item_from_the_non_existing_guest_cart | ×2 | `POST /guest-carts/$` → 404 | — | S | — |
| [ ] | Update_an_item_quantity_at_the_guest_cart_with_empty_quantity_value | ×2 | `GET /guest-carts/$` → 422 | — | S | — |
| [ ] | Update_an_item_quantity_at_the_guest_cart_with_non_numeric_quantity_value | ×2 | `DELETE /guest-carts/$` → 422 | — | S | — |
| [ ] | Update_an_item_quantity_at_the_guest_cart_without_quantity_attribute | ×2 | `DELETE /guest-carts/$` → 422 | — | S | — |
| [ ] | Update_an_item_quantity_at_the_non_existing_guest_cart | ×2 | `PATCH /guest-carts/$` → 404 | — | S | — |
| [ ] | Update_quantity_of_a_non_existing_item_at_the_guest_cart | ×2 | `DELETE /guest-carts/guestCartId/guest-cart-items/itemId` → 404 | — | S | — |
| [ ] | Add_a_configurable_product_to_the_cart | ×2 | `POST /guest-carts/$` → 201 | — | S | — |
| [ ] | Add_an_item_to_the_guest_cart | ×2 | `POST /guest-carts/$` → 201 | — | S | — |
| [ ] | Add_an_item_to_the_guest_cart_with_bundle_items_include | ×2 | `PATCH /guest-carts/$` → 201 | — | S | — |
| [ ] | Add_an_item_to_the_guest_cart_with_cart_rules_includes | suite | `POST /guest-carts/$` → 201 | — | S | — |
| [ ] | Add_an_item_to_the_guest_cart_with_concrete_products_and_abstract_products_includes | ×2 | `POST /guest-carts/$` → 201 | — | S | — |
| [ ] | Add_an_item_to_the_guest_cart_with_items_include | ×2 | `POST /guest-carts/$` → 201 | — | S | — |
| [ ] | Change_configuration_and_quantity_in_the_cart | suite | `PATCH /guest-carts/$` → 201 | — | S | — |
| [ ] | Delete_configurable_product_item_form_the_cart | ×2 | `GET /guest-carts/$` → 201 | — | S | — |
| [ ] | Remove_an_item_from_the_guest_cart | ×2 | `POST /guest-carts/$` → 204 | — | S | — |
| [ ] | Update_an_item_quantity_at_the_guest_cart_with_items_include | ×2 | `DELETE /guest-carts/$` → 200 | — | S | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Get_cart_by_cart_id_with_2_product_discounts | drop | Glue already asserts GET /carts/{id} -> 200 in CartsRestApiCest::requestCartByUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_cart_by_cart_id_with_included_vouchers | drop | Glue already asserts PATCH /carts/{id} -> 200 in CartsRestApiCest::requestUpdateCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Add_item_to_guest_cart_non_existing_sku | drop | Glue already asserts POST /guest-cart-items -> 422 in GuestCartsRestApiCest::requestCreateGuestCartWithoutSku. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Add_item_to_guest_cart_with_missing_properties | drop | Glue already asserts PATCH /guest-carts/{id} -> 422 in GuestCartsRestApiCest::requestUpdatePriceModeOfNonEmptyGuestCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Add_item_to_guest_cart_with_missing_x_anonymous_customer_id | drop | Glue already asserts PATCH /guest-carts/{id} -> 400 in GuestCartsRestApiCest::requestUpdateGuestCartWithoutAnonymousCustomerUniqueId. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Add_item_to_guest_cart_with_wrong_type | drop | Glue already asserts PATCH /guest-carts/{id} -> 400 in GuestCartsRestApiCest::requestUpdateGuestCartWithoutAnonymousCustomerUniqueId. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Delete_cart_item_without_guest_cart_id | drop | Glue already asserts POST /guest-cart-items -> 400 in GuestCartsRestApiCest::requestCreateGuestCartWithoutAnonymousCustomerUniqueId. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Add_items_to_guest_cart_with_included_cart_rules | drop | Glue already asserts POST /guest-cart-items -> 201 in GuestCartsRestApiCest::requestCreateGuestCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Add_items_to_guest_cart_with_included_items_concrete_products_and_abstract_products | drop | Glue already asserts POST /guest-cart-items -> 201 in GuestCartsRestApiCest::requestCreateGuestCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Add_items_to_guest_cart_with_included_promotional_products | drop | Glue already asserts POST /guest-cart-items -> 201 in GuestCartsRestApiCest::requestCreateGuestCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Add_items_to_guest_cart_with_items_include | drop | Glue already asserts POST /guest-cart-items -> 201 in GuestCartsRestApiCest::requestCreateGuestCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieve_guest_cart_including_vouchers | drop | Glue already asserts PATCH /guest-carts/{id} -> 200 in GuestCartsRestApiCest::requestUpdateGuestCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Add_a_configurable_product_to_the_cart_with_0_quantity | drop | Glue already asserts POST /guest-cart-items -> 422 in GuestCartsRestApiCest::requestCreateGuestCartWithoutSku. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Adding_eur_gift_cart_code_in_chf_cart | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Add_a_configurable_product_to_the_cart | drop | Glue already asserts POST /carts -> 201 in CartsRestApiCest::requestCreateCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_cart_with_empty_attributes | drop | Glue already asserts POST /carts -> 422 in CartsRestApiCest::requestCreateCartWithoutPriceMode. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_cart_with_invalid_store | drop | Glue already asserts POST /carts -> 422 in CartsRestApiCest::requestCreateCartWithoutPriceMode. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_cart_without_access_token | drop | Glue already asserts POST /carts -> 403 in CartsRestApiCest::requestCreateCartWithoutAuthorizationToken. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_cart_without_attributes | drop | Glue already asserts POST /carts -> 422 in CartsRestApiCest::requestCreateCartWithoutPriceMode. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Delete_cart_without_access_token | drop | Glue already asserts DELETE /carts/{id} -> 403 in CartsRestApiCest::requestDeleteCartWithoutAuthorizationToken. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_cart_by_cart_id_without_access_token | drop | Glue already asserts GET /customers/{id}/carts -> 403 in CartsRestApiCest::requestCustomerCartsForbidden. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_cart_by_customer_id_without_access_token | drop | Glue already asserts POST /carts -> 403 in CartsRestApiCest::requestCreateCartWithoutAuthorizationToken. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_cart_from_another_customer_id | drop | Glue already asserts POST /carts -> 201 in CartsRestApiCest::requestCreateCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_cart_with_non_existing_customer_id | drop | Glue already asserts POST /carts -> 403 in CartsRestApiCest::requestCreateCartWithoutAuthorizationToken. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_cart_without_customer_id | drop | Glue already asserts POST /carts -> 403 in CartsRestApiCest::requestCreateCartWithoutAuthorizationToken. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_cart_with_invalid_header_tag | drop | Glue already asserts POST /carts -> 201 in CartsRestApiCest::requestCreateCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_cart_with_invalid_priceMod_currency_store | drop | Glue already asserts POST /carts -> 201 in CartsRestApiCest::requestCreateCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_cart_with_invalid_type | drop | Glue already asserts POST /carts -> 201 in CartsRestApiCest::requestCreateCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_cart_without_access_token | drop | Glue already asserts PATCH /carts/{id} -> 403 in CartsRestApiCest::requestUpdateCartWithoutAuthorizationToken. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_cart_without_header_tag | drop | Glue already asserts POST /carts -> 201 in CartsRestApiCest::requestCreateCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_cart | drop | Glue already asserts POST /carts -> 201 in CartsRestApiCest::requestCreateCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_cart_by_cart_id_with_included_items | drop | Glue already asserts GET /carts/{id} -> 200 in CartsRestApiCest::requestCartByUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_cart_by_customer_id | drop | Glue already asserts POST /carts -> 201 in CartsRestApiCest::requestCreateCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_guest_cart_without_anonymous_customer_unique_id | drop | Glue already asserts PATCH /guest-carts/{id} -> 400 in GuestCartsRestApiCest::requestUpdateGuestCartWithoutAnonymousCustomerUniqueId. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_guest_cart_wth_empty_anonymous_customer_unique_id | drop | Glue already asserts PATCH /guest-carts/{id} -> 400 in GuestCartsRestApiCest::requestUpdateGuestCartWithoutAnonymousCustomerUniqueId. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_guest_cart_update_price_mode_with_items_in_the_cart | drop | Glue already asserts PATCH /guest-carts/{id} -> 422 in GuestCartsRestApiCest::requestUpdatePriceModeOfNonEmptyGuestCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_guest_cart_with_empty_x_anonymous_customer_id | drop | Glue already asserts PATCH /guest-carts/{id} -> 400 in GuestCartsRestApiCest::requestUpdateGuestCartWithoutAnonymousCustomerUniqueId. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_guest_cart_with_invalid_type | drop | Glue already asserts PATCH /guest-carts/{id} -> 400 in GuestCartsRestApiCest::requestUpdateGuestCartWithoutAnonymousCustomerUniqueId. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_guest_cart_without_guest_cart_id | drop | Glue already asserts PATCH /guest-carts/{id} -> 400 in GuestCartsRestApiCest::requestUpdateGuestCartWithoutAnonymousCustomerUniqueId. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_guest_cart_without_type | drop | Glue already asserts PATCH /guest-carts/{id} -> 400 in GuestCartsRestApiCest::requestUpdateGuestCartWithoutAnonymousCustomerUniqueId. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Convert_guest_cart_to_customer_cart | drop | Glue already asserts GET /carts/{id} -> 200 in CartsRestApiCest::requestCartByUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieve_guest_cart | drop | Glue already asserts GET /guest-carts/{id} -> 200 in GuestCartsRestApiCest::requestGuestCartByUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieve_guest_cart_by_id | drop | Glue already asserts GET /guest-carts/{id} -> 200 in GuestCartsRestApiCest::requestGuestCartByUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieve_guest_cart_including_cart_items | drop | Glue already asserts GET /guest-carts/{id} -> 200 in GuestCartsRestApiCest::requestGuestCartByUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Retrieve_guest_cart_including_cart_rules | drop | Glue already asserts PATCH /guest-carts/{id} -> 200 in GuestCartsRestApiCest::requestUpdateGuestCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_guest_cart_with_all_attributes | drop | Glue already asserts PATCH /guest-carts/{id} -> 200 in GuestCartsRestApiCest::requestUpdateGuestCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_guest_cart_with_empty_priceMod_currency_store | drop | Glue already asserts GET /carts/{id} -> 200 in CartsRestApiCest::requestCartByUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Add_an_item_to_the_shared_shopping_cart_by_user_without_access | drop | Glue already asserts DELETE /carts/{id} -> 403 in CartsRestApiCest::requestDeleteCartWithoutAuthorizationToken. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Share_shopping_cart_without_access_token | drop | Glue already asserts DELETE /carts/{id} -> 403 in CartsRestApiCest::requestDeleteCartWithoutAuthorizationToken. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_permissions_of_shared_shopping_cart_with_empty_permission_group_value | drop | Glue already asserts POST /carts -> 201 in CartsRestApiCest::requestCreateCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_permissions_of_shared_shopping_cart_without_permission_group_attribute | drop | Glue already asserts POST /carts -> 201 in CartsRestApiCest::requestCreateCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_a_shared_shopping_cart_with_read_only_permissions_with_includes | drop | Glue already asserts POST /carts -> 201 in CartsRestApiCest::requestCreateCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Add_an_item_to_the_guest_cart_without_sku_and_quantity_values | drop | Glue already asserts PATCH /guest-carts/{id} -> 400 in GuestCartsRestApiCest::requestUpdateGuestCartWithoutAnonymousCustomerUniqueId. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Add_an_item_to_the_guest_cart_without_sku_attribute_and_quantity_attribute | drop | Glue already asserts PATCH /guest-carts/{id}/guest-cart-items/{id} -> 400 in GuestCartsRestApiCest::requestUpdateItemsInGuestCartWithoutAnonymousCustomerUniqueId. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Add_an_non_existing_item_to_the_guest_cart | drop | Glue already asserts PATCH /guest-carts/{id}/guest-cart-items/{id} -> 400 in GuestCartsRestApiCest::requestUpdateItemsInGuestCartWithoutAnonymousCustomerUniqueId. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Remove_a_non_existing_item_from_the_guest_cart | drop | Glue already asserts GET /guest-carts/{id} -> 404 in GuestCartsRestApiCest::requestGuestCartByNotExistingGuestCartUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_an_item_quantity_at_the_guest_cart_of_another_anonymous_customer | drop | Glue already asserts GET /guest-carts/{id} -> 404 in GuestCartsRestApiCest::requestGuestCartByNotExistingGuestCartUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_an_item_quantity_at_the_guest_cart_without_x_anonymous_customer_unique_id | drop | Glue already asserts PATCH /guest-carts/{id} -> 400 in GuestCartsRestApiCest::requestUpdateGuestCartWithoutAnonymousCustomerUniqueId. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
