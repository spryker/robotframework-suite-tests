*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    bapi

*** Test Cases ***
ENABLER
    TestSetup

Assign_user_to_warehous_without_body
    [Setup]    Run Keywords    I get access token by user credentials:    michele@sony-experts.com
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    When I send a POST request with data:    $path    $data