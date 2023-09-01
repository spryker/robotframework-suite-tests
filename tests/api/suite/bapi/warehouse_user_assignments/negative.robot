*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

Assign_user_to_warehous_without_body
    [Setup]    Run Keywords    I get access token by user credentials:    michele@sony-experts.com
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    When I send a POST request with data:    $path    $data

*** Test Cases ***
Create Warehouse User Assignment - Forbidden
    [Tags]    Negative
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer invalid_token
    ...    AND    I set Request Body    ${VALID_REQUEST_BODY}
    When I send a POST request:    ${BASE_URL}${ENDPOINT}    data=${REQUEST_BODY}    headers=${HEADERS}
    Then Response status code should be:    403
    And Response Should Be Valid Schema
    [Teardown]    Run Keywords    I send a DELETE request:    ${BASE_URL}${ENDPOINT}/7a576652-7a5d-4bdf-864a-a2ad38233caf

Create Warehouse User Assignment - Validation Issues
    [Tags]    Negative
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    ...    AND    I set Request Body    ${INVALID_REQUEST_BODY}
    When I send a POST request:    ${BASE_URL}${ENDPOINT}    data=${REQUEST_BODY}    headers=${HEADERS}
    Then Response status code should be:    400
    And Response Should Be Valid Schema
    [Teardown]    Run Keywords    I send a DELETE request:    ${BASE_URL}${ENDPOINT}/7a576652-7a5d-4bdf-864a-a2ad38233caf

Create Warehouse User Assignment - Empty Request Body
    [Tags]    Negative
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    ...    AND    I set Request Body    ${EMPTY_REQUEST_BODY}
    When I send a POST request:    ${BASE_URL}${ENDPOINT}    data=${REQUEST_BODY}    headers=${HEADERS}
    Then Response status code should be:    400
    And Response Should Be Valid Schema
    [Teardown]    Run Keywords    I send a DELETE request:    ${BASE_URL}${ENDPOINT}/7a576652-7a5d-4bdf-864a-a2ad38233caf

Create Warehouse User Assignment - Wrong Type
    [Tags]    Negative
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    ...    AND    I set Request Body    ${WRONG_TYPE_REQUEST_BODY}
    When I send a POST request:    ${BASE_URL}${ENDPOINT}    data=${REQUEST_BODY}    headers=${HEADERS}
    Then Response status code should be:    400
    And Response Should Be Valid Schema
    [Teardown]    Run Keywords    I send a DELETE request:    ${BASE_URL}${ENDPOINT}/7a576652-7a5d-4bdf-864a-a2ad38233caf

Create Warehouse User Assignment - Empty Token
    [Tags]    Negative
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}
    ...    AND    I set Request Body    ${VALID_REQUEST_BODY}
    When I send a POST request:    ${BASE_URL}${ENDPOINT}    data=${REQUEST_BODY}    headers=${HEADERS}
    Then Response status code should be:    403
    And Response Should Be Valid Schema
    [Teardown]    Run Keywords    I send a DELETE request:    ${BASE_URL}${ENDPOINT}/7a576652-7a5d-4bdf-864a-a2ad38233caf

Create Warehouse User Assignment - Incorrect Token
    [Tags]    Negative
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer incorrect_token
    ...    AND    I set Request Body    ${VALID_REQUEST_BODY}
    When I send a POST request:    ${BASE_URL}${ENDPOINT}    data=${REQUEST_BODY}    headers=${HEADERS}
    Then Response status code should be:    403
    And Response Should Be Valid Schema
    [Teardown]    Run Keywords    I send a DELETE request:    ${BASE_URL}${ENDPOINT}/7a576652-7a5d-4bdf-864a-a2ad38233caf

Create_Warehouse_User_Assignment_With_Forbidden
    [Setup]    I get access token by user credentials:    ${user_email}    ${user_password}
    When I send a POST request:    /warehouse-user-assignments
    ...    {"data": {"type": "warehouse-user-assignments","attributes": {"userUuid": "111","warehouse": {"uuid": "222"},"isActive": false}}}
    Then Response status code should be:    403

Create_Warehouse_User_Assignment_With_Validation_Issues
    [Setup]    I get access token by user credentials:    ${user_email}    ${user_password}
    When I send a POST request:    /warehouse-user-assignments
    ...    {"data": {"type": "warehouse-user-assignments","attributes": {"userUuid": "","warehouse": {"uuid": "222"},"isActive": false}}}
    Then Response status code should be:    400

Create_Warehouse_User_Assignment_With_Duplicate_Assignment
    [Setup]    I get access token by user credentials:    ${user_email}    ${user_password}
    When I send a POST request:    /warehouse-user-assignments
    ...    {"data": {"type": "warehouse-user-assignments","attributes": {"userUuid": "111","warehouse": {"uuid": "222"},"isActive": true}}}
    Then Response status code should be:    400

Create_Warehouse_User_Assignment_With_Multiple_Active_Assignments
    [Setup]    I get access token by user credentials:    ${user_email}    ${user_password}
    When I send a POST request:    /warehouse-user-assignments
    ...    {"data": {"type": "warehouse-user-assignments","attributes": {"userUuid": "111","warehouse": {"uuid": "222"},"isActive": true}}}
    And I send a POST request:    /warehouse-user-assignments
    ...    {"data": {"type": "warehouse-user-assignments","attributes": {"userUuid": "111","warehouse": {"uuid": "333"},"isActive": true}}}
    Then Response status code should be:    400


   Get_user_assigments_by_UUID
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_user.email}
     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}    
    # assign several warehouses to one user [only one warehous active]
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehous[0].warehous_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehous_assigment_id_1
    When I send a POST request:    /warehouse-user-assignments?include=users    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehous[0].video_king_warehous_uuid}"},"isActive":"true"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehous_assigment_id_2
    Then I send a GET request:    /warehouse-user-assignments/${warehous_assigment_id_1}
    Then Response status code should be:    200
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehous_assigment_id_1}
    ...  AND    Response status code should be:    204
    ...  AND    I send a DELETE request:    /warehouse-user-assignments/${warehous_assigment_id_2}
    ...  AND    Response status code should be:    204