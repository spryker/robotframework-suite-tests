*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
Get_category_node_by_id
    When I send a GET request:    /category-nodes/${category_nodes_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    category-nodes
    And Response body parameter should be:    [data][id]    ${category_nodes_id}
    And Response body parameter should be:    [data][attributes][nodeId]    ${category_nodes_id}
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
    And Response should contain the array of a certain size:    [data][attributes][children][0][parents]    0
    And Response body has correct self link internal
