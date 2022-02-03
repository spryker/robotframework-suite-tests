*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Agent_searches_for_customers_with_no_token
    When I send a GET request:    /agent-customer-search
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4103
    And Response should return error message:    Action is available to agent user only.

