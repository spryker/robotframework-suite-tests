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
# Create_Service_Point_With_Existing_Key
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Service Point Name1","key": "service-point${random}","isActive": "true","stores": ["DE", "AT"]}}}
#     Then Response status code should be:    201
#     Then Save value to a variable:    [data][attributes][key]    service_point_key
#     When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Service Point Name2","key": "service-point${random}","isActive": "true","stores": ["DE", "AT"]}}}
#     Then Response status code should be:    400
#     And Response should return error code:    5404
#     And Response should return error message:    A service point with the same key already exists.
#     # [Teardown]     Run Keywords    Get service point uuid by key:    ${service_point_key}
#     # ...    AND    Delete service point in DB    ${servicePointUuid}

# Create_Service_Point_With_Invalid_Key_Length
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Incorrect key lenghth","key": "fihslafnkjskdjfnskadfkafkjsadfkjsdjnnkfjsdkfjdskdjfhnjdksbfjhdsbfjkdsfbjsdfjksdfjksdfhdjksfhkdsf jkdsfhjdhsfjhdsjfhdsfjhsjkfhkshkjdsahf78348937489137489yewhkjdsfildksh9832urqewdiosjakrj3982diasjif8d3j89siojfdisakjfdiksdjfkasdjfhkjdashfjkldsahfldchgjhjjghjg2","isActive": "true","stores": ["DE", "AT"]}}}
#     Then Response status code should be:    400
#     And Response should return error code:    5405
#     And Response should return error message:    A service point key must have length from 1 to 255 characters.

# Create_Service_Point_With_Empty_Key
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "New Service Point", "key": "", "isActive": "true", "stores": ["DE", "AT"]}}}
#     Then Response status code should be:    400
#     And Response should return error code:    5405
#     And Response should return error message:    A service point key must have length from 1 to 255 characters.

# Create_Service_Point_Without_Authorization
#     [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
#     [Tags]    skip-due-to-issue
#     [Setup]    I set Headers:    Authorization=
#     When I send a POST request:    /service-points   {"name": "New Service Point", "key": "new_service_point", "isActive": "true", "stores": ["DE", "AT"]}
#     Then Response status code should be:    403
#     And Response should return error message:    Invalid access token
    #!!!!!! 
# Create_Service_Point_With_Invalid_Name_Length
    # [Documentation]    500
    # [Tags]    skip-due-to-issue
    # [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    # ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    # When I send a POST request:    /service-points   {"name": "", "key": "invalid_name_length", "isActive": "true", "stores": ["DE", "AT"]}
    # Then Response status code should be:    400
    # And Response should return error code:    5407
    # And Response should return error message:    A service point name must have length from 0 to 255 characters.
#    #!!!!!! 
# Create_Service_Point_With_Invalid_Store
#     [Documentation]     500
#     [Tags]    skip-due-to-issue
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-points   {"name": "Invalid Store Service Point", "key": "invalid_store", "isActive": "true", "stores": ["Invalid_Store"]}
#     Then Response status code should be:    400
#     And Response should return error code:    5401
#     And Response should return error message:    Wrong request body.
# !!!!!!
# Create_Service_Point_With_Empty_Body
#     [Documentation]    500 как везде, нужен баг тикет
#     [Tags]    skip-due-to-issue
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a POST request:    /service-points   {}
#     Then Response status code should be:    400
#     And Response should return error code:    5401
#     And Response should return error message:    Wrong request body.
# !!!!!!
# Create_Service_Point_With_Invalid_Content_Type
#     [Documentation]    in response: [{"message":"Not found","status":404,"code":"007"}] 
#     [Tags]    skip-due-to-issue
    # [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    # ...    AND    I set Headers:    Content-Type=text/plain   Authorization=Bearer ${token}
    # When I send a POST request:    /service-points   {"name": "Invalid Content Type", "key": "invalid_content_type", "isActive": "true", "stores": ["DE", "AT"]}
    # Then Response status code should be:    400
    # And Response should return error code:    5401
    # And Response should return error message:    Wrong request body.
# !!!!!!
# Create_Service_Point_With_Invalid_Token
#     [Documentation]    in response: [{"message":"Invalid access token.","status":400,"code":"001"}] 
#     [Tags]    skip-due-to-issue
#     [Setup]    I set Headers:    Authorization=InvalidToken
#     When I send a POST request:    /service-points   {"name": "Invalid Token", "key": "invalid_token", "isActive": "true", "stores": ["DE", "AT"]}
#     Then Response status code should be:    401
#     And Response should return error code:    001
#     And Response should return error message:    Invalid access token.
# !!!!!!
# Create_Service_Point_With_Missing_Required_Fields
#     [Documentation]    500
#     [Tags]    skip-due-to-issue
    # [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    # ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    # When I send a POST request:    /service-points   {"isActive": "true", "stores": ["DE", "AT"]}
    # Then Response status code should be:    400
    # And Response should return error code:    5401
    # And Response should return error message:    Wrong request body.
# !!!!!!
# Update_Service_Point_With_Wrong_type
    # [Documentation]    response 200 but request PATCH should fail
    # [Tags]    skip-due-to-issue
    # [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    # ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    # ...    AND    I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Initial Service Point ${random}","key": "initial-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    # ...    AND    Save value to a variable:    [data][attributes][key]    service_point_key
    # ...    AND    Save value to a variable:    [data][id]    service_point_id
    # When I send a PATCH request:    /service-points/${service_point_id}    {"data": {"type": "invalid-type","attributes": {"key": "initial-service-point-${random}","stores": ["DE"],"isActive": "false","name": "Updated Service Point"}}}
    # Then Response status code should be:    400
    # And Response should return error code:    5401
    # And Response should return error message:    Wrong request body
    # [Teardown]     Run Keywords    Get service point uuid by key:    ${service_point_key}
    # ...    AND    Delete service point in DB    ${service_point_id}
# !!!!!!!
# Update_Service_Point_Without_Authorization
#     [Documentation]    receive 400 error in responce but should 401
#     [Tags]    skip-due-to-issue
    # [Setup]    I set Headers:    Authorization=
    # When I send a PATCH request:    /service-points/random-id    {"data": {"type": "service-points","attributes": {"name": "Unauthorized Update","key": "unauthorized-update-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    # Then Response status code should be:    401
    # And Response should return error code:    001
    # And Response should return error message:    Invalid access token.

# Update_Service_Point_With_Nonexistent_ID
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     When I send a PATCH request:    /service-points/nonexistent-id    {"data": {"type": "service-points","attributes": {"name": "Nonexistent ID","key": "nonexistent-id-${random}","isActive": "true","stores": ["DE", "AT"]}}}
#     Then Response status code should be:    404
#     And Response should return error code:    5403
#     And Response should return error message:    Service point entity was not found.
#  !!!!!!!
# Update_Service_Point_With_incorrect_token
#     [Documentation]    receive 400 error in responce but should 401
#     [Tags]    skip-due-to-issue
#     [Setup]    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer incorrect
#     When I send a PATCH request:    /service-points/random-id    {"data": {"type": "service-points","attributes": {"name": "Unauthorized Update","key": "unauthorized-update-${random}","isActive": "true","stores": ["DE", "AT"]}}}
#     Then Response status code should be:    401
#     And Response should return error code:    001
#     And Response should return error message:    Invalid access token.

# Update_Service_Point_With_Empty_Name
#     [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
#     ...    AND    I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Initial Service Point ${random}","key": "initial-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
#     ...    AND    Save value to a variable:    [data][attributes][key]    service_point_key
#     ...    AND    Save value to a variable:    [data][id]    service_point_id
#     When I send a PATCH request:    /service-points/${service_point_id}    {"data": {"type": "service-points","attributes": {"key": "Initial Service Point ${random}","stores": ["DE"],"isActive": "true","name": ""}}}
#     Then Response status code should be:    400
#     And Response should return error code:    5407
#     And Response should return error message:    A service point name must have length from 1 to 255 characters.
    # [Teardown]     Run Keywords    Get service point uuid by key:    ${service_point_key}
    # ...    AND    Delete service point in DB    ${service_point_id}

Update_Service_Point_With_not_existing_key
# !!!!
#     [Documentation]    get 200 is that expectable?
#     [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Initial Service Point ${random}","key": "initial-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    ...    AND    Save value to a variable:    [data][attributes][key]    service_point_key
    ...    AND    Save value to a variable:    [data][id]    service_point_id
    When I send a PATCH request:    /service-points/${service_point_id}    {"data": {"type": "service-points","attributes": {"key": "not-existing-key","stores": ["DE"],"isActive": "true","name": "test"}}}
    Then Response status code should be:    400
    # [Teardown]     Run Keywords    Get service point uuid by key:    ${service_point_key}
    # ...    AND    Delete service point in DB    ${service_point_id}
*** Test Cases ***

Get_Service_Points_Without_Authentication
    [Setup]    I set Headers:    Authorization=
    When I send a GET request:    /service-points
    Then Response status code should be:    403
    And Response should return error code:    5402
    And Response should return error message:    Authorization failed.

Get_Service_Points_With_Incorrect_Token
    [Setup]    I set Headers:    Authorization=IncorrectToken
    When I send a GET request:    /service-points
    Then Response status code should be:    403
    And Response should return error code:    5402
    And Response should return error message:    Authorization failed.

Get_Service_Point_By_Nonexistent_ID
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a GET request:    /service-points/NonexistentID
    Then Response status code should be:    400
    And Response should return error code:    5403
    And Response should return error message:    The service point entity was not found.

Get_Service_Point_By_Invalid_ID
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a GET request:    /service-points/InvalidID
    Then Response status code should be:    400
    And Response should return error code:    5401
    And Response should return error message:    Wrong request body.

Get_Service_Points_With_Bad_Header
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/badtype   Authorization=Bearer ${token}
    When I send a GET request:    /service-points
    Then Response status code should be:    400
    And Response should return error code:    5401
    And Response should return error message:    Wrong request body.

