*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../resources/common/common_api.robot

*** Test Cases ***
Abstract_product_with_one_concrete
    When I send a GET request:    /abstract-products/${abstract_available_product_with_stock}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    application/vnd.api+json
    And Response body parameter should be:    [data][id]    ${abstract_available_product_with_stock}
    And Response body parameter should be:    [data][attributes][sku]    ${abstract_available_product_with_stock}
    And Response body parameter should be:    [data][attributes][merchantReference]    None
    And Response body parameter should be:    [data][attributes][averageRating]    None
    And Response body parameter should be:    [data][attributes][reviewCount]    0
    And Response body parameter should be:    [data][attributes][name]    Sony Xperia SGP512E1
    And Response body parameter should not be EMPTY:    [data][attributes][description]
    And Response body parameter should not be EMPTY:    [data][attributes][attributes]
    And Response should contain the array of a certain size:    [data][attributes][superAttributesDefinition]    3
    And Response should contain the array of a certain size:    [data][attributes][attributeMap]    4
    And Response should contain the array of a certain size:    [data][attributes][attributeMap][product_concrete_ids]    1
    And Response body parameter should contain:    [data][attributes][attributeMap][product_concrete_ids]    ${abstract_available_product_with_stock}
    And Response body parameter should be:    [data][attributes][superAttributes][color]    White
    And Response body parameter should not be EMPTY:    [data][attributes][metaTitle]
    And Response body parameter should not be EMPTY:    [data][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][attributes][metaDescription]
    And Response body parameter should not be EMPTY:    [data][attributes][attributeNames]
    And Response body parameter should not be EMPTY:    [data][attributes][url]
    And Response body has correct self link internal

