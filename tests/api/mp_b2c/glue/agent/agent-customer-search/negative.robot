*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Agent_customer_search_without_agent_token
    When I send a GET request:    /agent-customer-search
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4103
    And Response should return error message:    Action is available to agent user only.

Agent_customer_search_with_regular_customer_token
    [Setup]    Run keywords
    ...    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /agent-customer-search
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4103
    And Response should return error message:    Action is available to agent user only.

Agent_customer_search_invalid_pagination_parameters
    [Setup]    Run keywords
    ...    I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"${agent.email}","password":"${agent.password}"}}}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I set Headers:    Authorization=Bearer ${agent_token}
    Run Keyword And Expect Error    STARTS: Got: '400' status code    I send a GET request:    /agent-customer-search?page[limit]=0&page[offset]=0