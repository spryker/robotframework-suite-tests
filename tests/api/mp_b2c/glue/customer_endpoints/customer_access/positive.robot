*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

##### all negative and positive tests for this endpoint are already covered with other tests (e.g. abstract-product-prices checks that without token proces are not accessible)
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

Access_restricted_resource_as_authorized_customer   
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a GET request:    /wishlists
    Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should contain:    [data][0][type]    wishlists
    And Response body parameter should be:    [data][0][attributes][numberOfItems]    1
    And Response body parameter should not be EMPTY:    [data][0][attributes][name]
    And Response body has correct self link