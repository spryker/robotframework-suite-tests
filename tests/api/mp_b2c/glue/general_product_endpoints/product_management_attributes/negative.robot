*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
    
Get_an_attribute_with_non_existent_attribute_id
    When I send a GET request:    /product-management-attributes/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    4201
    And Response should return error message:    Attribute not found.
