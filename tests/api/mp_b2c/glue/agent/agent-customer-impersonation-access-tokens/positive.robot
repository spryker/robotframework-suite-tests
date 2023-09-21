*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Agent_impersonate_a_customer
    [Setup]    Run keywords
    ...    I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"${agent.email}","password":"${agent.password}"}}}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I set Headers:    Authorization=Bearer ${agent_token}
    When I send a POST request:    /agent-customer-impersonation-access-tokens    {"data":{"type":"agent-customer-impersonation-access-tokens","attributes":{"customerReference":"${yves_user.reference}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    agent-customer-impersonation-access-tokens
    And Response body parameter should be greater than:    [data][attributes][expiresIn]    0
    And Response body parameter should be less than:    [data][attributes][expiresIn]    30000
    And Response body parameter should not be EMPTY:    [data][attributes][tokenType]
    And Response body parameter should not be EMPTY:    [data][attributes][accessToken]
    And Response body parameter should not be EMPTY:    [data][attributes][refreshToken]
    And Response body has correct self link internal