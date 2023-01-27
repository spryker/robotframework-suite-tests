*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    SuiteSetup
Test Setup    TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup


#Post
#CC-16555 API: JSON response is missing product availability and price
Adding_item_in_wishlist 
    [Tags]    skip-due-to-refactoring
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id  
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${abstract_available_product_with_stock.concrete_sku}"}}}
    Then Response status code should be:    201 
    And Response reason should be:    Created
    And Save value to a variable:    [data][id]    wishlist_items_id  
    And Response body parameter should not be EMPTY:    [data][attributes][sku]
    And Response body parameter should not be EMPTY:    [data][attributes][merchantReference]
    And Response body parameter should be:    [data][attributes][productOfferReference]    None
    And Response body parameter should be:    [data][type]    wishlist-items
    And Response body parameter should be:    [data][id]    ${wishlist_items_id}
    And Response body parameter should be:    [data][attributes][sku]    ${abstract_available_product_with_stock.concrete_sku}
    And Response body parameter should be:    [data][attributes][id]    ${wishlist_items_id}
    And Response body parameter should not be EMPTY:    [data][attributes][availability]
    And Response body parameter should not be EMPTY:    [data][attributes][prices]
    And Response body parameter should not be EMPTY:    [data][links][self]
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204

#Post
Adding_item_in_wishlist_with_offer 
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${concrete_available_product.with_offer}", "productOfferReference": "offer37"}}}
    Then Response status code should be:    201 
    And Response reason should be:    Created
    And Save value to a variable:    [data][id]    wishlist_items_id
    And Response body parameter should not be EMPTY:    [data][attributes][sku]
    And Response body parameter should not be EMPTY:    [data][attributes][merchantReference]
    And Response body parameter should not be EMPTY:    [data][attributes][productOfferReference]
    And Response body parameter should be:    [data][type]    wishlist-items
    And Response body parameter should be:    [data][id]    ${wishlist_items_id}
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_available_product.with_offer}
    And Response body parameter should be:    [data][attributes][id]    ${wishlist_items_id}
    And Response body parameter should not be EMPTY:    [data][attributes][availability]
    And Response body parameter should not be EMPTY:    [data][attributes][prices]
    And Response body parameter should not be EMPTY:    [data][links][self]
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204


Adding_multiple_variant_of_abstract_product_in_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${abstract_product_with_variants.variant1_sku}"}}}
    Then Response status code should be:    201 
    And Response reason should be:    Created
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${abstract_product_with_variants.variant2_sku}"}}}
    Then Response status code should be:    201 
    And Response reason should be:    Created
    And Save value to a variable:    [data][id]    wishlist_items_id
    And Response body parameter should not be EMPTY:    [data][attributes][sku]
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items
    Then Response status code should be:    200 
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    wishlists
    And Response body parameter should be:    [data][id]    ${wishlist_id}
    And Response body parameter should be:    [data][attributes][name]    ${random}
    And Response body parameter should be:    [data][attributes][numberOfItems]    2
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][wishlist-items][data][0]
    And Response body parameter should not be EMPTY:    [data][relationships][wishlist-items][data][1]
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204

#Delete
Deleting_item_from_wishlist
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${concrete_available_product.with_offer}"}}}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    When I send a DELETE request:    /wishlists/${wishlist_id}/wishlist-items/${concrete_available_product.with_offer}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204