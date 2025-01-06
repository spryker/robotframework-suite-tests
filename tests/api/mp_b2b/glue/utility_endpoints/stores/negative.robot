*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Test Tags    glue

*** Test Cases ***
Get_store_by_non_exist_id
    [Tags]    dms-off
    [Documentation]    https://spryker.atlassian.net/browse/FRW-7427 Test has been skipped for dms-on shop. discussed with Platform team. Bug has low priority can be not fixed soon.
    When I send a GET request:    /stores/NON_EXIST_STORE
    Then Response status code should be:    404
    And Response should return error code:    601
    And Response should return error message:    Store not found.