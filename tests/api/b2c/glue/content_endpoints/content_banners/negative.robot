*** Settings ***
Suite Setup    SuiteSetup
Test Setup     TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
Get_banner_without_id
    When I send a GET request:    /content-banners
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    2202
    And Response should return error message:    Content key is missing.

Get_banner_with_wrong_content_id_type
    When I send a GET request:    /content-banners/${abstract_list.product_id}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    2203
    And Response should return error message:    Content type is invalid.

Get_banner_with_invalid_content_id
    When I send a GET request:    /content-banners/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    2201
    And Response should return error message:    Content not found.
