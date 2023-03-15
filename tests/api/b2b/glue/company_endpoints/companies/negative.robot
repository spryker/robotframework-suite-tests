*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     SuiteSetup
Test Setup      TestSetup

Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup

Request_company_by_wrong_ID
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /companies/3525626
    Then Response status code should be:    404
    And Response should return error code:    1801
    And Response reason should be:    Not Found
    And Response body parameter should be:    [errors][0][detail]    Company not found.

Request_company_without_access_token
    When I send a GET request:    /companies/${company_id}
    Then Response status code should be:    403
    And Response should return error code:    002
    And Response reason should be:    Forbidden
    And Response body parameter should be:    [errors][0][detail]    Missing access token.

Request_company_with_wrong_access_token
    [Setup]    I set Headers:    Authorization=sdrtfuygiuhoi
    When I send a GET request:    /companies/${company_id}
    Then Response status code should be:    401
    And Response should return error code:    001
    And Response reason should be:    Unauthorized
    And Response body parameter should be:    [errors][0][detail]    Invalid access token.

Request_company_if_company_belong_to_other_users
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /companies/mine
    ...    AND    Save value to a variable:    [data][0][id]    company_id
    ...    AND    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /companies/${company_id}
    Then Response status code should be:    404
    And Response should return error code:    1801
    And Response reason should be:    Not Found
    And Response body parameter should be:    [errors][0][detail]    Company not found.
