*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Get_banner
    When I send a GET request:    /content-banners/${banner.id_1}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${banner.id_1}
    And Response body parameter should be:    [data][type]    content-banners
    And Response body parameter should be:    [data][attributes][title]    ${banner.name_1}
    And Response body parameter should not be EMPTY:    [data][attributes][subtitle]
    And Response body parameter should contain:    [data][attributes][imageUrl]    png
    And Response body parameter should not be EMPTY:    [data][attributes][clickUrl]
    And Response body parameter should be:    [data][attributes][altText]    ${banner.name_1}
    And Response body has correct self link internal
