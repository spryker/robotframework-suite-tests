*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Default Tags    glue
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
ENABLER
    TestSetup
Get_abstract_product_alternative_for_concrete_product_with_invalid_sku_of_product
    When I send a GET request:    /concrete-products/65789/concrete-alternative-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:    Concrete product is not found.


Get_abstract_product_alternative_for_concrete_product_using_abstract_product_SKU
    When I send a GET request:    /concrete-products/${bundle_product.abstract.product_1_sku}/concrete-alternative-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:    Concrete product is not found.