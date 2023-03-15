*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     SuiteSetup
Test Setup      TestSetup

Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup

Get_abstract_prices_by_concrete_SKU
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:
    ...    /abstract-products/${concrete.alternative_products.product_1.sku}/abstract-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    307
    And Response should return error message:    Can`t find abstract product prices.

Get_abstract_prices_by_fake_SKU
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /abstract-products/fake/abstract-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    307
    And Response should return error message:    Can`t find abstract product prices.

Get_abstract_prices_with_missing_SKU
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /abstract-products//abstract-product-prices
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    311
    And Response should return error message:    Abstract product sku is not specified.

Get_abstract_prices_with_missing_token
    When I send a GET request:    /abstract-products/${abstract.original_prices.sku}/abstract-product-prices
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Get_abstract_prices_with_invalid_token
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    Authorization=fake
    When I send a GET request:    /abstract-products/${abstract.original_prices.sku}/abstract-product-prices
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
