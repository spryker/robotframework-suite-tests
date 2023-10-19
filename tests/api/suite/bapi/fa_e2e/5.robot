*** Settings ***
Suite Setup       common_api.SuiteSetup
Test Setup        common_api.TestSetup
# Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/steps/service_point_steps.robot
Resource     ../../../../../resources/common/common.robot
Resource    ../../../../../resources/common/common_zed.robot
# Resource    ../../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../../resources/steps/zed_users_steps.robot

Default Tags    bapi


*** Test Cases ***
ENABLER
    common_api.TestSetup


# Change_OMS_States
#     [Setup]    Run Keywords    common.SuiteSetup    AND    common.TestSetup
#     Zed: login on Zed with provided credentials:    ${zed_admin.email}
#     Zed: go to order page:    ${lastPlacedOrder}
#     Zed: click Action Button in a table for row that contains:    $row_content    $zed_table_action_button_locator
#     Wait Until Element Is Visible    $locator
#     Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay

