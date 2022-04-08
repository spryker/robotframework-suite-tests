*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Abstract_product_with_one_concrete
    When I send a GET request:    /abstract-products/${abstract_available_product_with_stock}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    abstract-products
    And Response body parameter should be:    [data][id]    ${abstract_available_product_with_stock}
    And Response body parameter should be:    [data][attributes][sku]    ${abstract_available_product_with_stock}
    And Response body parameter should not be EMPTY:    [data][attributes][averageRating]
    And Response body parameter should not be EMPTY:    [data][attributes][reviewCount]
    And Response body parameter should be:    [data][attributes][name]    ${abstract_available_product_with_stock_name}
    And Response body parameter should not be EMPTY:    [data][attributes][description]
    And Response body parameter should not be EMPTY:    [data][attributes][attributes]
    And Response body parameter should not be EMPTY:    [data][attributes][superAttributesDefinition]
    And Response should contain the array of a certain size:    [data][attributes][attributeMap]    4
    And Response should contain the array of a certain size:    [data][attributes][attributeMap][product_concrete_ids]    1
    And Response body parameter should contain:    [data][attributes][superAttributes]    ${abstract_available_product_with_stock_superattribute}
    And Response body parameter should not be EMPTY:    [data][attributes][metaTitle]
    And Response body parameter should not be EMPTY:    [data][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][attributes][metaDescription]
    And Response body parameter should not be EMPTY:    [data][attributes][attributeNames]
    And Response body parameter should not be EMPTY:    [data][attributes][url]
    And Response body has correct self link internal

