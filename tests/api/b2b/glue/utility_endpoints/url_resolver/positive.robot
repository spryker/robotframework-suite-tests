*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     SuiteSetup
Test Setup      TestSetup

Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup

Get_url_collections_by_url_paramater
    When I send a GET request:    /url-resolver?url=${url_resolver.example}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should be:    [data][0][attributes][entityType]    ${url_resolver.entity_type}
    And Response body parameter should be:    [data][0][attributes][entityId]    ${url_resolver.entity_id}
    And Each array element of array in response should contain nested property:    [data]    attributes    entityType
    And Each array element of array in response should contain nested property:    [data]    attributes    entityId
    And Each array element of array in response should contain nested property:    [data]    links    self
    And Response body has correct self link
