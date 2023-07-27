*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/steps/service_point_steps.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
    Deactivate service points

Retrieves_list_of_service_points
    [Setup]    Run Keywords    Create service point in DB    ${servicePoints[0].uuid}    ${servicePoints[0].name}    ${servicePoints[0].key}
    ...    AND    Create service point address in DB    ${servicePoints[0].uuid}
    ...    AND    Trigger publish trigger-events    service_point    ${console_path}
    When I send a GET request:    /service-points
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    service-points
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body parameter should be:    [data][0][id]    ${servicePoints[0].uuid}
    And Response body parameter should be:    [data][0][attributes][name]    ${servicePoints[0].name}
    And Response body parameter should be:    [data][0][attributes][key]    ${servicePoints[0].key}
    And Response body has correct self link
    [Teardown]    Run Keyword    Delete service point in DB    ${servicePoints[0].uuid}

Retrieves_list_of_service_points_filtered_by_service_type_key
    [Setup]    Run Keywords    Create service point with address and store relations in DB    ${servicePoints[0].uuid}    ${servicePointAddresses[0].uuid}
    ...    AND    Create service type in DB    uuid=${serviceTypes[0].uuid}    key=${serviceTypes[0].key}
    ...    AND    Create service in DB    servicePointUuid=${servicePoints[0].uuid}    serviceTypeUuid=${serviceTypes[0].uuid}
    ...    AND    Create service point with address and store relations in DB    servicePointUuid=${servicePoints[1].uuid}
    ...    AND    Trigger publish trigger-events    service_point    ${console_path}
    When I send a GET request:    /service-points?filter[service-points.serviceTypeKey]=${serviceTypes[0].key}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    1
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    service-points
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body parameter should be:    [data][0][id]    ${servicePoints[0].uuid}
    [Teardown]     Run Keywords    Delete service point in DB    ${servicePoints[0].uuid}
    ...    AND    Delete service point in DB    ${servicePoints[1].uuid}
    ...    AND    Delete service type in DB    ${serviceTypes[0].uuid}

Retrieves_list_of_service_points_filtered_by_name_using_full_text_search
    [Setup]    Run Keywords    Create service point in DB    name=${servicePoints[0].name}    uuid=${servicePoints[0].uuid}
    ...    AND    Create service point address in DB    servicePointUuid=${servicePoints[0].uuid}
    ...    AND    Create service point with address and store relations in DB    servicePointUuid=${servicePoints[1].uuid}
    ...    AND    Trigger publish trigger-events    service_point    ${console_path}
    When I send a GET request:    /service-points?q=${servicePoints[0].name}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    1
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    service-points
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body parameter should be:    [data][0][id]    ${servicePoints[0].uuid}
    [Teardown]     Run Keywords    Delete service point in DB    ${servicePoints[0].uuid}
    ...    AND    Delete service point in DB    ${servicePoints[1].uuid}

Retrieves_list_of_service_points_filtered_by_city_using_full_text_search
    [Setup]    Run Keywords    Create service point in DB    name=${servicePoints[0].name}    uuid=${servicePoints[0].uuid}
    ...    AND    Create service point address in DB    servicePointUuid=${servicePoints[0].uuid}    city=${servicePointAddresses[0].city}
    ...    AND    Create service point with address and store relations in DB    servicePointUuid=${servicePoints[1].uuid}
    ...    AND    Trigger publish trigger-events    service_point    ${console_path}
    When I send a GET request:    /service-points?q=${servicePointAddresses[0].city}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    1
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    service-points
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body parameter should be:    [data][0][id]    ${servicePoints[0].uuid}
    [Teardown]     Run Keywords    Delete service point in DB    ${servicePoints[0].uuid}
    ...    AND    Delete service point in DB    ${servicePoints[1].uuid}

Retrieves_list_of_service_points_sort_by_city_asc
    [Setup]    Run Keywords    Create service point in DB    ${servicePoints[0].uuid}
    ...    AND    Create service point address in DB    servicePointUuid=${servicePoints[0].uuid}    city=A
    ...    AND    Create service point in DB    uuid=${servicePoints[1].uuid}
    ...    AND    Create service point address in DB    servicePointUuid=${servicePoints[1].uuid}    city=B
    ...    AND    Trigger publish trigger-events    service_point    ${console_path}
    When I send a GET request:    /service-points?sort=city
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    2
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    service-points
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body parameter should be:    [data][0][id]    ${servicePoints[0].uuid}
    And Response body parameter should be:    [data][1][id]    ${servicePoints[1].uuid}
    And Response body has correct self link
    [Teardown]     Run Keywords    Delete service point in DB    ${servicePoints[0].uuid}
    ...    AND    Delete service point in DB    ${servicePoints[1].uuid}

Retrieves_list_of_service_points_sort_by_city_desc
    [Setup]    Run Keywords    Create service point in DB    ${servicePoints[0].uuid}
    ...    AND    Create service point address in DB    servicePointUuid=${servicePoints[0].uuid}    city=A
    ...    AND    Create service point in DB    uuid=${servicePoints[1].uuid}
    ...    AND    Create service point address in DB    servicePointUuid=${servicePoints[1].uuid}    city=B
    ...    AND    Trigger publish trigger-events    service_point    ${console_path}
    When I send a GET request:    /service-points?sort=-city
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    2
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    service-points
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body parameter should be:    [data][0][id]    ${servicePoints[1].uuid}
    And Response body parameter should be:    [data][1][id]    ${servicePoints[0].uuid}
    And Response body has correct self link
    [Teardown]     Run Keywords    Delete service point in DB    ${servicePoints[0].uuid}
    ...    AND    Delete service point in DB    ${servicePoints[1].uuid}

Retrieves_list_of_service_points_with_addresses_relations
    [Setup]    Run Keywords    Create service point in DB    ${servicePoints[0].uuid}
    ...    AND    Create service point address in DB    ${servicePoints[0].uuid}    ${servicePointAddresses[0].uuid}    ${servicePointAddresses[0].address1}    ${servicePointAddresses[0].address2}    ${servicePointAddresses[0].address3}    ${servicePointAddresses[0].city}    ${servicePointAddresses[0].zipCode}    DE
    ...    AND    Trigger publish trigger-events    service_point    ${console_path}
    When I send a GET request:    /service-points?include=service-point-addresses
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    service-points
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    service-points
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response should contain the array of a certain size:    [included]    1
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain property with value:    [included]    type    service-point-addresses
    And Each array element of array in response should contain nested property:    [included]    [attributes]    countryIso2Code
    And Each array element of array in response should contain nested property:    [included]    [attributes]    address1
    And Each array element of array in response should contain nested property:    [included]    [attributes]    address2
    And Each array element of array in response should contain nested property:    [included]    [attributes]    address3
    And Each array element of array in response should contain nested property:    [included]    [attributes]    zipCode
    And Each array element of array in response should contain nested property:    [included]    [attributes]    city
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Response body parameter should be:    [included][0][id]    ${servicePointAddresses[0].uuid}
    And Response body parameter should be:    [included][0][attributes][countryIso2Code]    DE
    And Response body parameter should be:    [included][0][attributes][address1]    ${servicePointAddresses[0].address1}
    And Response body parameter should be:    [included][0][attributes][address2]    ${servicePointAddresses[0].address2}
    And Response body parameter should be:    [included][0][attributes][address3]    ${servicePointAddresses[0].address3}
    And Response body parameter should be:    [included][0][attributes][city]    ${servicePointAddresses[0].city}
    And Response body parameter should be:    [included][0][attributes][zipCode]    ${servicePointAddresses[0].zipCode}
    And Response body has correct self link
    [Teardown]     Run Keyword   Delete service point in DB    ${servicePoints[0].uuid}

Retrieves_a_service_point_by_id
    [Setup]    Run Keywords    Create service point in DB    name=${servicePoints[0].name}    key=${servicePoints[0].key}    uuid=${servicePoints[0].uuid}
    ...    AND    Trigger publish trigger-events    service_point    ${console_path}
    When I send a GET request:    /service-points/${servicePoints[0].uuid}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][id]    ${servicePoints[0].uuid}
    And Response body parameter should be:    [data][type]    service-points
    And Response body parameter should be:    [data][attributes][name]    ${servicePoints[0].name}
    And Response body parameter should be:    [data][attributes][key]    ${servicePoints[0].key}
    And Response body has correct self link internal
    [Teardown]    Run Keyword    Delete service point in DB    ${servicePoints[0].uuid}

Retrieves_a_service_point_by_id_with_address_relation
    [Setup]    Run Keywords    Create service point in DB    name=${servicePoints[0].name}    key=${servicePoints[0].key}    uuid=${servicePoints[0].uuid}
    ...    AND    Create service point address in DB    ${servicePoints[0].uuid}    ${servicePointAddresses[0].uuid}    ${servicePointAddresses[0].address1}    ${servicePointAddresses[0].address2}    ${servicePointAddresses[0].address3}    ${servicePointAddresses[0].city}    ${servicePointAddresses[0].zipCode}    DE
    ...    AND    Trigger publish trigger-events    service_point    ${console_path}
    When I send a GET request:    /service-points/${servicePoints[0].uuid}?include=service-point-addresses
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][id]    ${servicePoints[0].uuid}
    And Response body parameter should be:    [data][type]    service-points
    And Response body parameter should be:    [data][attributes][name]    ${servicePoints[0].name}
    And Response body parameter should be:    [data][attributes][key]    ${servicePoints[0].key}
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should be:    [included][0][id]    ${servicePointAddresses[0].uuid}
    And Response body parameter should be:    [included][0][attributes][countryIso2Code]    DE
    And Response body parameter should be:    [included][0][attributes][address1]    ${servicePointAddresses[0].address1}
    And Response body parameter should be:    [included][0][attributes][address2]    ${servicePointAddresses[0].address2}
    And Response body parameter should be:    [included][0][attributes][address3]    ${servicePointAddresses[0].address3}
    And Response body parameter should be:    [included][0][attributes][city]    ${servicePointAddresses[0].city}
    And Response body parameter should be:    [included][0][attributes][zipCode]    ${servicePointAddresses[0].zipCode}
    And Response body has correct self link internal
    [Teardown]    Run Keyword    Delete service point in DB    ${servicePoints[0].uuid}

Retrieves_a_service_point_by_id_with_empty_address_relation
    [Setup]    Run Keywords    Create service point in DB    name=${servicePoints[0].name}    key=${servicePoints[0].key}    uuid=${servicePoints[0].uuid}
    ...    AND    Trigger publish trigger-events    service_point    ${console_path}
    When I send a GET request:    /service-points/${servicePoints[0].uuid}?include=service-point-addresses
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][id]    ${servicePoints[0].uuid}
    And Response body parameter should be:    [data][type]    service-points
    And Response body parameter should be:    [data][attributes][name]    ${servicePoints[0].name}
    And Response body parameter should be:    [data][attributes][key]    ${servicePoints[0].key}
    And Response body should not contain:    included
    And Response body has correct self link internal
    [Teardown]    Run Keyword    Delete service point in DB    ${servicePoints[0].uuid}
