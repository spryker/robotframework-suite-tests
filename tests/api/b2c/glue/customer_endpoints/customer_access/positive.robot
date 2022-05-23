*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Default Tags    glue
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
ENABLER
    TestSetup
Resources_list_which_customer_can_access
    I send a GET request:    /customer-access
    Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should contain:    [data][0][type]    customer-access
    And Response should contain the array of a certain size:    [data][0][attributes] [resourceTypes]    2
    And Response body parameter should be:    [data][0][attributes][resourceTypes][0]    wishlists
    And Response body parameter should be:    [data][0][attributes][resourceTypes][1]    wishlist-items
    And Response body has correct self link

# Customer doesn't have wishlist and test fails
Access_restricted_resource_as_authorized_customer   
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name_2}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${concrete_available_product_with_label}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    I set Headers:    Authorzation=None
    ...    AND    I send a GET request:    /wishlists
    ...    AND    Response status code should be:    403
    ...    AND    Response reason should be:    Forbidden
    ...    AND    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a GET request:    /wishlists
    Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should contain:    [data][0][type]    wishlists
    And Response body parameter should be:    [data][0][id]    ${wishlist_id}
    And Response body parameter should be:    [data][0][attributes][numberOfItems]    1
    And Response body parameter should be:    [data][0][attributes][name]    Wishlist Name
    And Response body has correct self link
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204