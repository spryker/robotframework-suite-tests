*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Get_abstract_product_alternative_for_concrete_product_with_invalid_sku_of_product
    When I send a GET request:    /concrete-products/65789/concrete-alternative-products
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Concrete product is not found.

Get_abstract_product_alternative_for_concrete_product_using_abstract_product_SKU
    When I send a GET request:    /concrete-products/${bundled_product_1_abstract_sku}/concrete-alternative-products
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Concrete product is not found.
