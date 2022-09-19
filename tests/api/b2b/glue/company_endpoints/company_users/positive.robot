*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup    TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
Request_company_users
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /company-users
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]  12
    And Each array element of array in response should contain property with value:    [data]    type   company-users   
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Response should contain the array of a certain size:    [data][0][attributes]  2
    And Response body parameter should be:    [data][0][attributes][isActive]    True
    And Response body parameter should be:    [data][0][attributes][isDefault]    False
    And Response body has correct self link

Request_company_users_by_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a GET request:    /company-users/mine
    ...    AND    Save value to a variable:    [data][id]    company_user_id
    When I send a GET request:    /company-users/${company_user_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]   company-users   
    
Request_company_users_by_mine
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /company-users/mine
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}   
    And Response should contain the array of a certain size:    [data]  1
    And Response body parameter should be:    [data][0][type]   company-users   
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body parameter should be:    [data][0][attributes][isActive]    True
    And Response body parameter should be:    [data][0][attributes][isDefault]    False

Request_company_users_include_customers_and_roles_and_business_units
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /company-users?include=customers,company-business-units,company-roles
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain property with value:    [data]    type   company-users   
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    relationships
    And Response should contain the array of a certain size:    [data][0][relationships]  3
    Response body parameter should contain:    [data][0][relationships]    company-business-units
    Response body parameter should contain:    [data][0][relationships]    customers
    Response body parameter should contain:    [data][0][relationships]    company-role

Request_companies_users_if_user_has_4_companies
    [Setup]    Run Keywords    I get access token for the customer:    ${user_with_multiple_companies}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /company-users/mine
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}   
    And Response should contain the array of a certain size:    [data]  4
    And Each array element of array in response should contain property with value:    [data]   type    company-users

Request_companies_users_with_include_customers_and_filtered_by_company_role
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a GET request:    /company-roles/mine
    ...    AND    Save value to a variable:    [data][0][id]    company-role-uuid   
    When I send a GET request:    /company-users?include=customers&filter[company-roles.id]=${company-role-uuid}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    Log    ${token}
    Log    ${company-role-uuid}
    And Each array element of array in response should contain property with value:    [data]    type   company-users   
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    relationships
    And Response should contain the array of a certain size:    [data][0][relationships]  1
    And Response body parameter should contain:    [data][0][relationships]    customers

