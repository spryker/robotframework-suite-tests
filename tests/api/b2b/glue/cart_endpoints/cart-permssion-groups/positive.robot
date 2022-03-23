*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***

# Get_cart_permission_groups_by_cart_id
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
#     ...  AND    I set Headers:    Authorization=${token}
#     ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${gross_mode}","currency": "${currency_code_eur}","store": "${store_de}","name": "${test_cart_name}-${random}"}}}
#     ...  AND    Save value to a variable:    [data][id]    cart_id
#     ...  AND    Response status code should be:    201
#     When I send a GET request:    /carts/${cart_id}?include=cart-permission-groups
#     Then Response status code should be:    200
#     And Response reason should be:    OK
#     And Response body parameter should be:    [data][type]    carts
#     And Response body parameter should be:    [data][id]    ${cart_id}
#     And Response Should Contain The Array Larger Than a Certain Size:    [included]    0
#     And Response Should Contain The Array Larger Than a Certain Size:    [data][relationships]    0
#     And Response body parameter should not be EMPTY:    [data][relationships]
#     And Response body parameter should not be EMPTY:    [data][relationships][cart-permission-groups]
#     And Each Array Element Of Array In Response Should Contain Property:    [data][relationships][cart-permission-groups][data]    type
#     And Each Array Element Of Array In Response Should Contain Property:    [data][relationships][cart-permission-groups][data]    id
#     And Response body parameter should not be EMPTY:    [included]
#     And Each Array Element Of Array In Response Should Contain Property:    [included]    type
#     And Each Array Element Of Array In Response Should Contain Property:    [included]    id
#     And Each Array Element Of Array In Response Should Contain Property:    [included]    attributes
#     And Each Array Element Of Array In Response Should Contain Property:    [included]    links
#     Each array element of array in response should contain nested property:    [included]    [links]    self
#     And Each Array Element Of Array In Response Should Contain Property With Value:    [included]    type    cart-permission-groups
#     And Each Array Element Of Array In Response Should Contain Nested Property:    [included]    attributes    name
#     And Each Array Element Of Array In Response Should Contain Nested Property:    [included]    attributes    isDefault
#     [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
#     ...  AND    Response status code should be:    204



Get_all_cart_permission_groups
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /cart-permission-groups
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each Array Element Of Array In Response Should Contain Property With Value:    [data]    type    cart-permission-groups
    And Each Array Element Of Array In Response Should Contain Property:    [data]    type
    And Each Array Element Of Array In Response Should Contain Property:    [data]    id
    And Each Array Element Of Array In Response Should Contain Nested Property:    [data]    [attributes]    name
    And Each Array Element Of Array In Response Should Contain Nested Property:    [data]    [attributes]    isDefault
    And Each Array Element Of Array In Response Should Contain Nested Property:    [data]    [links]    self
    And Response Body Has Correct Self Link


Get_cart_permission_groups_by_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /cart-permission-groups/1
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response Body Parameter Should Be:    [data][type]    cart-permission-groups
    And Response Body Parameter should Not Be EMPTY:   [data][type]
    And Response Body Parameter should Not Be EMPTY:   [data][id]
    And Response Body Parameter should Not Be EMPTY:   [data][attributes][name]
    And Response Body Parameter should Not Be EMPTY:   [data][attributes][isDefault]
    And Response Body Has Correct Self Link Internal