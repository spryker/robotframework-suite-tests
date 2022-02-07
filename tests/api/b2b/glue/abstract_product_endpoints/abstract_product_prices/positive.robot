*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Abstract_prices_detault_only
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /abstract-products/${abstract_available_product_with_3_concretes}/abstract-product-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][id]    ${abstract_available_product_with_3_concretes}
    And Response body parameter should be greater than:    [data][0][attributes][price]   100
    And Save value to a variable:    [data][0][attributes][price]    default_price
    And Response should contain the array of a certain size:    [data][0][attributes][prices]    1
    And Response body parameter should be:    [data][0][attributes][prices][0][priceTypeName]    DEFAULT
    And Response body parameter should be:    [data][0][attributes][prices][0][netAmount]    None
    And Response body parameter should be:    [data][0][attributes][prices][0][grossAmount]    ${default_price}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][code]    ${currency_code_eur}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][name]    ${currency_name_eur}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][symbol]    ${currency_symbol_eur}
    And Response should contain the array of a certain size:    [data][0][attributes][prices][0][volumePrices]   0
    And Response body has correct self link

# Bug in B2B - volume prices arre not shown in glue
Abstract_volume_prices
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /abstract-products/${abstract_product_with_volume_prices}/abstract-product-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][id]    ${abstract_product_with_volume_prices}
    And Response body parameter should be greater than:    [data][0][attributes][price]   100
    And Save value to a variable:    [data][0][attributes][price]    default_price
    And Response should contain the array of a certain size:    [data][0][attributes][prices]    1
    And Response body parameter should be:    [data][0][attributes][prices][0][priceTypeName]    DEFAULT
    And Response body parameter should be:    [data][0][attributes][prices][0][netAmount]    None
    And Response body parameter should be:    [data][0][attributes][prices][0][grossAmount]    ${default_price}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][code]    ${currency_code_eur}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][name]    ${currency_name_eur}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][symbol]    ${currency_symbol_eur}
    And Response should contain the array of a certain size:    [data][0][attributes][prices][0][volumePrices]   3
    And Each array element of array in response should contain property:    [data][0][attributes][prices][0][volumePrices]    grossAmount
    And Each array element of array in response should contain property:    [data][0][attributes][prices][0][volumePrices]    netAmount
    And Each array element of array in response should contain property:    [data][0][attributes][prices][0][volumePrices]    quantity
    And Response body parameter should be greater than:    [data][0][attributes][prices][0][volumePrices][0][grossAmount]    1
    And Response body parameter should be greater than:    [data][0][attributes][prices][0][volumePrices][0][netAmount]    1
    And Response body parameter should be greater than:    [data][0][attributes][prices][0][volumePrices][0][quantity]    1
    And Response body has correct self link

Abstract_prices_original_price
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /abstract-products/${abstract_product_with_original_prices}/abstract-product-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][id]    ${abstract_product_with_original_prices}
    And Response body parameter should be greater than:    [data][0][attributes][price]   100
    And Save value to a variable:    [data][0][attributes][price]    default_price
    And Response should contain the array of a certain size:    [data][0][attributes][prices]    2
    And Response body parameter should be:    [data][0][attributes][prices][0][priceTypeName]    DEFAULT
    And Response body parameter should be:    [data][0][attributes][prices][0][grossAmount]    ${default_price}
    And Response body parameter should be:    [data][0][attributes][prices][1][priceTypeName]    ORIGINAL
    And Response body parameter should be greater than:    [data][0][attributes][prices][1][grossAmount]   ${default_price}
    And Each array element of array in response should contain property with value:    [data][0][attributes][prices]    netAmount    None
    And Each array element of array in response should contain value:    [data][0][attributes][prices]    ${currency_code_eur}
    And Each array element of array in response should contain value:    [data][0][attributes][prices]    ${currency_name_eur}
    And Each array element of array in response should contain value:    [data][0][attributes][prices]    ${currency_symbol_eur}
    And Each array element of array in response should contain property with value:    [data][0][attributes][prices]    volumePrices    []
    And Response body has correct self link