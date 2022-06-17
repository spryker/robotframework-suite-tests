*** Settings ***
Suite Setup        SuiteSetup
Test Setup        TestSetup
Default Tags    glue
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
ENABLER
   TestSetup
Not_agent_can't_get_search_for_customers
    When I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${non_agent.email}","password": "${non_agent.password}"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4101
    And Response should return error message:    Failed to authenticate an agent.
    When I send a GET request:    /agent-customer-search
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4103
    And Response should return error message:    Action is available to agent user only.


Agent_can't_get_search_for_customers_without_token
    When I send a GET request:    /agent-customer-search
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4103
    And Response should return error message:    Action is available to agent user only.
