*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
Get_a_tax_set_with_concrete_sku
    When I send a GET request:    /abstract-products/${abstract_available_product_with_stock.concrete_available_product.sku}/product-tax-sets
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    310
    And Response should return error message:    Product tax sets not found.

Get_a_tax_set_with_missing_sku
    When I send a GET request:    /abstract-products//product-tax-sets
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    301
    And Response should return error message:    Abstract product is not found.

Get_a_tax_set_with_non_existing_sku
    When I send a GET request:    /abstract-products/fake/product-tax-sets
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    310
    And Response should return error message:    Product tax sets not found.
