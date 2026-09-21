### order · robot-api-to-codeception · 45 scenarios

MIGRATE 21 · REVIEW 24   ▸ 0/21 verified

Batches: `order-1`, `order-2`

#### MIGRATE / RESHAPE — port these
| ✓ | Scenario | Var | Contract | Target | Eff | Run |
|---|---|---|---|---|---|---|
| [ ] | Get_order_by_order_id_with_net_mode_&_chf_currency_&_express_shipment_method | b2c | `POST /carts/$` → 200 | — | M | — |
| [ ] | Get_customer_orders_list_from_another_customer | mp_b2b | `GET /customers/$` → 403 | — | M | — |
| [ ] | Get_customer_orders_list_with_invalid_access_token | mp_b2b | `GET /customers/$` → 401 | — | S | — |
| [ ] | Get_customer_orders_list_with_invalid_customer_id | mp_b2b | `GET /customers/$` → 403 | — | M | — |
| [ ] | Get_customer_orders_list_without_access_token | mp_b2b | `GET /customers/$` → 403 | — | S | — |
| [ ] | Get_customer_orders_list_without_customer_id | mp_b2b | `GET /customers/$` → 403 | — | M | — |
| [ ] | Get_order_by_order_id_from_another_customer | mp_b2b | `GET /customers/yves_user.reference/orders` → 404 | — | M | — |
| [ ] | Get_order_by_order_id_with_invalid_access_token | mp_b2b | `GET /orders/$` → 401 | — | S | — |
| [ ] | Get_order_by_order_id_without_access_token | mp_b2b | `GET /customers/$` → 403 | — | S | — |
| [ ] | Get_order_by_order_id_with_nonsplit_item | mp_b2b | `POST /carts` → 200 | — | M | — |
| [ ] | Get_customer_orders_list_from_another_customer | ×4 | `GET /customers/$` → 403 | — | M | — |
| [ ] | Get_customer_orders_list_with_invalid_access_token | ×4 | `GET /customers/$` → 401 | — | S | — |
| [ ] | Get_customer_orders_list_with_invalid_customer_id | ×4 | `GET /customers/$` → 403 | — | M | — |
| [ ] | Get_customer_orders_list_without_access_token | ×4 | `GET /customers/$` → 403 | — | S | — |
| [ ] | Get_customer_orders_list_without_customer_id | ×4 | `GET /customers/$` → 403 | — | M | — |
| [ ] | Get_order_by_order_id_from_another_customer | ×4 | `GET /customers/yves_user.reference/orders` → 404 | — | M | — |
| [ ] | Get_order_by_order_id_with_invalid_access_token | ×4 | `GET /orders/$` → 401 | — | S | — |
| [ ] | Get_order_by_order_id_without_access_token | ×4 | `GET /customers/$` → 403 | — | S | — |
| [ ] | Get_order_by_order_id_with_nonsplit_item | ×3 | `POST /carts/$` → 200 | — | M | — |
| [ ] | Get_order_with_configurable_bundle | suite | `GET /orders/$` → 201 | — | M | — |
| [ ] | Get_order_with_gift_card | suite | `GET /orders/$` → 201 | — | M | — |

#### REVIEW — needs a call before this batch can close
| Scenario | Recommended | Why |
|---|---|---|
| Get_order_by_order_id_with_2_product_discounts | drop | Glue already asserts GET /orders/{id} -> 200 in OrderShipmentsRelationshipsCest::requestOrdersWithOrderShipmentsIncludeReturnsEmptyRelationshipForSingleShipmentOrder. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_order_by_order_id_with_mode.net_&_chf_currency_&_express_shipment_method | drop | Glue already asserts GET /orders/{id} -> 200 in OrderShipmentsRelationshipsCest::requestOrdersWithOrderShipmentsIncludeReturnsEmptyRelationshipForSingleShipmentOrder. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_order_by_order_id_with_free_shipping_discount | drop | Glue already asserts GET /orders/{id} -> 200 in OrderShipmentsRelationshipsCest::requestOrdersWithOrderShipmentsIncludeReturnsEmptyRelationshipForSingleShipmentOrder. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_order_by_order_id_with_split_shipment | drop | Glue already asserts GET /orders/{id} -> 200 in OrderShipmentsRelationshipsCest::requestOrdersWithOrderShipmentsIncludeReturnsEmptyRelationshipForSingleShipmentOrder. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_order_with_invalid_order_id | drop | Glue already asserts GET /customers/{id} -> 404 in CustomerReadCest::requestGetCustomerByIdDoesNotReturnAnotherCustomersProfile. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_customer_orders_list | drop | Glue already asserts GET /orders -> 200 in OrdersRestApiCest::requestGetEmptyListOfOrders. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_customer_orders_list_without_order_id | drop | Glue already asserts GET /orders -> 200 in OrdersRestApiCest::requestGetEmptyListOfOrders. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_customer_orders_list_without_order_id_with_pagination | drop | Glue already asserts GET /customers/{id} -> 200 in CustomerReadCest::requestGetCustomerByIdReturnsOneResource. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_order_by_order_id | drop | Glue already asserts GET /orders/{id} -> 200 in OrderShipmentsRelationshipsCest::requestOrdersWithOrderShipmentsIncludeReturnsEmptyRelationshipForSingleShipmentOrder. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_order_by_order_id_with_2_product_discounts | drop | Glue already asserts GET /orders/{id} -> 200 in OrderShipmentsRelationshipsCest::requestOrdersWithOrderShipmentsIncludeReturnsEmptyRelationshipForSingleShipmentOrder. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_order_by_order_id_with_different_items_and_quantity | drop | Glue already asserts GET /orders/{id} -> 200 in OrderShipmentsRelationshipsCest::requestOrdersWithOrderShipmentsIncludeReturnsEmptyRelationshipForSingleShipmentOrder. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_order_by_order_id_with_free_shipping_discount | drop | Glue already asserts GET /orders/{id} -> 200 in OrderShipmentsRelationshipsCest::requestOrdersWithOrderShipmentsIncludeReturnsEmptyRelationshipForSingleShipmentOrder. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_order_by_order_id_with_mode.net_&_chf_currency_&_express_shipment_method | drop | Glue already asserts GET /orders/{id} -> 200 in OrderShipmentsRelationshipsCest::requestOrdersWithOrderShipmentsIncludeReturnsEmptyRelationshipForSingleShipmentOrder. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_order_by_order_id_with_split_shipment | drop | Glue already asserts GET /orders/{id} -> 200 in OrderShipmentsRelationshipsCest::requestOrdersWithOrderShipmentsIncludeReturnsEmptyRelationshipForSingleShipmentOrder. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_order_by_order_id_with_split_shipment_&_include | drop | Glue already asserts GET /orders/{id} -> 200 in OrderShipmentsRelationshipsCest::requestOrdersWithOrderShipmentsIncludeReturnsEmptyRelationshipForSingleShipmentOrder. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_order_with_invalid_order_id | drop | Glue already asserts GET /customers/{id} -> 404 in CustomerReadCest::requestGetCustomerByIdDoesNotReturnAnotherCustomersProfile. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_customer_orders_list | drop | Glue already asserts GET /orders -> 200 in OrdersRestApiCest::requestGetEmptyListOfOrders. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_customer_orders_list_without_order_id | drop | Glue already asserts GET /orders -> 200 in OrdersRestApiCest::requestGetEmptyListOfOrders. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_customer_orders_list_without_order_id_with_pagination | drop | Glue already asserts GET /customers/{id} -> 200 in CustomerReadCest::requestGetCustomerByIdReturnsOneResource. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_order_by_order_id | drop | Glue already asserts GET /orders/{id} -> 200 in OrderShipmentsRelationshipsCest::requestOrdersWithOrderShipmentsIncludeReturnsEmptyRelationshipForSingleShipmentOrder. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_order_by_order_id_with_bundle_product | drop | Glue already asserts GET /orders/{id} -> 200 in OrderShipmentsRelationshipsCest::requestOrdersWithOrderShipmentsIncludeReturnsEmptyRelationshipForSingleShipmentOrder. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_order_by_order_id_with_different_items_and_quantity | drop | Glue already asserts GET /orders/{id} -> 200 in OrderShipmentsRelationshipsCest::requestOrdersWithOrderShipmentsIncludeReturnsEmptyRelationshipForSingleShipmentOrder. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_order_by_order_id_with_sales_unit | drop | Glue already asserts GET /orders/{id} -> 200 in OrderShipmentsRelationshipsCest::requestOrdersWithOrderShipmentsIncludeReturnsEmptyRelationshipForSingleShipmentOrder. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
| Get_order_by_order_id_with_split_shipment_&_include | drop | Glue already asserts GET /orders/{id} -> 200 in OrderShipmentsRelationshipsCest::requestOrdersWithOrderShipmentsIncludeReturnsEmptyRelationshipForSingleShipmentOrder. Confirm it asserts the same thing before dropping — a matching contract is not matching coverage. |
