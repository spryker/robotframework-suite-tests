*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/steps/service_point_steps.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Retrieves_list_of_service_points_by_incorrect_url
    When I send a GET request:    /service-point
    Then Response status code should be:    404
    And Response should return error message:    Not Found

Retrieves_a_service_point_by_incorrect_url
    [Setup]    Run Keywords    Create service point in DB    ${servicePoints[0].uuid}
    ...    AND    Trigger publish trigger-events    service_point    ${console_path}
    When I send a GET request:    /service-point/${servicePoints[0].uuid}
    Then Response status code should be:    404
    And Response should return error message:    Not Found
    [Teardown]    Run Keyword    Delete service point in DB    ${servicePoints[0].uuid}

Retrieves_a_service_point_by_not_existing_id
    When I send a GET request:    /service-points/NonExistId
    Then Response status code should be:    404
    And Response should return error code:    5401
    And Response should return error message:    Service point entity was not found.
