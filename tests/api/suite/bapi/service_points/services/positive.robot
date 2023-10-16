*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/service_point_steps.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup
Create_Service
    [Setup]
    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /services    {"data": {"type": "services", "attributes": {"serviceTypeUuid": "${service_type_id}", "servicePointUuid": "${service_point_id}", "isActive": true, "key": "service-point-1-collect"}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    Then Save value to a variable:    [data][id]    service_id
    And Response body parameter should be:    [data][type]    services
    And Response body parameter should be:    [data][attributes][isActive]    true
    And Response body parameter should be:    [data][attributes][key]    service-point-1-collect

### PATCH Request for Updating Services:


Update_Service
    [Setup]
    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a PATCH request:    /services/${service_id}    {"data": {"type": "services", "attributes": {"isActive": false}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][attributes][isActive]    false

### GET Request for Retrieving a Service by ID:


Get_Service_By_ID
    [Setup]
    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a GET request:    /services/${service_id}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][type]    services
    And Response body parameter should be:    [data][attributes][isActive]    false

### GET Request for Retrieving a List of Services:


Get_Services_List
    [Setup]
    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a GET request:    /services
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][type]    services
    And Response should have at least one item in [data]
    And Response body parameter should be:    [data][0][attributes][isActive]    false


