*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Get_access_token_for_the_agent_with_wrong_type
    When I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-fake","attributes":{"username":"${agent.email}","password":"${agent.password}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should return error message:    Invalid type.
    And Response should return error code:    400

Get_access_token_for_the_agent_with_empty_type
    When I send a POST request:    /agent-access-tokens    {"data":{"type":"","attributes":{"username":"${agent.email}","password":"${agent.password}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should return error message:    Invalid type.
    And Response should return error code:    400

Get_access_token_for_the_agent_with_invalid_password
    When I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"${agent.email}","password":"fake123"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should return error message:    Failed to authenticate an agent.
    And Response should return error code:    4101

Get_access_token_for_the_agent_with_invalid_email
    When I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"${non_agent.email}","password":"${agent.password}"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should return error message:    Failed to authenticate an agent.
    And Response should return error code:    4101

Get_access_token_for_the_agent_with_empty_password
    When I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"${non_agent.email}","password":""}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should return error message:    Failed to authenticate an agent.
    And Response should return error code:    4101

Get_access_token_for_the_agent_with_empty_email
    When I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"","password":"${agent.password}"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should return error message:    Failed to authenticate an agent.
    And Response should return error code:    4101

Get_access_token_for_the_agent_without_username
    When I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"password":"${agent.password}"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should return error message:    Failed to authenticate an agent.
    And Response should return error code:    4101

Get_access_token_for_the_agent_without_password
    When I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":""}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should return error message:    Failed to authenticate an agent.
    And Response should return error code:    4101