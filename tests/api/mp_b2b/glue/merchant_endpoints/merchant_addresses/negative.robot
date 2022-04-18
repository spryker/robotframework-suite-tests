*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup

Retrieves_merchant_addresses_by_non_exist_merchant_id
    When I send a GET request:    /merchants/NonExistId/merchant-addresses
    Then Response status code should be:    404
    And Response should return error code:    3501
    And Response should return error message:    Merchant not found. 

Retrieves_merchant_addresses_witout_pass_merchant_id
    When I send a GET request:    /merchants//merchant-addresses
    Then Response status code should be:    400
    And Response should return error code:    3502
    And Response should return error message:    Merchant identifier is not specified.