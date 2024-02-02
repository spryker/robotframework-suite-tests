*** Settings ***
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        API_test_setup
Default Tags    glue_dms_eu

*** Test Cases ***
ENABLER
    API_test_setup

Get_url_collections_by_url_paramater_of_category_nodes
    When I send a GET request:    /url-resolver?url=${url_resolver_category_nodes}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Array in response should contain property with value:    [data]    type    url-resolver
    And Response body parameter should be:    [data][0][id]    None
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should be:    [data][0][attributes][entityType]    ${url_resolver_category_nodes_entity}
    And Response body parameter should be:    [data][0][attributes][entityId]    ${url_resolver_category_nodes_id}
    And Each array element of array in response should contain nested property:    [data]     links    self
    And Response body has correct self link

Get_url_collections_by_url_paramater_of_product
    When I send a GET request:    /url-resolver?url=${url_resolver_abstract_product}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Array in response should contain property with value:    [data]    type    url-resolver
    And Response body parameter should be:    [data][0][id]    None
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should be:    [data][0][attributes][entityType]    ${url_resolver_product_entity}
    And Response body parameter should be:    [data][0][attributes][entityId]    ${url_resolver_product_id}
    And Each array element of array in response should contain nested property:    [data]     links    self
    And Response body has correct self link

Get_url_collections_by_url_paramater_of_cms_page
    When I send a GET request:    /url-resolver?url=${url_resolver_cms}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Array in response should contain property with value:    [data]    type    url-resolver
    And Response body parameter should be:    [data][0][id]    None
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should be:    [data][0][attributes][entityType]    ${url_resolver_cms_entity}
    And Response body parameter should be:    [data][0][attributes][entityId]    ${url_resolver_cms_id}
    And Each array element of array in response should contain nested property:    [data]     links    self
    And Response body has correct self link

Get_url_collections_by_url_paramater_of_merchant_page
    When I send a GET request:    /url-resolver?url=${url_resolver_merchant}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Array in response should contain property with value:    [data]    type    url-resolver
    And Response body parameter should be:    [data][0][id]    None
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should be:    [data][0][attributes][entityType]    ${url_resolver_merchant_entity}
    And Response body parameter should be:    [data][0][attributes][entityId]    ${url_resolver_merchant_id}
    And Each array element of array in response should contain nested property:    [data]     links    self
    And Response body has correct self link