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



Revert_changes
    Make user not a warehouse user:   ${warehous_user[0].user_uuid}    0
    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id}
    Then Remove picking list item by uuid in DB:    ${item_id_1}
    Then Remove picking list item by uuid in DB:    ${item_id_2}    
    Remove picking list item by uuid in DB:    ${pick_list_uuid}


Revert_changes
   When Make user not a warehouse user:   92cd431f-96e3-5259-91cb-ab9f6d14829f    0
   And I send a DELETE request:    /warehouse-user-assignments/4d1ab7a7-8012-58eb-bccf-04dda5fbf4d6
    Then Remove picking list item by uuid in DB:    9ac9fd06-f491-506e-b302-0b166786d91c
    Then Remove picking list item by uuid in DB:    54a264b8-dc2b-5a0e-9a78-ae7138e9d0b5
    Then Remove picking list by uuid in DB:    910a4d20-59a3-5c49-808e-aa7038a59313


