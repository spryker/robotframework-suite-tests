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


# Bapi_move_throe_picking_process
#     [Tags]    bapi
#     Then I get access token by user credentials:   ${zed_admin.email_de}
#     And I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
# #     # Check that picking lists created
#     And I send a GET request:    /picking-lists/?include=picking-list-items,concrete-products,sales-shipments,sales-orders
#     Then Save value to a variable:    [data][id]    cart_id

#     # Go to DB and choose last picking list, save uuid to variable picklist
#     Then I send a POST request:   /picking-lists/${picklist}/start-picking    {"data":[]}
#     Then I send a PATCH request:    /picking-lists/${picklist}/picking-list-items    {"data":[{"id":"${item1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":0}}]}
#     # check that status of picking list = started
#     Then I send a PATCH request:    /picking-lists/${picklist}/picking-list-items    {"data":[{"id":"${item1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":1}}]}
#     # check that status of picking list = finished
#     #  check status in BO and finish an order

