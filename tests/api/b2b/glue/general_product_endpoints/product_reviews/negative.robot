*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
# bug CC-16486
Get_a_review_with_non_existent_review_id
    When I send a GET request:    /abstract-products/${abstract_product_with_reviews}/product-reviews/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    3402
    And Response should return error message:    Product review not found.

Get_reviews_with_non_existent_abstract_product
    When I send a GET request:    /abstract-products/fake/product-reviews
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    301
    And Response should return error message:    Abstract product is not found.

Get_reviews_with_missing_abstract_product
    When I send a GET request:    /abstract-products//product-reviews
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    311
    And Response should return error message:    Abstract product sku is not specified.

Get_review_by_id_with_missing_abstract_product
    When I send a GET request:    /abstract-products//product-reviews/78
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    311
    And Response should return error message:    Abstract product sku is not specified.

# bug CC-16486
Get_a_reviews_with_non_existent_abstract_product
    When I send a GET request:    /abstract-products/fake/product-reviews/78
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    3402
    And Response should return error message:    Product review not found.

