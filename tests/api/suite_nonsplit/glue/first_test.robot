*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
My_first_get_request
    I set Headers:    Content-Type=application/test    Accept=application/new-test    
    When I send a GET request:    /abstract-products/${abstract_available_product_with_stock}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${abstract_available_product_with_stock}
    And Response body parameter should be:    [data][attributes][sku]    ${abstract_available_product_with_stock}
    And Response body parameter should be:    [data][attributes][merchantReference]    None
    And Response body parameter should be:    [data][attributes][averageRating]    None
    And Response body parameter should be:    [data][attributes][reviewCount]    0
    And Response body parameter should be:    [data][attributes][name]    ${abstract_available_product_with_stock_name}
    And Response body parameter should not be EMPTY:    [data][attributes][description]
    And Response body parameter should not be EMPTY:    [data][attributes][attributes]
    And Response should contain the array larger than a certain size:    [data][attributes][superAttributesDefinition]    0
    And Response should contain the array of a certain size:    [data][attributes][attributeMap]    4
    And Response should contain the array of a certain size:    [data][attributes][attributeMap][product_concrete_ids]    1
    And Each array element of array in response should contain value:    [data][attributes][attributeMap][product_concrete_ids]    ${abstract_available_product_with_stock}
    And Response body parameter should contain:    [data][attributes][superAttributes]    ${abstract_available_product_with_stock_superattribute}
    And Response body parameter should not be EMPTY:    [data][attributes][metaTitle]
    And Response body parameter should not be EMPTY:    [data][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][attributes][metaDescription]
    And Response body parameter should not be EMPTY:    [data][attributes][attributeNames]
    And Response body parameter should not be EMPTY:    [data][attributes][url]
    And Response body has correct self link internal

My_second_test
    I set Headers:    Content-Type=application/test    Accept=application/new-test
    I send a GET request:    /abstract-products/${abstract_available_product_with_stock}
    Response status code should be:    200
    And Response reason should be:    OK    
    And Response body has correct self link internal
    And Response body parameter should not be EMPTY:    [data][attributes][description]
    And Response should contain the array of a certain size:    [data][attributes][attributeMap][product_concrete_ids]    1
    Save value to a variable:    $json_path    $name    