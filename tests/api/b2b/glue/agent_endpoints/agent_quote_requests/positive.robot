*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***

#######GET#######

# We need a bug here because swagger documentation does not match reality at all
Agent_can_get_list_of_quotes
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent_email}","password": "${agent_password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-quote-requests
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    quote-requests
    And Response should contain the array larger than a certain size:   [data]    0
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Save value to a variable:    [data][0][id]    quite_id
    And Response body parameter should be:    [data][0][attributes][quoteRequestReference]    ${quite_id}
    And Response body parameter should not be EMPTY:    [data][0][attributes][versions]
    And Save value to a variable:    [data][0][attributes][versions][0]   version_id
    And Response body parameter should not be EMPTY:    [data][0][attributes][status]
    And Response body parameter should not be EMPTY:    [data][0][attributes][isLatestVersionVisible]
    And Response body parameter should not be EMPTY:    [data][0][attributes][createdAt]
    And Each array element of array in response should contain property:    [data]    id
    And Response body parameter should not be EMPTY:    [data][0][attributes][shownVersion]
    And Response body parameter should not be EMPTY:    [data][0][links][self]
    And Response body has correct self link
    And Response body parameter should be:    [data][0][attributes][shownVersion][versionReference]    ${version_id}
    And Response body parameter should not be EMPTY:    [data][0][attributes][shownVersion][metadata]
    And Response body parameter should be greater than:    [data][0][attributes][shownVersion][cart][totals][priceToPay]    100
    And Response body parameter should be:    [data][0][attributes][shownVersion][cart][store]    ${store_de}
    And Response body parameter should be:    [data][0][attributes][shownVersion][cart][currency]    ${currency_code_eur}
    And Response body parameter should be:    [data][0][attributes][shownVersion][cart][priceMode]    ${gross_mode}
    And Response should contain the array larger than a certain size:   [data][0][attributes][shownVersion][cart][items]    0

Agent_can_get_a_specific_quote
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent_email}","password": "${agent_password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    ...    AND    I send a GET request:    /agent-quote-requests
    ...    AND    Response status code should be:    200
    ...    AND    Save value to a variable:    [data][0][id]    quote_id
    When I send a GET request:    /agent-quote-requests/${quote_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    quote-requests
    And Response should contain the array larger than a certain size:   [data]    0
    And Response body parameter should not be EMPTY:    [data][id]
    And Save value to a variable:    [data][id]    quote_id
    And Response body parameter should be:    [data][attributes][quoteRequestReference]    ${quote_id}
    And Response body parameter should not be EMPTY:    [data][attributes][versions]
    And Save value to a variable:    [data][attributes][versions][0]   version_id
    And Response body parameter should not be EMPTY:    [data][attributes][status]
    And Response body parameter should not be EMPTY:    [data][attributes][isLatestVersionVisible]
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should not be EMPTY:    [data][attributes][shownVersion]
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response body has correct self link
    And Response body parameter should be:    [data][attributes][shownVersion][versionReference]    ${version_id}
    And Response body parameter should not be EMPTY:    [data][attributes][shownVersion][metadata]
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][priceToPay]    100
    And Response body parameter should be:    [data][attributes][shownVersion][cart][store]    ${store_de}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][currency]    ${currency_code_eur}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][priceMode]    ${gross_mode}
    And Response should contain the array larger than a certain size:   [data][attributes][shownVersion][cart][items]    0

#######POST########
Agent_can_create_a_quote_request