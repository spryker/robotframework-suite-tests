*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Get_concrete_product_offers
    When I send a GET request:    /concrete-products/091_25873091/product-offers
    Then Response status code should be:    200
    And Response reason should be:    OK

Get_all_product_offer_info_product_offer_prices_included
    When I send a GET request:    /product-offers/${offer}?include=product-offer-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should not be EMPTY:    [data][attributes][merchantReference]
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response body parameter should be greater than:    [data][attributes][merchantSku]    1
    And Response should contain the array of a certain size:    [data][relationships][product-offer-prices][data]    1
    And Response body parameter should be:    [data][relationships][product-offer-prices][data][0][id]    ${offer}
    And Response body parameter should be:    [data][relationships][product-offer-prices][data][0][type]    product-offer-prices
    And Response should contain the array of a certain size:    [included]    1
    And Response include should contain certain entity type:    product-offer-prices
    And Response body parameter should be:    [included][0][id]    ${offer}
    And Response body parameter should be:    [included][0][type]    product-offer-prices
    And Response body parameter should be greater than:    [included][0][attributes][price]    0
    And Response body parameter should be:    [included][0][attributes][prices][0][priceTypeName]    DEFAULT
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][netAmount]    1
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][grossAmount]    0
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][currency]    3
    And Response body parameter should not be EMPTY:    [included][0][attributes][prices][0][currency][code]
    And Response body parameter should not be EMPTY:    [included][0][attributes][prices][0][currency][name]
    And Response body parameter should not be EMPTY:    [included][0][attributes][prices][0][currency][symbol]
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][volumePrices]    0
    And Response body parameter should be:    [included][0][attributes][prices][1][priceTypeName]    ORIGINAL
    And Response body parameter should be greater than:    [included][0][attributes][prices][1][netAmount]    1
    And Response body parameter should be greater than:    [included][0][attributes][prices][1][grossAmount]    0
    And Response should contain the array of a certain size:    [included][0][attributes][prices][1][currency]    3
    And Response body parameter should not be EMPTY:    [included][0][attributes][prices][1][currency][code]
    And Response body parameter should not be EMPTY:    [included][0][attributes][prices][1][currency][name]
    And Response body parameter should not be EMPTY:    [included][0][attributes][prices][1][currency][symbol]
    And Response should contain the array of a certain size:    [included][0][attributes][prices][1][volumePrices]    0

Get_product_offer_without_volume_prices
    When I send a GET request:    /product-offers/${offer_without_vp}?include=product-offer-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_without_vp}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][volumePrices]    0

Get_product_offer_with_gross_eur_volume_prices
    When I send a GET request:    /product-offers/${offer_with_vp}?include=product-offer-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_with_vp}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should be:    [included][0][attributes][prices][0][netAmount]    None
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][grossAmount]    0
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][volumePrices]    3
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][grossAmount]    int
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][netAmount]    int
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][quantity]    int
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][currency]    3
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    EUR
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    Euro
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    €

Get_product_offer_with_net_eur_volume_prices
    When I send a GET request:    /product-offers/${offer_with_vp}?include=product-offer-prices&priceMode=NET_MODE
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_with_vp}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should be:    [included][0][attributes][prices][0][grossAmount]    None
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][netAmount]    1
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][volumePrices]    3
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][grossAmount]    int
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][netAmount]    int
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][quantity]    int
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][currency]    3
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    EUR
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    Euro
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    €

Get_product_offer_with_gross_chf_volume_prices
    When I send a GET request:    /product-offers/${offer_with_vp}?include=product-offer-prices&currency=CHF
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_with_vp}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should be:    [included][0][attributes][prices][0][netAmount]    None
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][grossAmount]    1
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][currency]    3
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    CHF
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    Swiss Franc
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    CHF

Get_product_offer_with_net_chf_volume_prices
    When I send a GET request:    /product-offers/${offer_with_vp}?include=product-offer-prices&priceMode=NET_MODE&currency=CHF
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_with_vp}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should be:    [included][0][attributes][prices][0][grossAmount]    None
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][netAmount]    1
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][currency]    3
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    CHF
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    Swiss Franc
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    CHF