*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     SuiteSetup
Test Setup      TestSetup

Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup

Get_access_token_for_company_user_by_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    Save value to a variable:    [data][attributes][idCompanyUser]    company_user
    When I send a POST request:
    ...    /company-user-access-tokens
    ...    {"data":{"type":"company-user-access-tokens","attributes":{"idCompanyUser":"${company_user}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    company-user-access-tokens
    And Response body parameter should be greater than:    [data][attributes][expiresIn]    0
    And Response body parameter should be less than:    [data][attributes][expiresIn]    30000
    And Response body parameter should not be EMPTY:    [data][attributes][tokenType]
    And Response body parameter should not be EMPTY:    [data][attributes][accessToken]
    And Response body parameter should not be EMPTY:    [data][attributes][refreshToken]
    And Response body has correct self link internal
