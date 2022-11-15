*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    SuiteSetup
Test Setup    TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup


Adding_item_in_wishlist_by_invalid_Access_Token
    [Setup]    I set Headers:    Authorization=3485h7
    When I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}"} }}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
    
Adding_item_in_wishlist_by_without_Access_Token 
    When I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}"} }}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Adding_item_with_abstract_sku
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    When I send a POST request:   /wishlists/${wishlist_reference_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${abstract_available_product_with_stock.sku}"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content  
    And Response should return error code:    206
    And Response should return error message:        "Cant add an item."
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...    AND    Response status code should be:    204

Adding_item_with_invalid_sku
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    When I send a POST request:   /wishlists/${wishlist_reference_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "SK123445666"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content  
    And Response should return error code:    206 
    And Response should return error message:        "Cant add an item."
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...    AND    Response status code should be:    204

Adding_item_with_empty_sku
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    When I send a POST request:   /wishlists/${wishlist_reference_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": ""}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content  
    And Response should return error code:    901 
    And Response should return error message:        sku => This value should not be blank.
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...    AND    Response status code should be:    204

Adding_item_after_enter_space_in_sku
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    When I send a POST request:   /wishlists/${wishlist_reference_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": " "}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content  
    And Response should return error code:    206 
    And Response should return error message:        "Cant add an item."
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...    AND    Response status code should be:    204

Adding_item_with_invalid_wishilist_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:   /wishlists/Mywishlist/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${abstract_available_product_with_stock.concrete_sku}"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content  
    And Response should return error code:    206 
    And Response should return error message:        "Cant add an item."
 
Adding_item_without_wishilist_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:   /wishlists//wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${abstract_available_product_with_stock.concrete_sku}"}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    201
    And Response should return error message:    "Cant find wishlist."

Adding_items_in_wishlist_by_another_customer_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}" } }}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    I get access token for the customer:   ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:   /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${abstract_available_product_with_stock.concrete_sku}"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    206
    And Response should return error message:    "Cant add an item."
    [Teardown]    Run Keywords     I get access token for the customer:    ${yves_second_user.email}
    ...     AND    I set Headers:    Authorization=${token}   
    ...    AND    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204

Adding_item_with_deactivated_item_sku
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    When I send a POST request:   /wishlists/${wishlist_reference_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "Demo-SKU-Id"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    206
    And Response should return error message:    "Cant add an item."
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...    AND    Response status code should be:    204

#Delete
Deleting_item_in_wishlist_by_invalid_Access_Token
    [Setup]    I set Headers:    Authorization=3485h7
    When I send a DELETE request:    /wishlists/mywishlist/wishlist-items/${abstract_available_product_with_stock.concrete_sku}
    Then Response status code should be:    401 
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
 
Deleting_item_in_wishlist_by_without_Access_Token
    When I send a DELETE request:    /wishlists/mywishlist/wishlist-items/${abstract_available_product_with_stock.concrete_sku}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Deleting_item_in_wishlist_with_empty_sku
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    When I send a DELETE request:    /wishlists/${wishlist_reference_id}/wishlist-items/
    Then Response status code should be:   400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.
    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...  AND    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...  AND    Response status code should be:    204

Delete_wishlist_item_from_already_deleted_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    When I send a POST request:    /wishlists/${wishlist_reference_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${abstract_available_product_with_stock.concrete_sku}"}}}
    Then Response status code should be:    201 
    And Response reason should be:    Created
    When I send a DELETE request:    /wishlists/${wishlist_reference_id}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    When I send a DELETE request:    /wishlists/${wishlist_reference_id}/wishlist-items/${abstract_available_product_with_stock.concrete_sku}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    201
    And Response should return error message:    "Cant find wishlist."

Deleting_item_with_invalid_wishilist_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a DELETE request:   /wishlists/Mywishlist/wishlist-items/${abstract_available_product_with_stock.concrete_sku}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    201
    And Response should return error message:        "Cant find wishlist."

Deleting_item_without_wishilist_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a DELETE request:   /wishlists//wishlist-items/${abstract_available_product_with_stock.concrete_sku}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Deleting_items_in_wishlist_by_another_customer_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}" } }}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${abstract_available_product_with_stock.concrete_sku}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_item_id
    ...    AND    I get access token for the customer:   ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a DELETE request:   /wishlists/${wishlist_id}/wishlist-items/${wishlist_item_id}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    201
    And Response should return error message:        "Cant find wishlist."
    [Teardown]    Run Keywords     I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Authorization=${token}   
    ...    AND    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    

Deleting_concrete_product_by_abstract_product_sku
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${abstract_available_product_with_stock.concrete_sku}"}}}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    When I send a DELETE request:    /wishlists/${wishlist_id}/wishlist-items/${abstract_available_product_with_stock.sku}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    208
    And Response should return error message:        No item with provided sku in wishlist.
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204