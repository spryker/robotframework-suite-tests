*** Settings ***
Suite Setup       common_api.SuiteSetup
Test Setup        common_api.TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/steps/service_point_steps.robot
Resource     ../../../../../resources/common/common.robot
Resource    ../../../../../resources/common/common_zed.robot
# Resource    ../../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../../resources/steps/zed_users_steps.robot

Default Tags    bapi


*** Test Cases ***
ENABLER
    common_api.TestSetup


Create_order_in_Glue
    Trigger oms
    And Update order status in Database:    picking list generation scheduled    ${uuid}
    Trigger oms
    And Update order status in Database:    picking list generation started    ${uuid}
    Trigger oms  
    And Update order status in Database:    ready for picking    ${uuid}
    Trigger oms
