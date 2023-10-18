*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/steps/service_point_steps.robot
Default Tags    bapi


*** Test Cases ***
ENABLER
    TestSetup

Bapi_move_throe_picking
    Then I get access token by user credentials:   ${zed_admin.email}
    And I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    # Check that picking lists created
    And I send a GET request:    /picking-lists/
    # Go to DB and choose last picking list, save uuid to variable picklist
    Then I send a POST request:   /picking-lists/${picklist}/start-picking    {"data":[]}
    Then I send a PATCH request:    /picking-lists/${picklist}/picking-list-items    {"data":[{"id":"${item1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":0}}]}
    # check that status of picking list = started
    Then I send a PATCH request:    /picking-lists/${picklist}/picking-list-items    {"data":[{"id":"${item1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":1}}]}
    # check that status of picking list = finished
    #  check status in BO and finish an order