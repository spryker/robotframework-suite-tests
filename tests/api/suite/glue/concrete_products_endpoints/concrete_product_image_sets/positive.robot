*** Settings ***
Suite Setup    SuiteSetup
Test Setup     TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
Request_concrete_product_with_one_image_set
    When I send a GET request:    /concrete-products/${concrete_products.one_image_set.sku}/concrete-product-image-sets
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body has correct self link
    And Response body parameter should be:    [data][0][id]    ${concrete_products.one_image_set.sku}
    And Response body parameter should be:    [data][0][type]   concrete-product-image-sets
    And Response body parameter should be:    [data][0][attributes][imageSets][0][name]    default
    And Response body parameter should contain:    [data][0][attributes]   imageSets 
    And Response should contain the array of a certain size:    [data][0][attributes][imageSets]   1
    And Response should contain the array of a certain size:    [data][0][attributes][imageSets][0][images]    1
    And Response body parameter should not be EMPTY:    [data][0][attributes][imageSets][0][images][0][externalUrlLarge]
    And Response body parameter should not be EMPTY:    [data][0][attributes][imageSets][0][images][0][externalUrlSmall]

Request_concrete_product_with_multiple_images
    [Documentation]   missing demodata https://spryker.atlassian.net/browse/CC-25735
    [Tags]    skip-due-to-issue  
    When I send a GET request:    /concrete-products/${concrete_products.multiple_image_set.sku}/concrete-product-image-sets
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body has correct self link
    And Response body parameter should be:    [data][0][id]    ${concrete_products.multiple_image_set.sku}
    And Response body parameter should be:    [data][0][type]   concrete-product-image-sets
    And Response body parameter should be:    [data][0][attributes][imageSets][0][name]    default
    And Response body parameter should contain:    [data][0][attributes]   imageSets 
    And Response should contain the array of a certain size:     [data][0][attributes][imageSets][0][images]    19
    And Response body parameter should not be EMPTY:    [data][0][attributes][imageSets][0][images][0][externalUrlLarge]
    And Response body parameter should not be EMPTY:    [data][0][attributes][imageSets][0][images][0][externalUrlSmall]