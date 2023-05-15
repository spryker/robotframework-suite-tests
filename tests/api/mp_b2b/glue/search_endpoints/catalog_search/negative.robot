*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Search_without_query_parameter
    [Documentation]    bug https://spryker.atlassian.net/browse/CC-15983
    [Tags]    skip-due-to-issue
    When I send a GET request:    /catalog-search?
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    q parameter is missing.
