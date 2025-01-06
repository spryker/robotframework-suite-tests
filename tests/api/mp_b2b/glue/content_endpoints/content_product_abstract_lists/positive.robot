*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue

*** Test Cases ***
Abstract_product_list
    When I send a GET request:    /content-product-abstract-lists/${abstract_list.product_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${abstract_list.product_id}
    And Response body parameter should be:    [data][type]    content-product-abstract-lists
    And Response body has correct self link internal

Abstract_product_list_abstract_products
    When I send a GET request:    /content-product-abstract-lists/${abstract_list.product_id}/abstract-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    ${abstract_list.size}
    And Each array element of array in response should contain property with value:    [data]    type    abstract-products
    And Response body parameter should be:    [data][0][attributes][sku]    ${abstract_list.product1_sku}
    And Response body parameter should be:    [data][0][attributes][name]    ${abstract_list.product1_name}
    And Response body parameter should be:    [data][1][attributes][sku]    ${abstract_list.product2_sku}
    And Response body parameter should be:    [data][1][attributes][name]    ${abstract_list.product2_name}

# there is a bug in b2b and mp_b2b - include does not work 
# fails in mp_b2b CC-16994
Abstract_product_list_with_include
    When I send a GET request:    /content-product-abstract-lists/${abstract_list.product_id}?include=abstract-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${abstract_list.product_id}
    And Response body parameter should be:    [data][type]    content-product-abstract-lists
    And Response body has correct self link internal
    And Response should contain the array of a certain size:    [data][relationships][abstract-products][data]    ${abstract_list.size}
    And Response should contain the array of a certain size:    [included]    ${abstract_list.size}
    And Response include should contain certain entity type:    abstract-products
    And Response include element has self link:   abstract-products
