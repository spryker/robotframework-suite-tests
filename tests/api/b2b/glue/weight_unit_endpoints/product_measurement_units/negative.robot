*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     SuiteSetup
Test Setup      TestSetup

Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup

Get_a_measurement_unit_with_non_existent_unit_id
    When I send a GET request:    /product-measurement-units/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    3402
    And Response should return error message:    Product measurement unit not found.

Get_a_measurement_unit_with_empty
    When I send a GET request:    /product-measurement-units
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    3401
    And Response should return error message:    Product measurement unit code has not been specified.
