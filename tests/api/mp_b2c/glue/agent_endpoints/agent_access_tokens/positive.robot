*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    SuiteSetup
Test Setup    TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
    
Get_agent_access_tokens
    When I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created 
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    agent-access-tokens
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should be:    [data][attributes][tokenType]    Bearer
    And Response body parameter should be greater than:    [data][attributes][expiresIn]    25000
    And Response body parameter should not be EMPTY:    [data][attributes][accessToken]
    And Response body parameter should not be EMPTY:    [data][attributes][refreshToken]
    And Response body has correct self link internal