*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
#GET requests

### Precondition: To run tests need to enable service endpoints and uncomment tests
### To enable the endpoints, add the following to /config/Shared/config_default.php:
### Spryker\Shared\HealthCheck\HealthCheckConstants;$config[HealthCheckConstants::HEALTH_CHECK_ENABLED] = true;
### Doc: https://docs.spryker.com/docs/scos/dev/technical-enhancement-integration-guides/integrating-health-checks.html#general-information

#Get_health_check_with_all_enabled_services
    #When I send a GET request:    /health-check
    #Then Response status code should be:    200
    #And Response reason should be:    OK
    #And Response body parameter should be:    [data][0][type]    health-check
    #And Response body parameter should be:    [data][0][id]    None
    #And Response body parameter should be:    [data][0][attributes][status]    healthy
    #And Response body parameter should be:    [data][0][attributes][statusCode]    200
    #And Response body parameter should be:    [data][0][attributes][message]    None
    #And Response body parameter should be:    [data][0][attributes][healthCheckServiceResponses][0][name]    search
    #And Response body parameter should be:    [data][0][attributes][healthCheckServiceResponses][1][name]    storage
    #And Response body parameter should be:    [data][0][attributes][healthCheckServiceResponses][2][name]    zed-request
    #And Each array element of array in response should contain property with value:    [data][0][attributes][healthCheckServiceResponses]    status    True
    #And Each array element of array in response should contain property with value:    [data][0][attributes][healthCheckServiceResponses]    message    None
    #And Response body has correct self link

#Get_health_check_with_enabled_search_service
    #When I send a GET request:    /health-check?services=search
    #Then Response status code should be:    200
    #And Response reason should be:    OK
    #And Response body parameter should be:    [data][0][type]    health-check
    #And Response body parameter should be:    [data][0][id]    None
    #And Response body parameter should be:    [data][0][attributes][status]    healthy
    #And Response body parameter should be:    [data][0][attributes][statusCode]    200
    #And Response body parameter should be:    [data][0][attributes][message]    None
    #And Response body parameter should be:    [data][0][attributes][healthCheckServiceResponses][0][name]    search
    #And Response body parameter should be:    [data][0][attributes][healthCheckServiceResponses][0][status]    True
    #And Response body parameter should be:    [data][0][attributes][healthCheckServiceResponses][0][message]    None
    #And Response body has correct self link

#Get_health_check_with_enabled_storage_service
    #When I send a GET request:    /health-check?services=storage
    #Then Response status code should be:    200
    #And Response reason should be:    OK
    #And Response body parameter should be:    [data][0][type]    health-check
    #And Response body parameter should be:    [data][0][id]    None
    #And Response body parameter should be:    [data][0][attributes][status]    healthy
    #And Response body parameter should be:    [data][0][attributes][statusCode]    200
    #And Response body parameter should be:    [data][0][attributes][message]    None
    #And Response body parameter should be:    [data][0][attributes][healthCheckServiceResponses][0][name]    storage
    #And Response body parameter should be:    [data][0][attributes][healthCheckServiceResponses][0][status]    True
    #And Response body parameter should be:    [data][0][attributes][healthCheckServiceResponses][0][message]    None
    #And Response body has correct self link

#Get_health_check_with_enabled_zed_request_service
    #When I send a GET request:    /health-check?services=zed-request
    #Then Response status code should be:    200
    #And Response reason should be:    OK
    #And Response body parameter should be:    [data][0][type]    health-check
    #And Response body parameter should be:    [data][0][id]    None
    #And Response body parameter should be:    [data][0][attributes][status]    healthy
    #And Response body parameter should be:    [data][0][attributes][statusCode]    200
    #And Response body parameter should be:    [data][0][attributes][message]    None
    #And Response body parameter should be:    [data][0][attributes][healthCheckServiceResponses][0][name]    zed-request
    #And Response body parameter should be:    [data][0][attributes][healthCheckServiceResponses][0][status]    True
    #And Response body parameter should be:    [data][0][attributes][healthCheckServiceResponses][0][message]    None
    #And Response body has correct self link

#Get_health_check_with_non_existing_id
### The bug https://spryker.atlassian.net/browse/CC-16492 related to the self link and required ID
    #When I send a GET request:    /health-check/1
    #Then Response status code should be:    200
    #And Response reason should be:    OK
    #And Response body parameter should be:    [data][type]    health-check
    #And Response body parameter should be:    [data][id]    None
    #And Response body parameter should be:    [data][attributes][status]    healthy
    #And Response body parameter should be:    [data][attributes][statusCode]    200
    #And Response body parameter should be:    [data][attributes][message]    None
    #And Response body parameter should be:    [data][attributes][healthCheckServiceResponses][0][name]    search
    #And Response body parameter should be:    [data][attributes][healthCheckServiceResponses][1][name]    storage
    #And Response body parameter should be:    [data][attributes][healthCheckServiceResponses][2][name]    zed-request
    #And Each array element of array in response should contain property with value:    [data][attributes][healthCheckServiceResponses]    status    True
    #And Each array element of array in response should contain property with value:    [data][attributes][healthCheckServiceResponses]    message    None
    ### Response body has correct self link internal