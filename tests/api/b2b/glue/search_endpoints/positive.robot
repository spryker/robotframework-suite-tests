*** Settings ***
Suite Setup    SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
#GET requests
Get_search_suggestions_without_query_parameter
    When I send a GET request:    /catalog-search-suggestions
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][type]    catalog-search-suggestions
    And Response body parameter should be:    [data][0][id]    None
    And Response should contain the array of a certain size:    [data][0][attributes][completion]    0
    And Response should contain the array of a certain size:    [data][0][attributes][categories]    0
    And Response should contain the array of a certain size:    [data][0][attributes][cmsPages]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    0
    And Response should contain the array of a certain size:    [data][0][attributes][categoryCollection]    0
    And Response should contain the array of a certain size:    [data][0][attributes][cmsPageCollection]    0
    And Response body has correct self link

Get_search_suggestions_with_non_existing_product_sku
    When I send a GET request:    /catalog-search-suggestions?q=000000
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][type]    catalog-search-suggestions
    And Response body parameter should be:    [data][0][id]    None
    And Response should contain the array of a certain size:    [data][0][attributes][completion]    0
    And Response should contain the array of a certain size:    [data][0][attributes][categories]    0
    And Response should contain the array of a certain size:    [data][0][attributes][cmsPages]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    0
    And Response should contain the array of a certain size:    [data][0][attributes][categoryCollection]    0
    And Response should contain the array of a certain size:    [data][0][attributes][cmsPageCollection]    0
    And Response body has correct self link

Get_search_suggestions_with_concrete_product_sku
    When I send a GET request:    /catalog-search-suggestions?q=${concrete_product_with_alternative_sku}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][type]    catalog-search-suggestions
    And Response body parameter should be:    [data][0][id]    None
    And Response body parameter should be:    [data][0][attributes][completion]    ${concrete_product_with_alternative_sku}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][price]    1579
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractName]    ${concrete_product_with_alternative_sku_name}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractSku]    ${abstract_product_with_alternative_sku}
    And Response body parameter should not be EMPTY:    [data][0][attributes][abstractProducts][0][url]
    And Response body parameter should not be EMPTY:    [data][0][attributes][abstractProducts][0][images]
    And Response should contain the array of a certain size:    [data][0][attributes][categories]    0
    And Response should contain the array of a certain size:    [data][0][attributes][cmsPages]    0
    And Response should contain the array of a certain size:    [data][0][attributes][categoryCollection]    0
    And Response should contain the array of a certain size:    [data][0][attributes][cmsPageCollection]    0
    And Response body has correct self link

Get_search_suggestions_with_abstract_product_sku
    When I send a GET request:    /catalog-search-suggestions?q=${abstract_available_product_with_stock}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][type]    catalog-search-suggestions
    And Response body parameter should be:    [data][0][id]    None
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][price]    40744
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractName]    ${abstract_available_product_with_stock_name}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractSku]    ${abstract_available_product_with_stock}
    And Response body parameter should not be EMPTY:    [data][0][attributes][abstractProducts][0][url]
    And Response body parameter should not be EMPTY:    [data][0][attributes][abstractProducts][0][images]
    And Response should contain the array of a certain size:    [data][0][attributes][completion]    0
    And Response should contain the array of a certain size:    [data][0][attributes][categories]    0
    And Response should contain the array of a certain size:    [data][0][attributes][cmsPages]    0
    And Response should contain the array of a certain size:    [data][0][attributes][categoryCollection]    0
    And Response should contain the array of a certain size:    [data][0][attributes][cmsPageCollection]    0
    And Response body has correct self link

Get_search_suggestions_with_concrete_product_name
    When I send a GET request:    /catalog-search-suggestions?q=${concrete_product_with_alternative_sku_name}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][type]    catalog-search-suggestions
    And Response body parameter should be:    [data][0][id]    None
    And Response body parameter should be:    [data][0][attributes][completion]    verbatim usb stick store n go v3 49173 32gb usb3.0 gray
    And Each array element of array in response should contain property:    [data][0][attributes][categories]    name
    And Each array element of array in response should contain property:    [data][0][attributes][categories]    url
    And Each array element of array in response should contain property:    [data][0][attributes][cmsPages]    name
    And Each array element of array in response should contain property:    [data][0][attributes][cmsPages]    url
    And Each array element of array in response should contain property:    [data][0][attributes][abstractProducts]    price
    And Each array element of array in response should contain property:    [data][0][attributes][abstractProducts]    abstractName
    And Each array element of array in response should contain property:    [data][0][attributes][abstractProducts]    abstractSku
    And Each array element of array in response should contain property:    [data][0][attributes][abstractProducts]    url
    And Each array element of array in response should contain property:    [data][0][attributes][abstractProducts]    images
    And Each array element of array in response should contain property:    [data][0][attributes][categoryCollection]    name
    And Each array element of array in response should contain property:    [data][0][attributes][categoryCollection]    url
    And Each array element of array in response should contain property:    [data][0][attributes][cmsPageCollection]    name
    And Each array element of array in response should contain property:    [data][0][attributes][cmsPageCollection]    url
    And Response body has correct self link

Get_search_suggestions_with_few_symbols
    When I send a GET request:    /catalog-search-suggestions?q=comp
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][type]    catalog-search-suggestions
    And Response body parameter should be:    [data][0][id]    None
    And Each array element of array in response should contain value:    [data][0][attributes][completion]    comp
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    comp
    And Each array element of array in response should contain property:    [data][0][attributes][categories]    name
    And Each array element of array in response should contain property:    [data][0][attributes][categories]    url
    And Each array element of array in response should contain property:    [data][0][attributes][cmsPages]    name
    And Each array element of array in response should contain property:    [data][0][attributes][cmsPages]    url
    And Each array element of array in response should contain property:    [data][0][attributes][abstractProducts]    price
    And Each array element of array in response should contain property:    [data][0][attributes][abstractProducts]    abstractName
    And Each array element of array in response should contain property:    [data][0][attributes][abstractProducts]    abstractSku
    And Each array element of array in response should contain property:    [data][0][attributes][abstractProducts]    url
    And Each array element of array in response should contain property:    [data][0][attributes][abstractProducts]    images
    And Each array element of array in response should contain property:    [data][0][attributes][categoryCollection]    name
    And Each array element of array in response should contain property:    [data][0][attributes][categoryCollection]    url
    And Each array element of array in response should contain property:    [data][0][attributes][cmsPageCollection]    name
    And Each array element of array in response should contain property:    [data][0][attributes][cmsPageCollection]    url
    And Response body has correct self link

Get_search_suggestions_with_category_name
    When I send a GET request:    /catalog-search-suggestions?q=Computer Accessories
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][type]    catalog-search-suggestions
    And Response body parameter should be:    [data][0][id]    None
    And Each array element of array in response should contain value:    [data][0][attributes][completion]    computer accessories
    And Each array element of array in response should contain property with value:    [data][0][attributes][categories]    name    Computer Accessories
    And Each array element of array in response should contain property:    [data][0][attributes][categories]    name
    And Each array element of array in response should contain property:    [data][0][attributes][categories]    url
    And Each array element of array in response should contain property:    [data][0][attributes][cmsPages]    name
    And Each array element of array in response should contain property:    [data][0][attributes][cmsPages]    url
    And Each array element of array in response should contain property:    [data][0][attributes][abstractProducts]    price
    And Each array element of array in response should contain property:    [data][0][attributes][abstractProducts]    abstractName
    And Each array element of array in response should contain property:    [data][0][attributes][abstractProducts]    abstractSku
    And Each array element of array in response should contain property:    [data][0][attributes][abstractProducts]    url
    And Each array element of array in response should contain property:    [data][0][attributes][abstractProducts]    images
    And Each array element of array in response should contain property with value:    [data][0][attributes][categoryCollection]    name    Computer Accessories
    And Each array element of array in response should contain property:    [data][0][attributes][categoryCollection]    name
    And Each array element of array in response should contain property:    [data][0][attributes][categoryCollection]    url
    And Each array element of array in response should contain property:    [data][0][attributes][cmsPageCollection]    name
    And Each array element of array in response should contain property:    [data][0][attributes][cmsPageCollection]    url
    And Response body has correct self link