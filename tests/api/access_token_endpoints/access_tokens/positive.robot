*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../resources/common/common_api.robot

*** Test Cases ***

Get_access_token_for_customer
    #When I set Headers:    Content-Type=application/json    Accept=*/*
    When I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${yves_user_email}","password":"${yves_user_password}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    access-tokens
    And Response body parameter should be greater than:    [data][attributes][expiresIn]    0
    And Response body parameter should be less than:    [data][attributes][expiresIn]    30000
    Response body parameter should not be EMPTY:    [data][attributes][tokenType]
    Response body parameter should not be EMPTY:    [data][attributes][accessToken]
    And Response body has correct self link internal

