*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    SuiteSetup
Test Setup    TestSetup
Default Tags    glue



*** Test Cases ***
ENABLER
    TestSetup

# bug https://spryker.atlassian.net/browse/CC-15983
Search_without_query_parameter
    [Tags]    skip-due-to-refactoring
    When I send a GET request:    /catalog-search?
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    q parameter is missing.
