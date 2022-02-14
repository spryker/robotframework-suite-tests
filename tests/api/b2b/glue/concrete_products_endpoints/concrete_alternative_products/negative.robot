*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Get_abstract_product_alternative_for_ concrete_product_with_an_invalid_endpoint
    When I send a GET request:    /concrete-products/${concrete_product_with_alternative_sku}/concrete-alternative-product
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Not Found

Get_abstract_product_alternative_for_concrete_product_with_invalid_sku_of_product
    When I send a GET request:    /concrete-products/65789/concrete-alternative-products
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Concrete product is not found.

Get_abstract_product_alternative_for_concrete_product_using_abstract_product_SKU
    When I send a GET request:    /concrete-products/${bundled_product_1_abstract_sku}/concrete-alternative-products
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Concrete product is not found.

Get_abstract_product_alternative_for_concrete_product_with_wrong_method_(POST)
    When I send a POST request:    /concrete-products/${concrete_product_with_alternative_sku}concrete-alternative-products    {} 
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Not Found
    
Get_abstract_product_alternative_for_concrete_product_with_wrong_method_(PUT)
    When I send a PUT request:    /concrete-products/${concrete_product_with_alternative_sku}/concrete-alternative-products    {} 
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Not Found

Get_abstract_product_alternative_for_concrete_product_with_wrong_method_(PATCH)
    When I send a PATCH request:    /concrete-products/${concrete_product_with_alternative_sku}/concrete-alternative-products    {} 
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Not Found

Get_abstract_product_alternative_for_concrete_product_with_wrong_method_(DELETE)
    When I send a DELETE request:   /concrete-products/${concrete_product_with_alternative_sku}/concrete-alternative-products
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Not Found