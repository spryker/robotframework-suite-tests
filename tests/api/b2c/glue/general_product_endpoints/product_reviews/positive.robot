*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Default Tags    glue
Resource    ../../../../../../resources/common/common_api.robot


*** Test Cases ***
ENABLER
    TestSetup

Get_product_reviews
    When I send a GET request:    /abstract-products/${abstract_product.with_reviews.sku}/product-reviews
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain nested property with value:    [data]    type    product-reviews
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain nested property:    [data]    [attributes]    rating
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][rating]    int
    And Each array element of array in response should contain nested property:    [data]    [attributes]    nickname
    And Each array element of array in response should contain nested property:    [data]    [attributes]    summary
    And Each array element of array in response should contain nested property:    [data]    [attributes]    description
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link



Get_subset_of_product_reviews
    When I send a GET request:    /abstract-products/${abstract_product.with_reviews.sku}/product-reviews?page[offset]=1&page[limit]=1 
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    1
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body parameter should be:    [data][0][type]    product-reviews
    And Response body parameter should not be EMPTY:    [data][0][attributes][rating]
    And Response body parameter should have datatype:    [data][0][attributes][rating]    int
    And Response body parameter should not be EMPTY:    [data][0][attributes][nickname]
    And Response body parameter should not be EMPTY:    [data][0][attributes][summary]
    And Response body parameter should not be EMPTY:    [data][0][attributes][description]
    And Response body parameter should not be EMPTY:    [data][0][links][self]
    And Response body parameter should not be EMPTY:    [links][self]
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][prev]
    And Response body parameter should not be EMPTY:    [links][next]

    
Get_product_reviews_for_product_with_no_reviews
    When I send a GET request:    /abstract-products/${product_availability.abstract_available_with_stock_and_never_out_of_stock}/product-reviews
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    0
    And Response body has correct self link

Get_product_review_by_id
    [Documentation]   https://spryker.atlassian.net/browse/CC-16486/
    [Tags]    skip-due-to-issue 
    [Setup]    Run Keywords    I send a GET request:    /abstract-products/${abstract_product.with_reviews.sku}/product-reviews
    ...    AND    Save value to a variable:    [data][0][id]    review_id
    When I send a GET request:    /abstract-products/${abstract_product.with_reviews.sku}/product-reviews/${review_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${review_id}
    And Response body parameter should be:    [data][type]    product-reviews
    And Response body parameter should not be EMPTY:    [data][attributes][rating]
    And Response body parameter should have datatype:    [data][attributes][rating]    int
    And Response body parameter should not be EMPTY:    [data][attributes][nickname]
    And Response body parameter should not be EMPTY:    [data][attributes][summary]
    And Response body parameter should not be EMPTY:    [data][attributes][description]
    And Response body parameter should not be EMPTY:    [data][links][self]

Create_a_product_review
    [Documentation]   https://spryker.atlassian.net/browse/CC-16486/ and a self link
    [Tags]    skip-due-to-issue 
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a POST request:    /abstract-products/${abstract_product.with_options.sku}/product-reviews    {"data": {"type": "product-reviews","attributes": {"rating": ${review.default_rating},"nickname": "${yves_user.first_name}","summary": "${review.title}","description": "${review.text}"}}}
    Then Response status code should be:    202
    And Response reason should be:    Accepted
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should not be EMPTY:    [data][id]
    And Save value to a variable:    [data][id]    review_id
    And Response body parameter should be:    [data][type]    product-reviews
    And Response body parameter should be:    [data][attributes][rating]    ${review.default_rating}
    And Response body parameter should be:    [data][attributes][nickname]    ${yves_user.first_name}
    And Response body parameter should be:    [data][attributes][summary]    ${review.title}
    And Response body parameter should be:    [data][attributes][description]    ${review.text}
    And Response body has correct self link for created entity:    ${review_id}