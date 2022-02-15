*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Search_with_empty_search_criteria_all_default_values_check
    When I send a GET request:    /catalog-search?q=
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][spellingSuggestion]    None
    #Sorting
    And Response should contain the array of a certain size:    [data][0][attributes][sort][sortParamNames]    5
    And Response should contain the array of a certain size:    [data][0][attributes][sort][sortParamLocalizedNames]    5
    And Response body parameter should contain:    [data][0][attributes]    currentSortParam
    And Response body parameter should contain:    [data][0][attributes]    currentSortOrder
    #Pagination
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    420
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    35
    And Response body parameter should be:    [data][0][attributes][pagination][currentItemsPerPage]    12
    And Response body parameter should be:    [data][0][attributes][pagination][config][defaultItemsPerPage]    12
    And Response should contain the array of a certain size:    [data][0][attributes][pagination][config][validItemsPerPageOptions]    3
    And Response body parameter should contain:    [data][0][attributes][pagination][config][validItemsPerPageOptions]    12
    And Response body parameter should contain:    [data][0][attributes][pagination][config][validItemsPerPageOptions]    24
    And Response body parameter should contain:    [data][0][attributes][pagination][config][validItemsPerPageOptions]    36
    #Abstract products
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    12
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    abstractSku
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    price
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    abstractName
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    prices
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    images
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    abstractSku
    #Filters - categoty
    And Response body parameter should contain:    [data][0][attributes]    valueFacets
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][name]    category
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][localizedName]    Categories
    And Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][0][values]    36
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][config][isMultiValued]    False
    #Filters - labels
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][name]    label
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][localizedName]    Product Labels
    And Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][1][values]    4
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][config][isMultiValued]    True
    #Filters - color
    And Response body parameter should be:    [data][0][attributes][valueFacets][2][name]    farbe
    And Response body parameter should be:    [data][0][attributes][valueFacets][2][localizedName]    Color
    And Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][2][values]    9
    And Response body parameter should be:    [data][0][attributes][valueFacets][2][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][2][config][isMultiValued]    True
    #Filters - color
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][name]    material
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][localizedName]    Material
    And Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][3][values]    9
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][config][isMultiValued]    True
    #Filters - brand
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][name]    brand
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][localizedName]    Brand
    And Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][4][values]    9
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][config][isMultiValued]    False
    #Filters - rating
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][name]    rating
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][localizedName]    Product Ratings
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][min]    4
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][max]    5
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMin]    4
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMax]    5
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][config][isMultiValued]    False
    #Filters - category
    And Response should contain the array larger than a certain size:    [data][0][attributes][categoryTreeFilter]    5
    And Each array element of array in response should contain value:    [data][0][attributes][categoryTreeFilter]   nodeId
    And Each array element of array in response should contain value:    [data][0][attributes][categoryTreeFilter]   name  
    And Each array element of array in response should contain value:    [data][0][attributes][categoryTreeFilter]   docCount  
    And Each array element of array in response should contain value:    [data][0][attributes][categoryTreeFilter]   children  
    #Selflinks
    And Response body has correct self link
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][next]

Search_by_concrete_sku
    When I send a GET request:    /catalog-search?q=${concrete_product_with_alternative_sku}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    1
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    1
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractSku]    ${abstract_product_with_alternative_sku}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractName]    ${abstract_product_with_alternative_name}
    And Response body parameter should be greater than:    [data][0][attributes][abstractProducts][0][prices][0][DEFAULT]    100
    #categories
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][0][values]    4
    #labels
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][1][values]    2
    #brand
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][4][values]    1
    And Response body has correct self link
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][last]
