*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***

# bug https://spryker.atlassian.net/browse/CC-15983
Search_without_query_parameter
    When I send a GET request:    /catalog-search?q=
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    q parameter is missing.



   