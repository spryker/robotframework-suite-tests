*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Request_concrete_product_with_one_image_set
    When I send a GET request:    /concrete-products/${concrete_product_one_image_set}/concrete-product-image-sets
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body has correct self link
    And Response body parameter should be:    [data][0][id]    ${concrete_product_one_image_set}
    And Response body parameter should be:    [data][0][type]   concrete-product-image-sets
    And Response body parameter should be:    [data][0][attributes][imageSets][0][name]    default
    And Response body parameter should contain:    [data][0][attributes]   imageSets 
    And Response should contain the array of a certain size:    [data][0][attributes][imageSets]   1
    And Response should contain the array of a certain size:    [data][0][attributes][imageSets][0][images]    1
    And Response body parameter should not be EMPTY:    [data][0][attributes][imageSets][images][externalUrlLarge]
    And Response body parameter should not be EMPTY:    [data][0][attributes][imageSets][images][externalUrlSmall]

Request_concrete_product_with_5_image_sets 
    When I send a GET request:    /concrete-products/${concrete_product_multiple_image_set}/concrete-product-image-sets
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body has correct self link
    And Response body parameter should be:    [data][0][id]    ${concrete_product_multiple_image_set}
    And Response body parameter should be:    [data][0][type]   concrete-product-image-sets
    And Response body parameter should be:    [data][0][attributes][imageSets][0][name]    default
    And Response body parameter should contain:    [data][0][attributes]   imageSets 
    And Response should contain the array of a certain size:     [data][0][attributes][imageSets][0][images]    5
    And Response body parameter should not be EMPTY:    [data][0][attributes][imageSets][images][externalUrlLarge]
    And Response body parameter should not be EMPTY:    [data][0][attributes][imageSets][images][externalUrlSmall]
