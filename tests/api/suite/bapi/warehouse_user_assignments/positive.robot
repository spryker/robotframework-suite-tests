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
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "48a6c610-693e-5d88-bdce-3c6018b3abd2","warehouse" :{"uuid": "e84b3cb8-a94a-5a7e-9adb-cc5353f7a73f"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehous_assigment_id
    Then Save value to a variable:    [included][0][id]   user_id
    And Response reason should be:    Created
    And Response body parameter should be:    [data][id]    ${warehous_assigment_id}
    And Response body parameter should be:    [data][type]    warehouse-user-assignments
    And Response body parameter should not be EMPTY:    [data][attributes][userUuid]
    And Response body parameter should be:    [data][attributes][isActive]    False
    And Response body parameter should be:    [data][attributes][warehouse][name]    Spryker MER000001 Warehouse 1
    And Response body parameter should not be EMPTY:    [data][attributes][warehouse][uuid]
    And Response body parameter should be:    [data][attributes][warehouse][isActive]    True
    And Response body parameter should not be EMPTY:    [data][relationships][users][data][0][id]
    And Each array in response should contain property with NOT EMPTY value:    [data][relationships][users][data]    id
    And Each array element of array in response should contain property with value:    [data][relationships][users][data]    type    users
    # And Response body has correct self link internal
    And Each array in response should contain property with NOT EMPTY value:    [included]    id
    And Each array element of array in response should contain property with value:    [included]    type    users
    And Response body parameter should be:    [included][0][attributes][username]    martha@video-king.nl
    And Response body parameter should be:    [included][0][attributes][firstName]    Martha
    And Response body parameter should be:    [included][0][attributes][lastName]    Farmer
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehous_assigment_id}
    ...  AND    Response status code should be:    204



# Get_user_assigment_by_UUID
#   # Then I send a GET request:    /warehouse-user-assignments/85949927-9f7e-5136-8ca6-53bec88d4f93 
    # Then I send a DELETE request:    /warehouse-user-assignments/85949927-9f7e-5136-8ca6-53bec88d4f93

