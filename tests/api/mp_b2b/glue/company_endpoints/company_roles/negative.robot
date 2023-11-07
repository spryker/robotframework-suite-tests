*** Settings ***
Test Setup    API_test_setup
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    API_test_setup
Request_company_role_by_wrong_company_ID
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /company-roles/wrongid12
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    2101
    And Response should return error message:    Company role not found.

Request_company_role_without_access_token 
    When I send a GET request:    /company-roles/
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Request_company_role_with_invalid_access_token 
    [Setup]    I set Headers:    Authorization=wrongtoken 
    When I send a GET request:    /company-roles/
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Request_company_role_if_role_belong_to_other_users 
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /company-roles/mine
    ...    AND    Save value to a variable:    [data][0][id]    company_role_id
    ...    AND    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    When I send a GET request:    /company-roles/${company_role_id}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    2101
    And Response should return error message:   Company role not found.

Request_company_role_when_customer_has_no_company_assignment
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /company-roles/mine
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    2103
    And Response should return error message:    Current company user is not set. You need to select the current company user with /company-user-access-tokens in order to access the resource collection.