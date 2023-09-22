*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/service_point_steps.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup
*** Test Cases ***

Create_new_service_point
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    Then Save value to a variable:    [data][attributes][key]    service_point_key
    And Response body parameter should be:    [data][type]    service-points
    And Save value to a variable:    [data][id]    service_point_id
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][name]    Some Service Point ${random}
    And Response body parameter should be:    [data][attributes][key]    some-service-point-${random}
    And Response body parameter should be:    [data][attributes][isActive]    True
    And Response body parameter should be in:    [data][attributes][stores]    DE    AT
    And Response body parameter should be in:    [data][attributes][stores]    AT    DE
    And Response body has correct self link for created entity:    ${service_point_id}
    Get service point uuid by key:    ${service_point_key}
    # [Teardown]   Delete service point in DB    ${servicePointUuid}
