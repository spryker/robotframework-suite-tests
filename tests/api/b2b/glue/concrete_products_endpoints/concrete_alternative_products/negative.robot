*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Get abstract product alternative for concrete product with an invalid endpoint
    When I send a GET request:    /concrete-products/${concrete_product_with_alternative_sku}/concrete-alternative-product
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Not Found

Get abstract product alternative for concrete product with invalid sku of product
    When I send a GET request:    /concrete-products/${concrete_product_with_invalid_sku}/concrete-alternative-products
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Concrete product is not found.

Get abstract product alternative for concrete product using abstract product SKU
    When I send a GET request:    /concrete-products/${bundled_product_1_abstract_sku}/concrete-alternative-products
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Concrete product is not found.

Get abstract product alternative for concrete product with wrong method (POST)
    When I send a POST request:    /concrete-products/${concrete_product_with_invalid_sku}/concrete-alternative-products    {} 
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Not Found

Get product alternative for concrete product with wrong method (PUT)
    When I send a PUT request:    /concrete-products/${concrete_product_with_invalid_sku}/concrete-alternative-products    {} 
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Not Found

Get product alternative for concrete product with wrong method (PATCH)
    When I send a PATCH request:    /concrete-products/${concrete_product_with_invalid_sku}/concrete-alternative-products    {} 
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Not Found

Get product alternative for concrete product with wrong method (DELETE)
    When I send a DELETE request:   /concrete-products/${concrete_product_with_invalid_sku}/concrete-alternative-products
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Not Found