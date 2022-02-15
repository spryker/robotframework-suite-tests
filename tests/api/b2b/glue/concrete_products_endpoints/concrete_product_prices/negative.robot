*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Request_product_prices_with_abstract_sku
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    When I send a GET request:    /concrete-products/${bundled_product_1_abstract_sku}/concrete-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    308
    And Response should return error message:    Can`t find concrete product prices.

Request_product_prices_with_empty_SKU
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token} 
    When I send a GET request:    /concrete-products//concrete-product-prices
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    312
    And Response should return error message:    Concrete product sku is not specified.

Request_product_prices_with_error_in_request
    When I send a GET request:    /concrete-products/${concrete_product_one_image_set}/concrete-product-pricess
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:     Not Found

Request_product_prices_with_special_characters
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    When I send a GET request:    /concrete-products/~!@#$%^&*()_+/concrete-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:     Concrete product is not found.

Request_product_prices_by_concrete_sku_product_doesn't_exist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Authorization=${token}  
    When I send a GET request:    /concrete-products/4567890/concrete-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    308
    And Response should return error message:     Can`t find concrete product prices.

Request_product_prices_using_wrong_method_POST
    When I send a POST request with data:    /concrete-products/${concrete_product_multiple_image_set}/concrete-product-prices    {}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:     Not Found

Request_product_prices_using_wrong_method_PATCH
    When I send a PATCH request with data    /concrete-products/${concrete_product_multiple_image_set}/concrete-product-prices    {}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:     Not Found

Request_product_prices_using_wrong_method_DELETE
    When I send a DELETE request:   /concrete-products/${concrete_product_multiple_image_set}/concrete-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:     Not Found

Request_product_prices_using_wrong_method_PUT
    When I send a PUT request:    /concrete-products/${concrete_product_multiple_image_set}/concrete-product-prices    {}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:     Not Found