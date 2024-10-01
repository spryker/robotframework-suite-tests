*** Settings ***
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        API_test_setup
Test Tags    glue

*** Test Cases ***
ENABLER
    API_test_setup

#GET requests
Get_category_trees
    When I send a GET request:    /category-trees
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property with value:    [data]    type    category-trees
    And Each array element of array in response should contain property with value:    [data]    id    ${None}
    And Response body parameter should be:    [data][0][type]    category-trees
    And Response body parameter should be:    [data][0][id]    None
    And Each array element of array in response should contain property:    [data][0][attributes][categoryNodesStorage]    nodeId
    And Each array element of array in response should contain property:    [data][0][attributes][categoryNodesStorage]    order
    And Each array element of array in response should contain property:    [data][0][attributes][categoryNodesStorage]    name
    And Each array element of array in response should contain property:    [data][0][attributes][categoryNodesStorage]    url
    And Each array element of array in response should contain property:    [data][0][attributes][categoryNodesStorage]    children
    And Response body parameter should be:    [data][0][attributes][categoryNodesStorage][1][name]    ${category_nodes_storage_name}
    And Response body parameter should be:    [data][0][attributes][categoryNodesStorage][1][url]    ${category_nodes_storage_url}
    And Response body parameter should not be EMPTY:    [data][0][attributes][categoryNodesStorage][1][children][0][nodeId]
    And Response body parameter should not be EMPTY:    [data][0][attributes][categoryNodesStorage][1][children][0][order]
    And Response body parameter should be:    [data][0][attributes][categoryNodesStorage][1][children][0][name]    ${subcategory_nodes_storage_name}
    And Response body parameter should be:    [data][0][attributes][categoryNodesStorage][1][children][0][url]    ${subcategory_nodes_storage_url}
    And Response should contain the array of a certain size:    [data][0][attributes][categoryNodesStorage][1][children][0][children]    0
    And Response should contain the array of a certain size:    [data][0][attributes][categoryNodesStorage]    ${qty_of_categories_in_category_trees}
    And Response should contain the array of a certain size:    [data][0][attributes][categoryNodesStorage][1][children]    ${qty_of_subcategories_in_category_trees}
    And Response body has correct self link
