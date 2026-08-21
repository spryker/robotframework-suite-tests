### search · robot-api-to-codeception · 73 scenarios

MIGRATE 24 · REVIEW 49   ▸ 0/24 verified

Batches: `search-1`, `search-2`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Search_set_specific_page_with_ipp.default | b2b | `GET ...` → 200 | — | S | — |
| [ ] | Get_search_suggestions_without_query_parameter | ×4 | `GET /catalog-search-suggestions?q=$` → 200 | — | S | — |
| [ ] | Filter_by_price_Min_max | ×2 | `GET /catalo` → 200 | — | S | — |
| [ ] | Search_with_invalid_category | mp_b2c | `GET /catalog-search?q=&category=!@!@!` → 400 | — | S | — |
| [ ] | Search_with_invalid_currency | mp_b2c | `GET /catalog-search?q=&category=!@!@!` → 400 | — | S | — |
| [ ] | Search_with_invalid_price_mode | mp_b2c | `GET /catalog-search?q=&category=!@!@!` → 400 | — | S | — |
| [ ] | Search_with_invalid_rating_max | mp_b2c | `GET /catalog-search?q=&category=!@!@!` → 400 | — | S | — |
| [ ] | Search_with_invalid_rating_min | mp_b2c | `GET /catalog-search?q=&category=!@!@!` → 400 | — | S | — |
| [ ] | Filter_by_label_one_label | ×5 | `GET /catalog-search?q=&label[]=test123` → 200 | — | S | — |
| [ ] | Get_search_suggestions_with_11_symbols | ×2 | `GET /catalog-search-suggestions?q=$` → 200 | — | S | — |
| [ ] | Get_search_suggestions_with_abstract_product_sku | ×4 | `GET /catalog-search-suggestions?q=$` → 200 | — | S | — |
| [ ] | Get_search_suggestions_with_abstract_product_sku_and_included_abstract_products | ×4 | `GET /catalog-search-suggestions?q=$` → 200 | — | S | — |
| [ ] | Get_search_suggestions_with_all_attributes_data | ×4 | `GET /catalog-search-suggestions?q=sony` → 200 | — | S | — |
| [ ] | Get_search_suggestions_with_brand_and_color | ×2 | `GET /catalog-search-suggestions?q=$` → 200 | — | S | — |
| [ ] | Get_search_suggestions_with_brand_and_currency | ×4 | `GET /catalog-search-suggestions?q=$` → 200 | — | S | — |
| [ ] | Get_search_suggestions_with_category_collection | ×4 | `GET /catalog-search-suggestions?q=$` → 200 | — | S | — |
| [ ] | Get_search_suggestions_with_cms_page_collection | ×4 | `GET /catalog-search-suggestions?q=$` → 200 | — | S | — |
| [ ] | Get_search_suggestions_with_cms_pages | ×4 | `GET /catalog-search-suggestions?q=$` → 200 | — | S | — |
| [ ] | Get_search_suggestions_with_color | ×4 | `GET /catalog-search-suggestions?q=$` → 200 | — | S | — |
| [ ] | Get_search_suggestions_with_concrete_product_sku | ×4 | `GET /catalog-search-suggestions?q=$` → 200 | — | S | — |
| [ ] | Get_search_suggestions_with_discontinued_product_sku | ×4 | `GET /catalog-search-suggestions?q=sony` → 200 | — | S | — |
| [ ] | Get_search_suggestions_with_empty_q_parameter | ×4 | `GET /catalog-search-suggestions?q=$` → 200 | — | S | — |
| [ ] | Get_search_suggestions_with_few_symbols | ×4 | `GET /catalog-search-suggestions?q=$` → 200 | — | S | — |
| [ ] | Get_search_suggestions_with_non_existing_product_sku | ×4 | `GET /catalog-search-suggestions?q=$` → 200 | — | S | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Filter_by_material_empty_material | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_material_non_existing_material | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_material_one_material | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_material_two_materials | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_valid_sub_subcategory | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_set_last_page_and_nonipp.default | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_set_specific_page_and_nonipp.default | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_price_only_max | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_price_only_min | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_sort_by_price_filter_query_parameter_and_pagination | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_material_non_existing_materail | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_material_two_materails | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_by_abstract_sku_per_store | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_without_query_parameter | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_brand_empty_brand | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_brand_non_existing_brand | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_brand_one_brand | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_brand_two_brands | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_color_empty_color | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_color_non_existing_color | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_color_one_color | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_color_two_colors | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_label_empty_label | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_label_non_existing_label | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_label_two_labels | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_rating_Min_max | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_rating_only_max | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_rating_only_min | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_valid_main_category | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Filter_by_valid_subcategory | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_by_abstract_sku | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_by_abstract_sku_with_abstract_include | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_by_attribute_(brand) | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_by_attribute_that_does_not_return_products | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_by_concrete_sku | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_by_full_name | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_by_name_substring | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_by_several_attributes | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_set_invalid_ipp | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_set_last_page_and_nondefault_ipp | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_set_specific_page_and_nondefault_ipp | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_set_specific_page_with_default_ipp | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_sort_by_name_asc | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_sort_by_name_desc | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_sort_by_price_asc | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_sort_by_price_desc | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_sort_by_rating | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_with_empty_search_criteria_all_default_values_check | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Search_with_specific_currency | drop | Glue already asserts GET /catalog-search -> 200 in CatalogSearchRestApiCest::requestWithoutAcceptHeaderFallsBackToLegacyJsonApiDefault. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
