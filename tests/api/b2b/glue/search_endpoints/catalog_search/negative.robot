*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Default Tags    glue


*** Test Cases ***
ENABLER
    API_test_setup

Search_without_query_parameter
    [Documentation]    bug https://spryker.atlassian.net/browse/CC-15983
    [Tags]    skip-due-to-issue
    When I send a GET request:    /catalog-search?
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    q parameter is missing.
