*** Settings ***
Library    BuiltIn
Suite Setup       SuiteSetup
Suite Teardown    SuiteTeardown
Test Setup        TestSetup
Test Teardown     TestTeardown
Test Tags    robot:recursive-stop-on-failure
Resource    ../../../../../resources/common/common.robot
Resource    ../../../../../resources/common/common_zed.robot
Resource    ../../../../../resources/steps/zed_users_steps.robot

*** Test Cases ***

Make_user_a_warehouse_user
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: update Zed user:
    ...    || oldEmail                       | password      | user_is_warehouse_user ||
    ...    || admin_de@spryker.com           | Change123!321 | true                   ||



