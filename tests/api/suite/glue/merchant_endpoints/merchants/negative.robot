*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue



*** Test Cases ***
ENABLER
    TestSetup
    
Retrieves_merchant_by_non_exist_id
    When I send a GET request:    /merchants/NonExistId
    Then Response status code should be:    404
    And Response should return error code:    3501
    And Response should return error message:    Merchant not found.