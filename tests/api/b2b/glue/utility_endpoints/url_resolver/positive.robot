*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***

Get_url_collections_by_url_paramater
    When I send a GET request:    /url-resolver?url=${url_resolver_example}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should be:    [data][0][attributes][entityType]    ${url_resolver_entity_type}
    And Response body parameter should be:    [data][0][attributes][entityId]    ${url_resolver_entity_id}
    And Each array element of array in response should contain nested property:    [data]     attributes    entityType
    And Each array element of array in response should contain nested property:    [data]     attributes    entityId
    And Each array element of array in response should contain nested property:    [data]     links    self
    And Response body has correct self link