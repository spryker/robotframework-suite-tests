*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Request_concrete_availability_by_abstract_SKU
    When I send a GET request:    /concrete-products/${abstract_product_with_alternative_sku}/concrete-product-availabilities
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    306
    And Response should return error message:    Availability is not found.

Request_concrete_availability_by_invalid_SKU
    When I send a GET request:    /concrete-products/124124/concrete-product-availabilities
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    306
    And Response should return error message:    Availability is not found.

Request_concrete_availability_with_missing_concrete_SKU
    When I send a GET request:    /concrete-products//concrete-product-availabilities
    Then Response status code should be:    400
    And Response reason should be:   Bad Request
    And Response should return error code:    312
    And Response should return error message:    Concrete product sku is not specified.

Request_concrete_availability_by_sku_with_error_in_request
    When I send a GET request:    /concrete-products/${concrete_product_with_alternative_sku}/concrete-product-availassbilities
    Then Response status code should be:    404
    And Response reason should be:   Not Found
    And Response should return error message:    Not Found

Request_concrete_availability_by_special_characters
    When I send a GET request:    /concrete-products/±!@#$%^&*()/concrete-product-availabilities
    Then Response status code should be:    404
    And Response reason should be:   Not Found
    And Response should return error code:    302
    And Response should return error message:    Concrete product is not found.

Request_concrete_availability_by_using_wrong_method_POST
    When I send a POST request:    /concrete-products/${concrete_product_with_alternative_sku}/concrete-product-availabilities    {}
    Then Response status code should be:    404
    And Response reason should be:   Not Found
    And Response should return error message:    Not Found

Request_concrete_availability_by_using_wrong_method_PATCH
    When I send a PATCH request:    /concrete-products/${concrete_product_with_alternative_sku}/concrete-product-availabilities    {}
    Then Response status code should be:    404
    And Response reason should be:   Not Found
    And Response should return error message:    Not Found

Request_concrete_availability_by_using_wrong_method_PUT
    When I send a PUT request:    /concrete-products/${concrete_product_with_alternative_sku}/concrete-product-availabilities    {}
    Then Response status code should be:    404
    And Response reason should be:   Not Found
    And Response should return error message:    Not Found

Request_concrete_availability_by_using_wrong_method_DELETE
    When I send a DELETE request:    /concrete-products/${concrete_product_with_alternative_sku}/concrete-product-availabilities
    Then Response status code should be:    404
    And Response reason should be:   Not Found
    And Response should return error message:    Not Found