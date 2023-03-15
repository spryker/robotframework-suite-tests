*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    SuiteSetup
Test Setup     TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Get_category_node_is_root_by_id
    [Documentation]   bug https://spryker.atlassian.net/browse/CC-11134
    [Tags]    skip-due-to-issue
    When I send a GET request:    /category-nodes/${category_node_is_root_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    category-nodes
    And Response body parameter should be:    [data][id]    ${category_node_is_root_id}
    And Response Body parameter should have datatype:    [data][attributes][name]    str
    And Response Body parameter should have datatype:    [data][attributes][nodeId]    int
    And Response Body parameter should have datatype:    [data][attributes][order]    int
    And Response Body parameter should have datatype:    [data][attributes][url]    str
    And Response should contain the array of a certain size:    [data][attributes][parents]    0
    And Response should contain the array larger than a certain size:   [data][attributes][children]    1
    And Response body has correct self link internal

Get_category_node_has_children_by_id
    When I send a GET request:    /category-nodes/${category_node_has_children_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    category-nodes
    And Response body parameter should be:    [data][id]    ${category_node_has_children_id}
    And Response body parameter should be:    [data][attributes][nodeId]    ${category_node_has_children_id}
    And Response Body parameter should have datatype:    [data][attributes][name]    str
    And Response Body parameter should have datatype:    [data][attributes][nodeId]    int
    And Response Body parameter should have datatype:    [data][attributes][order]    int
    And Response Body parameter should have datatype:    [data][attributes][url]    str
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][children]    nodeId
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][children]    name
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][children]    isActive
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][children]    order
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][children]    url
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][children]    children
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][children]    parents
    And Response body has correct self link internal


Get_category_node_that_has_only_parents_by_id
    When I send a GET request:    /category-nodes/${category_node_has_only_parent_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    category-nodes
    And Response body parameter should be:    [data][id]    ${category_node_has_only_parent_id}
    And Response Body parameter should have datatype:    [data][attributes][name]    str
    And Response Body parameter should have datatype:    [data][attributes][nodeId]    int
    And Response Body parameter should have datatype:    [data][attributes][order]    int
    And Response Body parameter should have datatype:    [data][attributes][url]    str
    And Response should contain the array of a certain size:    [data][attributes][children]    0
    And Response should contain the array larger than a certain size:   [data][attributes][parents]    0
    And Response body has correct self link internal