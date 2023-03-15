*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     SuiteSetup
Test Setup      TestSetup

Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup

Get_abstract_product_list_by_fake_id
    When I send a GET request:    /content-product-abstract-lists/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    2201
    And Response should return error message:    Content item not found.

Get_abstract_product_list_products_by_fake_id
    When I send a GET request:    /content-product-abstract-lists/fake/abstract-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    2201
    And Response should return error message:    Content item not found.

Get_abstract_product_list_with_no_id
    When I send a GET request:    /content-product-abstract-lists
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    2202
    And Response should return error message:    Content key is missing.

Get_abstract_product_list_products_with_missing_id
    When I send a GET request:    /content-product-abstract-lists//abstract-products
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    2202
    And Response should return error message:    Content key is missing.

Get_abstract_product_list_products_with_no_id
    When I send a GET request:    /content-product-abstract-lists/abstract-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    2201
    And Response should return error message:    Content item not found.
