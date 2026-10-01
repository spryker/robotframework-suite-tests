### product · robot-api-to-codeception · 235 scenarios

MIGRATE 122 · REVIEW 113   ▸ 0/122 verified

Batches: `product-1`, `product-2`, `product-3`, `product-4`, `product-5`, `product-6`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Get_abstract_image_stes_by_concrete_SKU | b2b | `GET /abstract-products//abstract-product-image-sets` → 404 | — | S | — |
| [ ] | Get_abstract_prices_with_invalid_token | ×2 | `GET /abstract-products/$` → 401 | — | S | — |
| [ ] | Get_abstract_prices_with_missing_token | ×2 | `GET /abstract-products/$` → 403 | — | S | — |
| [ ] | Abstract_product_with_abstract_includes_for_labels | ×4 | `GET ...` → 200 | — | M | — |
| [ ] | Request_product_prices_without_access_token | b2b | `GET /concrete-products/$` → 403 | — | S | — |
| [ ] | Request_product_prices_without_wrong_access_token | b2b | `GET /concrete-products/$` → 401 | — | S | — |
| [ ] | Get_a_label_with_non_existent_label_id | b2b | `GET /product-labels/fake` → 404 | — | S | — |
| [ ] | Get_a_label_without_label_id | b2b | `GET /product-labels/fake` → 400 | — | S | — |
| [ ] | Get_upselling_products_plus_includes | ×4 | `GET ...` → 201 | — | M | — |
| [ ] | Get_abstract_product_alternative_for_concrete_product_with_empty_SKU | b2c | `GET /concrete-products//concrete-alternative-products` → 400 | — | S | — |
| [ ] | Request_product_prices_with_empty_SKU | ×2 | `GET /concrete-products/4567890/concrete-product-prices` → 400 | — | S | — |
| [ ] | Get_alternatives_product_label_by_id | ×2 | `GET /product-labels/$` → 200 | — | S | — |
| [ ] | Create_a_product_review_with_invalid_access_token | ×2 | `POST /abstract-products/$` → 401 | — | S | — |
| [ ] | Create_a_product_review_without_access_token | ×2 | `POST /abstract-products/$` → 403 | — | S | — |
| [ ] | Get_subset_of_product_reviews | ×2 | `POST /abstract-products/$` → 200 | — | S | — |
| [ ] | Get_a_tax_set_with_concrete_sku | ×4 | `GET /abstract-products/fake/product-tax-sets` → 404 | — | S | — |
| [ ] | Get_concrete_product_availability_by_abstract_SKU | mp_b2b | `GET /concrete-products/±!@#$%^&*()/concrete-product-availabilities` → 404 | — | S | — |
| [ ] | Get_concrete_product_availability_by_invalid_SKU | mp_b2b | `GET /concrete-products/±!@#$%^&*()/concrete-product-availabilities` → 404 | — | S | — |
| [ ] | Get_concrete_product_availability_by_special_characters | mp_b2b | `GET /concrete-products/±!@#$%^&*()/concrete-product-availabilities` → 404 | — | S | — |
| [ ] | Get_concrete_product_availability_with_missing_concrete_SKU | mp_b2b | `GET /concrete-products/±!@#$%^&*()/concrete-product-availabilities` → 400 | — | S | — |
| [ ] | Get_product_image_by_concrete_sku_product_doesn't_exist | mp_b2b | `GET /concrete-products/4567890/concrete-product-image-sets` → 404 | — | S | — |
| [ ] | Get_product_image_with_abstract_SKU | mp_b2b | `GET /concrete-products/4567890/concrete-product-image-sets` → 404 | — | S | — |
| [ ] | Get_product_image_with_empty_SKU | mp_b2b | `GET /concrete-products/4567890/concrete-product-image-sets` → 404 | — | S | — |
| [ ] | Get_product_image_with_special_characters | mp_b2b | `GET /concrete-products/4567890/concrete-product-image-sets` → 404 | — | S | — |
| [ ] | Get_product_prices_without_access_token | mp_b2b | `GET /concrete-products/$` → 403 | — | S | — |
| [ ] | Get_product_prices_without_wrong_access_token | mp_b2b | `GET /concrete-products/$` → 401 | — | S | — |
| [ ] | Get_upselling_products_using_cart_from_another_customer | mp_b2b | `DELETE /carts/$` → 201 | — | M | — |
| [ ] | Get_upselling_products_with_invalid token | mp_b2b | `DELETE /carts/$` → 401 | — | S | — |
| [ ] | No_cart_is_passing_to_upselling_products_request | mp_b2b | `DELETE /carts/$` → 400 | — | M | — |
| [ ] | Nonexistent_cart_id_is_passing_to_upselling_products_request | mp_b2b | `DELETE /carts/$` → 404 | — | M | — |
| [ ] | Cart_contains_multiple_products_with_upselling_relation | mp_b2b | `GET /carts/$` → 201 | — | M | — |
| [ ] | Cart_contains_no_products_with_upselling_relations | mp_b2b | `DELETE /carts/$` → 201 | — | M | — |
| [ ] | Cart_contains_product_with_upselling_relation | mp_b2b | `GET /carts/$` → 201 | — | M | — |
| [ ] | Cart_contains_product_with_upselling_relation_with_include_abstract_prodcut_image_sets | mp_b2b | `GET /carts/$` → 201 | — | M | — |
| [ ] | Cart_contains_product_with_upselling_relation_with_include_abstract_product_availabilities | mp_b2b | `GET /carts/$` → 201 | — | M | — |
| [ ] | Cart_contains_product_with_upselling_relation_with_include_abstract_product_prices | mp_b2b | `POST /carts/$` → 201 | — | M | — |
| [ ] | Cart_contains_product_with_upselling_relation_with_include_concrete_products | mp_b2b | `GET /carts/$` → 201 | — | M | — |
| [ ] | Cart_contains_product_with_upselling_relation_with_include_product_labels | mp_b2b | `GET /carts/$` → 201 | — | M | — |
| [ ] | Cart_contains_product_with_upselling_relation_with_include_product_options | mp_b2b | `GET /carts/$` → 201 | — | M | — |
| [ ] | Cart_contains_product_with_upselling_relation_with_include_product_reviews | mp_b2b | `GET /carts/$` → 201 | — | M | — |
| [ ] | Cart_contains_product_with_upselling_relation_with_include_product_tax_sets | mp_b2b | `GET /carts/$` → 201 | — | M | — |
| [ ] | Get_abstract_image_sets_by_concrete_sku | mp_b2c | `GET /abstract-products//abstract-product-image-sets` → 404 | — | S | — |
| [ ] | Get_abstract_image_sets_by_not_existing_sku | mp_b2c | `GET /abstract-products//abstract-product-image-sets` → 404 | — | S | — |
| [ ] | Get_abstract_image_sets_with_missing_sku_in_url | mp_b2c | `GET /abstract-products//abstract-product-image-sets` → 404 | — | S | — |
| [ ] | Get_abstract_prices_with_missing_sku_in_url | mp_b2c | `GET /abstract-products//abstract-product-prices` → 400 | — | S | — |
| [ ] | Get_alternative_abstract_without_SKU | ×5 | `GET /concrete-products//abstract-alternative-products` → 400 | — | S | — |
| [ ] | Product_has_no_abstract_alternative | ×5 | `GET /concrete-products/$` | — | S | — |
| [ ] | Get_abstract_availability_by_concrete_SKU | ×5 | `GET /abstract-products//abstract-product-availabilities` → 404 | — | S | — |
| [ ] | Get_abstract_availability_by_fake_SKU | ×5 | `GET /abstract-products//abstract-product-availabilities` → 404 | — | S | — |
| [ ] | Get_abstract_availability_with_missing_SKU | ×5 | `GET /abstract-products//abstract-product-availabilities` → 400 | — | S | — |
| [ ] | Get_abstract_image_sets_by_concrete_SKU | ×3 | `GET /abstract-products//abstract-product-image-sets` → 404 | — | S | — |
| [ ] | Get_abstract_image_sets_by_fake_SKU | ×4 | `GET /abstract-products//abstract-product-image-sets` → 404 | — | S | — |
| [ ] | Get_abstract_image_sets_with_missing_SKU | ×4 | `GET /abstract-products//abstract-product-image-sets` → 404 | — | S | — |
| [ ] | Get_abstract_prices_with_missing_SKU | ×4 | `GET /abstract-products//abstract-product-prices` → 400 | — | S | — |
| [ ] | Get_concrete_availability_by_abstract_SKU | suite | `GET /concrete-products/124124/concrete-product-availabilities` → 404 | — | S | — |
| [ ] | Get_concrete_availability_by_invalid_SKU | suite | `GET /concrete-products/124124/concrete-product-availabilities` → 404 | — | S | — |
| [ ] | Get_concrete_availability_by_special_characters | suite | `GET /concrete-products/124124/concrete-product-availabilities` → 404 | — | S | — |
| [ ] | Get_concrete_availability_with_missing_concrete_SKU | suite | `GET /concrete-products/124124/concrete-product-availabilities` → 400 | — | S | — |
| [ ] | Request_concrete_availability_by_abstract_SKU | ×4 | `GET /concrete-products/±!@#$%^&*()/concrete-product-availabilities` → 404 | — | S | — |
| [ ] | Request_concrete_availability_by_invalid_SKU | ×4 | `GET /concrete-products/±!@#$%^&*()/concrete-product-availabilities` → 404 | — | S | — |
| [ ] | Request_concrete_availability_by_special_characters | ×4 | `GET /concrete-products/±!@#$%^&*()/concrete-product-availabilities` → 404 | — | S | — |
| [ ] | Request_concrete_availability_with_missing_concrete_SKU | ×4 | `GET /concrete-products/±!@#$%^&*()/concrete-product-availabilities` → 400 | — | S | — |
| [ ] | Request_product_image_by_concrete_sku_product_doesn't_exist | ×4 | `GET /concrete-products/4567890/concrete-product-image-sets` → 404 | — | S | — |
| [ ] | Request_product_image_with_abstract_SKU | ×4 | `GET /concrete-products/4567890/concrete-product-image-sets` → 404 | — | S | — |
| [ ] | Request_product_image_with_empty_SKU | ×4 | `GET /concrete-products/4567890/concrete-product-image-sets` → 404 | — | S | — |
| [ ] | Request_product_image_with_special_characters | ×4 | `GET /concrete-products/4567890/concrete-product-image-sets` → 404 | — | S | — |
| [ ] | Request_product_concrete_with_abstract_SKU | ×5 | `GET /concrete-products/~!@#$%^&*()_+/` → 404 | — | S | — |
| [ ] | Request_product_concrete_with_empty_SKU | ×5 | `GET /concrete-products/~!@#$%^&*()_+/` → 400 | — | S | — |
| [ ] | Request_product_concrete_with_product_doesn't_exist | ×5 | `GET /concrete-products/~!@#$%^&*()_+/` → 404 | — | S | — |
| [ ] | Request_product_concrete_with_special_characters | ×5 | `GET /concrete-products/~!@#$%^&*()_+/` → 404 | — | S | — |
| [ ] | Get_product_prices_by_concrete_sku_product_doesn't_exist | ×3 | `GET /concrete-product/$` → 404 | — | S | — |
| [ ] | Get_product_prices_with_abstract_sku | ×3 | `GET /concrete-product/$` → 404 | — | S | — |
| [ ] | Get_product_prices_with_empty_SKU | ×3 | `GET /concrete-product/$` → 400 | — | S | — |
| [ ] | Get_product_prices_with_special_characters | ×3 | `GET /concrete-product/$` → 404 | — | S | — |
| [ ] | Request_URL_type_is_wrong | ×2 | `GET /concrete-product/$` → 404 | — | S | — |
| [ ] | Get_product_label_with_invalid_label_id | ×4 | `GET /product-labels` → 404 | — | S | — |
| [ ] | Get_product_label_with_nonexistend_label_id | ×4 | `GET /product-labels` → 404 | — | S | — |
| [ ] | Get_product_label_without_label_id | ×4 | `GET /product-labels` → 400 | — | S | — |
| [ ] | Get_alternative_product_label_by_id | ×3 | `GET /product-labels/$` → 200 | — | S | — |
| [ ] | Get_discontinued_product_label_by_id | ×5 | `GET /product-labels/$` → 200 | — | S | — |
| [ ] | Get_manual_product_label_by_id | ×3 | `GET /product-labels/$` → 200 | — | S | — |
| [ ] | Get_new_product_label_by_id | ×5 | `GET /product-labels/$` → 200 | — | S | — |
| [ ] | Get_sale_product_label_by_id | ×5 | `GET /product-labels/$` → 200 | — | S | — |
| [ ] | Get_an_attribute_with_non_existent_attribute_id | ×5 | `GET /product-management-attributes/fake` → 404 | — | S | — |
| [ ] | Get_all_product_management_attributes | ×5 | `GET /product-management-attributes/$` → 200 | — | S | — |
| [ ] | Get_product_management_attribute_by_id_normal_editable_attribute | ×5 | `GET /product-management-attributes/$` → 200 | — | S | — |
| [ ] | Get_product_management_attribute_by_id_normal_non_editable_attribute | ×5 | `GET /product-management-attributes/$` → 200 | — | S | — |
| [ ] | Get_product_management_attribute_by_id_superattribute | ×5 | `GET /product-management-attributes/$` → 200 | — | S | — |
| [ ] | Create_a_product_review_with_empty_fields | ×5 | `POST /abstract-products/$` → 422 | — | M | — |
| [ ] | Create_a_product_review_with_invalid_token | ×3 | `POST /abstract-products/$` → 401 | — | S | — |
| [ ] | Create_a_product_review_with_invalid_type | ×5 | `POST /abstract-products/$` → 400 | — | M | — |
| [ ] | Create_a_product_review_with_missing_fields | ×3 | `POST /abstract-products/$` → 422 | — | M | — |
| [ ] | Create_a_product_review_with_missing_type | ×5 | `POST /abstract-products/$` → 400 | — | M | — |
| [ ] | Create_a_product_review_without_token | ×3 | `POST /abstract-products/$` → 403 | — | S | — |
| [ ] | Get_review_by_id_with_missing_abstract_product | ×3 | `POST /abstract-products/$` → 400 | — | S | — |
| [ ] | Get_reviews_with_missing_abstract_product | ×5 | `POST /abstract-products/$` → 400 | — | S | — |
| [ ] | Create_a_product_review | ×5 | `POST /abstract-products/$` → 202 | — | M | — |
| [ ] | Get_a_subset_of_product_reviews | ×3 | `POST /abstract-products/$` → 200 | — | S | — |
| [ ] | Get_product_review_by_id | ×5 | `POST /abstract-products/$` → 200 | — | S | — |
| [ ] | Get_product_reviews_for_product_with_no_reviews | ×5 | `POST /abstract-products/$` → 200 | — | S | — |
| [ ] | Get_a_tax_set_with_invalid_concrete_sku | suite | `GET /abstract-products/fake/product-tax-sets` → 404 | — | S | — |
| [ ] | Get_a_tax_set_with_missing_sku | ×5 | `GET /abstract-products/fake/product-tax-sets` → 404 | — | S | — |
| [ ] | Get_a_tax_set_with_non_existing_sku | ×5 | `GET /abstract-products/fake/product-tax-sets` → 404 | — | S | — |
| [ ] | Get_upselling_products_with_empty_anonymous_id | ×3 | `GET /guest-carts/$` → 400 | — | S | — |
| [ ] | Get_upselling_products_with_invalid_token | ×4 | `GET /guest-carts/$` → 401 | — | S | — |
| [ ] | Get_upselling_products_with_missing_cart_id | ×4 | `GET /guest-carts/not_a_cart/up-selling-products` → 400 | — | M | — |
| [ ] | Get_upselling_products_with_missing_guest_cart_id | ×3 | `GET /guest-carts/$` → 400 | — | S | — |
| [ ] | Get_upselling_products_with_other_anonymous_id | ×3 | `GET /guest-carts/$` → 201 | — | S | — |
| [ ] | Get_upselling_products_without_access_token | ×5 | `GET /guest-carts/$` → 403 | — | S | — |
| [ ] | Get_upselling_products | ×4 | `POST /carts/$` → 201 | — | M | — |
| [ ] | Get_upselling_products_for_cart_containing_multiple_products | ×4 | `GET /carts/$` → 201 | — | M | — |
| [ ] | Get_upselling_products_for_cart_without_upselling_relations | ×4 | `GET /guest-carts/$` → 201 | — | M | — |
| [ ] | Get_upselling_products_for_guest_cart | ×3 | `GET /guest-carts/$` → 201 | — | S | — |
| [ ] | Get_upselling_products_for_guest_cart_containing_multiple_products | ×3 | `GET /guest-carts/$` → 201 | — | S | — |
| [ ] | Get_upselling_products_for_guest_cart_plus_includes | ×3 | `POST /guest-carts/$` → 201 | — | S | — |
| [ ] | Get_upselling_products_for_guest_cart_without_upselling_relations | ×3 | `GET /guest-carts/$` → 201 | — | S | — |
| [ ] | Get_a_measurement_unit_with_empty | ×2 | `GET /product-measurement-units` → 400 | — | S | — |
| [ ] | Get_a_measurement_unit_with_non_existent_unit_id | ×3 | `GET /product-measurement-units` → 404 | — | S | — |
| [ ] | Get_product_measurement_unit_by_id | ×3 | `GET /product-measurement-units/$` → 200 | — | S | — |
| [ ] | Get_a_measurement_unit_with_abstract_sku | ×3 | `GET /concrete-products//sales-units` → 404 | — | S | — |
| [ ] | Get_a_measurement_unit_with_empty_sku | ×3 | `GET /concrete-products//sales-units` → 400 | — | S | — |
| [ ] | Get_a_measurement_unit_with_non_existent_sku | ×3 | `GET /concrete-products//sales-units` → 404 | — | S | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Request_concrete_product_with_5_image_sets | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_prices_default_only | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_prices_default_only_CHF | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_alternative_for_concrete_product_using_abstract_product_SKU | drop | Glue already asserts GET /concrete-products/{id}/concrete-alternative-products -> 404 in ConcreteAlternativeProductsRestApiCest::requestConcreteAlternativeProductsByNotExistingProductConcreteSku. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_alternative_for_concrete_product_with_invalid_sku_of_product | drop | Glue already asserts GET /concrete-products/{id}/concrete-alternative-products -> 404 in ConcreteAlternativeProductsRestApiCest::requestConcreteAlternativeProductsByNotExistingProductConcreteSku. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_product_prices_by_concrete_sku_product_doesn't_exist | drop | Glue already asserts GET /concrete-products/{id}/concrete-product-prices -> 404 in PriceProductConcreteRestApiCest::requestTheNonExistingProductConcretePrices. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_product_prices_with_abstract_sku | drop | Glue already asserts GET /concrete-products/{id}/concrete-product-prices -> 404 in PriceProductConcreteRestApiCest::requestTheNonExistingProductConcretePrices. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_product_prices_with_special_characters | drop | Glue already asserts GET /concrete-products/{id}/concrete-product-prices -> 404 in PriceProductConcreteRestApiCest::requestTheNonExistingProductConcretePrices. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_concrete_product_with_default_and_original_prices | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_concrete_product_with_only_default_price | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_concrete_product_with_volume_product_prices | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_image_sets_with_1_concrete | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_image_sets_with_3_concretes | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_with_1_concrete_with_include_abstract_product_image_sets | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_with_3_concretes_with_include_abstract_product_image_sets | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_prices_detault_only | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_prices_detault_only_CHF | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_with_include_abstract_product_prices_only_default | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_with_include_abstract_product_prices_with_volume_prices | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_with_original_price | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_with_category_nodes_included | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_with_concrete_products_included | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_with_merchants_included | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_with_one_concrete | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_with_product_labels_included | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_with_product_options_included | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_product_availability_by_concrete_SKU_with_stock | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_product_availability_by_concrete_SKU_with_stock_and_never_out_of_stock | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_product_with_5_image_sets | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_product_with_one_image_set | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Cart_contains_product_with_upselling_relation_with_include_category_nodes | drop | Glue already asserts POST /carts -> 201 in CartsRestApiCest::requestCreateCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Product_has_abstract_alternative | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Product_has_abstract_alternative_with_includes | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_image_sets_with_one_concrete | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_image_sets_with_several_concretes | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_prices_by_concrete_sku | drop | Glue already asserts GET /abstract-products/{id}/abstract-product-prices -> 404 in PriceProductAbstractRestApiCest::requestTheNonExistingProductAbstractPrices. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_prices_by_non_existing_sku | drop | Glue already asserts GET /abstract-products/{id}/abstract-product-prices -> 404 in PriceProductAbstractRestApiCest::requestTheNonExistingProductAbstractPrices. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_original_prices | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_original_prices_CHF | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_prices_detault_only | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_volume_prices | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_product_with_3_concrete | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_concrete_availability_by_concrete_SKU_without_stock | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_product_information_by_sku | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_product_with_included_abstract_product | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_product_with_included_availabilities_and_product_prices | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_product_with_included_image_sets | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_product_with_included_product_labels | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_alternative_abstract_with_abstract_SKU | drop | Glue already asserts GET /concrete-products/{id}/abstract-alternative-products -> 404 in AbstractAlternativeProductsRestApiCest::requestAbstractAlternativeProductsByNotExistingProductConcreteSku. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_alternative_abstract_with_nonexistant_SKU | drop | Glue already asserts GET /concrete-products/{id}/abstract-alternative-products -> 404 in AbstractAlternativeProductsRestApiCest::requestAbstractAlternativeProductsByNotExistingProductConcreteSku. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Product_is_available_never_out_of_stock | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Product_is_available_with_3_concrete_stocks_combined | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Product_is_available_with_stock | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Product_is_available_with_stock_and_never_out_of_stock | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Product_is_unavailable | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_image_sets_with_1_concrete | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_image_sets_with_3_concretes | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_prices_by_concrete_SKU | drop | Glue already asserts GET /abstract-products/{id}/abstract-product-prices -> 404 in PriceProductAbstractRestApiCest::requestTheNonExistingProductAbstractPrices. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_prices_by_fake_SKU | drop | Glue already asserts GET /abstract-products/{id}/abstract-product-prices -> 404 in PriceProductAbstractRestApiCest::requestTheNonExistingProductAbstractPrices. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_prices_detault_only | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_prices_detault_only_CHF | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_prices_original_price | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_volume_prices | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_by_concrete_SKU | drop | Glue already asserts GET /abstract-products/{id} -> 404 in ProductAbstractRestApiCest::requestProductAbstractByNotExistingProductAbstractSku. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_by_fake_SKU | drop | Glue already asserts GET /abstract-products/{id} -> 404 in ProductAbstractRestApiCest::requestProductAbstractByNotExistingProductAbstractSku. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_abstract_product_with_missing_SKU | drop | Glue already asserts GET /abstract-products/{id} -> 400 in ProductAbstractRestApiCest::requestProductAbstractWithoutId. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_product_in_different_locales_languages | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_product_with_3_concrete3 | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_product_with_3_concrete_and_concrete_nested_includes | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_product_with_abstract_includes_for_availability_images_taxes_categories_and_prices | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_product_with_abstract_includes_for_options | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_product_with_abstract_includes_for_reviews | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_product_with_concrete_includes_nested_offers | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Abstract_product_with_one_concrete | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_alternative_product | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_alternative_product_for_a_product_that_has_none | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_alternative_product_with_include | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_concrete_availability_by_concrete_SKU_with_stock | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_concrete_availability_by_concrete_SKU_with_stock_and_never_out_of_stock | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_concrete_product_with_multiple_images | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_concrete_product_with_one_image_set | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_product_concrete_by_id | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_product_concrete_with_included_abstract_product | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_product_concrete_with_included_availabilities_and_product_prices | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_product_concrete_with_included_bundled_products | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_product_concrete_with_included_bundled_products_concrete_products_and_abstract_products | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_product_concrete_with_included_image_sets | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_product_concrete_with_included_product_labels_and_product_options | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_product_concrete_with_included_product_offers | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_product_concrete_with_included_product_reviews | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Request_product_concrete_with_included_sales_unit_and_product_measurement_units | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_product_with_CHF_price_and_gross_mode | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_product_with_default_and_original_prices | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_product_with_only_default_price | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_concrete_product_with_volume_product_prices | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_a_review_with_non_existent_review_id | drop | Glue already asserts POST /abstract-products/{id} -> 404 in ProductAbstractProductLabelsRestApiCest::requestProductAbstractWithProductLabelsRelationshipByPost. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_a_reviews_with_non_existent_abstract_product | drop | Glue already asserts POST /abstract-products/{id} -> 404 in ProductAbstractProductLabelsRestApiCest::requestProductAbstractWithProductLabelsRelationshipByPost. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_reviews_with_non_existent_abstract_product | drop | Glue already asserts POST /abstract-products/{id} -> 404 in ProductAbstractProductLabelsRestApiCest::requestProductAbstractWithProductLabelsRelationshipByPost. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_product_reviews | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_product_tax sets | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_related_products_for_concrete_SKU | drop | Glue already asserts GET /abstract-products/{id} -> 404 in ProductAbstractRestApiCest::requestProductAbstractByNotExistingProductAbstractSku. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_related_products_for_nonexistent_SKU | drop | Glue already asserts GET /abstract-products/{id} -> 404 in ProductAbstractRestApiCest::requestProductAbstractByNotExistingProductAbstractSku. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_related_products_without_abstract_SKU | drop | Glue already asserts GET /abstract-products/{id} -> 400 in ProductAbstractRestApiCest::requestProductAbstractWithoutId. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Product_has_no_related_products | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Product_has_related_products | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Product_has_related_products_with_includes | drop | Glue already asserts GET /abstract-products/{id} -> 200 in ProductAbstractRestApiCest::requestProductAbstract. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_upselling_products_using_cart_of_other_customer | drop | Glue already asserts GET /guest-carts/{id} -> 404 in GuestCartsRestApiCest::requestGuestCartByNotExistingGuestCartUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_upselling_products_with_nonexistent_cart_id | drop | Glue already asserts GET /guest-carts/{id} -> 404 in GuestCartsRestApiCest::requestGuestCartByNotExistingGuestCartUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_upselling_products_with_nonexistent_guest_cart_id | drop | Glue already asserts GET /guest-carts/{id} -> 404 in GuestCartsRestApiCest::requestGuestCartByNotExistingGuestCartUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_upselling_products_for_empty_cart | drop | Glue already asserts GET /guest-carts/{id} -> 200 in GuestCartsRestApiCest::requestGuestCartByUuid. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_sales_units_for_product_with_measurement_units_include | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_sales_units_for_product_with_sales_units | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_sales_units_for_product_without_sales_units | drop | Glue already asserts GET /concrete-products/{id} -> 200 in ProductConfigurationRestApiCest::requestProductConcrete. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
