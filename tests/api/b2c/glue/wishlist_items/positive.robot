*** Settings ***
Suite Setup        SuiteSetup
Test Setup        TestSetup 
Resource    ../../../../../resources/common/common_api.robot

*** Test Cases ***
#Post
Adding_item_in_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${product_sku_1}"}}}
    Then Response status code should be:    201 
    And Response reason should be:    Created
    And Save value to a variable:    [data][id]    wishlist_items_id
    And Response body parameter should not be EMPTY:    [data][attributes][sku]
    And Response body parameter should be:    [data][type]    wishlist-items
    And Response body parameter should be:    [data][id]    ${wishlist_items_id}
    And Response body parameter should be:    [data][attributes][sku]    ${product_sku_1}
    And Response body parameter should be:    [data][attributes][id]    ${wishlist_items_id}
    And Response body parameter should be:    [data][attributes][availability]    None
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
   

#Delete
Deleting_item_from_wishlist
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${product_sku_4}"}}}
    Then Response status code should be:    201 
    And Response reason should be:    Created
    And Save value to a variable:    [data][id]    wishlist_items_id
    And Response body parameter should be:    [data][type]    wishlist-items
    And Response body parameter should be:    [data][id]    ${wishlist_items_id}
    And Response body parameter should be:    [data][attributes][sku]    ${product_sku_4}
    And Response body parameter should be:    [data][attributes][id]    ${wishlist_items_id}
    And Response body parameter should be:    [data][attributes][availability]    None
    When I send a DELETE request:    /wishlists/${wishlist_id}/wishlist-items/${product_sku_4}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    When I send a GET request:    /wishlists/${wishlist_id}/wishlist-items/${product_sku_4}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204




    




   

