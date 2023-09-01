*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

Assign_user_to_warehouse
    [Setup]    Run Keywords    I get access token by user credentials:    michele@sony-experts.com
     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehous[0].warehous_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehous_assigment_id
    Then Save value to a variable:    [included][0][id]   user_id
    And Response reason should be:    Created
    And Response body parameter should be:    [data][id]    ${warehous_assigment_id}
    And Response body parameter should be:    [data][type]    warehouse-user-assignments
    And Response body parameter should not be EMPTY:    [data][attributes][userUuid]
    And Response body parameter should be:    [data][attributes][isActive]    False
    And Response body parameter should be:    [data][attributes][warehouse][name]    ${warehous[0].warehous_name}
    And Response body parameter should not be EMPTY:    [data][attributes][warehouse][uuid]
    And Response body parameter should be:    [data][attributes][warehouse][isActive]    True
    And Response body parameter should not be EMPTY:    [data][relationships][users][data][0][id]
    And Each array in response should contain property with NOT EMPTY value:    [data][relationships][users][data]    id
    And Each array element of array in response should contain property with value:    [data][relationships][users][data]    type    users
    # And Response body has correct self link internal
    And Each array in response should contain property with NOT EMPTY value:    [included]    id
    And Each array element of array in response should contain property with value:    [included]    type    users
    And Response body parameter should be:    [included][0][attributes][username]    ${warehous_user[0].user_name}
    And Response body parameter should be:    [included][0][attributes][firstName]    ${warehous_user[0].user_first_name}
    And Response body parameter should be:    [included][0][attributes][lastName]    ${warehous_user[0].user_last_name}
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehous_assigment_id}
    ...  AND    Response status code should be:    204


#!!!!self-links keywords need to be ajusted to use then in BAPI

# Get_user_assigments_by_UUID
#     [Setup]    Run Keywords    I get access token by user credentials:    michele@sony-experts.com
#      ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
#     When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user.user_uuid}","warehouse" :{"uuid": "${warehous.warehous_uuid}"},"isActive":"false"}}}
#     Then Response status code should be:    201
#     Then Save value to a variable:    [data][id]   warehous_assigment_id_1
#     When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "84b8f847-d755-5763-b128-8e138e6571fc","warehouse" :{"uuid": "e84b3cb8-a94a-5a7e-9adb-cc5353f7a73f"},"isActive":"false"}}}
#     Then Response status code should be:    201
#     Then Save value to a variable:    [data][id]   warehous_assigment_id_2
#     Then I send a GET request:    /warehouse-user-assignments/${warehous_assigment_id_1}
#     Then Response status code should be:    200

#     [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehous_assigment_id_1}
#     ...  AND    Response status code should be:    204
#     ...  AND    I send a DELETE request:    /warehouse-user-assignments/${warehous_assigment_id_2}
#     ...  AND    Response status code should be:    204

# Get_user_assigments_with_filter_by_warehouse_uuid
#     Then I send a GET request:    /warehouse-user-assignments/?filter[warehouse-user-assignments.warehouseUuid]=39c50570-d47f-553a-9edc-3c44ea6a1cb6



# Get_user_assigments_with_filter_by_is_active
#     Then I send a GET request:    /warehouse-user-assignments/?filter[warehouse-user-assignments.isActive]=true    



# Update_warehous_user_assigment
#     Then I send a PATCH request:    /warehouse-user-assignments/a9e7d1de-bdd2-578b-b456-286693afa14a    {"data":{"attributes":{"isActive":"false"}}} 
#     Then I send a PATCH request:    /warehouse-user-assignments/a9e7d1de-bdd2-578b-b456-286693afa14a    {"data":{"attributes":{"isActive":"true"}}} 
#     Then I send a GET request:    /warehouse-user-assignments/${warehous_assigment_id_1}

# Delete_warehous_user_assigment
#     Then I send a DELETE request:    /warehouse-user-assignments/${warehous_assigment_id_1} 
 

