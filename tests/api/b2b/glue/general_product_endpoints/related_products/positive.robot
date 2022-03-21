*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Product_has_related_products
    When I send a GET request:    /abstract-products/${product_with_relations_related_products_sku}/related-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    4
    And Response body parameter should be:    [data][0][type]    abstract-products
    And Response body parameter should be:    [data][0][id]    ${product_related_to_abstract}
    And Response body parameter should not be EMPTY:    [data][0][attributes]
    And Response body parameter should be:    [data][0][attributes][sku]    ${product_related_to_abstract}
    And Response body parameter should be:    [data][0][attributes][averageRating]    None
    And Response body parameter should be:    [data][0][attributes][reviewCount]    0
    And Response body parameter should be:    [data][0][attributes][name]    ${product_related_to_abstract_name}
    And Response body parameter should not be EMPTY:    [data][0][attributes][description]
    And Response body parameter should not be EMPTY:    [data][0][attributes][attributes]
    And Response body parameter should not be EMPTY:    [data][0][attributes][attributes][brand]
    And Response should contain the array of a certain size:    [data][0][attributes][superAttributesDefinition]    0
    And Response should contain the array of a certain size:    [data][0][attributes][superAttributes]    0
    And Response should contain the array of a certain size:    [data][0][attributes][attributeMap]    4
    And Response should contain the array of a certain size:    [data][0][attributes][attributeMap][super_attributes]   0
    And Response should contain the array of a certain size:    [data][0][attributes][attributeMap][product_concrete_ids]   1
    And Response should contain the array of a certain size:    [data][0][attributes][attributeMap][attribute_variants]   0
    And Response should contain the array of a certain size:    [data][0][attributes][attributeMap][attribute_variant_map]   0 
    And Response should contain the array of a certain size:    [data][0][attributes][metaTitle]    0  
    And Response body parameter should not be EMPTY:    [data][0][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][0][attributes][metaDescription]
    And Response body parameter should not be EMPTY:    [data][0][attributes][attributeNames]
    And Response body parameter should not be EMPTY:    [data][0][attributes][attributeNames][brand]
    And Response body parameter should not be EMPTY:    [data][0][attributes][url]     
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes   
    And Each array element of array in response should contain nested property:    [data]    [attributes]    sku
    And Each array element of array in response should contain nested property:    [data]    [attributes]    averageRating
    And Each array element of array in response should contain nested property:    [data]    [attributes]    reviewCount
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    description
    And Each array element of array in response should contain nested property:    [data]    [attributes]    attributes
    And Each array element of array in response should contain nested property:    [data]    [attributes][attributes]    brand
    And Each array element of array in response should contain nested property:    [data]    [attributes]    superAttributesDefinition
    And Each array element of array in response should contain nested property:    [data]    [attributes]   superAttributes
    And Each array element of array in response should contain nested property:    [data]    [attributes]   attributeMap
    And Each array element of array in response should contain nested property:    [data]    [attributes][attributeMap]    super_attributes
    And Each array element of array in response should contain nested property:    [data]    [attributes][attributeMap]    product_concrete_ids
    And Each array element of array in response should contain nested property:    [data]    [attributes][attributeMap]    attribute_variants
    And Each array element of array in response should contain nested property:    [data]    [attributes][attributeMap]    attribute_variant_map
    And Each array element of array in response should contain nested property:    [data]    [attributes]    metaTitle
    And Each array element of array in response should contain nested property:    [data]    [attributes]    metaKeywords
    And Each array element of array in response should contain nested property:    [data]    [attributes]   metaDescription
    And Each array element of array in response should contain nested property:    [data]    [attributes]   attributeNames
    And Each array element of array in response should contain nested property:    [data]    [attributes][attributeNames]    brand
    And Each array element of array in response should contain nested property:    [data]    [attributes]   url
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link
    
Product_has_no_related_products
    When I send a GET request:    /abstract-products/${abstract_available_product_with_stock}/related-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    0
    And Response body has correct self link