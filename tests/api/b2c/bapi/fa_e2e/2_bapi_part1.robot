*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/steps/service_point_steps.robot
Default Tags    bapi


*** Test Cases ***
ENABLER
    TestSetup

Activate-warehouse
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    # make warehouse active [warehouse = Spryker Mer 000001 Warehouse 1]
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"true"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id