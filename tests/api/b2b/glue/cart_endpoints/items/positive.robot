*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
#####POST#####
Add_one_item_to_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${gross_mode}","currency":"${currency_code_eur}","store":"${store_de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cart_uid}
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][attributes][priceMode]    ${gross_mode}
    And Response body parameter should be:    [data][attributes][currency]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should be:    [data][attributes][name]    Cart-${random}
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:   [data][attributes][totals][discountTotal]
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    1
    And Response body parameter should not be EMPTY:    [data][attributes][discounts]
    And Response body parameter should not be EMPTY:    [data][attributes][thresholds]
    And Response body parameter should not be EMPTY:    [data][links][self]
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_uid}
    ...    AND    Response status code should be:    204

Add_two_items_to_cart_with_included_items_and_concrete_products
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${gross_mode}","currency":"${currency_code_eur}","store":"${store_de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items?include=items,concrete-products   {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 2}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cart_uid}
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][attributes][priceMode]    ${gross_mode}
    And Response body parameter should be:    [data][attributes][currency]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should be:    [data][attributes][name]    Cart-${random}
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][discounts]
    And Response body parameter should not be EMPTY:    [data][attributes][thresholds]
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response should contain the array of a certain size:    [data][relationships][items][data]    1
    And Response should contain the array of a certain size:    [included]    2
    And Response include should contain certain entity type:    items
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:   items
    And Response include element has self link:   concrete-products
    And Response body parameter should be:    [included][1][type]    items
    And Response body parameter should be:    [included][1][id]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [included][1][attributes][sku]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [included][1][attributes][quantity]    2
    And Response body parameter should be:    [included][1][attributes][groupKey]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [included][1][attributes][abstractSku]    ${abstract_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [included][1][attributes][amount]    None
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitPrice] 
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumPrice]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][taxRate]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitNetPrice]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumNetPrice]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitGrossPrice]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumGrossPrice]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitTaxAmountFullAggregation]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumTaxAmountFullAggregation]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumSubtotalAggregation]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitSubtotalAggregation]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitProductOptionPriceAggregation]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumProductOptionPriceAggregation]   
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitDiscountAmountAggregation]  
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumDiscountAmountAggregation]  
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitDiscountAmountFullAggregation]  
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumDiscountAmountFullAggregation]  
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitPriceToPayAggregation] 
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumPriceToPayAggregation] 
    And Response body parameter should be:    [included][1][attributes][salesUnit]    None 
    And Response should contain the array of a certain size:    [included][1][attributes][selectedProductOptions]    0 
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_uid}
    ...    AND    Response status code should be:    204

Get_a_cart_with_included_items_and_concrete_products
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${gross_mode}","currency":"${currency_code_eur}","store":"${store_de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    ...    AND    I send a POST request:    /carts/${cart_uid}/items?include=items   {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 2}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_uid}?include=items,concrete-products 
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cart_uid}
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][attributes][priceMode]    ${gross_mode}
    And Response body parameter should be:    [data][attributes][currency]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should be:    [data][attributes][name]    Cart-${random}
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][discounts]
    And Response body parameter should not be EMPTY:    [data][attributes][thresholds]
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response should contain the array of a certain size:    [data][relationships][items][data]    1
    And Response should contain the array of a certain size:    [included]    2
    And Response include should contain certain entity type:    items
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:   items
    And Response include element has self link:   concrete-products
    And Response body parameter should be:    [included][1][type]    items
    And Response body parameter should be:    [included][1][id]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [included][1][attributes][sku]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [included][1][attributes][quantity]    2
    And Response body parameter should be:    [included][1][attributes][groupKey]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [included][1][attributes][abstractSku]    ${abstract_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [included][1][attributes][amount]    None
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitPrice] 
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumPrice]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][taxRate]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitNetPrice]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumNetPrice]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitGrossPrice]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumGrossPrice]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitTaxAmountFullAggregation]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumTaxAmountFullAggregation]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumSubtotalAggregation]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitSubtotalAggregation]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitProductOptionPriceAggregation]
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumProductOptionPriceAggregation]   
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitDiscountAmountAggregation]  
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumDiscountAmountAggregation]  
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitDiscountAmountFullAggregation]  
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumDiscountAmountFullAggregation]  
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitPriceToPayAggregation] 
    And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumPriceToPayAggregation] 
    And Response body parameter should be:    [included][1][attributes][salesUnit]    None 
    And Response should contain the array of a certain size:    [included][1][attributes][selectedProductOptions]    0 

    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_uid}
    ...    AND    Response status code should be:    204


Add_five_items_to_cart_with_included_cart_rules_and_promotional_items
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${gross_mode}","currency":"${currency_code_eur}","store":"${store_de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items?include=cart-rules,promotional-items   {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_promotions}","quantity": 5}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cart_uid}
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response should contain the array of a certain size:    [data][relationships][cart-rules][data]    1
    And Response should contain the array of a certain size:    [data][relationships][promotional-items][data]    1
    And Response should contain the array of a certain size:    [included]    3
    And Response include should contain certain entity type:    cart-rules
    And Response include should contain certain entity type:    items
    And Response include element has self link:   cart-rules
    And Response include element has self link:   items
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_uid}
    ...    AND    Response status code should be:    204

Add_bundle_to_cart_with_included_bundle_items
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${gross_mode}","currency":"${currency_code_eur}","store":"${store_de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items?include=bundle-items    {"data": {"type": "items","attributes": {"sku": "${bundle_product_concrete_sku}","quantity": 1}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cart_uid}
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    1
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response should contain the array of a certain size:    [data][relationships][bundle-items][data]    1
    And Response should contain the array of a certain size:    [included]    1
    And Response include should contain certain entity type:    bundle-items
    And Response include element has self link:   bundle-items
    And Response body parameter should be:    [included][0][type]    bundle-items
    And Response body parameter should be:    [included][0][id]    ${bundle_product_concrete_sku}
    And Response body parameter should be:    [included][0][attributes][sku]    ${bundle_product_concrete_sku}
    And Response body parameter should be:    [included][0][attributes][quantity]    1
    And Response body parameter should be:    [included][0][attributes][groupKey]    ${bundle_product_concrete_sku}
    And Response body parameter should be:    [included][0][attributes][abstractSku]    ${bundle_product_abstract_sku}
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_uid}
    ...    AND    Response status code should be:    204


Add_random_weight_product_to_cart_with_included_sales_units
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${gross_mode}","currency":"${currency_code_eur}","store":"${store_de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    ...    AND    I send a GET request:    /concrete-products/${concrete_product_random_weight_sku}?include=sales-units
    ...    AND    Save value to a variable:    [included][0][id]    sales_unit_id
    When I send a POST request:    /carts/${cart_uid}/items?include=items,sales-units   {"data": {"type": "items","attributes": {"sku": "${concrete_product_random_weight_sku}","quantity": 1,"salesUnit": {"id": "${sales_unit_id}","amount": 2.5}}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cart_uid}
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][attributes][amount]    2.5
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:   [data][attributes][totals][discountTotal]
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    1
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response should contain the array of a certain size:    [data][relationships][items][data]    1
    And Response should contain the array of a certain size:    [included]    2
    And Response include should contain certain entity type:    items
    And Response include should contain certain entity type:    sales-units
    And Response include element has self link:   items
    And Response include element has self link:   sales-units
    And Response body parameter should be:    [included][0][type]    sales-units
    And Response body parameter should be:    [included][0][id]    ${sales_unit_id}
    And Response body parameter should be:    [included][1][attributes][salesUnit][id]    ${sales_unit_id}
    And Response body parameter should be:    [included][1][attributes][salesUnit][amount]    2.5
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_uid}
    ...    AND    Response status code should be:    204


Add_product_with_options_to_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${gross_mode}","currency":"${currency_code_eur}","store":"${store_de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items?include=items    {"data":{"type": "items","attributes":{"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1,"productOptions": [{ "sku": "${product_option_1}"},{ "sku": "${product_option_2}"}] }}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cart_uid}
    And Response body parameter should be:    [data][type]    carts
    And Response should contain the array of a certain size:    [data][relationships][items][data]    1
    And Response should contain the array of a certain size:    [included]    1
    And Response include should contain certain entity type:    items
    And Response include element has self link:   items
    And Response body parameter should contain:    [included][0][id]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be:    [included][0][attributes][sku]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should contain:    [included][0][attributes][groupKey]    ${concrete_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be greater than:    [included][0][attributes][calculations][unitProductOptionPriceAggregation]    1
    And Response body parameter should be greater than:    [included][0][attributes][calculations][sumProductOptionPriceAggregation]    1
    And Response should contain the array of a certain size:    [included][0][attributes][selectedProductOptions]    2
    Each array element of array in response should contain property:    [included][0][attributes][selectedProductOptions]    optionGroupName
    Each array element of array in response should contain property:    [included][0][attributes][selectedProductOptions]    sku
    Each array element of array in response should contain property:    [included][0][attributes][selectedProductOptions]    optionName
    Each array element of array in response should contain property:    [included][0][attributes][selectedProductOptions]    price
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_uid}
    ...    AND    Response status code should be:    204
