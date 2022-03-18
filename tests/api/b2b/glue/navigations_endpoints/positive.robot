*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***


Get_navigation_tree_using_valid_navigation_key
    When I send a GET request:    /navigations/MAIN_NAVIGATION
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    navigations
    And Response body parameter should be:    [data][id]    MAIN_NAVIGATION
    And Response Body parameter should have datatype:    [data][attributes][name]    str
    And Response Body parameter should have datatype:    [data][attributes][isActive]    bool
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    resourceId
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    nodeType
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    isActive
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    title
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    url
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    cssClass
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    validFrom
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    validTo
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    children
    And Response Body parameter should have datatype:    [data][attributes][nodes][0][nodeType]    str
    And Response Body parameter should have datatype:    [data][attributes][nodes][0][title]    str
    And Response Body parameter should have datatype:    [data][attributes][nodes][0][children]    list
    And Response body parameter should not be EMPTY:    [data][attributes][nodes][0][nodeType]
    And Response body parameter should not be EMPTY:    [data][attributes][nodes][0][title]
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes][0][children]   nodeType
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes][0][children]   cssClass
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes][0][children]   title
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes][0][children]   url
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes][0][children]   validFrom
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes][0][children]   validTo
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes][0][children]   children
    And Response body has correct self link internal
    