*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Add_item_to_guest_cart_non_existing_sku
    [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
                ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a POST request:    /guest-cart-items    {"data": {"type": "guest-cart-items","attributes": {"sku": "fake","quantity": 1}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    102
    And Response should return error message:    Product "fake" not found

Add_item_to_guest_cart_with_missing_x_anonymous_customer_id
    When I send a POST request:    /guest-cart-items    {"data": {"type": "guest-cart-items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    109
    And Response should return error message:    Anonymous customer unique id is empty.

Add_item_to_guest_cart_with_wrong_type
    [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
               ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a POST request:    /guest-cart-items    {"data": {"type": "fake","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.

Add_item_to_guest_cart_with_missing_properties
    [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
               ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a POST request:    /guest-cart-items    {"data": {"type": "guest-cart-items","attributes": {}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    sku => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    quantity => This field is missing.

Add_item_to_guest_cart_with_invalid_properties
    [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
          ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a POST request:    /guest-cart-items    {"data": {"type": "guest-cart-items","attributes": {"sku": "","quantity": "" }}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    sku => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should be of type numeric.
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should be greater than 0.



####### PATCH #######
Update_item_in_guest_cart_with_not_matching_anonymous_customer_id
    [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
               ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=fake_anonymous-customer-id
    When I send a PATCH request:    /guest-carts/${guest_cart_id}/guest-cart-items/${concrete_product_with_concrete_product_alternative.sku}    {"data": {"type": "guest-cart-items","attributes": {"quantity": "1"}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.
    
Update_item_in_guest_cart_with_non_existing_item_id
    [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
               ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a PATCH request:    /guest-carts/${guest_cart_id}/guest-cart-items/fake    {"data": {"type": "guest-cart-items","attributes": {"quantity": 1}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    103
    And Response should return error message:    Item with the given group key not found in the cart.

Update_item_in_guest_cart_with_no_item_id
    [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
           ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a PATCH request:    /guest-carts/${guest_cart_id}/guest-cart-items    {"data": {"type": "guest-cart-items","attributes": {"quantity": 1}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Update_item_in_guest_cart_with_non_existing_cart_id
     [Setup]    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_prefix}${random}
    When I send a PATCH request:    /guest-carts/fake/guest-cart-items/fake    {"data": {"type": "guest-cart-items","attributes": {"quantity": 1}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Update_item_in_guest_cart_with_no_cart_id
    When I send a PATCH request:    /guest-carts//guest-cart-items/fake    {"data": {"type": "guest-cart-items","attributes": {"quantity": 1}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Update_item_in_guest_cart_with_invalid_parameters
    [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
               ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a PATCH request:    /guest-carts/${guest_cart_id}/guest-cart-items/${concrete_product_with_concrete_product_alternative.sku}    {"data": {"type": "guest-cart-items","attributes": {"quantity": ""}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should be of type numeric.

Update_item_in_guest_cart_with_invalid_properties
    [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
               ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a PATCH request:    /guest-carts/${guest_cart_id}/guest-cart-items/${concrete_product_with_concrete_product_alternative.sku}    {"data": {"type": "guest-cart-items","attributes": {"quantity": ""}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should be of type numeric.



####### DELETE #######
Delete_cart_item_with_not_matching_anonymous_customer_id
    [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
    ...  AND    I set Headers:     X-Anonymous-Customer-Unique-Id=fake_anonymous-customer-id
    When I send a DELETE request:    /guest-carts/${guest_cart_id}/guest-cart-items/${concrete_product_with_concrete_product_alternative.sku}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.
    
Delete_cart_item_without_guest_cart_id
    [Setup]    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_prefix}${random}
    When I send a DELETE request:    /guest-carts//guest-cart-items/${concrete_product_with_concrete_product_alternative.sku}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Delete_cart_item_with_non_existing_item_id
    [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
                  ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a DELETE request:    /guest-carts/${guest_cart_id}/guest-cart-items/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    103
    And Response should return error message:    Item with the given group key not found in the cart.

Delete_cart_item_with_empty_item_id
    [Setup]    Run Keywords     Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
                     ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a DELETE request:    /guest-carts/${guest_cart_id}/guest-cart-items
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Delete_cart_item_with_non_existing_cart
     [Setup]    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_prefix}${random}
    When I send a DELETE request:    /guest-carts/fake/guest-cart-items/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.