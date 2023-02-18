*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     SuiteSetup
Test Setup      TestSetup

Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup
######POST#####

ENABLER
    TestSetup

Get_a_label_without_label_id
    When I send a GET request:    /product-labels
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    1202
    And Response should return error message:    Product label id is missing.

Get_a_label_with_non_existent_label_id
    When I send a GET request:    /product-labels/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    1201
    And Response should return error message:    Product label is not found.
