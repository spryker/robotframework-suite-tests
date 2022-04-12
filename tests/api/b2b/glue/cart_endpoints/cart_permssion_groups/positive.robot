*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

# This test is not working regarding to this bug https://spryker.atlassian.net/browse/CC-16527
Get_cart_permission_groups_by_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}?include=cart-permission-groups
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]    ${cart_id}
    And Response should contain the array larger than a certain size:    [included]    0
    And Response should contain the array larger than a certain size:    [data][relationships]    0
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][cart-permission-groups]
    And Each array element of array in response should contain property:    [data][relationships][cart-permission-groups][data]    type
    And Each array element of array in response should contain property:    [data][relationships][cart-permission-groups][data]    id
    And Response body parameter should not be EMPTY:    [included]
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Each array element of array in response should contain property with value:    [included]    type    ${cart_permission_group_type}
    And Each array element of array in response should contain nested property:    [included]    attributes    name
    And Each array element of array in response should contain nested property:    [included]    attributes    isDefault
    And Each array element of array in response should contain property with value in:    [included]    [attributes][isDefault]    True    False    
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Get_all_cart_permission_groups
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /cart-permission-groups
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property with value:    [data]    type    ${cart_permission_group_type}
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isDefault
    And Each array element of array in response should contain property with value in:    [data]    [attributes][isDefault]    True    False
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link


Get_cart_permission_groups_by_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /cart-permission-groups/${cart_permission_group_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter Should Be:    [data][type]    ${cart_permission_group_type}
    And Response body parameter should Be:    [data][id]    ${cart_permission_group_id}
    And Response body parameter should not be EMPTY:   [data][type]
    And Response body parameter should not be EMPTY:   [data][id]
    And Response body parameter should not be EMPTY:   [data][attributes][name]
    And Response body parameter should not be EMPTY:   [data][attributes][isDefault]
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response body has correct self link internal