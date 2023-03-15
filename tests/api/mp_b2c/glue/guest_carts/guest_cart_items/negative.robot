*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Add_an_item_to_the_guest_cart_without_x_anonymous_customer_unique_id
    When I send a POST request:    /guest-cart-items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${concrete_available_product.with_offer}","quantity":"1"}}}
    Then Response status code should be:    400
    And Response should return error code:    109
    And Response reason should be:    Bad Request
    And Response should return error message:    Anonymous customer unique id is empty.

Add_an_item_to_the_guest_cart_of_another_anonymous_customer
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product.with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}1
    When I send a POST request:    /guest-carts/${guest_cart_id}/guest-cart-items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${concrete_available_product.with_offer}","quantity":"1"}}}
    Then Response status code should be:    404
    And Response should return error code:    101
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.

Add_an_item_to_the_non_existing_guest_cart
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-carts/guestCartId/guest-cart-items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${concrete_available_product.with_offer}","quantity":"1"}}}
    Then Response status code should be:    404
    And Response should return error code:    101
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.

Add_an_non_existing_item_to_the_guest_cart
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product.with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    Cleanup All Items In The Guest Cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guestCartId}/guest-cart-items    {"data":{"type":"guest-cart-items","attributes":{"sku":"non_existing_item","quantity":"1"}}}
    Then Array in response should contain property with value:    [errors]    code    102
    And Array in response should contain property with value:    [errors]    code    113
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Response reason should be:    Unprocessable Content
    And Array in response should contain property with value:    [errors]    detail    Product "non_existing_item" not found
    And Array in response should contain property with value:    [errors]    detail    Cart item could not be added.

Add_an_item_to_the_guest_cart_without_sku_attribute_and_quantity_attribute
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product.with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    Cleanup All Items In The Guest Cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guestCartId}/guest-cart-items    {"data":{"type":"guest-cart-items","attributes":{}}}
    Then Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Response reason should be:    Unprocessable Content
    And Array in response should contain property with value:    [errors]    detail    sku => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    quantity => This field is missing.

Add_an_item_to_the_guest_cart_without_sku_and_quantity_values
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product.with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    Cleanup All Items In The Guest Cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guestCartId}/guest-cart-items    {"data":{"type":"guest-cart-items","attributes":{"sku":"","quantity":""}}}
    Then Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Response reason should be:    Unprocessable Content
    And Array in response should contain property with value:    [errors]    detail    sku => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should not be blank.

Update_an_item_quantity_at_the_guest_cart_without_x_anonymous_customer_unique_id
    When I send a PATCH request:    /guest-carts/guestCartId/guest-cart-items/${concrete_available_product.with_offer}?include=items    {"data":{"type":"guest-cart-items","attributes":{"quantity":"2"}}}
    Then Response status code should be:    400
    And Response should return error code:    109
    And Response reason should be:    Bad Request
    And Response should return error message:    Anonymous customer unique id is empty.

Update_an_item_quantity_at_the_guest_cart_of_another_anonymous_customer
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product.with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}1
    When I send a PATCH request:    /guest-carts/guestCartId/guest-cart-items/${concrete_available_product.with_offer}?include=items    {"data":{"type":"guest-cart-items","attributes":{"quantity":"2"}}}
    Then Response status code should be:    404
    And Response should return error code:    101
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.

Update_an_item_quantity_at_the_non_existing_guest_cart
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    When I send a PATCH request:    /guest-carts/guestCartId/guest-cart-items/${concrete_available_product.with_offer}?include=items    {"data":{"type":"guest-cart-items","attributes":{"quantity":"2"}}}
    Then Response status code should be:    404
    And Response should return error code:    101
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.

Update_quantity_of_a_non_existing_item_at_the_guest_cart
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product.with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    When I send a PATCH request:    /guest-carts/${guestCartId}/guest-cart-items/non_existing_item   {"data":{"type":"guest-cart-items","attributes":{"quantity":"2"}}}
    Then Response status code should be:    404
    And Response should return error code:    103
    And Response reason should be:    Not Found
    And Response should return error message:    Item with the given group key not found in the cart.

Update_an_item_quantity_at_the_guest_cart_without_quantity_attribute
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product.with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    When I send a PATCH request:    /guest-carts/${guestCartId}/guest-cart-items/${concrete_available_product.with_offer}    {"data":{"type":"guest-cart-items","attributes":{}}}
    Then Response status code should be:    ${422}
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    quantity => This field is missing.

Update_an_item_quantity_at_the_guest_cart_with_empty_quantity_value
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product.with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    When I send a PATCH request:    /guest-carts/${guestCartId}/guest-cart-items/${concrete_available_product.with_offer}    {"data":{"type":"guest-cart-items","attributes":{"quantity":""}}}
    Then Response status code should be:    ${422}
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    quantity => This value should not be blank.

Update_an_item_quantity_at_the_guest_cart_with_non_numeric_quantity_value
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product.with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    When I send a PATCH request:    /guest-carts/${guestCartId}/guest-cart-items/${concrete_available_product.with_offer}    {"data":{"type":"guest-cart-items","attributes":{"quantity":"test"}}}
    Then Response status code should be:    ${422}
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    quantity => This value should be of type numeric.

Remove_an_item_from_the_guest_cart_without_x_anonymous_customer_unique_id
    When I send a DELETE request:    /guest-carts/guestCartId/guest-cart-items/itemId
    Then Response status code should be:    400
    And Response should return error code:    109
    And Response reason should be:    Bad Request
    And Response should return error message:    Anonymous customer unique id is empty.

Remove_a_non_existing_item_from_the_guest_cart
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product.with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    When I send a DELETE request:    /guest-carts/${guestCartId}/guest-cart-items/non_existing_item
    Then Response status code should be:    404
    And Response should return error code:    103
    And Response reason should be:    Not Found
    And Response should return error message:    Item with the given group key not found in the cart.

Remove_an_item_from_the_non_existing_guest_cart
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    When I send a DELETE request:    /guest-carts/guestCartId/guest-cart-items/${concrete_available_product.with_offer}
    Then Response status code should be:    404
    And Response should return error code:    101
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.

Remove_an_item_from_the_guest_cart_of_another_anonymous_customer
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product.with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}1
    When I send a DELETE request:    /guest-carts/${guestCartId}/guest-cart-items/${concrete_available_product.with_offer}
    Then Response status code should be:    404
    And Response should return error code:    101
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.