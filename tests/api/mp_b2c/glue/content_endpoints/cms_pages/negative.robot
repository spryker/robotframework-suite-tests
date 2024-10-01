*** Settings ***
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        API_test_setup
Test Tags    glue

*** Test Cases ***
ENABLER
    API_test_setup

Get_cms_page_list_by_fake_id
    When I send a GET request:    /cms-pages/:cms
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    3801
    And Response should return error message:    Cms page not found.

Get_cms_page_list_by_wrond_id
    When I send a GET request:    /cms-pages/${abstract_list.product_id}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    3801
    And Response should return error message:    Cms page not found.

