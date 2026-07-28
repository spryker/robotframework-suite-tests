### checkout · robot-api-to-codeception · 79 scenarios

MIGRATE 40 · REVIEW 39   ▸ 0/40 ported

Batches: `checkout-1`, `checkout-2`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Create_order_with_invalid_email_&_salutation | b2b | `POST ...` → 204 | — | M | — |
| [ ] | Create_order_with_lower_order_total_price_than_threshold_limit | ×2 | `POST ...` → 204 | — | M | — |
| [ ] | Create_order_with_mode.net_&_chf_currency_&_express_shipment_method | b2b | `POST /carts/$` → 201 | — | M | — |
| [ ] | Create_order_with_weight_product_&_product_options | ×2 | `POST ...` → 201 | — | M | — |
| [ ] | Create_order_for_guest_user_without_anonymous_id | b2c | `POST /checkout` → 400 | — | S | — |
| [ ] | Create_order_with_higher_order_total_price_than_threshold_limit | b2c | `POST /checkout?include=orders` | — | M | — |
| [ ] | Create_order_with_split_shipments_&_invalid_shipment.delivery_date | b2c | `POST /checkout?include=orders` | — | M | — |
| [ ] | Create_order_with_bundle_product | ×2 | `POST /carts/$` → 201 | — | M | — |
| [ ] | Create_order_with_invalid_checkout_data | mp_b2c | `POST /checkout?include=orders` | — | M | — |
| [ ] | Deleting_cart | mp_b2c | `POST /checkout?include=orders` → 400 | — | M | — |
| [ ] | Create_order_with_empty_billing_address_data | ×5 | `POST /carts/$` | — | M | — |
| [ ] | Create_order_with_empty_customer_attributes_and_cart_id | ×5 | `POST /checkout` | — | M | — |
| [ ] | Create_order_with_empty_payments | ×5 | `POST /checkout` | — | M | — |
| [ ] | Create_order_with_empty_shipping_address_data | ×5 | `POST /carts/$` | — | M | — |
| [ ] | Create_order_with_empty_type | ×5 | `POST /checkout` → 400 | — | M | — |
| [ ] | Create_order_with_invalid_access_token | ×5 | `POST /checkout` → 401 | — | M | — |
| [ ] | Create_order_with_invalid_type | ×5 | `POST /checkout` → 400 | — | M | — |
| [ ] | Create_order_with_split_shipments_&_invalid_delivery_date | ×4 | `POST /checkout?include=orders` | — | M | — |
| [ ] | Create_order_without_access_token | ×5 | `POST /checkout` → 400 | — | M | — |
| [ ] | Create_order_without_billing_address_data | ×5 | `POST /checkout` | — | M | — |
| [ ] | Create_order_without_customer_attributes_and_cart_id | ×5 | `POST /checkout` | — | M | — |
| [ ] | Create_order_without_payments | ×5 | `POST /checkout` | — | M | — |
| [ ] | Create_order_without_shipping_address_data | ×5 | `POST /checkout` | — | M | — |
| [ ] | Create_order_without_type | ×5 | `POST /checkout` → 400 | — | M | — |
| [ ] | Create_order_with_net_mode_&_chf_currency_&_express_shipment_method | ×3 | `POST /carts/$` → 201 | — | M | — |
| [ ] | Provide_checkout_data_with_empty_customer_attributes_and_cart_id | ×4 | `POST /checkout-data` | — | M | — |
| [ ] | Provide_checkout_data_with_empty_payments | ×4 | `POST /checkout-data` → 204 | — | M | — |
| [ ] | Provide_checkout_data_with_empty_type | ×4 | `POST /checkout-data` → 400 | — | M | — |
| [ ] | Provide_checkout_data_with_invalid_access_token | ×4 | `POST /checkout-data` → 401 | — | M | — |
| [ ] | Provide_checkout_data_with_invalid_type | ×4 | `POST /checkout-data` → 400 | — | M | — |
| [ ] | Provide_checkout_data_without_access_token | ×4 | `POST /checkout-data` → 400 | — | M | — |
| [ ] | Provide_checkout_data_without_billing_address_data | ×4 | `POST /carts/$` → 204 | — | M | — |
| [ ] | Provide_checkout_data_without_customer_attributes_and_cart_id | ×4 | `POST /checkout-data` | — | M | — |
| [ ] | Provide_checkout_data_without_payments | ×4 | `POST /checkout-data` → 204 | — | M | — |
| [ ] | Provide_checkout_data_without_shipping_address_data | ×4 | `POST /carts/$` → 204 | — | M | — |
| [ ] | Provide_checkout_data_without_type | ×4 | `POST /checkout-data` → 400 | — | M | — |
| [ ] | Provide_checkout_data_with_bundle_product | ×4 | `DELETE /carts/$` → 200 | — | M | — |
| [ ] | Provide_checkout_data_with_invalid_billing_address_data | ×4 | `POST /carts` → 200 | — | M | — |
| [ ] | Provide_checkout_data_with_invalid_payments | ×4 | `DELETE /carts/$` → 200 | — | M | — |
| [ ] | Provide_checkout_data_with_invalid_shipping_address_data | ×4 | `POST /carts` → 200 | — | M | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Create_order_for_guest_user | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_chf_currency_&_express_shipment_method | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_free_shipping_discount | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_product_options | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Provide_checkout_data | drop | Glue already asserts POST /checkout-data -> 200 in CheckoutDataRelationshipsCest::requestCheckoutDataIncludesServicePointsRelationship. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_cart_id_from_another_customer | drop | Glue already asserts POST /checkout -> 422 in CheckoutRestApiCest::requestWithNoItemsInQuote. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_empty_cart | drop | Glue already asserts POST /checkout -> 422 in CheckoutRestApiCest::requestWithNoItemsInQuote. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_invalid_billing_address_data | drop | Glue already asserts POST /checkout -> 422 in CheckoutRestApiCest::requestWithNoItemsInQuote. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_invalid_cart_id | drop | Glue already asserts POST /checkout -> 422 in CheckoutRestApiCest::requestWithNoItemsInQuote. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_invalid_email | drop | Glue already asserts POST /checkout -> 422 in CheckoutRestApiCest::requestWithNoItemsInQuote. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_invalid_payment_method | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_invalid_payments | drop | Glue already asserts POST /checkout -> 422 in CheckoutRestApiCest::requestWithNoItemsInQuote. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_invalid_shipment_method_id | drop | Glue already asserts POST /checkout -> 422 in CheckoutRestApiCest::requestWithNoItemsInQuote. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_invalid_shipping_address_data | drop | Glue already asserts POST /checkout -> 422 in CheckoutRestApiCest::requestWithNoItemsInQuote. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_regular_shipment_&_split_shipments | drop | Glue already asserts POST /checkout -> 422 in CheckoutRestApiCest::requestWithNoItemsInQuote. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_split_shipments_&_empty_shipping_address | drop | Glue already asserts POST /checkout -> 422 in CheckoutRestApiCest::requestWithNoItemsInQuote. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_split_shipments_&_invalid_shipping_address | drop | Glue already asserts POST /checkout -> 422 in CheckoutRestApiCest::requestWithNoItemsInQuote. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_split_shipments_&_without_shipping_address | drop | Glue already asserts POST /checkout -> 422 in CheckoutRestApiCest::requestWithNoItemsInQuote. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_two_payment_method | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_without_shipment_method_id | drop | Glue already asserts POST /checkout -> 422 in CheckoutRestApiCest::requestWithNoItemsInQuote. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_checkout_with_gift_card | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_checkout_with_gift_card_when_gift_amount_partially_used | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_include_orders | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_2_product_discounts | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_configurable_bundle_item | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_configurable_product | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_same_items_in_different_shipments | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_split_shipments | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Create_order_with_split_shipments_&_same_shipping_address | drop | Glue already asserts POST /checkout -> 201 in CheckoutRestApiCest::requestWithOneItemInQuoteAndInvoicePayment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Provide_checkout_data_with_cart_id_from_another_customer | drop | Glue already asserts POST /checkout-data -> 422 in ServicePointShipmentTypeCheckoutDataRestApiCest::requestCheckoutDataReturnsServicePointNotProvidedUnprocessableEntityForMultiShipment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Provide_checkout_data_with_empty_billing_address_data | drop | Glue already asserts DELETE /carts/{id} -> 204 in CartsRestApiCest::requestDeleteCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Provide_checkout_data_with_empty_shipping_address_data | drop | Glue already asserts DELETE /carts/{id} -> 204 in CartsRestApiCest::requestDeleteCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Provide_checkout_data_with_invalid_cart_id | drop | Glue already asserts POST /checkout-data -> 422 in ServicePointShipmentTypeCheckoutDataRestApiCest::requestCheckoutDataReturnsServicePointNotProvidedUnprocessableEntityForMultiShipment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Provide_checkout_data_with_invalid_email | drop | Glue already asserts POST /checkout-data -> 422 in ServicePointShipmentTypeCheckoutDataRestApiCest::requestCheckoutDataReturnsServicePointNotProvidedUnprocessableEntityForMultiShipment. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Provide_checkout_data_without_shipment_method_id | drop | Glue already asserts DELETE /carts/{id} -> 204 in CartsRestApiCest::requestDeleteCart. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Provide_checkout_data_with_empty_cart | drop | Glue already asserts POST /checkout-data -> 200 in CheckoutDataRelationshipsCest::requestCheckoutDataIncludesServicePointsRelationship. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Provide_checkout_data_with_invalid_shipment_method_id | drop | Glue already asserts POST /checkout-data -> 200 in CheckoutDataRelationshipsCest::requestCheckoutDataIncludesServicePointsRelationship. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Provide_checkout_with_only_cart_id | drop | Glue already asserts POST /checkout-data -> 200 in CheckoutDataRelationshipsCest::requestCheckoutDataIncludesServicePointsRelationship. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
