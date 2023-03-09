*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

New_warehouse_token_without_autorization
    And I send a POST request:    /warehouse-tokens   {"grantType": "${grant_type.password}","username": "${warehause_user.name}","password": "${warehause_user.password}"}
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized
    And Response should return error code:    003
    And Response should return error message:    Autorization is required.

New_warehouse_token_with_invalid_token
    When I set Headers:    Authorization=fake_token    Content-Type=application/x-www-form-urlencoded
    And I send a POST request:    /warehouse-tokens   {"grantType": "${grant_type.password}","username": "${warehause_user.name1}","password": "${warehause_user.password1}"}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    003
    And Response should return error message:    Failed to authenticate user.

New_warehouse_token_for_admin_user_who_is_not_a_WH_user
    When I set Headers:    Authorization=fake_token    Content-Type=application/x-www-form-urlencoded
    And I send a POST request:    /warehouse-tokens   {"grantType": "${grant_type.password}","username": "${admin_not_warehause_user.name}","password": "${admin_not_warehause_user.password}"}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    003
    And Response should return error message:    Failed to authenticate user.    