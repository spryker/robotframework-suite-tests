*** Settings ***
Suite Setup    SuiteSetup
Test Setup     TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
Get_abstract_product_alternative_for_concrete_product_with_invalid_sku_of_product
    When I send a GET request:    /concrete-products/65789/concrete-alternative-products
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Concrete product is not found.

Get_abstract_product_alternative_for_concrete_product_using_abstract_product_SKU
    When I send a GET request:    /concrete-products/${bundled.product_1.abstract_sku}/concrete-alternative-products
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Concrete product is not found.

Get_abstract_product_alternative_for_concrete_product_with_empty_SKU
    When I send a GET request:    /concrete-products//concrete-alternative-products
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    312
    And Response should return error message:   Concrete product sku is not specified.
