*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Abstract_product_with_one_concrete
    When I send a GET request:    /abstract-products/${abstract_available_product_with_stock_NESTED.id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    abstract-products
    And Response body parameter should be:    [data][id]    ${abstract_available_product_with_stock_NESTED.id}
    And Response body parameter should be:    [data][attributes][sku]    ${abstract_available_product_with_stock_NESTED.id}
    And Response body parameter should be:    [data][attributes][merchantReference]    ${abstract_available_product_with_stock_NESTED.merchant_reference}
    And Response body parameter should have datatype:    [data][attributes][reviewCount]    int
    And Response body parameter should be:    [data][attributes][name]    ${abstract_available_product_with_stock_NESTED.name}
    And Response body parameter should be:    [data][attributes][description]    ${abstract_available_product_with_stock_NESTED.description}
    And Response body parameter should be:    [data][attributes][metaTitle]    ${abstract_available_product_with_stock_NESTED.meta_title}
    And Response body parameter should be:    [data][attributes][metaKeywords]    ${abstract_available_product_with_stock_NESTED.meta_keywords}
    And Response body parameter should be:    [data][attributes][metaDescription]    ${abstract_available_product_with_stock_NESTED.meta_description}
    And Response body parameter should be:    [data][attributes][attributeMap][product_concrete_ids][0]    ${abstract_available_product_with_stock_NESTED.concrete_available_product.sku}
    And Response body parameter should be:    [data][attributes][averageRating]    None
    And Response body parameter should not be EMPTY:    [data][attributes][attributes]
    And Response should contain the array of a certain size:    [data][attributes][superAttributesDefinition]    0
    And Response should contain the array of a certain size:    [data][attributes][attributeMap]    4
    And Response should contain the array of a certain size:    [data][attributes][attributeMap][product_concrete_ids]    1
    And Response body parameter should have datatype:    [data][attributes][attributeMap][attribute_variants]    list
    And Response body parameter should have datatype:    [data][attributes][attributeMap][attribute_variant_map]    dict
    And Response body parameter should contain:    [data][attributes][superAttributes]    ${abstract_available_product_with_stock_NESTED.superattribute}
    And Response body parameter should not be EMPTY:    [data][attributes][attributeNames]
    And Response body parameter should not be EMPTY:    [data][attributes][url]
    And Response body has correct self link internal


Abstract_product_with_category_nodes_included
    When I send a GET request:    /abstract-products/${abstract_available_product_with_stock_NESTED.id}?include=category-nodes
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    abstract-products
    And Response should contain the array of a certain size:    [included]    3
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][category-nodes]
    And Each array element of array in response should contain property:    [data][relationships][category-nodes][data]    type
    And Each array element of array in response should contain property:    [data][relationships][category-nodes][data]    id
    And Response body parameter should not be EMPTY:    [included]
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Each array element of array in response should contain property with value:    [included]    type    category-nodes
    And Response body parameter should be:    [included][0][attributes][name]    ${abstract_available_product_with_stock_NESTED.category_nodes.first_category_node_name}
    And Response body parameter should be:    [included][1][attributes][name]    ${abstract_available_product_with_stock_NESTED.category_nodes.second_category_node_name}
    And Response body parameter should be:    [included][2][attributes][name]    ${abstract_available_product_with_stock_NESTED.category_nodes.third_category_node_name}
    And Each array element of array in response should contain nested property:    [included]    attributes    nodeId
    And Each array element of array in response should contain nested property:    [included]    attributes    name
    And Each array element of array in response should contain nested property:    [included]    attributes    metaTitle
    And Each array element of array in response should contain nested property:    [included]    attributes    metaKeywords
    And Each array element of array in response should contain nested property:    [included]    attributes    metaDescription
    And Each array element of array in response should contain nested property:    [included]    attributes    isActive
    And Each array element of array in response should contain nested property:    [included]    attributes    order
    And Each array element of array in response should contain nested property:    [included]    attributes    url
    And Each array element of array in response should contain nested property:    [included]    attributes    children
    And Each array element of array in response should contain nested property:    [included]    attributes    parents


Abstract_product_has_one_concrete_product_with_concrete_products_included
    When I send a GET request:    /abstract-products/${abstract_available_product_with_stock_NESTED.id}?include=concrete-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    abstract-products
    And Response should contain the array of a certain size:    [included]    2
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][concrete-products]
    And Each Array Element Of Array In Response Should Contain Property:    [data][relationships][concrete-products][data]    type
    And Each Array Element Of Array In Response Should Contain Property:    [data][relationships][concrete-products][data]    id
    And Each Array Element Of Array In Response Should Contain Property:    [included]    type
    And Each Array Element Of Array In Response Should Contain Property:    [included]    id
    And Each Array Element Of Array In Response Should Contain Property:    [included]    attributes
    And Each Array Element Of Array In Response Should Contain Property:    [included]    links
    Each array element of array in response should contain nested property:    [included]    [links]    self
    And Response body parameter should be:    [included][0][type]    concrete-products
    And Response body parameter should be:    [included][0][attributes][sku]    ${abstract_available_product_with_stock_NESTED.concrete_available_product.sku}
    And Response body parameter should not be EMPTY:    [included][0][attributes][isDiscontinued]
    And Response body parameter should be:    [included][0][attributes][discontinuedNote]    None
    And Response body parameter should be:    [included][0][attributes][averageRating]    None
    And Response body parameter should have datatype:    [included][0][attributes][reviewCount]    int
    And Response body parameter should be:    [included][0][attributes][productAbstractSku]    ${abstract_available_product_with_stock_NESTED.id}
    And Response body parameter should be:    [included][0][attributes][name]    ${abstract_available_product_with_stock_NESTED.concrete_available_product.name}
    And Response body parameter should be:    [included][0][attributes][description]    ${abstract_available_product_with_stock_NESTED.concrete_available_product.description}
    And Response body parameter should be:    [included][0][attributes][metaTitle]    ${abstract_available_product_with_stock_NESTED.concrete_available_product.meta_title}
    And Response body parameter should be:    [included][0][attributes][metaKeywords]    ${abstract_available_product_with_stock_NESTED.concrete_available_product.meta_keywords}
    And Response body parameter should be:    [included][0][attributes][metaDescription]    ${abstract_available_product_with_stock_NESTED.concrete_available_product.meta_description}
    And Response body parameter should contain:    [data][attributes][superAttributes]    ${abstract_available_product_with_stock_NESTED.superattribute}
    And Response body parameter should not be EMPTY:    [included][0][attributes][attributes]
    And Response body parameter should not be EMPTY:    [included][0][attributes][superAttributesDefinition]
    And Response body parameter should not be EMPTY:    [included][0][attributes][attributeNames]

    

Abstract_product_with_product_options_included
    When I send a GET request:    /abstract-products/${abstract_available_product_with_stock_NESTED.id}?include=product-options
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    abstract-products
    And Response should contain the array of a certain size:    [included]    4
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][product-options]
    And Each array element of array in response should contain property:    [data][relationships][product-options][data]    type
    And Each array element of array in response should contain property:    [data][relationships][product-options][data]    id
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain property with value:    [included]    type    product-options
    And Each array element of array in response should contain nested property:    [included]    attributes    optionGroupName
    And Each array element of array in response should contain nested property:    [included]    attributes    sku
    And Each array element of array in response should contain nested property:    [included]    attributes    optionName
    And Each array element of array in response should contain nested property:    [included]    attributes    price
    And Each array element of array in response should contain nested property:    [included]    attributes    currencyIsoCode
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Response body parameter should be:    [included][0][id]    ${abstract_available_product_with_stock_NESTED.product_options.first.id}
    And Response body parameter should be:    [included][0][attribtues][optionGroupName]    'Three (3) year limited warranty'
    And Response body parameter should be:    [included][0][attribtues][sku]    ${abstract_available_product_with_stock_NESTED.product_options.first.sku}
    And Response body parameter should be:    [included][0][attribtues][optionName]    ${abstract_available_product_with_stock_NESTED.product_options.first.option_name}
    And Response body parameter should be:    [included][0][attribtues][price]    ${abstract_available_product_with_stock_NESTED.product_options.first.price}
    And Each array element of array in response should contain property with value in:    [included]    [attributes][currencyIsoCode]    ${currency_code_eur}    ${currency_code_dollar}

    



