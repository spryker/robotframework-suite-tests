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
# Create_warehouse_user_assigment_with_invalid_token
#     [Setup]    Run Keywords    I get access token by user credentials:    invalid
#      ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
#     When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
#     Then Response status code should be:    400

# Create_warehouse_user_assigment_without_token
#     And I set Headers:    Content-Type=${default_header_content_type}   
#     When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
#     Then Response status code should be:    403

# Create_warehouse_user_assigment_with_invalid_body
#     [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
#      ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
#     When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "test","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
#     Then Response status code should be:    400


# Create_warehouse_user_assigment_with_empty_body
#     [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
#      ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
#     When I send a POST request:    /warehouse-user-assignments    {"data": {}}
#     Then Response status code should be:    400

# Create_warehouse_user_assigment_with_incorrect_type
#     [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
#      ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
#     When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "invalid", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
#     Then Response status code should be:    400

# Create_warehouse_user_assignment_with_duplicate_assignment
#     [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
#      ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
#     When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
#     Then Response status code should be:    201
#     Then Save value to a variable:    [data][id]   warehouse_assigment_id
#     When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
#     Then Response status code should be:    400

# Create_warehouse_user_assignment_with_multiple_active_assignments
#     [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
#     When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"true"}}}
#     When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}}","warehouse" :{"uuid": "${warehouse[0].video_king_warehouse_uuid}"},"isActive":"true"}}}
#     Then Response status code should be:    400

# Get_user_assigments_by_UUID_without_token
#     Then I send a GET request:    /warehouse-user-assignments/${warehous_assigment_id}
#     Then Response status code should be:    401

# Get_user_assigments_by_UUID_with_invalid_token
#     [Setup]    Run Keywords    I get access token by user credentials:    invalid
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}  
#     Then I send a GET request:    /warehouse-user-assignments/${warehous_assigment_id}
#     Then Response status code should be:    403

# Get_user_assigments_by_invalid_UUID
#     [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
#      ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}  
#     Then I send a GET request:    /warehouse-user-assignments/invalid
#     Then Response status code should be:    400

# Get_user_assigments_list_with_invalid_token
#     [Setup]    Run Keywords    I get access token by user credentials:    invalid
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}  
#     Then I send a GET request:    /warehouse-user-assignments/${warehous_assigment_id}
#     Then Response status code should be:    401

# Get_user_assigments_list_without_token
#     Then I send a GET request:    /warehouse-user-assignments/${warehous_assigment_id}
#     Then Response status code should be:    401

# Get_user_assigments_list_with_invalid_filters
#     Then I send a GET request:    /warehouse-user-assignments/?filter[warehouse-user-assignments.warehouse]=${warehouse[0].video_king_warehouse_uuid}
#     Then Response status code should be:    404

# Update_warehous_user_assigment_without_token   
#     Then I send a PATCH request:    /warehouse-user-assignments/${warehouse_assigment_id}    {"data":{"attributes":{"isActive":"true"}}} 
#     Then Response status code should be:    401

# Update_warehous_user_assigment_with_invalid_token
#     [Setup]    Run Keywords    I get access token by user credentials:    invalid
#      ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
#     Then I send a PATCH request:    /warehouse-user-assignments/${warehouse_assigment_id}    {"data":{"attributes":{"isActive":"true"}}} 
#     Then Response status code should be:    403

# Update_warehous_user_assigment_with_incorrect_uuid
#     [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
#      ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
#     When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid_2}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
#     Then Response status code should be:    201
#     Then Save value to a variable:    [data][id]   warehouse_assigment_id_1
#     Then I send a PATCH request:    /warehouse-user-assignments/invalid    {"data":{"attributes":{"isActive":"true"}}} 
#     Then Response status code should be:    400  
#     [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_1}
#     ...  AND    Response status code should be:    204 

Update_one_of_already exist_warehous_user_assigment_with_two_assigments_to active
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_1
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid_2}","warehouse" :{"uuid": "${warehouse[0].video_king_warehouse_uuid}"},"isActive":"true"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_2
    Then I send a PATCH request:    /warehouse-user-assignments/${warehouse_assigment_id}    {"data":{"attributes":{"isActive":"true"}}} 
    Then Response status code should be:    200
    Then I send a GET request:    /warehouse-user-assignments/${warehouse_assigment_id}
    Then Response status code should be:    200

    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_1}
    ...  AND    Response status code should be:    204
    ...  AND    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_2}
    ...  AND    Response status code should be:    204

Delete_warehous_user_assigment_without_token
    Then I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id}   
    Then Response status code should be:    400

 Delete_warehous_user_assigment_with_invalid_token
    [Setup]    Run Keywords    I get access token by user credentials:    invalid
     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token} 
    Then I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id} 
    Then Response status code should be:    400
 
#  Delete_warehous_user_assigment_with_invalid_uuid
#     [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
#      ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
#     When Create_warehouse_user_assigment   
#     Then I send a DELETE request:    /warehouse-user-assignments/invalid  
#     Then Response status code should be:    400

# *******

# Precondition_test
#     [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
#      ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}  
#     When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
#     Then Response status code should be:    201
#     Then Save value to a variable:    [data][id]   warehouse_assigment_id

# Teardown_test
#     [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}   
#     I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id}
#     And Response status code should be:    204
