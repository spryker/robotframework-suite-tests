### product-offer · robot-api-to-codeception · 48 scenarios

MIGRATE 48   ▸ 0/48 verified

Batches: `product-offer-1`, `product-offer-2`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Get_empty_product_offer_availabilities | mp_b2b | `GET /product-offers/$` → 400 | — | S | — |
| [ ] | Get_not_existing_product_offer_availabilities | mp_b2b | `GET /product-offers/$` → 404 | — | S | — |
| [ ] | Get_not_existing_product_offer_availabilities_for_inactive_product_offer | mp_b2b | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_not_existing_product_offer_availabilities_for_waiting_for_approval_product_offer | mp_b2b | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_with_gross_chf_volume_prices | mp_b2b | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_with_gross_eur_volume_prices | mp_b2b | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_with_net_chf_volume_prices | mp_b2b | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_with_net_eur_volume_prices | mp_b2b | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_without_volume_prices | mp_b2b | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_prices_with_invalid_offerId | mp_b2c | `GET /product-offers/InvalidOfferId/product-offer-prices` → 404 | — | S | — |
| [ ] | Retrieve_prices_of_a_product_offer_without_offerId | mp_b2c | `GET /product-offers/InvalidOfferId/product-offer-prices` → 400 | — | S | — |
| [ ] | Get_default&original_prices_of_a_product_offer | mp_b2c | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_with_volume_price | mp_b2c | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_without_volume_price | mp_b2c | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_with_invalid_offer_id | mp_b2c | `GET /concrete-products//product-offers` → 404 | — | S | — |
| [ ] | Get_product_offer_availabilities_with_invalid_offerId | ×2 | `GET /product-offers/InvalidOfferId/product-offer-availabilities` → 404 | — | S | — |
| [ ] | Get_product_offer_availabilities_without_offerId | ×2 | `GET /product-offers/InvalidOfferId/product-offer-availabilities` → 400 | — | S | — |
| [ ] | Get_product_offer_availabilities | ×3 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_not_existing_concrete_product_offers_price | ×2 | `GET /product-offers/test/product-offer-prices` → 200 | — | S | — |
| [ ] | Get_product_offer_prices_with_invaild_offer_id | ×2 | `GET /product-offers/test/product-offer-prices` → 404 | — | S | — |
| [ ] | Get_product_offer_prices_without_offer_id | ×2 | `GET /product-offers/test/product-offer-prices` → 400 | — | S | — |
| [ ] | Get_product_offer_with_volume_prices_included_for_denied_product_offer | ×3 | `GET /product-offers/test/product-offer-prices` → 404 | — | S | — |
| [ ] | Get_product_offer_with_volume_prices_included_for_inactive_product_offer | ×3 | `GET /product-offers/test/product-offer-prices` → 404 | — | S | — |
| [ ] | Get_product_offer_with_volume_prices_included_for_waiting_for_approval_product_offer | ×3 | `GET /product-offers/test/product-offer-prices` → 404 | — | S | — |
| [ ] | Get_product_offers_price_without_complete_url | ×2 | `GET /product-offers/test/product-offer-prices` → 400 | — | S | — |
| [ ] | Get_all_concrete_product_offer_info_with_product_offer_prices_and_product_offer_availabilities_and_merchants_included | ×3 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_all_product_offer_info_with_product_offer_prices_and_merchants_included | ×2 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_concrete_product_without_offers_prices | ×2 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_price_with_gross_chf | ×2 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_price_with_gross_eur_volume_prices | ×2 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_price_with_net_chf | ×2 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_price_with_net_eur_volume_prices | ×2 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_price_without_volume_prices | ×2 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Retrieve_prices_of_a_product_offer | ×2 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_not_existing_concrete_product_offers | ×3 | `GET /concrete-products//product-offers` → 200 | — | S | — |
| [ ] | Get_product_offer_with_empty_product_id | ×3 | `GET /concrete-products//product-offers` → 400 | — | S | — |
| [ ] | Get_product_offer_with_invaild_offer_id | suite | `GET /concrete-products//product-offers` → 404 | — | S | — |
| [ ] | Get_product_offers_without_product_offer_id | ×3 | `GET /concrete-products//product-offers` → 400 | — | S | — |
| [ ] | Get_all_product_offer_info_with_product_offer_prices_and_product_offer_availabilities_and_merchants_included | ×3 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_concrete_product_without_offers | ×3 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_with_gross_chf | ×2 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_with_gross_eur | ×2 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_with_net_chf | ×2 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Get_product_offer_with_net_eur | ×2 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Retrieving_product_offer | ×2 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Retrieving_product_offer_including_merchants | ×2 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Retrieving_product_offer_including_product_offer_availabilities | ×2 | `GET /product-offers/$` → 200 | — | S | — |
| [ ] | Retrieving_product_offer_including_product_offer_prices | ×2 | `GET /product-offers/$` → 200 | — | S | — |
