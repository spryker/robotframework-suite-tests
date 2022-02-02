*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Get_alternative_abstract_with_nonexistant_SKU
    When I send a GET request:    /concrete-products/fake/abstract-alternative-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:    Concrete product is not found.

Get_alternative_abstract_with_abstract_SKU
    When I send a GET request:    /concrete-products/${abstract_product_with_alternative_sku}/abstract-alternative-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:    Concrete product is not found.