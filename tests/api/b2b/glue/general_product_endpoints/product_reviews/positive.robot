*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***

Get_product_reviews
    When I send a GET request:    /abstract-products/${abstract_product_with_reviews}/product-reviews
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    ${abstract_product_with_reviews_qty}
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body parameter should be:    [data][0][type]    product-reviews
    And Response body parameter should not be EMPTY:    [data][0][attributes][rating]
    And Response body parameter should not be EMPTY:    [data][0][attributes][nickname]
    And Response body parameter should not be EMPTY:    [data][0][attributes][summary]
    And Response body parameter should not be EMPTY:    [data][0][attributes][description]
    And Response body parameter should not be EMPTY:    [data][0][links][self]
    Each array element of array in response should contain nested property:    [data]    [attributes]    rating
    Each array element of array in response should contain nested property:    [data]    [attributes]    nickname
    Each array element of array in response should contain nested property:    [data]    [attributes]    summary
    Each array element of array in response should contain nested property:    [data]    [attributes]    description
    Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link

Get_product_reviews_for_product_with_no_reviews
    When I send a GET request:    /abstract-products/${abstract_available_with_stock_and_never_out_of_stock}/product-reviews
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    0
    And Response body has correct self link

# bug CC-16486
Get_product_review_by_id
    [Setup]    Run Keywords    I send a GET request:    /abstract-products/${abstract_product_with_reviews}/product-reviews
    ...    AND    Save value to a variable:    [data][0][id]    review_id
    When I send a GET request:    /abstract-products/${abstract_product_with_reviews}/product-reviews/${review_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    ${abstract_product_with_reviews_qty}
    And Response body parameter should be:    [data][id]    ${review_id}
    And Response body parameter should be:    [data][type]    product-reviews
    And Response body parameter should not be EMPTY:    [data][attributes][rating]
    And Response body parameter should not be EMPTY:    [data][attributes][nickname]
    And Response body parameter should not be EMPTY:    [data][attributes][summary]
    And Response body parameter should not be EMPTY:    [data][attributes][description]
    And Response body parameter should not be EMPTY:    [data][links][self]

