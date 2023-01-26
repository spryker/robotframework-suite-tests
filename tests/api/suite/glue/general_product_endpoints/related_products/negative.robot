*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Get_related_products_without_abstract_SKU
    When I send a GET request:    /abstract-products//related-products
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    311
    And Response should return error message:    Abstract product sku is not specified. 
    
Get_related_products_for_nonexistent_SKU
    When I send a GET request:    /abstract-products/not_a_SKU/related-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    301
    And Response should return error message:    Abstract product is not found.

Get_related_products_for_concrete_SKU
    When I send a GET request:    /abstract-products/${concrete_available_product.sku}/related-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    301
    And Response should return error message:    Abstract product is not found.
