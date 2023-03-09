*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

Generate_new_user_token
    When I set Headers:    Content-Type=application/x-www-form-urlencoded
    When I send a POST request:    /token  {"grantType": "${grant_type.password}","username": "${zed_admin.email}","password": "${zed_admin.password}"}
    Then Response status code should be:    201
    And Response body parameter should be:    [0][token_type]    Bearer
    And Response body parameter should be greater than:    [0][expires_in]    0
    And Response body parameter should be less than:    [0][expires_in]    30000
    And Response body parameter should not be EMPTY:    [0][token_type]
    And Response body parameter should not be EMPTY:    [0][access_token]
    And Response body parameter should not be EMPTY:    [0][refresh_token]

 Generate_new_warehouse_token
    When I set Headers:    Content-Type=application/x-www-form-urlencoded
    When I send a POST request:    /token  {"grantType": "${grant_type.password}","username": "${zed_admin.email}","password": "${zed_admin.password}"}
    Then Response status code should be:    201
    And Save value to a variable:    [0][access_token]   bapi_token
    When I set Headers:    Authorization=${bapi_token}    Content-Type=application/x-www-form-urlencoded
    And I send a POST request:    /warehouse-tokens   {"grantType": "${grant_type.password}","username": "${warehause_user.name}","password": "${warehause_user.password}"}
    Then Response status code should be:    201
    And Response body parameter should be:    [data][type]    warehouse-tokens
    And Response body parameter should be:    [data][attributes]    Bearer
    And Response body parameter should be greater than:    [data][attributes][expiresin]    0
    And Response body parameter should be less than:    [data][attributes][expiresin]    30000
    And Response body parameter should not be EMPTY:    [data][attributes][tokenType]
    And Response body parameter should not be EMPTY:    [data][attributes][accessToken]
    And Response body parameter should not be EMPTY:    [data][attributes][refreshToken]   
    And Response body has correct self link internal