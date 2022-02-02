*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    bapi
Test Setup    TestSetup

*** Test Cases ***
Get_merchant_relationships
    When I send a GET request:    /merchant-relationships
    Then Response status code should be:    200
    And Response reason should be:    OK

