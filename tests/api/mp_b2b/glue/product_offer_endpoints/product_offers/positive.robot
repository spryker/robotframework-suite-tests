*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Get_concrete_product_without_offers
    When I send a GET request:    /concrete-products/${bundle_product_concrete_sku}/product-offers
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    0

# Due to the MP-6749 there is no product-offer-prices include displayed
Get_all_concrete_product_offer_info_with_product_offer_prices_and_product_offer_availabilities_and_merchants_included
    When I send a GET request:    /concrete-products/${concrete_product_with_volume_prices}/product-offers?include=product-offer-prices,product-offer-availabilities,merchants
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][id]    ${second_offer_with_vp}
    And Response body parameter should be:    [data][0][type]    product-offers
    And Response body parameter should be in:    [data][0][attributes][isDefault]    True    False
    And Response body parameter should be:    [data][0][attributes][merchantReference]    ${second_merchant_reference}
    And Response body parameter should not be EMPTY:    [data][0][links][self]
    And Response body parameter should contain:    [data][0][attributes]    merchantSku
    And Response should contain the array of a certain size:    [included]    4
    And Response should contain the array of a certain size:    [data][0][relationships]    2
    And Response include should contain certain entity type:    product-offer-prices
    # And Response include should contain certain entity type:    product-offer-availabilities
    And Response include should contain certain entity type:    merchants
    And Response include element has self link:    product-offer-prices
    # And Response include element has self link:    product-offer-availabilities
    And Response include element has self link:    merchants
    And Response body has correct self link

# Due to the MP-6749 there is no product-offer-prices include displayed
Get_all_product_offer_info_with_product_offer_prices_and_product_offer_availabilities_and_merchants_included
    When I send a GET request:    /product-offers/${offer}?include=product-offer-prices,product-offer-availabilities,merchants
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response body parameter should be:    [data][attributes][merchantReference]    ${merchant_reference}
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response body parameter should be greater than:    [data][attributes][merchantSku]    1
    And Response should contain the array of a certain size:    [included]    2
    And Response should contain the array of a certain size:    [data][relationships]    2
    And Response include should contain certain entity type:    product-offer-prices
    # And Response include should contain certain entity type:    product-offer-availabilities
    And Response include should contain certain entity type:    merchants
    And Response include element has self link:    product-offer-prices
    # And Response include element has self link:    product-offer-availabilities
    And Response include element has self link:    merchants

Get_product_offer_without_volume_prices
    When I send a GET request:    /product-offers/${offer_without_vp}?include=product-offer-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_without_vp}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    product-offer-prices
    And Response include element has self link:    product-offer-prices
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][volumePrices]    0

Get_product_offer_with_gross_eur_volume_prices
    When I send a GET request:    /product-offers/${offer_with_vp}?include=product-offer-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_with_vp}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    product-offer-prices
    And Response include element has self link:    product-offer-prices
    And Response body parameter should be:    [included][0][attributes][prices][0][netAmount]    None
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][grossAmount]    0
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][volumePrices]    3
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][grossAmount]    int
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][netAmount]    int
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][quantity]    int
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][currency]    3
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    ${currency_code_eur}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    ${currency_name_eur}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    ${currency_symbol_eur}

Get_product_offer_with_net_eur_volume_prices
    When I send a GET request:    /product-offers/${offer_with_vp}?include=product-offer-prices&priceMode=${net_mode}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_with_vp}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    product-offer-prices
    And Response include element has self link:    product-offer-prices
    And Response body parameter should be:    [included][0][attributes][prices][0][grossAmount]    None
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][netAmount]    1
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][volumePrices]    3
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][grossAmount]    int
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][netAmount]    int
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][quantity]    int
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][currency]    3
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    ${currency_code_eur}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    ${currency_name_eur}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    ${currency_symbol_eur}

Get_product_offer_with_gross_chf_volume_prices
    When I send a GET request:    /product-offers/${offer_with_vp}?include=product-offer-prices&currency=${currency_code_chf}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_with_vp}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    product-offer-prices
    And Response include element has self link:    product-offer-prices
    And Response body parameter should be:    [included][0][attributes][prices][0][netAmount]    None
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][grossAmount]    1
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][currency]    3
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    ${currency_code_chf}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    ${currency_name_chf}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    ${currency_symbol_chf}

Get_product_offer_with_net_chf_volume_prices
    When I send a GET request:    /product-offers/${offer_with_vp}?include=product-offer-prices&priceMode=${net_mode}&currency=${currency_code_chf}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_with_vp}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    product-offer-prices
    And Response include element has self link:    product-offer-prices
    And Response body parameter should be:    [included][0][attributes][prices][0][grossAmount]    None
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][netAmount]    1
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][currency]    3
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    ${currency_code_chf}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    ${currency_name_chf}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    ${currency_symbol_chf}