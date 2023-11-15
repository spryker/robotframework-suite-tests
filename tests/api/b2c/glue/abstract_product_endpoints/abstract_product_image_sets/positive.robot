*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    API_test_setup
Abstract_image_sets_with_1_concrete
    When I send a GET request:    /abstract-products/${product_availability.abstract_available_with_stock_and_never_out_of_stock}/abstract-product-image-sets
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][id]    ${product_availability.abstract_available_with_stock_and_never_out_of_stock}
    And Response should contain the array of a certain size:    [data][0][attributes][imageSets]   1
    And Response should contain the array of a certain size:    [data][0][attributes][imageSets][0][images]    1
    And Response body parameter should not be EMPTY:   [data][0][attributes][imageSets][0][images][0][externalUrlLarge]
    And Response body parameter should not be EMPTY:    [data][0][attributes][imageSets][0][images][0][externalUrlSmall]
    And Response body has correct self link

Abstract_image_sets_with_3_concretes
    When I send a GET request:    /abstract-products/${multivariant.abstract_product.concretes_3}/abstract-product-image-sets
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][id]    ${multivariant.abstract_product.concretes_3}
    And Response should contain the array of a certain size:    [data][0][attributes][imageSets]   1
    And Response should contain the array of a certain size:    [data][0][attributes][imageSets][0][images]    1
    And Response body parameter should not be EMPTY:   [data][0][attributes][imageSets][0][images][0][externalUrlLarge]
    And Response body parameter should not be EMPTY:    [data][0][attributes][imageSets][0][images][0][externalUrlSmall]
    And Response body has correct self link
