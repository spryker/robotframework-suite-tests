*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Add_an_item_to_the_guest_cart
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product_with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    Cleanup All Items In The Guest Cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guestCartId}/guest-cart-items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${concrete_available_product_with_offer}","quantity":"1"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${guestCartId}
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should be:    [data][attributes][priceMode]    ${gross_mode}
    And Response body parameter should be:    [data][attributes][currency]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    1
    And Response body parameter should not be EMPTY:    [data][attributes][discounts]
    And Each array element of array in response should contain property:    [data][attributes][discounts]    displayName
    And Each array element of array in response should contain property:    [data][attributes][discounts]    amount
    And Each array element of array in response should contain property:    [data][attributes][discounts]    code
    And Response body parameter should contain:    [data][attributes]    thresholds
    And Response body parameter should not be EMPTY:    [data][links][self]

Add_an_item_to_the_guest_cart_with_items_include
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product_with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    Cleanup All Items In The Guest Cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guestCartId}/guest-cart-items?include=items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${concrete_product_with_concrete_product_alternative_sku}","quantity":"1"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [included][0][type]    guest-cart-items
    And Response body parameter should be:    [included][0][id]    ${concrete_product_with_concrete_product_alternative_sku}
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should not be EMPTY:    [data][links][self]

Add_an_item_to_the_guest_cart_with_concrete_products_and_abstract_products_includes
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative_sku}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    Cleanup All Items In The Guest Cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guestCartId}/guest-cart-items?include=concrete-products,abstract-products    {"data":{"type":"guest-cart-items","attributes":{"sku":"${concrete_product_with_concrete_product_alternative_sku}","quantity":"1"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response should contain the array of a certain size:    [included]    4
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    abstract-products
    And Response include should contain certain entity type:    guest-cart-items
    And Response include element has self link:   guest-cart-items
    And Response include element has self link:   abstract-products
    And Response include element has self link:   concrete-products

Add_an_item_to_the_guest_cart_with_cart_rules_and_promotional_items_includes
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative_sku}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    Cleanup All Items In The Guest Cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guestCartId}/guest-cart-items?include=cart-rules,promotional-items   {"data":{"type":"guest-cart-items","attributes":{"sku":"${concrete_product_with_concrete_product_alternative_sku}","quantity": 10}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${guestCartId}
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response should contain the array of a certain size:    [data][relationships][cart-rules][data]    1
    And Response should contain the array of a certain size:    [data][relationships][promotional-items][data]    2
    And Response should contain the array of a certain size:    [included]    4
    And Response include should contain certain entity type:    cart-rules
    And Response include should contain certain entity type:    guest-cart-items
    And Response include should contain certain entity type:    promotional-items
    And Response include element has self link:   cart-rules
    And Response include element has self link:   guest-cart-items
    And Response include element has self link:   promotional-items

Add_an_item_to_the_guest_cart_with_bundle_items_include
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative_sku}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    Cleanup All Items In The Guest Cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guestCartId}/guest-cart-items?include=bundle-items,bundled-items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${bundle_product_concrete_sku}","quantity":"1"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response body parameter should be:    [included][0][attributes][sku]    ${bundled_product_1_concrete_sku}
    And Response body parameter should be:    [included][1][attributes][sku]    ${bundled_product_2_concrete_sku}
    And Response body parameter should be:    [included][2][attributes][sku]    ${bundled_product_3_concrete_sku}
    And Response body parameter should be:    [included][3][attributes][sku]    ${bundle_product_concrete_sku}
    And Response body parameter should be:    [included][3][attributes][quantity]    1
    And Response body parameter should be:    [included][3][attributes][groupKey]    ${bundle_product_concrete_sku}
    And Response body parameter should be:    [included][3][attributes][abstractSku]    ${bundle_product_abstract_sku}
    And Response should contain the array of a certain size:    [included]    4
    And Response include should contain certain entity type:    bundled-items
    And Response include should contain certain entity type:    bundle-items
    And Response include element has self link:   bundled-items
    And Response include element has self link:   bundle-items

Update_an_item_quantity_at_the_guest_cart_with_items_include
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product_with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    When I send a PATCH request:    /guest-carts/${guestCartId}/guest-cart-items/${concrete_available_product_with_offer}?include=items    {"data":{"type":"guest-cart-items","attributes":{"quantity":"2"}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${guestCartId}
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should be:    [data][attributes][priceMode]    ${gross_mode}
    And Response body parameter should be:    [data][attributes][currency]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][store]    ${store_de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    1
    And Response body parameter should not be EMPTY:    [data][attributes][discounts]
    And Each array element of array in response should contain property:    [data][attributes][discounts]    displayName
    And Each array element of array in response should contain property:    [data][attributes][discounts]    amount
    And Each array element of array in response should contain property:    [data][attributes][discounts]    code
    And Response body parameter should contain:    [data][attributes]    thresholds
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response body parameter should be:    [included][0][type]    guest-cart-items
    And Response body parameter should be:    [included][0][id]    ${concrete_available_product_with_offer}
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should be:    [included][0][attributes][quantity]    2
    And Response body parameter should not be EMPTY:    [data][links][self]

Remove_an_item_from_the_guest_cart
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product_with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    When I send a DELETE request:    /guest-carts/${guestCartId}/guest-cart-items/${concrete_available_product_with_offer}
    Then Response status code should be:    204
    And Response reason should be:    No Content