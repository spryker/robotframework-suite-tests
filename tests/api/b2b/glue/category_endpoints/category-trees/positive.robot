*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
#GET requests
Get_category-trees
    When I send a GET request:    /category-trees
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property with value:    [data]    type    category-trees
    And Each array element of array in response should contain property with value:    [data]    id    None
    And Response body parameter should be:    [data][0][type]    category-trees
    And Response body parameter should be:    [data][0][id]    None
    And Each array element of array in response should contain property:    [data][0][attributes][categoryNodesStorage]    nodeId
    And Each array element of array in response should contain property:    [data][0][attributes][categoryNodesStorage]    order
    And Each array element of array in response should contain property:    [data][0][attributes][categoryNodesStorage]    name
    And Each array element of array in response should contain property:    [data][0][attributes][categoryNodesStorage]    url
    And Each array element of array in response should contain property:    [data][0][attributes][categoryNodesStorage]    children
    And Response body has correct self link