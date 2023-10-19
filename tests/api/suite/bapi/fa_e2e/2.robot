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

Assign_user_to_active_warehouse
    [Tags]    bapi
    And I get access token by user credentials:   ${zed_admin.email}
    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    # make warehouse active [warehouse = Spryker Mer 000001 Warehouse 1]
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].de_admin_user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"true"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id    
