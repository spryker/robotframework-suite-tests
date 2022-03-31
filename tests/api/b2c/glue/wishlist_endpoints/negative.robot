*** Settings ***
Suite Setup    SuiteSetup
Resource    ../../../../../resources/common/common_api.robot

*** Test Cases ***

#Get_request
Getting_wishlist_by_invalid_Access_Token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I set Headers:    Authorization=3485h7
    When I send a GET request:    /wishlists
    Then Response status code should be:    401 
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Getting_wishlist_without_Access_Token
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I set Headers:    Authorization=
    When I send a GET request:    /wishlists
    Then Response status code should be:    403 
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Getting_wishlist_with_invalid_id
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name2}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    When I send a GET request:    /wishlists/2345hasd
    Then Response status code should be:    404 
    And Response reason should be:    Not Found
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204

######POST#####
creating_wishlist_by_invalid_Access_Token
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I set Headers:    Authorization=3485h7
    When I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": ""}}}
    Then Response status code should be:    401 
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

creating_wishlist_without_Access_Token
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I set Headers:    Authorization=
    When I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": ""}}}
    Then Response status code should be:    403 
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Creating_wishlist_with_missing_name
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user_email}
    ...    AND     I set headers:    authorization=${token}
    When I send a POST request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": ""}}}
    Then Response status code should be:    422
    AND Response reason should be:    Unprocessable Entity
    And Each array element of array in response should contain property with value:    [errors]    code    901

Creating_wishlist_with_invalid_name
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "."}}}
    Then Response status code should be:    400
    And Response should return error message:   Please enter name using only letters, numbers, underscores, spaces or dashes.
    And Response should return error code:    210

Creating_Wishlist_with_same_name
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user_email}
    ...    AND    I set headers:    authorization=${token}
    ...    AND    I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name2}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    When I send a POST request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name2}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    AND Response should return error code:    202
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204
    
#Delete
Delete_Wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name1}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    When I send a DELETE request:    /wishlists/${wishlist_reference_id}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    When I send a DELETE request:    /wishlists
    Response status code should be:   400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Deleting_wishlist_by_invalid_Access_Token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name1}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    ...    AND    I set Headers:    Authorization=3485h7
    When I send a Delete request:    /wishlists/${wishlist_reference_id}    
    Then Response status code should be:    401 
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...  AND    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...  AND    Response status code should be:    204

Deleting_wishlist_without_Access_Token
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name1}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    ...    AND    Response reason should be:    Created
    ...    AND    I set Headers:    Authorization=
    When I send a Delete request:    /wishlists/${wishlist_reference_id}
    Then Response status code should be:    403 
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.
    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...  AND    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...  AND    Response status code should be:    204

#Delete_request
Wishlist_id_not_specified
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user_email}
    ...    AND    I set headers:    authorization=${token}
    ...    AND    I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name2}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    When I send a DELETE request:    /wishlists/
    
    And Response reason should be:    Bad Request
    Then I send a GET request:    /wishlists/${wishlist_id}
    Then Response status code should be:    200

    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...  AND    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204

#Patch_request
updating_wishlist_with_missing_name
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user_email}
    ...    AND     I set headers:    authorization=${token}
    ...    AND     I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name2}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    When I send a Patch request:    /wishlists${wishlist_id}    {"data": {"type": "wishlists","attributes": {"name": ""}}}
    Then Response status code should be:    404
    AND Response reason should be:    Not Found
    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...  AND    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204

updating_wishlist_with_invalid_name
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name2}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    When I send a Patch request:    /wishlists/${wishlist_id}    {"data": {"type": "wishlists","attributes": {"name": "."}}}
    Then Response status code should be:    422
    And Response should return error message:   Please enter name using only letters, numbers, underscores, spaces or dashes.
    And Response should return error code:    210
    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...  AND    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204

updating_wishlist_by_invalid_Access_Token
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name1}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    ...    AND    I set Headers:    Authorization=3485h7
    When I send a Patch request:    /wishlists/${wishlist_reference_id}    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name1}"}}}  
    Then Response status code should be:    401 
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...  AND    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...  AND    Response status code should be:    204

updating_wishlist_without_Access_Token
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name1}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    ...    AND    I set Headers:    Authorization=
    When I send a Patch request:    /wishlists/${wishlist_reference_id}    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name1}"}}}  
    Then Response status code should be:    403 
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.
    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...  AND    I send a DELETE request:    /wishlists/${wishlist_reference_id}
    ...  AND    Response status code should be:    204
