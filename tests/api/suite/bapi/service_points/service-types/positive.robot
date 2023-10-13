*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/service_point_steps.robot
Default Tags    bapi


*** Test Cases ***
ENABLER
    TestSetup


Create_Service_Type
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "service1-test${random}"}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_type_id
    And Response body parameter should be:    [data][attributes][name]    Test Service ${random}
    And Response body parameter should be:    [data][attributes][key]    service1-test${random}
    [Teardown]    Run Keywords    Delete service type by ID:    ${service_type_id}

Update_Service_Type_Key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "original-key"}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_type_id
    When I send a PATCH request:    /service-types/${service_type_id}    {"data": {"type": "service-types", "attributes": {"key": "new-key"}}
    Then Response status code should be:    400
    And Response should return error code:    5423
    And Response should return error message:    A service type key cannot be changed.
    [Teardown]    Run Keywords    Delete service type by ID:    ${service_type_id}

Get_Service_Type
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Collect Service", "key": "collect"}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_type_id
    When I send a GET request:    /service-types/${service_type_id}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][attributes][name]    Collect Service
    And Response body parameter should be:    [data][attributes][key]    collect
    [Teardown]    Run Keywords    Delete service type by ID:    ${service_type_id}

Get_Service_Types_List
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a GET request:    /service-types
    Then Response status code should be:    200
    And Response body should have at least one item
    And Response body parameter should be:    data[0][attributes][name]    1 Service
    And Response body parameter should be:    data[0][attributes][key]    collect



# Create_Service_Point_Service_Relation
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "service1-test${random}"}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [data][id]    service_type_id
#     When I send a POST request:    /service-points/${demo_service_point.spryker_main_store.uuid}/service-point-service-types    {"data": {"type": "service-point-service-types", "attributes": {"serviceTypeId": "${service_type_id}"}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [data][id]    service_point_service_id
#     [Teardown]    Run Keywords    Delete service type by ID:    ${service_type_id}
#     ...    AND    Delete service point service type by ID:    ${service_point_service_id}

# Create_Duplicate_Service_Point_Service_Relation
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "service1-test${random}"}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [data][id]    service_type_id
#     When I send a POST request:    /service-points/${demo_service_point.spryker_main_store.uuid}/service-point-service-types    {"data": {"type": "service-point-service-types", "attributes": {"serviceTypeId": "${service_type_id}"}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [data][id]    service_point_service_id
#     When I send a POST request:    /service-points/${demo_service_point.spryker_main_store.uuid}/service-point-service-types    {"data": {"type": "service-point-service-types", "attributes": {"serviceTypeId": "${service_type_id}"}}
#     Then Response status code should be:    400
#     And Response should return error code:    5429
#     And Response should return error message:    A relation between service point service and service type already exists.
#     [Teardown]    Run Keywords    Delete service type by ID:    ${service_type_id}
#     ...    AND    Delete service point service type by ID:    ${service_point_service_id}