*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Agent_customer_search_empty_search_get_all_customers
    [Setup]    Run keywords
    ...    I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"${agent.email}","password":"${agent.password}"}}}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I set Headers:    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    agent-customer-search
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    10
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    customerReference
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    email
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    firstName
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    lastName
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][next]
    And Response body parameter should contain:    [data][0][links][self]    /agent-customer-search
    And Response body has correct self link

Agent_customer_search_by_email
    [Setup]    Run keywords
    ...    I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"${agent.email}","password":"${agent.password}"}}}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I set Headers:    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?q=${yves_user.email}
    Then Response status code should be:    200
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    1
    And Response body parameter should be:    [data][0][attributes][customers][0][customerReference]    ${yves_user.reference}
    And Response body parameter should be:    [data][0][attributes][customers][0][email]    ${yves_user.email}
    And Response body parameter should be:    [data][0][attributes][customers][0][firstName]    ${yves_user.first_name}
    And Response body parameter should be:    [data][0][attributes][customers][0][lastName]    ${yves_user.last_name}
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should contain:    [data][0][links][self]    /agent-customer-search
    And Response body has correct self link

Agent_customer_search_by_first_name
    [Setup]    Run keywords
    ...    I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"${agent.email}","password":"${agent.password}"}}}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I set Headers:    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?q=${yves_user.first_name}
    Then Response status code should be:    200
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    1
    And Response body parameter should be:    [data][0][attributes][customers][0][customerReference]    ${yves_user.reference}
    And Response body parameter should be:    [data][0][attributes][customers][0][email]    ${yves_user.email}
    And Response body parameter should be:    [data][0][attributes][customers][0][firstName]    ${yves_user.first_name}
    And Response body parameter should be:    [data][0][attributes][customers][0][lastName]    ${yves_user.last_name}
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should contain:    [data][0][links][self]    /agent-customer-search
    And Response body has correct self link

Agent_customer_search_by_last_name
    [Setup]    Run keywords
    ...    I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"${agent.email}","password":"${agent.password}"}}}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I set Headers:    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?q=${yves_user.last_name}
    Then Response status code should be:    200
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    1
    And Response body parameter should be:    [data][0][attributes][customers][0][customerReference]    ${yves_user.reference}
    And Response body parameter should be:    [data][0][attributes][customers][0][email]    ${yves_user.email}
    And Response body parameter should be:    [data][0][attributes][customers][0][firstName]    ${yves_user.first_name}
    And Response body parameter should be:    [data][0][attributes][customers][0][lastName]    ${yves_user.last_name}
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should contain:    [data][0][links][self]    /agent-customer-search
    And Response body has correct self link

Agent_customer_search_by_non_existing_customer
    [Setup]    Run keywords
    ...    I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"${agent.email}","password":"${agent.password}"}}}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I set Headers:    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?q=fake_search_request
    Then Response status code should be:    200
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    0
    And Response body has correct self link

Agent_customer_search_by_substring
    [Setup]    Run keywords
    ...    I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"${agent.email}","password":"${agent.password}"}}}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I set Headers:    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?q=mar
    Then Response status code should be:    200
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    2
    and Array element should contain property with value at least once:    [data][0][attributes][customers]    email    ${yves_second_user.email}
    and Array element should contain property with value at least once:    [data][0][attributes][customers]    firstName    ${yves_second_user.first_name}
    and Array element should contain property with value at least once:    [data][0][attributes][customers]    lastName    ${yves_second_user.last_name}
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should contain:    [data][0][links][self]    /agent-customer-search
    And Response body has correct self link

Agent_customer_search_with_page_limit_and_offset
    [Setup]    Run keywords
    ...    I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"${agent.email}","password":"${agent.password}"}}}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I set Headers:    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?page[limit]=6&page[offset]=3
    Then Response status code should be:    200
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    6
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    customerReference
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    email
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    firstName
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    lastName
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][next]
    And Response body parameter should contain:    [data][0][links][self]    /agent-customer-search
    And Response body has correct self link

Agent_customer_search_pagination
    [Setup]    Run keywords
    ...    I send a POST request:    /agent-access-tokens    {"data":{"type":"agent-access-tokens","attributes":{"username":"${agent.email}","password":"${agent.password}"}}}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I set Headers:    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?page[limit]=10&page[offset]=30
    Then Response status code should be:    200
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    1
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    customerReference
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    email
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    firstName
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    lastName
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should contain:    [data][0][links][self]    /agent-customer-search
    And Response body has correct self link
