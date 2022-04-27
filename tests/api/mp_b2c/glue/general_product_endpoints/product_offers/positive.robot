*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    SuiteSetup
Test Setup    TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Retrieving_product_offer
    When I send a GET request:    /product-offers/${product_offer_reference_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][id]    ${product_offer_reference_id}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be:    [data][attributes][merchantSku]    None
    And Response body parameter should not be EMPTY:    [data][attributes][merchantReference]
    And Response body parameter should not be EMPTY:    [data][attributes][isDefault]
    And Response body has correct self link internal

Retrieving_product_offer_including_product_offer_prices
    When I send a GET request:    /product-offers/${product_offer_reference_id}?include=product-offer-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][id]    ${product_offer_reference_id}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be:    [data][attributes][merchantSku]    None
    And Response body parameter should not be EMPTY:    [data][attributes][merchantReference]
    And Response body parameter should not be EMPTY:    [data][attributes][isDefault]
    And Response body has correct self link internal
    And Response body parameter should be greater than:    [data][relationships]    0
    And Response body parameter should not be EMPTY:    [data][relationships][product-offer-prices][data]
    And Response include element has self link:    product-offer-prices
    And Each array element of array in response should contain nested property with value:        [included]    [attributes][price]    9000
    And Each array element of array in response should contain nested property with value:        [included]    id    ${product_offer_reference_id}
    And Each array element of array in response should contain nested property:     [included]    type       product-offer-prices
    And Response should contain the array larger than a certain size:    [included]    0
  
Retrieving_product_offer_including_product_offer_availabilities
    When I send a GET request:    /product-offers/${product_offer_reference_id}?include=product-offer-availabilities
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][id]    ${product_offer_reference_id}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be:    [data][attributes][merchantSku]    None
    And Response body parameter should not be EMPTY:    [data][attributes][merchantReference]
    And Response body parameter should not be EMPTY:    [data][attributes][isDefault]
    And Response body has correct self link internal
    And Response body parameter should be greater than:    [data][relationships]    0
    And Response body parameter should not be EMPTY:    [data][relationships][product-offer-availabilities][data]
    And Response include element has self link:    product-offer-availabilities
    And Each array element of array in response should contain nested property with value:        [included]    id    ${product_offer_reference_id}
    And Each array element of array in response should contain nested property:     [included]    type       product-offer-availabilities
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes    None

Retrieving_product_offer_including_merchants
    When I send a GET request:    /product-offers/${product_offer_reference_id}?include=merchants
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][id]    ${product_offer_reference_id}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be:    [data][attributes][merchantSku]    None
    And Response body parameter should not be EMPTY:    [data][attributes][merchantReference]
    And Response body parameter should not be EMPTY:    [data][attributes][isDefault]
    And Response body has correct self link internal
    And Response body parameter should be greater than:    [data][relationships]    0
    And Response body parameter should not be EMPTY:    [data][relationships][merchants][data]
    And Response include element has self link:    merchants
    And Each array element of array in response should contain nested property:     [included]    type       merchants
    And Each array element of array in response should contain property with value NOT in:    [included]    type    None
    And Each array element of array in response should contain property with value NOT in:    [included]    attributes    None