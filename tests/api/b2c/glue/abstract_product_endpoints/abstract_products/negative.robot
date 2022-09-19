*** Settings ***
Suite Setup    SuiteSetup
Test Setup     TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
Get_abstract_product_by_concrete_SKU
    When I send a GET request:    /abstract-products/${concrete_product_with_abstract_product_alternative.sku}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    301
    And Response should return error message:    Abstract product is not found.

Get_abstract_product_by_fake_SKU
    When I send a GET request:    /abstract-products/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    301
    And Response should return error message:    Abstract product is not found.

Get_abstract_product_with_missing_SKU
    When I send a GET request:    /abstract-products/
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    311
    And Response should return error message:    Abstract product sku is not specified. 
