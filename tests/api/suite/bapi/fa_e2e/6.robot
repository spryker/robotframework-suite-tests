*** Settings ***
Suite Setup       common_api.SuiteSetup
Test Setup        common_api.TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/steps/service_point_steps.robot

Default Tags    bapi


*** Test Cases ***
ENABLER
    common_api.TestSetup


Bapi_move_throe_picking_process
    [Tags]    bapi
    Then I get access token by user credentials:   ${zed_admin.email_de}    Change123!321
    And I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    And I send a GET request:    /picking-lists/?include=picking-list-items,concrete-products,sales-shipments,sales-orders,include=warehouses
    Then Response status code should be:    200
    Then Save value to a variable:    [data][0][id]    picklist_id
    And Response body parameter should be:    [data][0][attributes][status]    ready-for-picking
    Then I send a POST request:   /picking-lists/${picklist_id}/start-picking    {"data": [{"type": "picking-lists","attributes": {"action": "startPicking"}}]}
    Then I send a PATCH request:    /picking-lists/${picklist_id}/picking-list-items    {"data":[{"id":"091_25873091","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"093_24495843","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":0}}]}
    And I send a GET request:    /picking-lists/picklist_id
    And Response body parameter should be:    [data][attribuites][status]    picking-started
    Then I send a PATCH request:    /picking-lists/${picklist_id}/picking-list-items    {"data":[{"id":"091_25873091","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"093_24495843","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":1}}]}
    And Response body parameter should be:    [data][attribuites][status]    picking-finished

