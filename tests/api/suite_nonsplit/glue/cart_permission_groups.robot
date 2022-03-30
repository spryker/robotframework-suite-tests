*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../resources/common/common_api.robot
Default Tags    glue


*** Test Cases ***
request_get_quote_permission_group_without_id
    When I send a GET request:    /cart-permission-groups
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type=application/vnd.api+json    Server=nginx    Transfer-Encoding=chunked
    