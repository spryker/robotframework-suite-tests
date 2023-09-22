*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

*** Test Cases ***

Create_new_service_point_with_existing_name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Not Unique Name","key": "unique-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    new_service_point_id
    # Create a new service point with an existing name
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Not Unique Name","key": "another-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    service-points
    And Save value to a variable:    [data][id]    service_point_id
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][name]    Not Unique Name
    And Response body parameter should be:    [data][attributes][key]    another-service-point-${random}
    [Teardown]     Run Keywords    Delete service point in DB:    unique-service-point-${random}
    ...    AND    Delete service point in DB:    another-service-point-${random}

Create_Service_Point_With_Existing_Key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /service-points    {"name": "Existing Service Point", "key": "existing_service_point", "isActive": true, "stores": ["DE", "AT"]}
    When I send a POST request:    /service-points   {"name": "New Service Point", "key": "existing_service_point", "isActive": true, "stores": ["DE", "AT"]}
    Then Response status code should be:    400
    And Response should return error code:    5404
    And Response should return error message:    A service point with the same key already exists.
    [Teardown]     Delete service point in DB:    existing_service_point

Create_Service_Point_With_Invalid_Key_Length
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points   {"name": "New Service Point", "key": "", "isActive": true, "stores": ["DE", "AT"]}
    Then Response status code should be:    400
    And Response should return error code:    5405
    And Response should return error message:    A service point key must have length from 0 to 255 characters.

Create_Service_Point_Without_Authorization
    [Setup]    I set Headers:    Authorization=
    When I send a POST request:    /service-points   {"name": "New Service Point", "key": "new_service_point", "isActive": true, "stores": ["DE", "AT"]}
    Then Response status code should be:    403
    And Response reason should be:    Not Authorized
    And Response should return error code:    5402
    And Response should return error message:    Authorization failed.
    
Create_Service_Point_With_Invalid_Name_Length
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points   {"name": "", "key": "invalid_name_length", "isActive": true, "stores": ["DE", "AT"]}
    Then Response status code should be:    400
    And Response should return error code:    5407
    And Response should return error message:    A service point name must have length from 0 to 255 characters.

Create_Service_Point_With_Invalid_Store
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points   {"name": "Invalid Store Service Point", "key": "invalid_store", "isActive": true, "stores": ["Invalid_Store"]}
    Then Response status code should be:    400
    And Response should return error code:    5401
    And Response should return error message:    Wrong request body.

Create_Service_Point_With_Empty_Body
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points   {}
    Then Response status code should be:    400
    And Response should return error code:    5401
    And Response should return error message:    Wrong request body.

Create_Service_Point_With_Invalid_Content_Type
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=text/plain   Authorization=Bearer ${token}
    When I send a POST request:    /service-points   {"name": "Invalid Content Type", "key": "invalid_content_type", "isActive": true, "stores": ["DE", "AT"]}
    Then Response status code should be:    400
    And Response should return error code:    5401
    And Response should return error message:    Wrong request body.

Create_Service_Point_With_Invalid_Token
    [Setup]    I set Headers:    Authorization=InvalidToken
    When I send a POST request:    /service-points   {"name": "Invalid Token", "key": "invalid_token", "isActive": true, "stores": ["DE", "AT"]}
    Then Response status code should be:    403
    And Response reason should be:    Not Authorized
    And Response should return error code:    5402
    And Response should return error message:    Authorization failed.

Create_Service_Point_With_Missing_Required_Fields
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points   {"isActive": true, "stores": ["DE", "AT"]}
    Then Response status code should be:    400
    And Response should return error code:    5401
    And Response should return error message:    Wrong request body.
