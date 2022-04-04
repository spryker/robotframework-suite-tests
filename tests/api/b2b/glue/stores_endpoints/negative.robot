*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
Get_store_by_non_exist_id
    When I send a GET request:    /stores/NON_EXIST_STORE
    Then Response status code should be:    404
    And Response should return error code:    601
    And Response should return error message:    Store not found.