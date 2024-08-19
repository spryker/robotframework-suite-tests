*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    API_test_setup
