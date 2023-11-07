*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/steps/service_point_steps.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
    Deactivate service points

Retrieves_a_service_point_address_by_id
    [Setup]    Run Keywords    Create service point in DB    ${servicePoints[0].uuid}
    ...    AND    Create service point address in DB    ${servicePoints[0].uuid}    ${servicePointAddresses[0].uuid}    ${servicePointAddresses[0].address1}    ${servicePointAddresses[0].address2}    ${servicePointAddresses[0].address3}    ${servicePointAddresses[0].city}    ${servicePointAddresses[0].zipCode}    DE
    ...    AND    Trigger publish trigger-events    service_point
    When I send a GET request:    /service-points/${servicePoints[0].uuid}/service-point-addresses/${servicePointAddresses[0].uuid}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][id]    ${servicePointAddresses[0].uuid}
    And Response body parameter should be:    [data][type]    service-point-addresses
    And Response body parameter should be:    [data][attributes][countryIso2Code]    DE
    And Response body parameter should be:    [data][attributes][address1]    ${servicePointAddresses[0].address1}
    And Response body parameter should be:    [data][attributes][address2]    ${servicePointAddresses[0].address2}
    And Response body parameter should be:    [data][attributes][address3]    ${servicePointAddresses[0].address3}
    And Response body parameter should be:    [data][attributes][city]    ${servicePointAddresses[0].city}
    And Response body parameter should be:    [data][attributes][zipCode]    ${servicePointAddresses[0].zipCode}
    And Response body has correct self link internal
    [Teardown]    Run Keyword    Delete service point in DB    ${servicePoints[0].uuid}