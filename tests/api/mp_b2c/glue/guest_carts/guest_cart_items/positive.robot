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
    Run Keywords    I send a POST request:    /guest-cart-items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${concrete_available_product_with_offer}","quantity":"1"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    I send a DELETE request:    /guest-carts/${guestCartId}/guest-cart-items/${concrete_available_product_with_offer}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content
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
    Run Keywords    I send a POST request:    /guest-cart-items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${concrete_available_product_with_offer}","quantity":"1"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    I send a DELETE request:    /guest-carts/${guestCartId}/guest-cart-items/${concrete_available_product_with_offer}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content
    # ...    AND    Cleanup items in the guest cart:    ${guestCartId}
    When I send a POST request:    /guest-carts/${guestCartId}/guest-cart-items?include=items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${concrete_available_product_with_offer}","quantity":"1"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [included][0][type]    guest-cart-items
    And Response body parameter should be:    [included][0][id]    ${concrete_available_product_with_offer}
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should not be EMPTY:    [data][links][self]

Update_an_item_quantity_at_the_guest_cart_with_items_include
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    I send a POST request:    /guest-cart-items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${concrete_available_product_with_offer}","quantity":"1"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Response reason should be:    Created
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
    Run Keywords    I send a POST request:    /guest-cart-items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${concrete_available_product_with_offer}","quantity":"1"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    When I send a DELETE request:    /guest-carts/${guestCartId}/guest-cart-items/${concrete_available_product_with_offer}
    Then Response status code should be:    204
    And Response reason should be:    No Content