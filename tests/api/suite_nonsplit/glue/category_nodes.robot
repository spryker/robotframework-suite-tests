*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../resources/common/common_api.robot
Default Tags    glue


*** Test Cases ***
###GET###
Request_category_node_in_different_languages
    When I set Headers:    Accept-Language=de
    And I send a GET request:    /category-nodes/${category_node}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    content-language    de_DE
    And Response body parameter should contain:    [data][attributes][url]    /de/
    When I set Headers:    Accept-Language=en
    And I send a GET request:    /category-nodes/${category_node}
    And Response header parameter should be:    content-language    en_US
    And Response body parameter should contain:    [data][attributes][url]    /en/
    Then Response status code should be:    200
    And Response reason should be:    OK
    



My_first_test
    Open Browser    https://translate.google.com/    chromium
    Type Text    xpath=//textarea[@class='er8xn']    dooll
    Sleep    5s
