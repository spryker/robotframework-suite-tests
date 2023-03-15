*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     SuiteSetup
Test Setup      TestSetup

Default Tags    glue


*** Test Cases ***
ENABLER
    TestSetup

Get_concrete_bundled_products_inside_concrete_bundle
    When I send a GET request:    /concrete-products/${bundle_product.product_1.concrete_sku}/bundled-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    ${bundle_product.qty_of_products_in_bundle}
    And Each array element of array in response should contain property with value:
    ...    [data]
    ...    type
    ...    bundled-products
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    links
    And Response body parameter should be in:    [data][0][attributes][sku]    ${bundle_product.product_2.concrete_sku}    ${bundle_product.product_3.concrete_sku}    ${bundle_product.product_4.concrete_sku}
    And Response body parameter should be in:    [data][1][attributes][sku]    ${bundle_product.product_2.concrete_sku}    ${bundle_product.product_3.concrete_sku}    ${bundle_product.product_4.concrete_sku}
    And Response body parameter should be in:    [data][2][attributes][sku]    ${bundle_product.product_2.concrete_sku}    ${bundle_product.product_3.concrete_sku}    ${bundle_product.product_4.concrete_sku}
    And Each array element of array in response should contain nested property with value:
    ...    [data]
    ...    [attributes][quantity]
    ...    ${bundle_product.qty_of_each_product_inside_bundle}
    And Response body has correct self link

Get_concrete_bundled_products_inside_concrete_bundle_with_included_concretes
    When I send a GET request:
    ...    /concrete-products/${bundle_product.product_1.concrete_sku}/bundled-products?include=concrete-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    ${bundle_product.qty_of_products_in_bundle}
    And Each array element of array in response should contain property with value:
    ...    [data]
    ...    type
    ...    bundled-products
    And Response body has correct self link
    And Each array element of array in response should contain nested property with value:
    ...    [data]
    ...    [relationships][concrete-products][data][0][type]
    ...    concrete-products
    And Response should contain the array of a certain size:
    ...    [included]
    ...    ${bundle_product.qty_of_products_in_bundle}
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:    concrete-products

Get_concrete_bundle_product_with_bundled_products_include
    When I send a GET request:    /concrete-products/${bundle_product.product_1.concrete_sku}?include=bundled-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    concrete-products
    And Response body parameter should be:    [data][id]    ${bundle_product.product_1.concrete_sku}
    And Response body parameter should be:    [data][attributes][sku]    ${bundle_product.product_1.concrete_sku}
    And Response body parameter should be:
    ...    [data][attributes][productAbstractSku]
    ...    ${bundle_product.product_1.abstract_sku}
    And Response body parameter should be:    [data][attributes][name]    ${bundle_product.product_1.name}
    And Response body parameter should be:    [data][attributes][attributes][bundled_product]    Yes
    And Response body parameter should be:    [data][attributes][attributeNames][bundled_product]    Bundled Product
    And Response body has correct self link internal
    And Response should contain the array of a certain size:
    ...    [data][relationships][bundled-products][data]
    ...    ${bundle_product.qty_of_products_in_bundle}
    And Each array element of array in response should contain property with value:
    ...    [data][relationships][bundled-products][data]
    ...    type
    ...    bundled-products
    And Response should contain the array larger than a certain size:
    ...    [included]
    ...    ${bundle_product.qty_of_products_in_bundle}
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    bundled-products
    And Response include element has self link:    concrete-products
    And Response include element has self link:    bundled-products

Get_abstract_bundle_product_with_bundled_products_include
    When I send a GET request:
    ...    /abstract-products/${bundle_product.product_1.abstract_sku}?include=bundled-products,concrete-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    abstract-products
    And Response body parameter should be:    [data][id]    ${bundle_product.product_1.abstract_sku}
    And Response body parameter should be:    [data][attributes][sku]    ${bundle_product.product_1.abstract_sku}
    And Response body parameter should be:    [data][attributes][name]    ${bundle_product.product_1.name}
    And Response body parameter should be:    [data][attributes][attributes][bundled_product]    Yes
    And Response body parameter should be:    [data][attributes][attributeNames][bundled_product]    Bundled Product
    And Response body parameter should be:
    ...    [data][attributes][attributeMap][product_concrete_ids]
    ...    ${bundle_product.product_1.concrete_sku}
    And Response body has correct self link internal
    And Response should contain the array of a certain size:    [data][relationships][concrete-products][data]    1
    And Response body parameter should be:
    ...    [data][relationships][concrete-products][data][0][id]
    ...    ${bundle_product.product_1.concrete_sku}
    And Response should contain the array larger than a certain size:
    ...    [included]
    ...    ${bundle_product.qty_of_products_in_bundle}
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    bundled-products
    And Response include element has self link:    concrete-products
    And Response include element has self link:    bundled-products

Get_concrete_bundled_products_for_nonbundle_product
    When I send a GET request:
    ...    /concrete-products/${concrete.available_product.with_stock_and_never_out_of_stock.sku}/bundled-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    0
    And Response body has correct self link
