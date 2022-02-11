*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Get concrete alternative product for a product that has none
    When I send a GET request:    /concrete-products/${bundled_product_1_concrete_sku}/concrete-alternative-products
    And Response should contain the array of a certain size:    [data]    0
    And Response body has correct self link
    And Response reason should be:    OK

Get concrete alternative product without include
    When I send a GET request:    /concrete-products/${concrete_product_with_alternative_sku}/concrete-alternative-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    3
    And Response body parameter should be:    [data][0][type]    concrete-products
    And Response body should contain:    id
    And Response body has correct self link
    And Response body parameter should contain:    [data][0][attributes]    sku
    And Response body parameter should contain:    [data][0][attributes]    isDiscontinued
    And Response body parameter should contain:    [data][0][attributes]    discontinuedNote
    And Response body parameter should contain:    [data][0][attributes]    averageRating
    And Response body parameter should contain:    [data][0][attributes]    reviewCount
    And Response body parameter should contain:    [data][0][attributes]    productAbstractSku
    And Response body parameter should contain:    [data][0][attributes]    name
    And Response body parameter should contain:    [data][0][attributes]    description
    And Response body parameter should contain:    [data][0][attributes]    attributes
    And Response body parameter should contain:    [data][0][attributes]    superAttributesDefinition
    And Response body parameter should contain:    [data][0][attributes]    metaTitle
    And Response body parameter should contain:    [data][0][attributes]    metaKeywords
    And Response body parameter should contain:    [data][0][attributes]    metaDescription
    And Response body parameter should contain:    [data][0][attributes]    attributeNames
    And Response should contain the array of a certain size:    [data][0][attributes][attributes]    7
    And Response should contain the array of a certain size:    [data][0][attributes][attributeNames]    7
    And Response body has correct self link

Get concrete alternative product with include
    When I send a GET request:    /concrete-products/${concrete_product_with_alternative_sku}/concrete-alternative-products?include=concrete-product-image-sets,concrete-product-availabilities,concrete-product-prices,concrete-product-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    3
    And Response body parameter should be:    [data][0][type]    concrete-products
    And Response body should contain:    id
    And Response body has correct self link
    And Response body parameter should contain:    [data][0][attributes]    sku
    And Response body parameter should contain:    [data][0][attributes]    isDiscontinued
    And Response body parameter should contain:    [data][0][attributes]    discontinuedNote
    And Response body parameter should contain:    [data][0][attributes]    averageRating
    And Response body parameter should contain:    [data][0][attributes]    reviewCount
    And Response body parameter should contain:    [data][0][attributes]    productAbstractSku
    And Response body parameter should contain:    [data][0][attributes]    name
    And Response body parameter should contain:    [data][0][attributes]    description
    And Response body parameter should contain:    [data][0][attributes]    attributes
    And Response body parameter should contain:    [data][0][attributes]    superAttributesDefinition
    And Response body parameter should contain:    [data][0][attributes]    metaTitle
    And Response body parameter should contain:    [data][0][attributes]    metaKeywords
    And Response body parameter should contain:    [data][0][attributes]    metaDescription
    And Response body parameter should contain:    [data][0][attributes]    attributeNames
    And Response should contain the array of a certain size:    [data][0][attributes][attributes]    7
    And Response should contain the array of a certain size:    [data][0][attributes][attributeNames]    7
    And Response should contain the array of a certain size:    [data][0][relationships]   2
    And Response include should contain certain entity type:    concrete-product-image-sets
    And Response include should contain certain entity type:    concrete-product-availabilities
    And Response include element has self link:   concrete-product-image-sets
    And Response include element has self link:   concrete-product-availabilities

