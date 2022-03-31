*** Settings ***
Suite Setup        SuiteSetup
Test Setup        TestSetup 
Resource    ../../../../../resources/common/common_api.robot

*** Test Cases ***
#Post

Adding_item_in_wishlist_by_invalid_Access_Token
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    ...    AND    I set Headers:    Authorization=3485h7
    When I send a POST request:    /wishlists/${wishlist_reference_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${product_sku_4}"}}}
    Then Response status code should be:    401 
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...  AND    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...  AND    Response status code should be:    204
    
Adding_item_in_wishlist_by_without_Access_Token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    ...    AND    I set Headers:    Authorization=
    When I send a POST request:    /wishlists/${wishlist_reference_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${product_sku_4}"}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.
    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...  AND    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...  AND    Response status code should be:    204

Adding_item_with_invalid_sku
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    When I send a POST request:   /wishlists/${wishlist_reference_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${product_sku_2}"}}}
    Response status code should be:    422
    And Response reason should be:    Unprocessable Entity  
    And Response should return error code:    206 
    And Response should return error message:        "Cant add an item."
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...    AND    Response status code should be:    204

Adding_item_with_deactivated_item_sku
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    When I send a POST request:   /wishlists/${wishlist_reference_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${product_sku_2}"}}}
     Response status code should be:    422
    And Response reason should be:    Unprocessable Entity  
    And Response should return error code:    206
    And Response should return error message:    "Cant add an item."
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...    AND    Response status code should be:    204

#Delete
Deleting_item_in_wishlist_by_invalid_Access_Token
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    ...    AND    I set Headers:    Authorization=3485h7
    When I send a DELETE request:    /wishlists/${wishlist_reference_id}/wishlist-items/${product_sku_1}
    Then Response status code should be:    401 
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...  AND    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...  AND    Response status code should be:    204
    
Deleting_item_in_wishlist_by_without_Access_Token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    ...    AND    I set Headers:    Authorization=
    When I send a DELETE request:    /wishlists/${wishlist_reference_id}/wishlist-items/${product_sku_1}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.
    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...  AND    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...  AND    Response status code should be:    204

Deleting_item_in_wishlist_with_empty_sku
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
     When I send a DELETE request:    /wishlists/${wishlist_reference_id}/wishlist-items/${product_sku_5}
    Response status code should be:   400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.
    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...  AND    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...  AND    Response status code should be:    204

Deleting_item_which_is_not_exist_in_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    When I send a DELETE request:    /wishlists/${wishlist_reference_id}/wishlist-items/${product_sku_1}
    Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    208
    And Response should return error message:    No item with provided sku in wishlist.
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...    AND    Response status code should be:    204

Delete_wishlist_item_from_already_deleted_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    When I send a POST request:    /wishlists/${wishlist_reference_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${product_sku_4}"}}}
    Then Response status code should be:    201 
    And Response reason should be:    Created
    When I send a DELETE request:    /wishlists/${wishlist_reference_id}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    When I send a DELETE request:    /wishlists/${wishlist_reference_id}/wishlist-items/${product_sku_1}
    Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    201
    And Response should return error message:    "Cant find wishlist."






