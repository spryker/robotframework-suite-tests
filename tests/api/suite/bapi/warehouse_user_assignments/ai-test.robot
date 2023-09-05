*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/steps/warehouse_user_assigment_steps.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
   TestSetup

*** Test Cases ***

Create New Warehouse User Assignment
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token} 
    When I send a POST request:    /warehouse-user-assignments    {"warehouseUuid": "18e3abbb-3f65-470b-87e0-1e203dc0000d", "userUuid": "18e3abbb-3f65-470b-87e0-1e203dc0000d"}
    Then Response status code should be:    201
    And Response body parameter should be:    [data][0][type]    warehouse-user-assignments
    And Save value to a variable:    [data][0][id]    warehouse_user_assignment_id
    And Response body parameter should not be EMPTY:    [data][0][attributes][userUuid]
    And Response body parameter should not be EMPTY:    [data][0][attributes][warehouse][uuid]
    And Response body parameter should not be EMPTY:    [data][0][attributes][warehouse][name]
    And Response body parameter should be:    [data][0][attributes][warehouse][isActive]    false
    And Response body has correct self link for created entity:    ${warehouse_user_assignment_id}
    [Teardown]    I send a DELETE request:    /warehouse-user-assignments/${warehouse_user_assignment_id}


Create Duplicate Warehouse User Assignment
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /warehouse-user-assignments    {"warehouseUuid": "18e3abbb-3f65-470b-87e0-1e203dc0000d", "userUuid": "18e3abbb-3f65-470b-87e0-1e203dc0000d"}
    Then Response status code should be:    400
    And Response should return error code:    <SPECIFIC_ERROR_CODE>
    And Response should return error message:    <SPECIFIC_ERROR_MESSAGE>
    [Teardown]    I send a DELETE request:    /warehouse-user-assignments/${warehouse_user_assignment_id}

Create Warehouse User Assignment With Missing Fields
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /warehouse-user-assignments    {"warehouseUuid": "", "userUuid": ""}
    Then Response status code should be:    400
    And Response should return error code:    <SPECIFIC_ERROR_CODE>
    And Response should return error message:    <SPECIFIC_ERROR_MESSAGE>

Create Warehouse User Assignment Without Authorization
    [Setup]    I set Headers:    Content-Type=application/vnd.api+json   Authorization=
    When I send a POST request:    /warehouse-user-assignments    {"warehouseUuid": "18e3abbb-3f65-470b-87e0-1e203dc0000d", "userUuid": "18e3abbb-3f65-470b-87e0-1e203dc0000d"}
    Then Response status code should be:    403
    And Response should return error message:    Forbidden

Delete Non-Existing Warehouse User Assignment
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a DELETE request:    /warehouse-user-assignments/non_existing_id
    Then Response status code should be:    404
    And Response should return error message:    Not found

Get All Warehouse User Assignments
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes": {"userUuid": "${warehouse_user[0].user_uuid}", "warehouse": {"uuid": "${warehouse[0].warehouse_uuid}"}, "isActive": "false"}}}
    ...    AND    Save value to a variable:    [data][0][id]    warehouse_user_assignment_id1
    ...    AND    I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes": {"userUuid": "${warehouse_user[1].user_uuid}", "warehouse": {"uuid": "${warehouse[1].warehouse_uuid}"}, "isActive": "true"}}}
    ...    AND    Save value to a variable:    [data][1][id]    warehouse_user_assignment_id2
    When I send a GET request:    /warehouse-user-assignments?include=users
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][type]    warehouse-user-assignments
    And Response body parameter should be:    [data][1][type]    warehouse-user-assignments
    # And Response body has correct self link:    http://glue-backend.de.spryker.local/warehouse-user-assignments?include=users
    [Teardown]    Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_user_assignment_id1}
    ...    AND    I send a DELETE request:    /warehouse-user-assignments/${warehouse_user_assignment_id2}
    
Get Warehouse User Assignment by UUID
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes": {"userUuid": "${warehouse_user[0].user_uuid}", "warehouse": {"uuid": "${warehouse[0].warehouse_uuid}"}, "isActive": "false"}}}
    ...    AND    Save value to a variable:    [data][0][id]    warehouse_user_assignment_id
    When I send a GET request:    /warehouse-user-assignments?warehouse-user-assignments.uuid=${warehouse_user_assignment_id}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][type]    warehouse-user-assignments
    And Response body parameter should be:    [data][0][id]    ${warehouse_user_assignment_id}
    # And Response body has correct self link:    http://glue-backend.de.spryker.local/warehouse-user-assignments?warehouse-user-assignments.uuid=${warehouse_user_assignment_id}
    [Teardown]    I send a DELETE request:    /warehouse-user-assignments/${warehouse_user_assignment_id}

Get Warehouse User Assignment by Warehouse UUID
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes": {"userUuid": "${warehouse_user[0].user_uuid}", "warehouse": {"uuid": "${warehouse[0].warehouse_uuid}"}, "isActive": "false"}}}
    ...    AND    Save value to a variable:    [data][0][attributes][warehouse][uuid]    warehouse_uuid
    When I send a GET request:    /warehouse-user-assignments?warehouse-user-assignments.warehouseUuid=${warehouse_uuid}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][type]    warehouse-user-assignments
    And Response body parameter should be:    [data][0][attributes][warehouse][uuid]    ${warehouse_uuid}
    # And Response body has correct self link:    http://glue-backend.de.spryker.local/warehouse-user-assignments?warehouse-user-assignments.warehouseUuid=${warehouse_uuid}
    [Teardown]    I send a DELETE request:    /warehouse-user-assignments/${warehouse_user_assignment_id}

Get Warehouse User Assignment by User UUID
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes": {"userUuid": "${warehouse_user[0].user_uuid}", "warehouse": {"uuid": "${warehouse[0].warehouse_uuid}"}, "isActive": "false"}}}
    ...    AND    Save value to a variable:    [data][0][attributes][userUuid]    user_uuid
    When I send a GET request:    /warehouse-user-assignments?warehouse-user-assignments.userUuid=${user_uuid}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][type]    warehouse-user-assignments
    And Response body parameter should be:    [data][0][attributes][userUuid]    ${user_uuid}
    # And Response body has correct self link:    http://glue-backend.de.spryker.local/warehouse-user-assignments?warehouse-user-assignments.userUuid=${user_uuid}
    [Teardown]    I send a DELETE request:    /warehouse-user-assignments/${warehouse_user_assignment_id}

Get Warehouse User Assignment by isActive Status
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes": {"userUuid": "${warehouse_user[0].user_uuid}", "warehouse": {"uuid": "${warehouse[0].warehouse_uuid}"}, "isActive": "true"}}}
    ...    AND    Save value to a variable:    [data][0][id]    warehouse_user_assignment_id
    When I send a GET request:    /warehouse-user-assignments?warehouse-user-assignments.isActive=true
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][type]    warehouse-user-assignments
    And Response body parameter should be:    [data][0][attributes][isActive]    true
    # And Response body has correct self link:    http://glue-backend.de.spryker.local/warehouse-user-assignments?warehouse-user-assignments.isActive=true
    [Teardown]    I send a DELETE request:    /warehouse-user-assignments/${warehouse_user_assignment_id}

Get Warehouse User Assignments Without Authorization
    [Setup]    I set Headers:    Content-Type=application/vnd.api+json   Authorization=
    When I send a GET request:    /warehouse-user-assignments
    Then Response status code should be:    403
    And Response should return error message:    Forbidden


Get Warehouse User Assignment by UUID Successfully
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes": {"userUuid": "${warehouse_user[0].user_uuid}", "warehouse": {"uuid": "${warehouse[0].warehouse_uuid}"}, "isActive": "false"}}}
    ...    AND    Save value to a variable:    [data][0][id]    warehouse_user_assignment_id
    When I send a GET request:    /warehouse-user-assignments/${warehouse_user_assignment_id}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][type]    warehouse-user-assignments
    And Response body parameter should be:    [data][0][id]    ${warehouse_user_assignment_id}
    And Response body parameter should be:    [data][0][attributes][isActive]    false
    And Response body parameter should be:    [data][0][attributes][warehouse][name]    Warehouse 1
    And Response body parameter should be:    [data][0][attributes][warehouse][isActive]    true
    # And Response body has correct self link:    http://glue-backend.de.spryker.local/warehouse-user-assignments/${warehouse_user_assignment_id}
    [Teardown]    I send a DELETE request:    /warehouse-user-assignments/${warehouse_user_assignment_id}

Get Warehouse User Assignment with Non-Existent UUID
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a GET request:    /warehouse-user-assignments/non-existent-uuid
    Then Response status code should be:    404
    And Response should return error message:    Not found

Get Warehouse User Assignment Without Authorization
    [Setup]    I set Headers:    Content-Type=application/vnd.api+json   Authorization=
    When I send a GET request:    /warehouse-user-assignments/7a576652-7a5d-4bdf-864a-a2ad38233caf
    Then Response status code should be:    403
    And Response should return error message:    Forbidden

Update Warehouse User Assignment Successfully
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes": {"userUuid": "${warehouse_user[0].user_uuid}", "warehouse": {"uuid": "${warehouse[0].warehouse_uuid}"}, "isActive": "false"}}}
    ...    AND    Save value to a variable:    [data][0][id]    warehouse_user_assignment_id
    When I send a PATCH request:    /warehouse-user-assignments/${warehouse_user_assignment_id}    {"isActive": true}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][type]    warehouse-user-assignments
    And Response body parameter should be:    [data][0][id]    ${warehouse_user_assignment_id}
    And Response body parameter should be:    [data][0][attributes][isActive]    true
    And Response body parameter should be:    [data][0][attributes][warehouse][name]    Warehouse 1
    And Response body parameter should be:    [data][0][attributes][warehouse][isActive]    true
    # And Response body has correct self link:    http://glue-backend.de.spryker.local/warehouse-user-assignments/${warehouse_user_assignment_id}
    [Teardown]    I send a DELETE request:    /warehouse-user-assignments/${warehouse_user_assignment_id}

Update Warehouse User Assignment with Non-Existent UUID
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_user.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a PATCH request:    /warehouse-user-assignments/non-existent-uuid    {"isActive": true}
    Then Response status code should be:    404
    And Response should return error message:    Not found

Update Warehouse User Assignment Without Authorization
    [Setup]    I set Headers:    Content-Type=application/vnd.api+json   Authorization=
    When I send a PATCH request:    /warehouse-user-assignments/7a576652-7a5d-4bdf-864a-a2ad38233caf    {"isActive": true}
    Then Response status code should be:    403
    And Response should return error message:    Forbidden
