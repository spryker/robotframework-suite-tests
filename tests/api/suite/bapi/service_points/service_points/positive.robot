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
    [Teardown]     Run Keywords    Get service point uuid by key:    ${service_point_key}
    ...    AND    Delete service point in DB    ${servicePointUuid}

 Create_new_service_point_with_existing_name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Not Unique Name","key": "some-service-point-1${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][attributes][key]    service_point_key_1
    And Save value to a variable:    [data][id]    new_service_point_id
    # Create a new service point with an existing name
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Not Unique Name","key": "another-service-point-2${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    Then Save value to a variable:    [data][attributes][key]    service_point_key_2
    And Response body parameter should be:    [data][type]    service-points
    And Save value to a variable:    [data][id]    service_point_id
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][name]    Not Unique Name
    And Response body parameter should be:    [data][attributes][key]    ${service_point_key_2}
    [Teardown]     Run Keywords    Get service point uuid by key:    ${service_point_key_1}
    ...    AND    Delete service point in DB    ${servicePointUuid}
    ...    AND    Get service point uuid by key:    ${service_point_key_2}
    ...    AND    Delete service point in DB    ${servicePointUuid}   

Create_Service_Point_With_Valid_Key_Length
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Incorrect key lenghth","key": "fihslafnkjskdjfnskadfkafkjsadfkjsdjnnkfjsdkfjdskdjfhnjdksbfjhdsbfjkdsfbjsdfjksdfjksdfhdjksfhkdsf jkdsfhjdhsfjhdsjfhdsfjhsjkfhkshkjdsahf78348937489137489yewhkjdsfildksh9832urqewdiosjakrj3982diasjif8d3j89siojfdisakjfdiksdjfkasdjfhkjdashfjkldsahfldchgjhjjghj","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    new_service_point_id
    [Teardown]     Run Keywords    Get service point uuid by key:    ${service_point_key_1}
    ...    AND    Delete service point in DB    ${servicePointUuid}

Update_Service_Point
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Initial Service Point ${random}","key": "initial-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    ...    AND    Save value to a variable:    [data][attributes][key]    service_point_key
    ...    AND    Save value to a variable:    [data][id]    service_point_id
    When I send a PATCH request:    /service-points/${service_point_id}    {"data": {"type": "service-points","attributes": {"key": "initial-service-point-${random}","stores": ["DE"],"isActive": "false","name": "Updated Service Point"}}}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][type]    service-points
    And Response body parameter should be:    [data][attributes][name]    Updated Service Point
    And Response body parameter should be:    [data][attributes][key]    initial-service-point-${random}
    And Response body parameter should be:    [data][attributes][isActive]    False
    And Response body parameter should be:    [data][attributes][stores]    DE
    [Teardown]     Run Keywords    Get service point uuid by key:    ${service_point_key}
    ...    AND    Delete service point in DB    ${service_point_id}

Get_All_Service_Points
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Service Point 1","key": "some-service-point1-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Save value to a variable:    [data][attributes][key]    service_point_key1
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Service Point 2","key": "some-service-point2-${random}","isActive": "false","stores": ["AT"]}}}
    Then Save value to a variable:    [data][attributes][key]    service_point_key2
    When I send a GET request:    /service-points
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][type]    service-points
    And Each array in response should contain property with NOT EMPTY value:    [data]    [id]
    And Each array in response should contain property with NOT EMPTY value:    [data]    [attributes][name]
    And Each array in response should contain property with NOT EMPTY value:    [data]    [attributes][key]
    And Each array in response should contain property with NOT EMPTY value:    [data]    [attributes][isActive]
    And Each array element of array in response should contain property with value in:    [data]    [attributes][stores]    DE    AT
    [Teardown]     Run Keywords    Get service point uuid by key:    ${service_point_key1}
    ...    AND    Delete service point in DB    ${service_point_key1}
    ...    AND    Get service point uuid by key:    ${service_point_key2}
    ...    AND    Delete service point in DB    ${service_point_key2}

Get_Service_Point_By_ID
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "SP by id ${random}","key": "service-point-to-get${random}","isActive": "true","stores": ["AT"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][attributes][key]    service_point_key_to_get
    And Save value to a variable:    [data][id]    service_point_id_to_get
    When I send a GET request:    /service-points/${service_point_id_to_get}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][id]    ${service_point_id_to_get}
    And Response body parameter should be:    [data][type]    service-points
    And Response body parameter should be:    [data][attributes][name]    SP by id ${random}
    And Response body parameter should be:    [data][attributes][key]    ${service_point_key_to_get}
    And Response body parameter should be:    [data][attributes][isActive]    True
    And Response body parameter should be:    [data][attributes][stores]    AT
    And Response body has correct self link internal
    [Teardown]     Run Keywords    Get service point uuid by key:    ${service_point_key_to_get}
    ...    AND    Delete service point in DB    ${service_point_id_to_get}


