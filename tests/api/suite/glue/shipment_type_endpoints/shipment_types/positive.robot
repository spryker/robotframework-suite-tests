*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/steps/shipment_type_steps.robot
Resource    ../../../../../../resources/steps/shipment_type_service_point_steps.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
    Deactivate shipment types
    Create shipment type in DB    ${shipment_type_delivery_test.uuid}    ${shipment_type_delivery_test.name}    ${shipment_type_delivery_test.key}
    Create shipment type in DB    ${shipment_type_pickup_test.uuid}    ${shipment_type_pickup_test.name}    ${shipment_type_pickup_test.key}
    Create service type in DB     ${serviceTypes[0].uuid}    ${serviceTypes[0].name}    ${serviceTypes[0].key}
    Create shipment type service type relation in DB  ${shipment_type_pickup_test.uuid}    ${serviceTypes[0].uuid}
    Trigger publish trigger-events    shipment_type    ${console_path}
    Trigger publish trigger-events    service_type    ${console_path}

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

Retrieves_a_shipment_type_collection_with_a_desc_sorting_by_key
    When I send a GET request:   /shipment-types?sort=-key
    Then Response status code should be:    200
    And Response reason should be:  OK
    And Response body parameter should be:    [data][0][attributes][key]    ${shipment_type_pickup_test.key}
    And Response body parameter should be:    [data][1][attributes][key]    ${shipment_type_delivery_test.key}

Retrieves_a_shipment_type_by_uuid
    When I send a GET request:   /shipment-types/${shipment_type_delivery_test.uuid}
    Then Response status code should be:    200
    And Response reason should be:  OK
    And Response body parameter should be:    [data][type]    shipment-types
    And Response body parameter should be:    [data][id]    ${shipment_type_delivery_test.uuid}
    And Response body parameter should be:    [data][attributes][name]    ${shipment_type_delivery_test.name}
    And Response body parameter should be:    [data][attributes][key]    ${shipment_type_delivery_test.key}
    And Response body has correct self link internal

Retrieves_list_of_shipment_types_with_service_types_relations
    When I send a GET request:    /shipment-types?include=service-types
    Then Response status code should be:    200
    And Response reason should be:          OK
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    links
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    Each array element of array in response should contain nested property with value:    [data]    [type]    shipment-types
    And Response should contain the array of a certain size:    [included]    1
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain property with value:    [included]    type    service-types
    And Each array element of array in response should contain nested property:    [included]    [attributes]    name
    And Each array element of array in response should contain nested property:    [included]    [attributes]    key
    And Response body parameter should be:    [included][0][id]                  ${serviceTypes[0].uuid}
    And Response body parameter should be:    [included][0][attributes][name]    ${serviceTypes[0].name}
    And Response body parameter should be:    [included][0][attributes][key]     ${serviceTypes[0].key}
    And Response body has correct self link

Retrieves_a_shipment_type_by_id_with_service_type_relation
    When I send a GET request:    /shipment-types/${shipment_type_pickup_test.uuid}?include=service-types
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    shipment-types
    And Response body parameter should be:    [data][id]    ${shipment_type_pickup_test.uuid}
    And Response body parameter should be:    [data][attributes][name]    ${shipment_type_pickup_test.name}
    And Response body parameter should be:    [data][attributes][key]    ${shipment_type_pickup_test.key}
    And Response should contain the array of a certain size:    [included]    1
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain property with value:    [included]    type    service-types
    And Each array element of array in response should contain nested property:    [included]    [attributes]    name
    And Each array element of array in response should contain nested property:    [included]    [attributes]    key
    And Response body parameter should be:    [included][0][id]                  ${serviceTypes[0].uuid}
    And Response body parameter should be:    [included][0][attributes][name]    ${serviceTypes[0].name}
    And Response body parameter should be:    [included][0][attributes][key]     ${serviceTypes[0].key}
    And Response body has correct self link internal

Retrieves_a_shipment_type_by_id_with_empty_service_type_relation
    When I send a GET request:    /shipment-types/${shipment_type_delivery_test.uuid}?include=service-types
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    shipment-types
    And Response body parameter should be:    [data][id]    ${shipment_type_delivery_test.uuid}
    And Response body parameter should be:    [data][attributes][name]    ${shipment_type_delivery_test.name}
    And Response body parameter should be:    [data][attributes][key]    ${shipment_type_delivery_test.key}
    And Response body should not contain:    included
    And Response body has correct self link internal

DISABLER
    Deactivate shipment types
    Delete shipment type service type in DB     ${shipment_type_pickup_test.uuid}
    Delete shipment type in DB                  ${shipment_type_delivery_test.uuid}
    Delete shipment type in DB                  ${shipment_type_pickup_test.uuid}
    Delete service type in DB                   ${serviceTypes[0].uuid}
    Activate shipment types
