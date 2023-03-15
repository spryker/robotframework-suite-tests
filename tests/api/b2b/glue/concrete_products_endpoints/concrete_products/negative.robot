*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     SuiteSetup
Test Setup      TestSetup

Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup

Request_product_concrete_with_product_doesn't_exist
    When I send a GET request:    /concrete-products/354656u7i8
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:    Concrete product is not found.

Request_product_concrete_with_abstract_SKU
    When I send a GET request:    /concrete-products/${bundle_product.product_2.abstract_sku}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:    Concrete product is not found.

Request_product_concrete_with_empty_SKU
    When I send a GET request:    /concrete-products/
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    312
    And Response should return error message:    Concrete product sku is not specified.

Request_product_concrete_with_special_characters
    When I send a GET request:    /concrete-products/~!@#$%^&*()_+/
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:    Concrete product is not found.
