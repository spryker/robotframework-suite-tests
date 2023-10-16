*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/service_point_steps.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

Create_Service_Type_With_Maximum_Length_Key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "K"*255}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_type_id
    And Response body parameter should be:    [data][attributes][name]    Test Service ${random}
    And Response body parameter should be:    [data][attributes][key]    K"*255
    [Teardown]    Run Keywords    Delete service type by ID:    ${service_type_id}

Create_Service_Type_With_Maximum_Length_Name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "N"*255, "key": "service1-test${random}"}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_type_id
    And Response body parameter should be:    [data][attributes][name]    N"*255
    And Response body parameter should be:    [data][attributes][key]    service1-test${random}
    [Teardown]    Run Keywords    Delete service type by ID:    ${service_type_id}

Create_Duplicate_Service_Type_Key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "duplicate-key"}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_type_id
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Another Service ${random}", "key": "duplicate-key"}}
    Then Response status code should be:    400
    And Response should return error code:    5419
    And Response should return error message:    A service type with the same key already exists.
    [Teardown]    Run Keywords    Delete service type by ID:    ${service_type_id}

Create_Service_Type_With_Duplicate_Name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Duplicate Service", "key": "service1-test${random}"}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_type_id
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Duplicate Service", "key": "another-key"}}
    Then Response status code should be:    400
    And Response should return error code:    5424
    And Response should return error message:    A service type with the same name already exists.
    [Teardown]    Run Keywords    Delete service type by ID:    ${service_type_id}

Create_Service_Type_With_Invalid_Key_Length
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Invalid Key Length", "key": "K"*256}}
    Then Response status code should be:    400
    And Response should return error code:    5420
    And Response should return error message:    A service type key must have length from 0 to 255 characters.

Create_Service_Type_With_Invalid_Name_Length
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "N"*256, "key": "invalid-name-length"}}
    Then Response status code should be:    400
    And Response should return error code:    5422
    And Response should return error message:    A service type name must have length from 0 to 255 characters.

 Update_Service_Type_Name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "service1-test${random}"}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_type_id
    When I send a PATCH request:    /service-types/${service_type_id}    {"data": {"type": "service-types", "attributes": {"name": "Updated Service Name", "key": "service1-test${random}"}}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][attributes][name]    Updated Service Name
    [Teardown]    Run Keywords    Delete service type by ID:    ${service_type_id}

Update_Service_Type_Key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "service1-test${random}"}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_type_id
    When I send a PATCH request:    /service-types/${service_type_id}    {"data": {"type": "service-types", "attributes": {"name": "Test Service Name", "key": "updated-key"}}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][attributes][key]    updated-key
    [Teardown]    Run Keywords    Delete service type by ID:    ${service_type_id}

Update_Service_Type_Invalid_Field
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "service1-test${random}"}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_type_id
    When I send a PATCH request:    /service-types/${service_type_id}    {"data": {"type": "service-types", "attributes": {"nonexistent_field": "Invalid Field"}}
    Then Response status code should be:    400
    And Response should return error code:    5401
    And Response should return error message:    Wrong request body.
    [Teardown]    Run Keywords    Delete service type by ID:    ${service_type_id}

Update_Nonexistent_Service_Type
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a PATCH request:    /service-types/nonexistent_id    {"data": {"type": "service-types", "attributes": {"name": "Updated Service Name", "key": "service1-test${random}"}}
    Then Response status code should be:    404
    And Response should return error code:    5418
    And Response should return error message:    The service type entity was not found.
    [Teardown]    # No need to delete since the service type doesn't exist

 Get_Service_Types_Negative_No_Auth
    [Setup]
    When I send a GET request without Authorization header:    /service-types
    Then Response status code should be:    403
    And Response should return error code:    5402
    And Response should return error message:    Authorization failed.

Get_Service_Types_Negative_Invalid_Auth
    [Setup]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer InvalidToken
    When I send a GET request:    /service-types
    Then Response status code should be:    403
    And Response should return error code:    5402
    And Response should return error message:    Authorization failed.

Get_Service_Type_By_ID_Negative_No_Auth
    [Setup]
    When I send a GET request without Authorization header:    /service-types/12345
    Then Response status code should be:    403
    And Response should return error code:    5402
    And Response should return error message:    Authorization failed.

Get_Nonexistent_Service_Type
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a GET request:    /service-types/nonexistent_id
    Then Response status code should be:    404
    And Response should return error code:    5418
    And Response should return error message:    The service type entity was not found.

     