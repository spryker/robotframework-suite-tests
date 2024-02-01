*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    API_test_setup

Get_abstract_prices_by_concrete_SKU
    When I send a GET request:    /abstract-products/${product_with_alternative.concrete_sku}/abstract-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    307
    And Response should return error message:    Can`t find abstract product prices.

Get_abstract_prices_by_fake_SKU
    When I send a GET request:    /abstract-products/fake/abstract-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    307
    And Response should return error message:    Can`t find abstract product prices.

Get_abstract_prices_with_missing_SKU
    When I send a GET request:    /abstract-products//abstract-product-prices
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    311
    And Response should return error message:    Abstract product sku is not specified.  