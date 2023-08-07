*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/steps/shipment_type_steps.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
    Deactivate shipment types
    Create shipment type in DB    ${shipment_type_delivery_test.uuid}    ${shipment_type_delivery_test.name}    ${shipment_type_delivery_test.key}
    Trigger publish trigger-events    shipment_type    ${console_path}

Retrieves_a_shipment_type_collection
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

Retrieves_a_shipment_type_by_uuid
    When I send a GET request:   /shipment-types/${shipment_type_delivery_test.uuid}
    Then Response status code should be:    200
    And Response reason should be:  OK
    And Response body parameter should be:    [data][type]    shipment-types
    And Response body parameter should be:    [data][id]    ${shipment_type_delivery_test.uuid}
    And Response body parameter should be:    [data][attributes][name]    ${shipment_type_delivery_test.name}
    And Response body parameter should be:    [data][attributes][key]    ${shipment_type_delivery_test.key}
    And Response body has correct self link internal

DISABLER
    Delete shipment type in DB    ${shipment_type_delivery_test.uuid}
    Active shipment types
