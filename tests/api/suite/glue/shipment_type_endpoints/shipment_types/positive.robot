*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Get_a_shipment_type_collection
    When I send a GET request:   /shipment-types
    Then Response status code should be:    200
    And Response reason should be:  OK
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    links
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    Each array element of array in response should contain nested property with value:    [data]    [type]    shipment-types
    And Response body has correct self link

Get_a_shipment_type_by_uuid
    When I send a GET request:   /shipment-types/${shipment_type_delivery.uuid}
    Then Response status code should be:    200
    And Response reason should be:  OK
    And Response body parameter should be:    [data][type]    shipment-types
    And Response body parameter should be:    [data][id]    ${shipment_type_delivery.uuid}
    And Response body parameter should be:    [data][attributes][name]    ${shipment_type_delivery.name}
    And Response body parameter should be:    [data][attributes][key]    ${shipment_type_delivery.key}
    And Response body has correct self link internal

