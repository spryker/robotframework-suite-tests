*** Settings ***

Suite Setup     SuiteSetup
Test Setup      TestSetup   

Default Tags    glue

Resource    ../../../../../resources/common/common_api.robot

*** Test Cases ***
#GET Request
Retrieves_all_customer_wishlists
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user_email}
    ...    AND     I set headers:    authorization=${token}
   

     when I send a GET request:    /wishlists 
     then Response status code should be:    200
     AND Response reason should be:    OK
     And Each array element of array in response should contain property with value:    [data]    type   wishlists
     And Response body has correct self link
     And Response body parameter should be:    [data][0][type]    wishlists
     And Each array element of array in response should contain nested property:    [data]    [attributes]    name
     And Each array element of array in response should contain nested property:    [data]    [attributes]    numberOfItems
     And Each array element of array in response should contain nested property:    [data]    [attributes]    createdAt
     And Each array element of array in response should contain nested property:    [data]    [attributes]    updatedAt
     And Response body parameter should be:    [data][0][attributes][name]    HS01
     And Response body parameter should be:    [data][0][attributes][numberOfItems]    1
     And Response body parameter should be:    [data][0][id]    ${wishlist_id}
     And Response body parameter should be:    [data][0][attributes][createdAt]     2022-03-25 06:40:42.000000 
     And Response body parameter should not be EMPTY:    [data][0][attributes][createdAt]    
     And Response body parameter should not be EMPTY:    [data][0][attributes][name]
     And Response body parameter should not be EMPTY:    [data][0][attributes][numberOfItems]
     And Response body parameter should not be EMPTY:    [data][0][attributes][updatedAt]

#GET Request
Retrieves_wishlist_data_by_id
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user_email}
    ...    AND     I set headers:    authorization=${token}
   

     when I send a GET request:    /wishlists/${wishlist_id}
     then Response status code should be:    200
     AND Response reason should be:    OK
     #And Response body has correct self link
     And Response body parameter should be:    [data][type]    wishlists
     And Response body parameter should be:    [data][attributes][name]    HS01
     And Response body parameter should be:    [data][attributes][numberOfItems]    1
     And Response body parameter should be:    [data][id]    ${wishlist_id}
     And Response body parameter should be:    [data][attributes][createdAt]     2022-03-25 06:40:42.000000 
     And Response body parameter should not be EMPTY:    [data][attributes][createdAt]    
     And Response body parameter should not be EMPTY:    [data][attributes][name]
     And Response body parameter should not be EMPTY:    [data][attributes][numberOfItems]
     And Response body parameter should not be EMPTY:    [data][attributes][updatedAt]

Creates_wishlist
# Post Request

    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...        AND    I set Headers:    Authorization=${token}

    When I send a POST request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "qa2"}}}
    And Save value to a variable:    [data][id]    wishlist_del_id
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][id]    ${wishlist_del_id}
    AND Response body parameter should be:    [data][attributes][name]    qa2
    AND Response body parameter should be:    [data][type]    wishlists
    AND Response body parameter should be:    [data][attributes][numberOfItems]    0
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_del_id}
    ...  AND    Response status code should be:    204

Updates_customer_wishlist
#Patch Request
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...        AND    I set Headers:    Authorization=${token}

    When I send a PATCH request:    /wishlists/${wishlist_id}    {"data": {"type": "wishlists","attributes": {"name": "qa2"}}}
    And Save value to a variable:    [data][id]    wishlist_del_id
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][id]    ${wishlist_del_id}
    AND Response body parameter should be:    [data][attributes][name]    qa2
    AND Response body parameter should be:    [data][type]    wishlists
    AND Response body parameter should be:    [data][attributes][numberOfItems]    1
    [Teardown]    Run Keywords    I send a PATCH request:    /wishlists/${wishlist_del_id}    {"data": {"type": "wishlists","attributes": {"name": "HS01"}}}
    ...  AND    Response status code should be:    200

Removes_customer_wishlist
# Delete Request
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "qa2"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    wishlists_notification_id
    When I send a DELETE request:    /wishlists/${wishlists_notification_id}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    When I send a GET request:    /wishlists/${wishlists_notification_id}
    Then Response status code should be:    404
    And Response reason should be:    Not Found