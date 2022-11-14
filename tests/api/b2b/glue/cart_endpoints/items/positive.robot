*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
    
#####POST#####
Add_one_item_to_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku}","quantity": 1}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cart_uid}
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][name]    Cart-${random}
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:   [data][attributes][totals][discountTotal]
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    1
    And Response body parameter should not be EMPTY:    [data][attributes][discounts]
    And Response body parameter should not be EMPTY:    [data][links][self]
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_uid}
    ...    AND    Response status code should be:    204

# Not sure if it makes any sense: I save id and groupKey to variables and then check them out with them from the same response body 
Add_two_items_to_cart_with_included_items_concrete_products_and_abstract_products
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items?include=items,concrete-products,abstract-products    {"data":{"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku}","quantity": 2}}}
    Then Save value to a variable:    [included][2][id]    concrete.available_product.with_stock_and_never_out_of_stock.id
    And Save value to a variable:    [included][2][attributes][groupKey]    concrete.available_product.with_stock_and_never_out_of_stock.groupKey
    And Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cart_uid}
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][name]    Cart-${random}
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][discounts]
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response should contain the array of a certain size:    [data][relationships][items][data]    1
    And Response should contain the array of a certain size:    [included]    3
    And Response include should contain certain entity type:    items
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    abstract-products
    And Response include element has self link:   items
    And Response include element has self link:   concrete-products
    And Response include element has self link:   abstract-products
    And Response body parameter should be:    [included][2][type]    items
    And Response body parameter should be:    [included][2][id]    ${concrete.available_product.with_stock_and_never_out_of_stock.id}
    And Response body parameter should be:    [included][2][attributes][sku]    ${concrete.available_product.with_stock_and_never_out_of_stock.sku}
    And Response body parameter should be:    [included][2][attributes][quantity]    2
    And Response body parameter should be:    [included][2][attributes][groupKey]    ${concrete.available_product.with_stock_and_never_out_of_stock.groupKey}
    And Response body parameter should be:    [included][2][attributes][abstractSku]    ${abstract.available_products.with_stock_and_never_out_of_stock_sku}
    And Response body parameter should be:    [included][2][attributes][amount]    None
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitPrice] 
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumPrice]
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][taxRate]
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitNetPrice]
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumNetPrice]
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitGrossPrice]
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumGrossPrice]
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitTaxAmountFullAggregation]
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumTaxAmountFullAggregation]
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumSubtotalAggregation]
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitSubtotalAggregation]
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitProductOptionPriceAggregation]
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumProductOptionPriceAggregation]   
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitDiscountAmountAggregation]  
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumDiscountAmountAggregation]  
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitDiscountAmountFullAggregation]  
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumDiscountAmountFullAggregation]  
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitPriceToPayAggregation] 
    And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumPriceToPayAggregation] 
    And Response body parameter should be:    [included][2][attributes][salesUnit]    None 
    And Response should contain the array of a certain size:    [included][2][attributes][selectedProductOptions]    0 
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_uid}
    ...    AND    Response status code should be:    204

Get_a_cart_with_included_items_and_concrete_products
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    ...    AND    I send a POST request:    /carts/${cart_uid}/items?include=items   {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku}","quantity": 2}}}
    ...    AND    Save value to a variable:    [included][0][id]    concrete.available_product.with_stock_and_never_out_of_stock.id 
    ...    AND    Save value to a variable:    [included][0][attributes][groupKey]    concrete.available_product.with_stock_and_never_out_of_stock.groupKey  
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_uid}?include=items,concrete-products 
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cart_uid}
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][name]    Cart-${random}
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][discounts]
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response should contain the array of a certain size:    [data][relationships][items][data]    1
    And Response should contain the array of a certain size:    [included]    2
    And Response include should contain certain entity type:    items
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:   items
    And Response include element has self link:   concrete-products
    And Response body parameter should be:    [included][1][type]    items
    And Response body parameter should be:    [included][1][id]    ${concrete.available_product.with_stock_and_never_out_of_stock.id}
    And Response body parameter should be:    [included][1][attributes][sku]    ${concrete.available_product.with_stock_and_never_out_of_stock.sku}
    And Response body parameter should be:    [included][1][attributes][quantity]    2
    And Response body parameter should be:    [included][1][attributes][groupKey]    ${concrete.available_product.with_stock_and_never_out_of_stock.groupKey}
    And Response body parameter should be:    [included][1][attributes][abstractSku]    ${abstract.available_products.with_stock_and_never_out_of_stock_sku}
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
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items?include=cart-rules,promotional-items   {"data": {"type": "items","attributes": {"sku": "${concrete.with_promotions_sku}","quantity": 5}}}
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

Add_bundle_to_cart_with_included_bundle_items_and_bundled_items
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items?include=bundle-items,bundled-items    {"data": {"type": "items","attributes": {"sku": "${bundle_product.product_1.concrete_sku}","quantity": 1}}}
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
    And Response should contain the array of a certain size:    [included]    4
    And Response include should contain certain entity type:    bundle-items
    And Response include should contain certain entity type:    bundled-items
    And Response include element has self link:   bundle-items
    And Response include element has self link:   bundled-items
    And Response body parameter should be:    [included][0][type]    bundled-items
    And Response body parameter should be:    [included][0][attributes][sku]    ${bundle_product.product_2.concrete_sku}
    And Response body parameter should be:    [included][1][type]    bundled-items
    And Response body parameter should be:    [included][1][attributes][sku]    ${bundle_product.product_3.concrete_sku}
    And Response body parameter should be:    [included][2][type]    bundled-items
    And Response body parameter should be:    [included][2][attributes][sku]    ${bundle_product.product_4.concrete_sku}
    And Response body parameter should be:    [included][3][type]    bundle-items
    And Response body parameter should be:    [included][3][attributes][sku]    ${bundle_product.product_1.concrete_sku}
    And Response body parameter should be:    [included][3][attributes][quantity]    1
    And Response body parameter should be:    [included][3][attributes][groupKey]    ${bundle_product.product_1.concrete_sku}
    And Response body parameter should be:    [included][3][attributes][abstractSku]    ${bundle_product.product_1.abstract_sku}
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_uid}
    ...    AND    Response status code should be:    204


Add_random_weight_product_to_cart_with_included_sales_units_and_measurenet_units
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    ...    AND    I send a GET request:    /concrete-products/${concrete.random_weight.sku}?include=sales-units
    ...    AND    Save value to a variable:    [included][0][id]    sales_unit_id
    When I send a POST request:    /carts/${cart_uid}/items?include=items,sales-units,product-measurement-units   {"data": {"type": "items","attributes": {"sku": "${concrete.random_weight.sku}","quantity": 1,"salesUnit": {"id": "${sales_unit_id}","amount": 2.5}}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cart_uid}
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:   [data][attributes][totals][discountTotal]
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    1
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response should contain the array of a certain size:    [data][relationships][items][data]    1
    And Response should contain the array of a certain size:    [included]    3
    And Response include should contain certain entity type:    items
    And Response include should contain certain entity type:    sales-units
    And Response include should contain certain entity type:    product-measurement-units 
    And Response include element has self link:   items
    And Response include element has self link:   sales-units
    And Response include element has self link:   product-measurement-units
    And Response body parameter should be:    [included][0][type]    product-measurement-units
    And Response body parameter should be:    [included][0][id]    ${packaging_unit.m}
    And Response body parameter should be:    [included][1][type]    sales-units
    And Response body parameter should be:    [included][1][id]    ${sales_unit_id}
    And Response body parameter should be:    [included][2][attributes][salesUnit][id]    ${sales_unit_id}
    And Response body parameter should be:    [included][2][attributes][salesUnit][amount]    2.5
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_uid}
    ...    AND    Response status code should be:    204


Add_product_with_options_to_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items?include=items    {"data":{"type": "items","attributes":{"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku}","quantity": 1,"productOptions": [{ "sku": "${product_options.option_1}"},{ "sku": "${product_options.option_2}"}] }}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cart_uid}
    And Response body parameter should be:    [data][type]    carts
    And Response should contain the array of a certain size:    [data][relationships][items][data]    1
    And Response should contain the array of a certain size:    [included]    1
    And Response include should contain certain entity type:    items
    And Response include element has self link:   items
    And Response body parameter should contain:    [included][0][id]    ${concrete.available_product.with_stock_and_never_out_of_stock.sku}
    And Response body parameter should be:    [included][0][attributes][sku]    ${concrete.available_product.with_stock_and_never_out_of_stock.sku}
    And Response body parameter should contain:    [included][0][attributes][groupKey]    ${concrete.available_product.with_stock_and_never_out_of_stock.sku}
    And Response body parameter should be greater than:    [included][0][attributes][calculations][unitProductOptionPriceAggregation]    1
    And Response body parameter should be greater than:    [included][0][attributes][calculations][sumProductOptionPriceAggregation]    1
    And Response should contain the array of a certain size:    [included][0][attributes][selectedProductOptions]    2
    Each array element of array in response should contain property:    [included][0][attributes][selectedProductOptions]    optionGroupName
    Each array element of array in response should contain property:    [included][0][attributes][selectedProductOptions]    sku
    Each array element of array in response should contain property:    [included][0][attributes][selectedProductOptions]    optionName
    Each array element of array in response should contain property:    [included][0][attributes][selectedProductOptions]    price
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_uid}
    ...    AND    Response status code should be:    204

Add_item_with_storage_category_and_2_discounts
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items    {"data": {"type": "items","attributes": {"sku": "${discount.product_1.sku}","quantity": 1}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cart_uid}
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    ${discount.product_1.total_sum_of_discounts}
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    0
    And Response body parameter should be:    [data][attributes][discounts][0][displayName]    ${discounts.discount_1.name}
    And Response body parameter should be:    [data][attributes][discounts][0][amount]    ${discount.product_1.with_discount_20_percent_off_storage}
    And Response body parameter should be:    [data][attributes][discounts][0][code]    None
    And Response body parameter should be:    [data][attributes][discounts][1][displayName]    ${discounts.discount_2.name}
    And Response body parameter should be:    [data][attributes][discounts][1][amount]    ${discount.product_1.with_discount_10_percent_off_minimum_order}
    And Response body parameter should be:    [data][attributes][discounts][1][code]    None
    And Response body parameter should not be EMPTY:    [data][links][self]
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_uid}
    ...    AND    Response status code should be:    204

Add_item_without_storage_category_and_2_discounts
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items    {"data": {"type": "items","attributes": {"sku": "${discount.product_3.sku}","quantity": 1}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cart_uid}
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
    And Response body parameter with rounding should be:    [data][attributes][totals][discountTotal]    ${discount.product_3.with_10_percent_discount_amount}
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    0
    And Response should contain the array of a certain size:    [data][attributes][discounts]    1
    And Response body parameter should be:    [data][attributes][discounts][0][displayName]    ${discounts.discount_2.name}
    And Response body parameter with rounding should be:    [data][attributes][discounts][0][amount]    ${discount.product_3.with_10_percent_discount_amount}
    And Response body parameter should be:    [data][attributes][discounts][0][code]    None
    And Response body parameter should not be EMPTY:    [data][links][self]
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_uid}
    ...    AND    Response status code should be:    204

####### PATCH #######
Change_item_qty_in_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    ...    AND    I send a POST request:    /carts/${cart_uid}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku}","quantity": 1}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_uid
    ...    AND    Save value to a variable:    [included][0][attributes][calculations][sumPriceToPayAggregation]    item_total_price
    When I send a PATCH request:    /carts/${cart_uid}/items/${item_uid}?include=items  {"data":{"type": "items","attributes":{"quantity": 2}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cart_uid}
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [included][0][id]    ${item_uid}
    And Response body parameter should be:    [included][0][attributes][quantity]    2
    And Response body parameter should be greater than:    [included][0][attributes][calculations][sumPriceToPayAggregation]    ${item_total_price}
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_uid}
    ...    AND    Response status code should be:    204

Change_item_amount_in_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    ...    AND    I send a GET request:    /concrete-products/${concrete.random_weight.sku}?include=sales-units
    ...    AND    Save value to a variable:    [included][0][id]    sales_unit_id
    ...    AND    I send a POST request:    /carts/${cart_uid}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${concrete.random_weight.sku}","quantity": 1,"salesUnit": {"id": "${sales_unit_id}","amount": 2.5}}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_uid
    ...    AND    Save value to a variable:    [included][0][attributes][calculations][sumPriceToPayAggregation]    item_total_price
    When I send a PATCH request:    /carts/${cart_uid}/items/${item_uid}?include=items    {"data":{"type": "items","attributes":{"quantity": 2,"salesUnit": {"id": "${sales_unit_id}","amount": 5}}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cart_uid}
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [included][0][id]    ${item_uid}
    And Response body parameter should be:    [included][0][attributes][quantity]    2
    And Response body parameter should be:    [included][0][attributes][amount]    5.0
    And Response body parameter should be greater than:    [included][0][attributes][calculations][sumPriceToPayAggregation]    ${item_total_price}
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_uid}
    ...    AND    Response status code should be:    204

####### DELETE #######
Delete_item_form_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_uid
    ...    AND    I send a POST request:    /carts/${cart_uid}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku}","quantity": 1}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_uid
    When I send a DELETE request:    /carts/${cart_uid}/items/${item_uid}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    And I send a GET request:    /carts/${cart_uid}
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    0 
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_uid}
    ...    AND    Response status code should be:    204