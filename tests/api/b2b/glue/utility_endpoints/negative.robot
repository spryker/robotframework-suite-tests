*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
#GET requests
Get_health_check_with_disabled_services
### Test works only if all services are disabled as default
    When I send a GET request:    /health-check
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response body parameter should be:    [data][0][type]    health-check
    And Response body parameter should be:    [data][0][id]    None
    And Response body parameter should be:    [data][0][attributes][status]    None
    And Response body parameter should be:    [data][0][attributes][statusCode]    403
    And Response body parameter should be:    [data][0][attributes][message]    HealthCheck endpoints are disabled for all applications.
    And Response should contain the array of a certain size:    [data][0][attributes][healthCheckServiceResponses]    0
    And Response body has correct self link

Get_health_check_with_invalid_service_name
    When I send a GET request:    /health-check?services=sear
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body parameter should be:    [data][0][type]    health-check
    And Response body parameter should be:    [data][0][id]    None
    And Response body parameter should be:    [data][0][attributes][status]    None
    And Response body parameter should be:    [data][0][attributes][statusCode]    400
    And Response body parameter should be:    [data][0][attributes][message]    Requested services not found.
    And Response should contain the array of a certain size:    [data][0][attributes][healthCheckServiceResponses]    0
    And Response body has correct self link

Get_health_check_with_empty_service_name
    When I send a GET request:    /health-check?services=
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body parameter should be:    [data][0][type]    health-check
    And Response body parameter should be:    [data][0][id]    None
    And Response body parameter should be:    [data][0][attributes][status]    None
    And Response body parameter should be:    [data][0][attributes][statusCode]    400
    And Response body parameter should be:    [data][0][attributes][message]    Requested services not found.
    And Response should contain the array of a certain size:    [data][0][attributes][healthCheckServiceResponses]    0
    And Response body has correct self link