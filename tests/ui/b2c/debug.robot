*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Resource    ../../../resources/common/common_ui.robot
Resource    ../../../resources/common/common_yves.robot


*** Test Cases ***

Debug
    [Tags]    debug
    Yves: login on Yves with provided credentials:    sonia@spryker.com
    Yves: check if cart is not empty and clear it