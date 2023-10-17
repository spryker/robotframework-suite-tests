*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/service_point_steps.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

# Create_Service_Type_With_Maximum_Length_Key
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "dsfhkjndfjknjknfksdnfkjnsdjkfndskjfndsfjnsdkfnk2374qe69ady78huijkndsfhkjndfjknjknfksdnfkjnsdjkfndskjfndsfjnsdkfnk2374qe69ady78huijkndsfhkjndfjknjknfksdnfkjnsdjkfndskjfndsfjnsdkfnk2374qe69ady78huijkndsfhkjndfjknjknfksdnfkjnsdjkfndskjfndsfjnsdkfnk2374333asss"}}}
#     Then Response status code should be:    400
#     And Response should return error code:    5420
#     And Response should return error message:    A service type key must have length from 1 to 255 characters.

# Create_Service_Type_With_256_Length_Name
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "dsfhkjndfjknjknfksdnfkjnsdjkfndskjfndsfjnsdkfnk2374qe69ady78huijkndsfhkjndfjknjknfksdnfkjnsdjkfndskjfndsfjnsdkfnk2374qe69ady78huijkndsfhkjndfjknjknfksdnfkjnsdjkfndskjfndsfjnsdkfnk2374qe69ady78huijkndsfhkjndfjknjknfksdnfkjnsdjkfndskjfndsfjnsdkfnk2374333asss", "key": "service1-test${random}"}}}
#     Then Response status code should be:    400
#     And Response should return error code:    5422
#     And Response should return error message:    A service type name must have length from 1 to 255 characters.

# Create_Duplicate_Service_Type_Key
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service type1 ${random}", "key": "duplicate-key"}}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [data][id]    service_type_id
#     When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Another Service 2 ${random}", "key": "duplicate-key"}}}
#     Then Response status code should be:    400
#     And Response should return error code:    5419
#     And Response should return error message:    A service type with the same key already exists.
#     [Teardown]    Delete service type in DB    ${service_type_id}

Create_Service_Type_With_Duplicate_Name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Duplicate Service", "key": "service1-test${random}"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_type_id
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Duplicate Service", "key": "another-key"}}}
    Then Response status code should be:    400
    And Response should return error code:    5424
    And Response should return error message:    A service type with the same name already exists.
    [Teardown]    Delete service type in DB    ${service_type_id}

# Create_Service_Type_With_Empty_Key
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Invalid Key Length", "key": "K"*256}}
#     Then Response status code should be:    400
#     And Response should return error code:    5420
#     And Response should return error message:    A service type key must have length from 0 to 255 characters.

# Create_Service_Type_With_Invalid_Name_Length
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "N"*256, "key": "invalid-name-length"}}
#     Then Response status code should be:    400
#     And Response should return error code:    5422
#     And Response should return error message:    A service type name must have length from 0 to 255 characters.

# Update_Service_Type_Key
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "original-key"}}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [data][id]    service_type_id
#     When I send a PATCH request:    /service-types/${service_type_id}    {"data": {"type": "service-types", "attributes": {"key": "new-key"}}}
#     Then Response status code should be:    400
#     And Response should return error code:    5423
#     And Response should return error message:    A service type key cannot be changed.
#     [Teardown]    Delete service type in DB    ${service_type_id}

# Update_Service_Type_Invalid_Field
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "service1-test${random}"}}
#     Then Response status code should be:    201
#     And Save value to a variable:    [data][id]    service_type_id
#     When I send a PATCH request:    /service-types/${service_type_id}    {"data": {"type": "service-types", "attributes": {"nonexistent_field": "Invalid Field"}}
#     Then Response status code should be:    400
#     And Response should return error code:    5401
#     And Response should return error message:    Wrong request body.
#     [Teardown]    Delete service type in DB    ${service_type_id}

# Update_Nonexistent_Service_Type
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a PATCH request:    /service-types/nonexistent_id    {"data": {"type": "service-types", "attributes": {"name": "Updated Service Name", "key": "service1-test${random}"}}
#     Then Response status code should be:    404
#     And Response should return error code:    5418
#     And Response should return error message:    The service type entity was not found.
#     [Teardown]    # No need to delete since the service type doesn't exist

#  Get_Service_Types_Negative_No_Auth
#     [Setup]
#     When I send a GET request without Authorization header:    /service-types
#     Then Response status code should be:    403
#     And Response should return error code:    5402
#     And Response should return error message:    Authorization failed.

# Get_Service_Types_Negative_Invalid_Auth
#     [Setup]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer InvalidToken
#     When I send a GET request:    /service-types
#     Then Response status code should be:    403
#     And Response should return error code:    5402
#     And Response should return error message:    Authorization failed.

# Get_Service_Type_By_ID_Negative_No_Auth
#     [Setup]
#     When I send a GET request without Authorization header:    /service-types/12345
#     Then Response status code should be:    403
#     And Response should return error code:    5402
#     And Response should return error message:    Authorization failed.

# Get_Nonexistent_Service_Type
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a GET request:    /service-types/nonexistent_id
#     Then Response status code should be:    404
#     And Response should return error code:    5418
#     And Response should return error message:    The service type entity was not found.

     