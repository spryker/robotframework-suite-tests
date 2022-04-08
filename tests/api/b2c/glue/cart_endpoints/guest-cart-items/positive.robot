*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Add_items_to_guest_cart
     [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative_sku}    1
            ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a POST request:    /guest-cart-items?include=items    {"data": {"type": "guest-cart-items","attributes": {"sku": "${concrete_product_with_concrete_product_alternative_sku}","quantity": 3}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][priceMode]    ${gross_mode}
    And Response body parameter should be:    [data][attributes][currency]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][subtotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][priceToPay]
    And Response body parameter should be:    [included][0][type]    guest-cart-items
    And Response body parameter should be:    [included][0][attributes][sku]    ${concrete_product_with_concrete_product_alternative_sku}
    Response body parameter should be greater than:    [included][0][attributes][quantity]    3

Change_item_qty_in_guest_cart
     [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative_sku}    1
            ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a PATCH request:    /guest-carts/${guest_cart_id}/guest-cart-items/${concrete_product_with_concrete_product_alternative_sku}?include=items    {"data": {"type": "guest-cart-items","attributes": {"quantity": "10"}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][priceMode]    ${gross_mode}
    And Response body parameter should be:    [data][attributes][currency]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][subtotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][priceToPay]
    And Response body parameter should be:    [included][0][type]    guest-cart-items
    And Response body parameter should be:    [included][0][attributes][sku]    ${concrete_product_with_concrete_product_alternative_sku}
    Response body parameter should be greater than:    [included][0][attributes][quantity]    1

Remove_item_from_guest_cart
     [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative_sku}    1
            ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a DELETE request:    /guest-carts/${guest_cart_id}/guest-cart-items/${concrete_product_with_concrete_product_alternative_sku}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    And I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    And I send a GET request:    /guest-carts/${guest_cart_id}?include=items
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be:    [data][attributes][totals][subtotal]    0
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    0
    And Response body parameter should be:    [data][attributes][totals][priceToPay]    0

Add_items_to_guest_cart_with_included_items_concrete_products_and_abstract_products
     [Setup]    I set Headers:    X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-cart-items?include=items,concrete-products,abstract-products    {"data": {"type": "guest-cart-items","attributes": {"sku": "${concrete_product_with_concrete_product_alternative_sku}","quantity": 1}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][priceMode]    ${gross_mode}
    And Response body parameter should be:    [data][attributes][currency]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][subtotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][priceToPay]
    And Response body parameter should be:    [included][0][type]    concrete-products
    And Response body parameter should not be EMPTY:    [included][0][id]
    And Response body parameter should not be EMPTY:    [included][0][attributes][sku]
    And Response body parameter should not be EMPTY:    [included][0][attributes][productAbstractSku]
    And Response body parameter should not be EMPTY:    [included][0][attributes][name]
    And Response body parameter should not be EMPTY:    [included][0][attributes][description]
    And Response body parameter should not be EMPTY:    [included][0][attributes][attributes]
    And Response body parameter should not be EMPTY:    [included][0][attributes][superAttributesDefinition]
    And Response body parameter should not be EMPTY:    [included][0][relationships]
    And Response body parameter should be:    [included][1][type]    concrete-products
    And Response body parameter should not be EMPTY:    [included][1][id]
    And Response body parameter should not be EMPTY:    [included][1][attributes][sku]
    And Response body parameter should not be EMPTY:    [included][1][attributes][productAbstractSku]
    And Response body parameter should not be EMPTY:    [included][1][attributes][name]
    And Response body parameter should not be EMPTY:    [included][1][attributes][description]
    And Response body parameter should not be EMPTY:    [included][1][attributes][attributes]
    And Response body parameter should not be EMPTY:    [included][1][attributes][superAttributesDefinition]
    And Response body parameter should not be EMPTY:    [included][1][relationships]
    And Response body parameter should be:    [included][2][type]    abstract-products
    And Response body parameter should not be EMPTY:    [included][2][attributes][name]
    And Response body parameter should not be EMPTY:    [included][2][attributes][description]
    And Response body parameter should not be EMPTY:    [included][2][attributes][attributes]
    And Response body parameter should not be EMPTY:    [included][2][attributes][superAttributesDefinition]
    And Response body parameter should not be EMPTY:    [included][2][attributes][superAttributes]
    And Response body parameter should not be EMPTY:    [included][2][relationships]
    And Response body parameter should be:    [included][3][type]    guest-cart-items
    And Response body parameter should not be EMPTY:    [included][3][id]
    And Response body parameter should not be EMPTY:    [included][3][attributes][sku]
    And Response body parameter should not be EMPTY:    [included][3][attributes][quantity]
    And Response body parameter should not be EMPTY:    [included][3][attributes][groupKey]
    And Response body parameter should not be EMPTY:    [included][3][attributes][abstractSku]

Add_items_to_guest_cart_with_included_cart_rules
     [Setup]    I set Headers:    X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-cart-items?include=cart-rules    {"data": {"type": "guest-cart-items","attributes": {"sku": "${concrete_product_with_concrete_product_alternative_sku}","quantity": 10}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][priceMode]    ${gross_mode}
    And Response body parameter should be:    [data][attributes][currency]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][subtotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][priceToPay]
    And Response body parameter should be:    [included][0][type]    cart-rules
    And Response body parameter should not be EMPTY:    [included][0][id]
    And Response body parameter should not be EMPTY:    [included][0][attributes][amount]
    And Response body parameter should not be EMPTY:    [included][0][attributes][discountType]
    And Response body parameter should not be EMPTY:    [included][0][attributes][displayName]
    And Response body parameter should not be EMPTY:    [included][0][attributes][expirationDateTime]

Add_items_to_guest_cart_with_included_promotional_products
     [Setup]    I set Headers:    X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-cart-items?include=promotional-items    {"data": {"type": "guest-cart-items","attributes": {"sku": "${concrete_product_with_concrete_product_alternative_sku}","quantity": 100}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][priceMode]    ${gross_mode}
    And Response body parameter should be:    [data][attributes][currency]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][subtotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][priceToPay]
    And Response body parameter should be:    [included][0][type]    promotional-items
    And Response body parameter should not be EMPTY:    [included][0][id]
    And Response body parameter should not be EMPTY:    [included][0][attributes][sku]
    And Response body parameter should not be EMPTY:    [included][0][attributes][quantity]
    And Response body parameter should not be EMPTY:    [included][0][attributes][skus]

Add_items_to_guest_cart_with_included_bundle_items
     [Setup]    I set Headers:    X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-cart-items?include=bundle-items,bundled-items    {"data": {"type": "guest-cart-items","attributes": {"sku": "${bundle_product_concrete_sku}","quantity": 1}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][priceMode]    ${gross_mode}
    And Response body parameter should be:    [data][attributes][currency]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][subtotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][priceToPay]
    And Response should contain the array of a certain size:    [data][relationships][bundle-items][data]    1
    And Response should contain the array of a certain size:    [included]    5
    And Response include should contain certain entity type:    bundle-items
    And Response include should contain certain entity type:    bundled-items
    And Response include element has self link:   bundle-items
    And Response include element has self link:   bundled-items
    And Response body parameter should be:    [included][0][type]    bundled-items
    And Response body parameter should be:    [included][0][attributes][sku]    ${bundled_product_1_concrete_sku}
    And Response body parameter should be:    [included][1][type]    bundled-items
    And Response body parameter should be:    [included][1][attributes][sku]    ${bundled_product_2_concrete_sku}
    And Response body parameter should be:    [included][2][type]    bundled-items
    And Response body parameter should be:    [included][2][attributes][sku]    ${bundled_product_3_concrete_sku}
    And Response body parameter should be:    [included][3][type]    bundle-items
    And Response body parameter should be:    [included][3][attributes][sku]    ${bundle_product_concrete_sku}
    And Response body parameter should be:    [included][3][attributes][quantity]    1
    And Response body parameter should be:    [included][3][attributes][groupKey]    ${bundle_product_concrete_sku}
    And Response body parameter should be:    [included][3][attributes][abstractSku]    ${bundle_product_abstract_sku}


