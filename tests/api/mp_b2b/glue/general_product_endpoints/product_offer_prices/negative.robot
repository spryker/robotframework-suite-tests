*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    SuiteSetup
Test Setup    TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Get_product_offer_prices_without_offer_id
    When I send a GET request:    /product-offers//product-offer-prices
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    3702
    And Response should return error message:    Product offer ID is not specified.

#bug MP-6779
Get_product_offer_prices_with_invaild_offer_id
    When I send a GET request:    /product-offers/test/product-offer-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    3701
    And Response should return error message:    Product offer not found. 