*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/service_point_steps.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

Create_Service_Negative_No_Auth
    [Setup]
    When I send a POST request without Authorization header:    /services    {"data": {"type": "services", "attributes": {"serviceTypeUuid": "${service_type_id}", "servicePointUuid": "${service_point_id}", "isActive": true, "key": "service-point-1-collect"}}
    Then Response status code should be:    403
    And Response should return error code:    5402
    And Response should return error message:    Authorization failed.

Create_Service_Negative_Invalid_Auth
    [Setup]
    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer InvalidToken
    When I send a POST request:    /services    {"data": {"type": "services", "attributes": {"serviceTypeUuid": "${service_type_id}", "servicePointUuid": "${service_point_id}", "isActive": true, "key": "service-point-1-collect"}}
    Then Response status code should be:    403
    And Response should return error code:    5402
    And Response should return error message:    Authorization failed.

Get_Service_By_ID_Negative_No_Auth
    [Setup]
    When I send a GET request without Authorization header:    /services/${service_id}
    Then Response status code should be:    403
    And Response should return error code:    5402
    And Response should return error message:    Authorization failed.

Get_Nonexistent_Service
    [Setup]
    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a GET request:    /services/nonexistent_id
    Then Response status code should be:    404
    And Response should return error code:    5418
    And Response should return error message:    The service entity was not found.

# # Create_Duplicate_Service_Point_Service_Relation
# #     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
# #     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
# #     When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "service1-test${random}"}}
# #     Then Response status code should be:    201
# #     And Save value to a variable:    [data][id]    service_type_id
# #     When I send a POST request:    /service-points/${demo_service_point.spryker_main_store.uuid}/service-point-service-types    {"data": {"type": "service-point-service-types", "attributes": {"serviceTypeId": "${service_type_id}"}}
# #     Then Response status code should be:    201
# #     And Save value to a variable:    [data][id]    service_point_service_id
# #     When I send a POST request:    /service-points/${demo_service_point.spryker_main_store.uuid}/service-point-service-types    {"data": {"type": "service-point-service-types", "attributes": {"serviceTypeId": "${service_type_id}"}}
# #     Then Response status code should be:    400
# #     And Response should return error code:    5429
# #     And Response should return error message:    A relation between service point service and service type already exists.
# #     [Teardown]    Run Keywords    Delete service type by ID:    ${service_type_id}
# #     ...    AND    Delete service point service type by ID:    ${service_point_service_id}