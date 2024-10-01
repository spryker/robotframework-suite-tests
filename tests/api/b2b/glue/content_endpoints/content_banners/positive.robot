*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue


*** Test Cases ***
ENABLER
    API_test_setup

Get_banner
    When I send a GET request:    /content-banners/${banner.id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${banner.id}
    And Response body parameter should be:    [data][type]    content-banners
    And Response body parameter should be:    [data][attributes][title]    ${banner.name}
    And Response body parameter should not be EMPTY:    [data][attributes][subtitle]
    And Response body parameter should contain:    [data][attributes][imageUrl]    jpg
    And Response body parameter should not be EMPTY:    [data][attributes][clickUrl]
    And Response body parameter should be:    [data][attributes][altText]    ${banner.name}
    And Response body has correct self link internal
