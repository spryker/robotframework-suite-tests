*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue


*** Test Cases ***
Get_cms_page_list_by_fake_id
    When I send a GET request:    /cms-pages/:cms
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    3801
    And Response should return error message:    Cms page not found.

Get_cms_page_list_by_wrond_id
    When I send a GET request:    /cms-pages/${abstract_list.id}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    3801
    And Response should return error message:    Cms page not found.
