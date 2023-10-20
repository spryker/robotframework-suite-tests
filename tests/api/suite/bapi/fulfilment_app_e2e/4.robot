*** Settings ***
Library    BuiltIn
Suite Setup       SuiteSetup
Suite Teardown    SuiteTeardown
Test Setup        TestSetup
Test Teardown     TestTeardown
Test Tags    robot:recursive-stop-on-failure
Resource    ../../../../../resources/common/common.robot
Resource    ../../../../../resources/common/common_yves.robot
Resource    ../../../../../resources/common/common_zed.robot
Resource    ../../../../../resources/steps/orders_management_steps.robot



*** Test Cases ***

Change_OMS_States
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    picking list generation schedule
    # Trigger oms
    Zed: wait for order item to be in state:    091_25873091    ready for picking
    Zed: wait for order item to be in state:    093_24495843    ready for picking

