*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Default Tags    glue

Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
ENABLER
        TestSetup

Get_url_collections_by_url_paramater_of_category_nodes
    When I send a GET request:    /url-resolver?url=${url_resolver.category_nodes}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Array in response should contain property with value:    [data]    type    url-resolver
    And Response body parameter should be:    [data][0][id]    None
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should be:    [data][0][attributes][entityType]    ${url_resolver.category_nodes_entity}
    And Response body parameter should be:    [data][0][attributes][entityId]    ${url_resolver.category_nodes_id}
    And Each array element of array in response should contain nested property:    [data]     links    self
    And Response body has correct self link

Get_url_collections_by_url_paramater_of_product
    When I send a GET request:    /url-resolver?url=${url_resolver.example}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Array in response should contain property with value:    [data]    type    url-resolver
    And Response body parameter should be:    [data][0][id]    None
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should be:    [data][0][attributes][entityType]    ${url_resolver.entity_type}
    And Response body parameter should be:    [data][0][attributes][entityId]    ${url_resolver.entity_id}
    And Each array element of array in response should contain nested property:    [data]     links    self
    And Response body has correct self link

Get_url_collections_by_url_paramater_of_cms_page
    When I send a GET request:    /url-resolver?url=${url_resolver.cms}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Array in response should contain property with value:    [data]    type    url-resolver
    And Response body parameter should be:    [data][0][id]    None
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should be:    [data][0][attributes][entityType]    ${url_resolver.cms_entity}
    And Response body parameter should be:    [data][0][attributes][entityId]    ${url_resolver.cms_id}
    And Each array element of array in response should contain nested property:    [data]     links    self
    And Response body has correct self link

Get_url_collections_by_url_paramater_of_merchant_page
    When I send a GET request:    /url-resolver?url=${url_resolver.merchant}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Array in response should contain property with value:    [data]    type    url-resolver
    And Response body parameter should be:    [data][0][id]    None
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should be:    [data][0][attributes][entityType]    ${url_resolver.merchant_entity}
    And Response body parameter should be:    [data][0][attributes][entityId]    ${url_resolver.merchant_id}
    And Each array element of array in response should contain nested property:    [data]     links    self
    And Response body has correct self link