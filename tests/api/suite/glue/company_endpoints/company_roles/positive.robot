*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     SuiteSetup
Test Setup      TestSetup

Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup
Request_company_role_by_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /company-roles/mine
    ...    AND    Save value to a variable:    [data][0][id]    company_role_id
    When I send a GET request:    /company-roles/${company_role_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    company-roles
    And Response body parameter should be in:    [data][attributes][name]    Buyer    Admin
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False

Request_company_role_by_mine
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /company-roles/mine
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    2
    And Each array element of array in response should contain property with value:    [data]    type    company-roles
    And Response body parameter should be in:    [data][0][attributes][name]    Buyer    Admin
    And Response body parameter should be in:    [data][1][attributes][name]    Admin    Buyer
    And Response body parameter should be in:    [data][0][attributes][isDefault]    True    False
    And Response body parameter should be in:    [data][1][attributes][isDefault]    False    True

Request_company_role_by_mine_with_include_companies
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /company-roles/mine?include=companies
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain property with value:    [data]    type    company-roles
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    relationships
    And Response body parameter should contain:    [data][0][relationships][companies][data][0][type]    companies

Request_company_role_by_id_with_include_companies
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /company-roles/mine
    ...    AND    Save value to a variable:    [data][0][id]    company_role_id
    When I send a GET request:    /company-roles/${company_role_id}?include=companies
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response body parameter should be:    [data][relationships][companies][data][0][type]    companies
    And Response body parameter should not be EMPTY:    [data][relationships][companies][data][0][id]
