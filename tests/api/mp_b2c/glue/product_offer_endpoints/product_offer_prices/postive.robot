*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup


Get_prices_of_a_product_offer
    I send a GET request:    /concrete-products/${merchants.spryker.concrete_product_with_offer_sku}/product-offers
    AND Save value to a variable:    [data][0][id]    offerId
    When I send a GET request:    /product-offers/${offerId}/product-offer-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property with value:    [data]    type    product-offer-prices
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain nested property:    [data]    [attributes]    price
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][price]    int
    And Response body parameter should be greater than:    [data][0][attributes][price]    0
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0]    priceTypeName
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0]    netAmount
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0]    grossAmount
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0]    currency
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][prices][0][currency][code]    ${currency_code_eur}    
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][prices][0][currency][name]    ${currency_name_eur}    
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][prices][0][currency][symbol]    ${currency_symbol_eur}    
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link 