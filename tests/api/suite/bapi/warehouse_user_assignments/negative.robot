*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/steps/warehouse_user_assigment_steps.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

Assign_user_to_warehouse
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    1
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id
    And Response reason should be:    Created
    And Response body parameter should be:    [data][id]    ${warehouse_assigment_id}
    And Response body parameter should be:    [data][type]    warehouse-user-assignments
    And Response body parameter should not be EMPTY:    [data][attributes][userUuid]
    And Response body parameter should be:    [data][attributes][isActive]    False
    And Response body parameter should be:    [data][attributes][warehouse][name]    ${warehouse[0].warehouse_name}
    And Response body parameter should not be EMPTY:    [data][attributes][warehouse][uuid]
    And Response body parameter should be:    [data][attributes][warehouse][isActive]    True
    And Response body has correct self link for created entity:    ${warehouse_assigment_id}
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id}
    ...  AND    Response status code should be:    204
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    0

Assign_user_to_warehouse_with_include
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    1
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id
    And Response body parameter should not be EMPTY:    [data][relationships][users][data][0][id]
    And Each array in response should contain property with NOT EMPTY value:    [data][relationships][users][data]    id
    And Each array element of array in response should contain property with value:    [data][relationships][users][data]    type    users
    And Each array in response should contain property with NOT EMPTY value:    [included]    id
    And Each array element of array in response should contain property with value:    [included]    type    users
    And Response body parameter should be:    [included][0][attributes][username]    ${warehous_user[0].user_name}
    And Response body parameter should be:    [included][0][attributes][firstName]    ${warehous_user[0].user_first_name}
    And Response body parameter should be:    [included][0][attributes][lastName]    ${warehous_user[0].user_last_name}
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id}
    ...  AND    Response status code should be:    204
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    0

Get_warehouse_user_assigments_by_UUID
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    # assign several warehouses to one user [only one warehouse active]
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    1
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id
    Then I send a GET request:    /warehouse-user-assignments/${warehouse_assigment_id}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][id]    ${warehouse_assigment_id}
    And Response body parameter should be:    [data][type]    warehouse-user-assignments
    And Response body parameter should not be EMPTY:    [data][attributes][userUuid]
    And Response body parameter should be:    [data][attributes][isActive]    False
    And Response body parameter should be:    [data][attributes][warehouse][name]    ${warehouse[0].warehouse_name}
    And Response body parameter should not be EMPTY:    [data][attributes][warehouse][uuid]
    And Response body parameter should be:    [data][attributes][warehouse][isActive]    True
    And Response body has correct self link internal
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id}
    ...  AND    Response status code should be:    204
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    0

Get_warehouse_user_assigments_list
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    # assign several warehouses to one user [only one warehous active]
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    1
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_1
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].video_king_warehouse_uuid}"},"isActive":"true"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_2
    Then I send a GET request:    /warehouse-user-assignments
    Then Response status code should be:    200
    And Response should contain the array of a certain size:    [data]    2
    And Response body parameter should be in:    [data][0][id]    ${warehouse_assigment_id_1}    ${warehouse_assigment_id_2}
    And Response body parameter should be in:    [data][1][id]    ${warehouse_assigment_id_1}    ${warehouse_assigment_id_2}
    And Response body parameter should be:    [data][0][type]    warehouse-user-assignments
    And Response body parameter should be:    [data][1][type]    warehouse-user-assignments
    And Response body parameter should be:    [data][0][attributes][userUuid]    ${warehous_user[0].user_uuid}
    And Response body parameter should be:    [data][1][attributes][userUuid]    ${warehous_user[0].user_uuid}
    And Response body parameter should be in:    [data][0][attributes][isActive]    False    True
    And Response body parameter should be in:    [data][1][attributes][isActive]    False    True
    And Response body parameter should be in:    [data][0][attributes][warehouse][name]    ${warehouse[0].warehouse_name}    ${warehouse[0].video_king_warehouse_name}
    And Response body parameter should be in:    [data][1][attributes][warehouse][name]    ${warehouse[0].warehouse_name}    ${warehouse[0].video_king_warehouse_name}
    And Response body parameter should be:    [data][0][attributes][warehouse][isActive]    True
    And Response body parameter should be:    [data][1][attributes][warehouse][isActive]    True
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_1}
    ...  AND    Response status code should be:    204
    ...  AND    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_2}
    ...  AND    Response status code should be:    204
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    0

Get_warehouse_user_assigments_with_filter_by_warehouse_assigment_uuid
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    # assign several users to one warehouse
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    1
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid_2}    1
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_1
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid_2}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"true"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_2
    Then I send a GET request:    /warehouse-user-assignments/?filter[warehouse-user-assignments.uuid]=${warehouse_assigment_id_1}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][id]    ${warehouse_assigment_id_1}
    And Response body parameter should be:    [data][0][type]    warehouse-user-assignments
    And Response body parameter should be:    [data][0][attributes][userUuid]    ${warehous_user[0].user_uuid}
    And Response body parameter should be:    [data][0][attributes][isActive]    False
    And Response body parameter should be:    [data][0][attributes][warehouse][name]    ${warehouse[0].warehouse_name}
    And Response body parameter should be:    [data][0][attributes][warehouse][uuid]    ${warehouse[0].warehouse_uuid}
    And Response body parameter should be:    [data][0][attributes][warehouse][isActive]    True
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_1}
    ...  AND    Response status code should be:    204
    ...  AND    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_2}
    ...  AND    Response status code should be:    204
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    0
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid_2}    0

Get_warehouse_user_assigments_with_filter_by_warehouse_uuid
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    1
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid_2}    1
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_1
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid_2}","warehouse" :{"uuid": "${warehouse[0].video_king_warehouse_uuid}"},"isActive":"true"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_2
    Then I send a GET request:    /warehouse-user-assignments/?filter[warehouse-user-assignments.warehouseUuid]=${warehouse[0].video_king_warehouse_uuid}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][id]    ${warehouse_assigment_id_2}
    And Response body parameter should be:    [data][0][attributes][userUuid]    ${warehous_user[0].user_uuid_2}
    And Response body parameter should be:    [data][0][attributes][isActive]    True
    And Response body parameter should be:    [data][0][attributes][warehouse][name]    ${warehouse[0].video_king_warehouse_name}
    And Response body parameter should be:    [data][0][attributes][warehouse][uuid]    ${warehouse[0].video_king_warehouse_uuid}
    And Response body parameter should be:    [data][0][attributes][warehouse][isActive]    True
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_1}
    ...  AND    Response status code should be:    204
    ...  AND    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_2}
    ...  AND    Response status code should be:    204
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    0
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid_2}    0

Get_warehouse_user_assigments_with_filter_by_user_uuid
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    1
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid_2}    1
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_1
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid_2}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"true"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_2
    Then I send a GET request:    /warehouse-user-assignments/?filter[warehouse-user-assignments.userUuid]=${warehous_user[0].user_uuid}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][id]    ${warehouse_assigment_id_1}
    And Response body parameter should be:    [data][0][attributes][userUuid]    ${warehous_user[0].user_uuid}
    And Response body parameter should be:    [data][0][attributes][isActive]    False
    And Response body parameter should be:    [data][0][attributes][warehouse][name]    ${warehouse[0].warehouse_name}
    And Response body parameter should be:    [data][0][attributes][warehouse][uuid]    ${warehouse[0].warehouse_uuid}
    And Response body parameter should be:    [data][0][attributes][warehouse][isActive]    True
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_1}
    ...  AND    Response status code should be:    204
    ...  AND    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_2}
    ...  AND    Response status code should be:    204
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    0
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid_2}    0

Get_warehouse_user_assigments_with_filter_by_isActive
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    1
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid_2}    1
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_1
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid_2}","warehouse" :{"uuid": "${warehouse[0].video_king_warehouse_uuid}"},"isActive":"true"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_2
    Then I send a GET request:    /warehouse-user-assignments/?filter[warehouse-user-assignments.isActive]=true
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][id]    ${warehouse_assigment_id_2}
    And Response body parameter should be:    [data][0][attributes][userUuid]    ${warehous_user[0].user_uuid_2}
    And Response body parameter should be:    [data][0][attributes][isActive]    True
    And Response body parameter should be:    [data][0][attributes][warehouse][name]    ${warehouse[0].video_king_warehouse_name}
    And Response body parameter should be:    [data][0][attributes][warehouse][uuid]    ${warehouse[0].video_king_warehouse_uuid}
    And Response body parameter should be:    [data][0][attributes][warehouse][isActive]    True
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_1}
    ...  AND    Response status code should be:    204
    ...  AND    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_2}
    ...  AND    Response status code should be:    204
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    0
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid_2}    0

Update_warehouse_user_assigment
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    1
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id
    Then I send a PATCH request:    /warehouse-user-assignments/${warehouse_assigment_id}    {"data":{"attributes":{"isActive":"true"}}}
    Then Response status code should be:    200
    Then I send a GET request:    /warehouse-user-assignments/${warehouse_assigment_id}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][id]    ${warehouse_assigment_id}
    And Response body parameter should be:    [data][attributes][isActive]    True
    Then I send a PATCH request:    /warehouse-user-assignments/${warehouse_assigment_id}    {"data":{"attributes":{"isActive":"false"}}}
    Then I send a GET request:    /warehouse-user-assignments/${warehouse_assigment_id}
    And Response body parameter should be:    [data][attributes][isActive]    False
    And Response body has correct self link internal
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id}
    ...  AND    Response status code should be:    204
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    0

 Create_warehouse_user_assignment_with_multiple_active_assignments
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    1
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"true"}}}
    Then Save value to a variable:    [data][id]   warehouse_assigment_id
    Then I send a GET request:    /warehouse-user-assignments/${warehouse_assigment_id}
    And Response body parameter should be:    [data][attributes][isActive]    True
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].video_king_warehouse_uuid}"},"isActive":"true"}}}
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_2
    Then I send a GET request:    /warehouse-user-assignments/${warehouse_assigment_id_2}
    And Response body parameter should be:    [data][attributes][isActive]    True
    # when we creating second active user warehouse assigment for one user,the existing one assigment deactivated
    Then I send a GET request:    /warehouse-user-assignments/${warehouse_assigment_id}
    And Response body parameter should be:    [data][attributes][isActive]    False
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id}
    ...  AND    Response status code should be:    204
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    0
    Then I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_2}
    And Response status code should be:    204

Update_one_of_already exist_warehouse_user_assigment_with_two_assigments_to active
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    1
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_1
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].video_king_warehouse_uuid}"},"isActive":"true"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id_2
    Then I send a PATCH request:    /warehouse-user-assignments/${warehouse_assigment_id_1}    {"data":{"attributes":{"isActive":"true"}}}
    Then Response status code should be:    200
    Then I send a GET request:    /warehouse-user-assignments/${warehouse_assigment_id_2}
    And Response body parameter should be:    [data][attributes][isActive]    False
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_1}
    ...  AND    Response status code should be:    204
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].user_uuid}    0
    Then I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id_2}
    And Response status code should be:    204
