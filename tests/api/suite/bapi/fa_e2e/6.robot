*** Settings ***
Suite Setup       common_api.SuiteSetup
Test Setup        common_api.TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/steps/warehouse_user_assigment_steps.robot
Resource    ../../../../../resources/steps/picking_list_steps.robot


Default Tags    bapi


*** Test Cases ***
ENABLER
    common_api.TestSetup



# Revert_changes
#     Make user not a warehouse user:   ${warehous_user[0].user_uuid}    0
#     I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id}
#     Remove picking list item by uuid in DB:    ${pick_list_uuid}


Revert_changes
    Make user not a warehouse user:   ${warehous_user[0].user_uuid}    0
    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id}
    Remove picking list item by uuid in DB:    ${pick_list_uuid}


