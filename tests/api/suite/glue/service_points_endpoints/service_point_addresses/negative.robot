*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/steps/service_point_steps.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    API_test_setup

Retrieves_list_of_service_point_addresses
    When I send a GET request:    /service-points/${servicePoints[0].uuid}/service-point-addresses
    Then Response status code should be:    404
    And Response should return error message:    The endpoint is not found.

Retrieves_a_service_point_address_by_not_existing_service_point_and_service_point_address_ids
    When I send a GET request:    /service-points/NonExistId/service-point-addresses/NonExistId
    Then Response status code should be:    404
    And Response should return error code:    5402
    And Response should return error message:    Service point address entity was not found.

Retrieves_a_service_point_address_by_existing_service_point_and_not_existing_service_point_address_ids
    [Setup]    Run Keywords    Create service point in DB    ${servicePoints[0].uuid}
    ...    AND    Trigger publish trigger-events    service_point
    When I send a GET request:    /service-points/${servicePoints[0].uuid}/service-point-addresses/NonExistId
    Then Response status code should be:    404
    And Response should return error code:    5402
    And Response should return error message:    Service point address entity was not found.
    [Teardown]    Run Keyword    Delete service point in DB    ${servicePoints[0].uuid}

Retrieves_a_service_point_address_by_not_existing_service_point_and_existing_service_point_address_ids
    [Setup]    Run Keywords    Create service point in DB    ${servicePoints[0].uuid}
    ...    AND    Create service point address in DB    ${servicePoints[0].uuid}    ${servicePointAddresses[0].uuid}
    ...    AND    Trigger publish trigger-events    service_point
    When I send a GET request:    /service-points/NonExistId/service-point-addresses/${servicePointAddresses[0].uuid}
    Then Response status code should be:    404
    And Response should return error code:    5402
    And Response should return error message:    Service point address entity was not found.
    [Teardown]    Run Keyword    Delete service point in DB    ${servicePoints[0].uuid}

Retrieves_a_service_point_address_by_incorrect_url
    [Setup]    Run Keywords    Create service point in DB    ${servicePoints[0].uuid}
    ...    AND    Create service point address in DB    ${servicePoints[0].uuid}    ${servicePointAddresses[0].uuid}
    ...    AND    Trigger publish trigger-events    service_point
    When I send a GET request:    /service-point/${servicePoints[0].uuid}/service-point-addresses/${servicePointAddresses[0].uuid}
    Then Response status code should be:    404
    And Response should return error message:    Not Found
    [Teardown]    Run Keyword    Delete service point in DB    ${servicePoints[0].uuid}
