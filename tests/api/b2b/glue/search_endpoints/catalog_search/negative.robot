*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Default Tags    glue


*** Test Cases ***
ENABLER
    API_test_setup
