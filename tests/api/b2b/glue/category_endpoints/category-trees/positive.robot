*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
#GET requests
Get_category_trees
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
    And Response body parameter should be:    [data][0][attributes][categoryNodesStorage][1][children][0][nodeId]    36
    And Response body parameter should be:    [data][0][attributes][categoryNodesStorage][1][children][0][order]    50
    And Response body parameter should be:    [data][0][attributes][categoryNodesStorage][1][children][0][name]    Fish
    And Response body parameter should be:    [data][0][attributes][categoryNodesStorage][1][children][0][url]    /en/foods/fish
    And Response should contain the array of a certain size:    [data][0][attributes][categoryNodesStorage][1][children][0][children]    0
    And Response should contain the array of a certain size:    [data][0][attributes][categoryNodesStorage]    ${qty_of_categories_in_category_trees}
    And Response should contain the array of a certain size:    [data][0][attributes][categoryNodesStorage][1][children]    ${qty_of_subcategories_in_category_trees}
    And Response body has correct self link