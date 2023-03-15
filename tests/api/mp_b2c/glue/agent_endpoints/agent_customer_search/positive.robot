*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Agent_can_get_search_for_customers_without_search_parameters
    [Documentation]    bug:https://spryker.atlassian.net/browse/CC-17010
    [Tags]    skip-due-to-issue    
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    agent-customer-search
    And Response body parameter should be:    [data][0][id]    None
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    10
    And Response body parameter should be:    [data][0][attributes][customers][0][customerReference]    ${customer_reference.de_1}
    And Response body parameter should be:    [data][0][attributes][customers][9][customerReference]    ${customer_reference.de_10}
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    email
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    firstName
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    lastName
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][next]
    And Response body has correct self link
    

Agent_can_get_search_for_customers_by_first_name
    [Documentation]    bug:https://spryker.atlassian.net/browse/CC-17010
    [Tags]    skip-due-to-issue    
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?q=${yves_user.first_name}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    agent-customer-search
    And Response body parameter should be:    [data][0][id]    None
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    1
    And Response body parameter should be:    [data][0][attributes][customers][0][customerReference]    ${yves_user.reference}
    And Response body parameter should be:    [data][0][attributes][customers][0][email]    ${yves_user.email}
    And Response body parameter should be:     [data][0][attributes][customers][0][firstName]     ${yves_user.first_name}
    And Response body parameter should be:     [data][0][attributes][customers][0][lastName]    ${yves_user.last_name}
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body has correct self link


Agent_can_get_search_for_customers_by_last_name
    [Documentation]    bug:https://spryker.atlassian.net/browse/CC-17010
    [Tags]    skip-due-to-issue    
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?q=${yves_user.last_name}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    agent-customer-search
    And Response body parameter should be:    [data][0][id]    None
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    1
    And Response body parameter should be:    [data][0][attributes][customers][0][customerReference]    ${yves_user.reference}
    And Response body parameter should be:    [data][0][attributes][customers][0][email]    ${yves_user.email}
    And Response body parameter should be:     [data][0][attributes][customers][0][firstName]     ${yves_user.first_name}
    And Response body parameter should be:     [data][0][attributes][customers][0][lastName]    ${yves_user.last_name}
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body has correct self link


Agent_can_get_search_for_customers_by_email
    [Documentation]    bug:https://spryker.atlassian.net/browse/CC-17010
    [Tags]    skip-due-to-issue    
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?q=${yves_user.email}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    agent-customer-search
    And Response body parameter should be:    [data][0][id]    None
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    1
    And Response body parameter should be:    [data][0][attributes][customers][0][customerReference]    ${yves_user.reference}
    And Response body parameter should be:    [data][0][attributes][customers][0][email]    ${yves_user.email}
    And Response body parameter should be:     [data][0][attributes][customers][0][firstName]     ${yves_user.first_name}
    And Response body parameter should be:     [data][0][attributes][customers][0][lastName]    ${yves_user.last_name}
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body has correct self link

Agent_can_get_search_for_customers_by_substring
    [Documentation]    bug:https://spryker.atlassian.net/browse/CC-17010
    [Tags]    skip-due-to-issue    
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?q=so
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    agent-customer-search
    And Response body parameter should be:    [data][0][id]    None
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    2
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    customerReference
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    email
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    firstName
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    lastName
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body has correct self link

Agent_can_get_search_for_customers_by_substring_and_not_find_any
    [Documentation]    bug:https://spryker.atlassian.net/browse/CC-17010
    [Tags]    skip-due-to-issue    
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?q=ghjk
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    agent-customer-search
    And Response body parameter should be:    [data][0][id]    None
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    0
    And Response body has correct self link


Agent_can_get_search_for_customers_with_larger_page_size
    [Documentation]    bug:https://spryker.atlassian.net/browse/CC-17010
    [Tags]    skip-due-to-issue    
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?page[offset]=0&page[limit]=15
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    agent-customer-search
    And Response body parameter should be:    [data][0][id]    None
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    15
    And Response body parameter should be:    [data][0][attributes][customers][0][customerReference]    ${customer_reference.de_1}
    And Response body parameter should be:    [data][0][attributes][customers][14][customerReference]    ${customer_reference.de_15}
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    email
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    firstName
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    lastName
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][next]
    And Response body parameter should not be EMPTY:    [links][self]


Agent_can_get_search_for_customers_from_last_page
    [Documentation]    bug:https://spryker.atlassian.net/browse/CC-17010
    [Tags]    skip-due-to-issue    
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?page[offset]=30&page[limit]=10
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][id]    None
    And Response body parameter should be:    [data][0][type]    agent-customer-search
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    1
    And Response body parameter should be:    [data][0][attributes][customers][0][customerReference]    ${yves_user.reference}
    And Response body parameter should be:    [data][0][attributes][customers][0][email]    ${yves_user.email}
    And Response body parameter should be:     [data][0][attributes][customers][0][firstName]     ${yves_user.first_name}
    And Response body parameter should be:     [data][0][attributes][customers][0][lastName]    ${yves_user.last_name}
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][prev]
    And Response body parameter should not be EMPTY:    [links][self]