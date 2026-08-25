### product-bundle · robot-api-to-codeception · 78 scenarios

MIGRATE 68 · REVIEW 10   ▸ 0/68 verified

Batches: `product-bundle-1`, `product-bundle-2`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Get_configurable_bundle_templates_by_invalid_configurable_bundle.template_id | b2b | `POST ...` → 404 | — | S | — |
| [ ] | Get_configurable_bundle_templates | b2b | `GET /configurable-bundle-templates?include=configurable-bundle-template-image-sets` → 200 | — | S | — |
| [ ] | Get_configurable_bundle_templates_by_configurable_bundle.template_id | b2b | `GET ...` → 200 | — | S | — |
| [ ] | Get_configurable_bundle_templates_including_concrete_products_concrete_product_prices_concrete_product_image_sets | b2b | `POST ...` → 200 | — | S | — |
| [ ] | Get_configurable_bundle_templates_including_configurable_bundle_template_image_sets | b2b | `GET ...` → 200 | — | S | — |
| [ ] | Get_configurable_bundle_templates_including_configurable_bundle_template_slots | b2b | `GET ...` → 200 | — | S | — |
| [ ] | Update_configurable_bundle.quantity_in_the cart_to_the_cart | b2b | `GET /carts/$` → 201 | — | M | — |
| [ ] | Get_bundled_products_with_invalid_concrete_sku | ×5 | `GET /concrete-products//bundled-products` → 400 | — | S | — |
| [ ] | Get_bundled_products_with_missing_concrete_sku | ×5 | `GET /concrete-products//bundled-products` → 400 | — | S | — |
| [ ] | Get_bundled_products_with_nonexisting_concrete_sku | ×5 | `GET /concrete-products//bundled-products` → 404 | — | S | — |
| [ ] | Add_configured_bundle_item_to_cart_non_existing_sku | ×3 | `POST /carts/fake/configured-bundles` → 422 | — | M | — |
| [ ] | Add_configured_bundle_item_to_cart_with_invalid_qty | ×2 | `PATCH /carts/fake/configured-bundles/fake` → 422 | — | M | — |
| [ ] | Add_configured_bundle_item_to_cart_with_invalid_token | ×3 | `POST /carts/$` → 401 | — | S | — |
| [ ] | Add_configured_bundle_item_to_cart_with_missing_properties | ×3 | `POST /carts/$` → 422 | — | M | — |
| [ ] | Add_configured_bundle_item_to_cart_with_missing_token | ×3 | `POST /carts/$` → 403 | — | S | — |
| [ ] | Add_configured_bundle_item_to_cart_with_wrong_type | ×3 | `PATCH /carts/$` → 400 | — | M | — |
| [ ] | Add_configured_bundle_item_to_missing_cart | ×3 | `POST /carts/$` → 400 | — | M | — |
| [ ] | Add_configured_bundle_item_to_non_existing_cart | ×3 | `POST /carts/$` → 422 | — | M | — |
| [ ] | Delete_configured_bundle_item_from_non_existing_cart | ×3 | `DELETE /carts//configured-bundles/fake` → 422 | — | M | — |
| [ ] | Delete_configured_bundle_item_from_the_cart_with_empty_bundle_group_key | ×3 | `DELETE /carts//configured-bundles/fake` → 400 | — | M | — |
| [ ] | Delete_configured_bundle_item_from_the_cart_with_wrong_bundle_group_key | ×3 | `DELETE /carts//configured-bundles/fake` → 400 | — | M | — |
| [ ] | Delete_configured_bundle_item_without_cart_id | ×3 | `DELETE /carts//configured-bundles/fake` → 400 | — | M | — |
| [ ] | Update_configured_bundle_item_in_cart_with_invalid_qty | ×2 | `DELETE /carts/$` → 201 | — | M | — |
| [ ] | Update_configured_bundle_item_in_cart_with_no_item_id | ×3 | `DELETE /carts//configured-bundles/fake` → 400 | — | M | — |
| [ ] | Update_configured_bundle_item_in_cart_with_non_existing_bundle_group_key | ×3 | `PATCH /carts//configured-bundles/fake` → 400 | — | M | — |
| [ ] | Update_configured_bundle_item_in_cart_with_non_existing_cart_id | ×3 | `DELETE /carts//configured-bundles/fake` → 422 | — | M | — |
| [ ] | Update_configured_bundle_item_in_cart_without_cart_id | ×3 | `DELETE /carts//configured-bundles/fake` → 400 | — | M | — |
| [ ] | Add_configured_bundle_item_to_the_cart_with_included_items | ×3 | `POST /carts/$` → 201 | — | M | — |
| [ ] | Delete_configured_bundle_item_from_the_cart | ×3 | `GET /carts/$` → 201 | — | M | — |
| [ ] | Update_configured_bundle_quantity_in_the cart_to_the_cart | ×2 | `GET /carts/$` → 201 | — | M | — |
| [ ] | Get_configurable_bundle_templates_by_invalid_configurable_bundle_template_id | ×2 | `GET /configurable-bundle-templates/fake` → 404 | — | S | — |
| [ ] | Get_configurable_bundle_templates | ×2 | `GET /configurable-bundle-templates?include=configurable-bundle-template-image-sets` → 200 | — | S | — |
| [ ] | Get_configurable_bundle_templates_by_configurable_bundle_template_1_uuid | ×2 | `GET /configurable-bundle-templates/$` → 200 | — | S | — |
| [ ] | Get_configurable_bundle_templates_including_concrete_products_concrete_product_prices_concrete_product_image_sets | ×2 | `GET /configurable-bundle-templates/$` → 200 | — | S | — |
| [ ] | Get_configurable_bundle_templates_including_configurable_bundle_template_image_sets | ×2 | `GET /configurable-bundle-templates/$` → 200 | — | S | — |
| [ ] | Get_configurable_bundle_templates_including_configurable_bundle_template_slots | ×2 | `GET /configurable-bundle-templates/$` → 200 | — | S | — |
| [ ] | Get_configurable_bundle_templates_with_uuid | ×2 | `GET /configurable-bundle-templates?include=configurable-bundle-template-image-sets` → 200 | — | S | — |
| [ ] | Add_configured_bundle_with_empty_anonymous_id | ×2 | `POST /guest-carts//guest-configured-bundles` → 400 | — | S | — |
| [ ] | Add_configured_bundle_with_empty_product_sku | ×2 | `PATCH /guest-carts//guest-configured-bundles/` → 422 | — | S | — |
| [ ] | Add_configured_bundle_with_empty_slot_uuid | ×2 | `POST /guest-carts//guest-configured-bundles` → 422 | — | S | — |
| [ ] | Add_configured_bundle_with_empty_template_uuid | ×2 | `POST /guest-carts//guest-configured-bundles` → 422 | — | S | — |
| [ ] | Add_configured_bundle_with_invalid_product_sku | ×2 | `POST /guest-carts//guest-configured-bundles?include=guest-cart-items` → 422 | — | S | — |
| [ ] | Add_configured_bundle_with_nonexistant_slot_uuid | ×2 | `POST /guest-carts//guest-configured-bundles` → 422 | — | S | — |
| [ ] | Add_configured_bundle_with_nonexistant_template_uuid | ×2 | `POST /guest-carts//guest-configured-bundles` → 422 | — | S | — |
| [ ] | Add_configured_bundle_with_nonexistent_guest_cart_id | ×2 | `POST /guest-carts//guest-configured-bundles` → 422 | — | S | — |
| [ ] | Add_configured_bundle_with_other_anonymous_id | ×2 | `POST /guest-carts//guest-configured-bundles` → 201 | — | S | — |
| [ ] | Add_configured_bundle_with_zero_quantity | ×2 | `POST /guest-carts//guest-configured-bundles` → 422 | — | S | — |
| [ ] | Delete_configured_bundle_with_empty_anonymous_id | ×2 | `DELETE /guest-carts/$` → 400 | — | S | — |
| [ ] | Delete_configured_bundle_with_empty_bundle_id | ×2 | `DELETE /guest-carts/$` → 400 | — | S | — |
| [ ] | Delete_configured_bundle_with_invalid_bundle_id | ×2 | `DELETE /guest-carts/$` → 400 | — | S | — |
| [ ] | Delete_configured_bundle_with_nonexistent_guest_cart_id | ×2 | `DELETE /guest-carts/$` → 400 | — | S | — |
| [ ] | Delete_configured_bundle_with_other_anonymous_id | ×2 | `DELETE /guest-carts/$` → 422 | — | S | — |
| [ ] | Update_configured_bundle_quantity_to_zero | ×2 | `DELETE /guest-carts//guest-configured-bundles/` → 422 | — | S | — |
| [ ] | Update_configured_bundle_with_empty_bundle_id | ×2 | `DELETE /guest-carts/$` → 400 | — | S | — |
| [ ] | Update_configured_bundle_with_invalid_bundle_id | ×2 | `DELETE /guest-carts/$` → 400 | — | S | — |
| [ ] | Update_configured_bundle_with_nonexistent_guest_cart_id | ×2 | `POST /guest-carts//guest-configured-bundles?include=guest-cart-items` → 400 | — | S | — |
| [ ] | Update_configured_bundle_with_other_anonymous_id | ×2 | `POST /guest-carts//guest-configured-bu` → 422 | — | S | — |
| [ ] | Add_configured_bundle_include_bundle_items | ×2 | `POST /guest-carts/$` → 201 | — | S | — |
| [ ] | Add_configured_bundle_include_cart_rules | ×2 | `POST /guest-carts/$` → 201 | — | S | — |
| [ ] | Add_configured_bundle_include_concrete_products | ×2 | `POST /guest-carts/$` → 201 | — | S | — |
| [ ] | Add_configured_bundle_include_guest_cart_items | ×2 | `POST /guest-carts/$` → 201 | — | S | — |
| [ ] | Add_configured_bundle_to_cart_that_contains_same_product | ×2 | `POST /guest-carts/$` → 201 | — | S | — |
| [ ] | Add_configured_bundle_with_1_slot_1_product_new_cart | ×2 | `POST /guest-carts/$` → 201 | — | S | — |
| [ ] | Add_configured_bundle_with_multiple_slots_and_products_to_existing_cart | ×2 | `POST /guest-carts/$` → 201 | — | S | — |
| [ ] | Add_other_configured_bundle_product_with_same_template | ×2 | `PATCH /guest-carts/$` → 201 | — | S | — |
| [ ] | Add_same_configured_bundle_again_to_check_quantity_not_merged | ×2 | `POST /guest-carts/$` → 201 | — | S | — |
| [ ] | Delete_configured_bundle_from_cart | ×2 | `DELETE /guest-carts/$` → 204 | — | S | — |
| [ ] | Update_configured_bundle_product_quantity | ×2 | `POST /guest-carts/$` → 200 | — | S | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Get_abstract_bundle_product_with_bundled_products_include | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_bundle_product_with_bundled_products_include | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_bundled_products_inside_concrete_bundle | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_bundled_products_inside_concrete_bundle_with_included_concretes | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_bundled_product_with_concrete_products_abstract_products_include | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_bundled_products_for_nonbundle_product | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Add_configured_bundle_item_to_cart_with_invalid_properties | drop | Glue already asserts PATCH /carts/{id} -> 422 in CartsRestApiCest::requestUpdatePriceModeOfNonEmptyCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Add_configured_bundle_with_abstract_product_sku | drop | Glue already asserts PATCH /guest-carts/{id} -> 422 in GuestCartsRestApiCest::requestUpdatePriceModeOfNonEmptyGuestCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Add_configured_bundle_with_product_not_in_stock | drop | Glue already asserts PATCH /guest-carts/{id} -> 422 in GuestCartsRestApiCest::requestUpdatePriceModeOfNonEmptyGuestCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Update_configured_bundle_with_empty_anonymous_id | drop | Glue already asserts PATCH /guest-carts/{id} -> 400 in GuestCartsRestApiCest::requestUpdateGuestCartWithoutAnonymousCustomerUniqueId. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
