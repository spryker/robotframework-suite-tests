*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/steps/warehouse_user_assigment_steps.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

*** Test Cases ***
Create_warehouse_user_assigment_with_invalid_token
    [Setup]    Run Keywords    I get access token by user credentials:    invalid
     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    400
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Create_warehouse_user_assigment_without_token
    And I set Headers:    Content-Type=${default_header_content_type}   
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    403
    And Response should return error message:    Unauthorized request.

Create_warehouse_user_assigment_with_invalid_body
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}     
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "test","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    400
    And Response should return error code:    5202
    And Response should return error message:    User not found.

Create_warehouse_user_assigment_with_empty_body
    [Documentation]    https://spryker.atlassian.net/browse/FRW-1597  
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
    When I send a POST request:    /warehouse-user-assignments    {"data": {}}
    Then Response status code should be:    400

Create_warehouse_user_assigment_with_incorrect_type
    [Documentation]    201 response, warehouse-user-assigment successfully created with incorrect type 
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "invalid", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    400

Create_warehouse_user_assignment_with_duplicate_assignment
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    400
    And Response should return error code:    5206
    And Response should return error message:    Warehouse user assignment already exists.
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id}
    ...  AND    Response status code should be:    204

Create_warehouse_user_assignment_with_multiple_active_assignments
    [Documentation]    both active assigments created to one user, should not be, bug needs 
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"true"}}}
    Then Save value to a variable:    [data][id]   warehouse_assigment_id
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].video_king_warehouse_uuid}"},"isActive":"true"}}}
    Then Response status code should be:    400
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id}
    ...  AND    Response status code should be:    204

Get_warehouse_user_assigments_by_UUID_without_token
    [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
    [Tags]    skip-due-to-issue
    And Create_warehouse_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}    false
    Then Get_warehouse_user_assigment_id:   ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}
    Then I send a GET request:    /warehouse-user-assignments/${id_warehouse_user_assigment}
    Then Response status code should be:    403
    And Remove_warehous_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}

Get_user_assigments_by_UUID_with_invalid_token
    [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
    [Tags]    skip-due-to-issue
    And Create_warehouse_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}    false
    Then Get_warehouse_user_assigment_id:   ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}
    [Setup]    Run Keywords    I get access token by user credentials:    invalid
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}  
    Then I send a GET request:    /warehouse-user-assignments/${id_warehouse_user_assigment}
    Then Response status code should be:    401
    And Response should return error code:    001
    And Response should return error message:   Invalid access token.
    And Remove_warehous_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}

Get_user_assigments_by_invalid_UUID
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}  
    And Create_warehouse_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}    false
    Then Get_warehouse_user_assigment_id:   ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}
    Then I send a GET request:    /warehouse-user-assignments/invalid
    Then Response status code should be:    404
    And Response should return error code:    5201
    And Response should return error message:    Warehouse user assignment not found.
    And Remove_warehous_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}

Get_user_assigments_list_with_invalid_token
    [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:    invalid
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}  
    And Create_warehouse_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}    false
    Then I send a GET request:    /warehouse-user-assignments/
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.
    And Remove_warehous_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}

Get_user_assigments_list_without_token
    [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
    [Tags]    skip-due-to-issue
    And Create_warehouse_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}    false
    Then I send a GET request:    /warehouse-user-assignments/
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.
    And Remove_warehous_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}

Update_warehous_user_assigment_without_token   
    [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
    [Tags]    skip-due-to-issue
    And Create_warehouse_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}    false
    Then Get_warehouse_user_assigment_id:   ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}
    Then I send a PATCH request:    /warehouse-user-assignments/${id_warehouse_user_assigment}    {"data":{"attributes":{"isActive":"true"}}} 
    Then Response status code should be:    401
    And Remove_warehous_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}

Update_warehous_user_assigment_with_invalid_token
  [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
  [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:    invalid
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}   
    And Create_warehouse_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}    false
    Then Get_warehouse_user_assigment_id:   ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}
    And Create_warehouse_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}    false 
    Then I send a PATCH request:    /warehouse-user-assignments/${id_warehouse_user_assigment}    {"data":{"attributes":{"isActive":"true"}}} 
    Then Response status code should be:    403
    And Remove_warehous_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}

Update_warehous_user_assigment_without_uuid
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid_2}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_1
    Then I send a PATCH request:    /warehouse-user-assignments/invalid    {"data":{"attributes":{"isActive":"true"}}} 
    Then Response status code should be:    404  
    And Response should return error code:    5201
    And Response should return error message:    Warehouse user assignment not found.
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_1}
    ...  AND    Response status code should be:    204 

Update_one_of_already exist_warehous_user_assigment_with_two_assigments_to active
    [Documentation]    both active assigments created to one user, should not be, bug needs to be Create_warehouse_user_assigment_with_invalid_body
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_1
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].video_king_warehouse_uuid}"},"isActive":"true"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_2
    Then I send a PATCH request:    /warehouse-user-assignments/${warehouse_assigment_id_1}    {"data":{"attributes":{"isActive":"true"}}} 
    Then Response status code should be:    404
    Then I send a GET request:    /warehouse-user-assignments/${warehouse_assigment_id_1}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][attributes][isActive]    False
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_1}
    ...  AND    Response status code should be:    204 
    Then I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_2}
    And Response status code should be:    204 

Delete_warehous_user_assigment_without_token
  [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
  [Tags]    skip-due-to-issue
    And Create_warehouse_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}    false
    Then Get_warehouse_user_assigment_id:   ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}
    Then I send a DELETE request:    /warehouse-user-assignments/${id_warehouse_user_assigment}  
    Then Response status code should be:    400
    And Remove_warehous_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}

 Delete_warehous_user_assigment_with_invalid_token
    [Setup]    Run Keywords    I get access token by user credentials:    invalid
     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token} 
    And Create_warehouse_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}    false
    Then Get_warehouse_user_assigment_id:   ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}
    Then I send a DELETE request:    /warehouse-user-assignments/${id_warehouse_user_assigment}
    Then Response status code should be:    400
    And Remove_warehous_user_assigment:    ${warehouse[0].warehouse_uuid}    ${warehous_user[0].user_uuid}

