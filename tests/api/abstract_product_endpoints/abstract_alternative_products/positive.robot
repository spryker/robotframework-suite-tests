*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../resources/common/common_api.robot

*** Test Cases ***
Product_has_abstract_alternative
    When I send a GET request:    /concrete-products/${concrete_product_with_alternative_sku}/abstract-alternative-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    application/vnd.api+json
    And Response should contain the array of a certain size:    [data]    1
    And Response body parameter should be:    [data][0][type]    abstract-products
    And Response body parameter should have datatype:    [data][0][attributes][name]    str
    And Response body parameter should be:    [data][0][attributes][sku]    ${alternative_abstract_product}
    And Response body has correct self link

Product_has_abstract_alternativewaith_includes
    When I send a GET request:    /concrete-products/${concrete_product_with_alternative_sku}/abstract-alternative-products?include=abstract-product-image-sets,abstract-product-availabilities,abstract-product-prices,category-nodes
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    application/vnd.api+json
    And Response should contain the array of a certain size:    [data]    1
    And Response body parameter should be:    [data][0][type]    abstract-products
    And Response body has correct self link
    And Response should contain the array of a certain size:    [data][0][relationships][abstract-product-image-sets][data]    1
    And Response should contain the array of a certain size:    [data][0][relationships][abstract-product-availabilities][data]    1
    And Response should contain the array of a certain size:    [data][0][relationships][abstract-product-prices][data]    1
    And Response should contain the array of a certain size:    [data][0][relationships][category-nodes][data]    3
    And Response should contain the array of a certain size:    [included]    6
    And Response include should contain certain entity type:    category-nodes
    And Response include should contain certain entity type:    abstract-product-image-sets
    And Response include should contain certain entity type:    abstract-product-prices
    And Response include should contain certain entity type:    abstract-product-availabilities
    And Response include element has self link:   category-nodes
    And Response include element has self link:   abstract-product-image-sets
    And Response include element has self link:   abstract-product-availabilities
    And Response include element has self link:   abstract-product-prices

Product_has_no_abstract_alternative
    When I send a GET request:    /concrete-products/${bundled_product_1_concrete_sku}/abstract-alternative-products
    Then Response header parameter should be:    Content-Type    application/vnd.api+json
    And Response should contain the array of a certain size:    [data]    0
    And Response body has correct self link
    And Response reason should be:    OK

