*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Agent_impersonate_wront_type
    [Setup]    Run keywords
    ...    I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"${agent.email}","password":"${agent.password}"}}}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I set Headers:    Authorization=Bearer ${agent_token}
    When I send a POST request:    /agent-customer-impersonation-access-tokens    {"data":{"type":"agent-customer-impersonation-access-fake","attributes":{"customerReference":"${yves_user.reference}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should return error message:    Invalid type.
    And Response should return error code:    400

Agent_impersonate_empty_type
    [Setup]    Run keywords
    ...    I send a POST request:    /agent-access-tokens    {"data":{"type":"","attributes":{"username":"${agent.email}","password":"${agent.password}"}}}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I set Headers:    Authorization=Bearer ${agent_token}
    When I send a POST request:    /agent-customer-impersonation-access-tokens    {"data":{"type":"","attributes":{"customerReference":"${yves_user.reference}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should return error message:    Invalid type.
    And Response should return error code:    400

Agent_impersonate_with_non_existing_customer_reference
    [Setup]    Run keywords
    ...    I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"${agent.email}","password":"${agent.password}"}}}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I set Headers:    Authorization=Bearer ${agent_token}
    When I send a POST request:    /agent-customer-impersonation-access-tokens    {"data":{"type":"agent-customer-impersonation-access-tokens","attributes":{"customerReference":"DE--5000"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should return error message:    Failed to impersonate a customer.
    And Response should return error code:    4104

Agent_impersonate_without_customer_reference
    [Setup]    Run keywords
    ...    I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"${agent.email}","password":"${agent.password}"}}}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I set Headers:    Authorization=Bearer ${agent_token}
    When I send a POST request:    /agent-customer-impersonation-access-tokens    {"data":{"type":"agent-customer-impersonation-access-tokens","attributes":{}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should return error message:    Failed to impersonate a customer.
    And Response should return error code:    4104

Agent_impersonate_with_empty_customer_reference
    [Setup]    Run keywords
    ...    I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"${agent.email}","password":"${agent.password}"}}}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I set Headers:    Authorization=Bearer ${agent_token}
    When I send a POST request:    /agent-customer-impersonation-access-tokens    {"data":{"type":"agent-customer-impersonation-access-tokens","attributes":{"customerReference":""}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should return error message:    Failed to impersonate a customer.
    And Response should return error code:    4104