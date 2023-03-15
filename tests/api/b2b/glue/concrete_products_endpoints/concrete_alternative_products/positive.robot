*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     SuiteSetup
Test Setup      TestSetup

Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup

Get_concrete_alternative_product_for_a_product_that_has_none
    When I send a GET request:
    ...    /concrete-products/${bundle_product.product_2.concrete_sku}/concrete-alternative-products
    Then Response status code should be:    200
    And Response should contain the array of a certain size:    [data]    0
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body has correct self link
    And Response reason should be:    OK

Get_concrete_alternative_product
    When I send a GET request:
    ...    /concrete-products/${concrete.alternative_products.product_1.sku}/concrete-alternative-products
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    3
    And Response body parameter should be:    [data][0][type]    concrete-products
    And Response body should contain:    id
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

Get_concrete_alternative_product_with_include
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:
    ...    /concrete-products/${concrete.alternative_products.product_1.sku}/concrete-alternative-products?include=concrete-product-image-sets,concrete-product-availabilities,concrete-product-prices
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    3
    And Response body parameter should be:    [data][0][type]    concrete-products
    And Response should contain the array of a certain size:    [data][0][relationships]    3
    And Response include should contain certain entity type:    concrete-product-image-sets
    And Response include should contain certain entity type:    concrete-product-availabilities
    And Response include should contain certain entity type:    concrete-product-prices
    And Response include element has self link:    concrete-product-image-sets
    And Response include element has self link:    concrete-product-availabilities
    And Response include element has self link:    concrete-product-prices
