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
