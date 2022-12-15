*** Settings ***   
Suite Setup    SuiteSetup   
Test Setup     TestSetup
Default Tags    glue

Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
ENABLER
        TestSetup

Get_url_collections_by_url_paramater_of_category_nodes
    [Documentation]   #CC-16595 API: ID is missing from url resolver.
    [Tags]    skip-due-to-issue 
    When I send a GET request:    /url-resolver?url=${url_resolver_category_nodes}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Array in response should contain property with value:    [data]    type    url-resolver
    And Response body parameter should not be EMPTY:    [data][id]
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should be:    [data][0][attributes][entityType]    ${url_resolver_category_nodes_entity}
    And Response body parameter should be:    [data][0][attributes][entityId]    ${url_resolver_category_nodes_id}
    And Each array element of array in response should contain nested property:    [data]     links    self
    And Response body has correct self link

Get_url_collections_by_url_paramater_of_product
    [Documentation]   #CC-16595 API: ID is missing from url resolver.
    [Tags]    skip-due-to-issue
    When I send a GET request:    /url-resolver?url=${url_resolver_abstract_product}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Array in response should contain property with value:    [data]    type    url-resolver
    And Response body parameter should not be EMPTY:    [data][id]
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should be:    [data][0][attributes][entityType]    ${url_resolver_product_entity}
    And Response body parameter should be:    [data][0][attributes][entityId]    ${url_resolver_product_id}
    And Each array element of array in response should contain nested property:    [data]     links    self
    And Response body has correct self link

Get_url_collections_by_url_paramater_of_cms_page
    [Documentation]   #CC-16595 API: ID is missing from url resolver.
    [Tags]    skip-due-to-issue
    When I send a GET request:    /url-resolver?url=${url_resolver_cms}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Array in response should contain property with value:    [data]    type    url-resolver
    And Response body parameter should not be EMPTY:    [data][id]
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should be:    [data][0][attributes][entityType]    ${url_resolver_cms_entity}
    And Response body parameter should be:    [data][0][attributes][entityId]    ${url_resolver_cms_id}
    And Each array element of array in response should contain nested property:    [data]     links    self
    And Response body has correct self link