*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
    
###### POST #######
Add_item_to_cart_non_existing_sku
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    Find or create customer cart
    When I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "fake","quantity": 1}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    102
    And Response should return error message:    Product "fake" not found

Add_item_to_non_existing_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a POST request:    /carts/fake/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Add_item_to_missing_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a POST request:    /carts//items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    104
    And Response should return error message:    Cart uuid is missing.

Add_item_to_cart_with_invalid_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=asdasfas
    When I send a POST request:    /carts/han/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Add_item_to_cart_with_missing_token
    When I send a POST request:    /carts/fake/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Add_item_to_cart_with_wrong_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /carts
    ...    AND    Save value to a variable:    [data][0][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items    {"data": {"type": "carts","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.


Add_item_to_cart_with_missing_properties
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /carts
    ...    AND    Save value to a variable:    [data][0][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items    {"data": {"type": "items","attributes": {}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    sku => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    quantity => This field is missing.


Add_item_to_cart_with_invalid_properties
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /carts
    ...    AND    Save value to a variable:    [data][0][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items    {"data": {"type": "items","attributes": {"sku": "","quantity": "" }}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    sku => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should be of type numeric.
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should be greater than 0.


###### PATCH #######
Update_item_in_cart_with_non_existing_item_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /carts
    ...    AND    Save value to a variable:    [data][0][id]    cart_uid
    When I send a PATCH request:    /carts/${cart_uid}/items/fake    {"data": {"type": "items","attributes": {"quantity": 1}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    103
    And Response should return error message:    Item with the given group key not found in the cart.


Update_item_in_cart_with_no_item_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /carts
    ...    AND    Save value to a variable:    [data][0][id]    cart_uid
    When I send a PATCH request:    /carts/${cart_uid}/items    {"data": {"type": "items","attributes": {"quantity": 1}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Update_item_in_cart_with_non_existing_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a PATCH request:    /carts/fake/items/fake    {"data": {"type": "items","attributes": {"quantity": 1}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Update_item_in_cart_with_no_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /carts
    ...    AND    Save value to a variable:    [data][0][id]    cart_uid
    ...    AND    I send a POST request:    /carts/${cart_uid}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_uid
    When I send a PATCH request:    /carts//items/${item_uid}    {"data": {"type": "items","attributes": {"quantity": 1}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.


Update_item_in_cart_with_another_user_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    find or create customer cart
    ...    AND    Cleanup all items in the cart:    ${cart_id}
    ...    AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_uid
    ...    AND    I get access token for the customer:    ${yves_second_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a PATCH request:    /carts/${cart_id}/items/${item_uid}    {"data": {"type": "items","attributes": {"quantity": 1}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.
 
Update_item_with_invalid_parameters
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    find or create customer cart
    ...    AND    Cleanup all items in the cart:    ${cart_id}
    ...    AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_with_stock_and_never_out_of_stock}","quantity": 1}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_uid
    When I send a PATCH request:    /carts/${cart_id}/items/${item_uid}    {"data": {"type": "items","attributes": {"quantity":""}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should be of type numeric.
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}/items/${concrete_available_with_stock_and_never_out_of_stock}
    ...    AND    Response status code should be:    204

###### DELETE #######
Delete_cart_item_with_non_existing_item_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    find or create customer cart
    ...    AND    Cleanup all items in the cart:    ${cart_id}
    ...    AND    I send a GET request:    /carts
    ...    AND    Save value to a variable:    [data][0][id]    cart_id
    When I send a DELETE request:    /carts/${cart_id}/items/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    103
    And Response should return error message:    Item with the given group key not found in the cart.

Delete_cart_item_with_empty_item_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /carts
    ...    AND    Save value to a variable:    [data][0][id]    cart_uid
    When I send a DELETE request:    /carts/${cart_uid}/items
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Delete_cart_item_with_non_existing_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a DELETE request:    /carts/fake/items/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Delete_cart_item_with_missing_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a DELETE request:    /carts//items/fake
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.