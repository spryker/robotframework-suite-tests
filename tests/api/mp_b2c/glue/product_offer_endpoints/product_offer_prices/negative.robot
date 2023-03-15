*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Retrieve_prices_of_a_product_offer_without_offerId
    When I send a GET request:    /product-offers//product-offer-prices
    Then Response status code should be:    400
    And Response reason should be:   Bad Request
    And Response should return error code:    3702
    And Response should return error message:    Product offer ID is not specified.

Get_product_offer_prices_with_invalid_offerId
   [Documentation]    https://spryker.atlassian.net/browse/CC-24094
    [Tags]    skip-due-to-issue 
    When I send a GET request:    /product-offers/InvalidOfferId/product-offer-prices
    Then Response status code should be:    404
    And Response reason should be:   Not Found
    And Response should return error code:    3701
    And Response should return error message:    Product offer was not found.