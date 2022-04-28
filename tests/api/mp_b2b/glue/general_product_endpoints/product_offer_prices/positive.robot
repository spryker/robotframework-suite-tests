*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    SuiteSetup
Test Setup    TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
Retrieve_prices_of_a_product_offer
    When I send a GET request:    /product-offers/${merchant_offer_id}/product-offer-prices
    Then Response reason should be:    OK
    And Response status code should be:    200
    And Response body parameter should be:    [data][0][type]    product-offer-prices
    And Response body parameter should be:    [data][0][id]    ${merchant_offer_id}
    And Response body parameter should be:    [data][0][attributes][price]    ${merchant_offer_price}
    And Response body parameter should not be EMPTY:    [data][0][attributes][prices]
    And Response body has correct self link