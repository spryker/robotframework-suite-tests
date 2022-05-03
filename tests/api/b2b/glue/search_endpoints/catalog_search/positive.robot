*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

##### SEARCH PARAMETERS #####

Search_with_empty_search_criteria_all_default_values_check
    When I send a GET request:    /catalog-search?q=
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][spellingSuggestion]    None
    #Sorting
    And Response should contain the array of a certain size:    [data][0][attributes][sort][sortParamNames]    ${sorting_options_qty}
    And Response should contain the array of a certain size:    [data][0][attributes][sort][sortParamLocalizedNames]    ${sorting_options_qty}
    And Response body parameter should contain:    [data][0][attributes]    currentSortParam
    And Response body parameter should contain:    [data][0][attributes]    currentSortOrder
    #Pagination
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    ${total_number_of_products_in_search}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    ${default_ipp_pages_qty}
    And Response body parameter should be:    [data][0][attributes][pagination][currentItemsPerPage]    ${default_ipp}
    And Response body parameter should be:    [data][0][attributes][pagination][config][defaultItemsPerPage]    ${default_ipp}
    And Response should contain the array of a certain size:    [data][0][attributes][pagination][config][validItemsPerPageOptions]    3
    And Response body parameter should contain:    [data][0][attributes][pagination][config][validItemsPerPageOptions]    ${default_ipp}
    And Response body parameter should contain:    [data][0][attributes][pagination][config][validItemsPerPageOptions]    ${ipp_middle}
    And Response body parameter should contain:    [data][0][attributes][pagination][config][validItemsPerPageOptions]    ${ipp_biggest}
    #Abstract products
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    abstractSku
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    price
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    abstractName
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    prices
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    images
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    abstractSku
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][prices][0][currency][code]    ${currency_code_eur}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][prices][0][currency][symbol]    ${currency_symbol_eur} 
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][prices][0][currency][name]    ${currency_name_eur} 
    And Response body parameter should be greater than:    [data][0][attributes][abstractProducts][0][prices][0][DEFAULT]    1  
    #Filters - category
    And Response body parameter should contain:    [data][0][attributes]    valueFacets
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][name]    category
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][localizedName]    Categories
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][0][values]    ${default_categories_qty}
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][config][isMultiValued]    False
    #Filters - labels
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][name]    label
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][localizedName]    Product Labels
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][1][values]    ${default_labels_qty}
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][config][isMultiValued]    True
    #Filters - color
    And Response body parameter should be:    [data][0][attributes][valueFacets][2][name]    farbe
    And Response body parameter should be:    [data][0][attributes][valueFacets][2][localizedName]    Color
    And Response should contain the array of acertain size:    [data][0][attributes][valueFacets][2][values]    ${default_colors_qty}
    And Response body parameter should be:    [data][0][attributes][valueFacets][2][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][2][config][isMultiValued]    True
    #Filters - material
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][name]    material
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][localizedName]    Material
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][3][values]    ${default_materials_qty}
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][config][isMultiValued]    True
    #Filters - brand
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][name]    brand
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][localizedName]    Brand
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][4][values]    ${default_brands_qty}
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][config][isMultiValued]    False
    #Filters - rating
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][name]    rating
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][localizedName]    Product Ratings
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][min]    ${default_min_rating}
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][max]    ${default_max_rating}
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMin]    ${default_min_rating}
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMax]    ${default_max_rating}
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][config][isMultiValued]    False
    #Filters - category tree
    And Response should contain the array of a certain size:    [data][0][attributes][categoryTreeFilter]    ${category_tree_branches_qty}
    And Each array element of array in response should contain value:    [data][0][attributes][categoryTreeFilter]   nodeId
    And Each array element of array in response should contain value:    [data][0][attributes][categoryTreeFilter]   name  
    And Each array element of array in response should contain value:    [data][0][attributes][categoryTreeFilter]   docCount  
    And Each array element of array in response should contain value:    [data][0][attributes][categoryTreeFilter]   children  
    #Selflinks
    And Response body has correct self link
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][next]

Search_by_attribute_that_does_not_return_products
    When I send a GET request:    /catalog-search?q=fake
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    0
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    0
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    0
    #categories
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][0][values]    0
    #labels
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][1][values]    0
    #brand
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][4][values]    0
    And Response body has correct self link

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
    And Response body parameter should be greater than:    [data][0][attributes][abstractProducts][0][prices][0][DEFAULT]    10
    #categories
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][0][values]    4
    #labels
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][1][values]    2
    #brand
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][4][values]    1
    And Response body has correct self link

Search_by_abstract_sku
    When I send a GET request:    /catalog-search?q=${abstract_product_with_alternative_sku}
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
    And Response body parameter should be greater than:    [data][0][attributes][abstractProducts][0][prices][0][DEFAULT]    10
    #categories
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][0][values]    4
    #labels
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][1][values]    2
    #brand
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][4][values]    1
    And Response body has correct self link

Search_by_full_name
    When I send a GET request:    /catalog-search?q=${abstract_product_with_alternative_name}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be greater than:    [data][0][attributes][pagination][numFound]    ${default_ipp}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractSku]    ${abstract_product_with_alternative_sku}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractName]    ${abstract_product_with_alternative_name}
    And Response body parameter should be greater than:    [data][0][attributes][abstractProducts][0][prices][0][DEFAULT]    10
    #categories
    And Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][0][values]    4
    #labels
    And Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][1][values]    2
    #brand
    And Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][4][values]    1
    And Response body has correct self link

Search_by_name_substring
    When I send a GET request:    /catalog-search?q=USB
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be greater than:    [data][0][attributes][pagination][numFound]    ${default_ipp}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Response body parameter should NOT be:    [data][0][attributes][abstractProducts][0][abstractSku]    ${abstract_product_with_alternative_sku}
    And Response body parameter should NOT be:   [data][0][attributes][abstractProducts][0][abstractName]    ${abstract_product_with_alternative_name}
    #categories
    And Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][0][values]    4
    #labels
    And Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][1][values]    2
    #brand
    And Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][4][values]    1
    And Response body has correct self link

Search_by_attribute_(brand)
    When I send a GET request:    /catalog-search?q=${brand_1}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    18
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Response body parameter should contain:   [data][0][attributes][abstractProducts][0][abstractName]    ${brand_1}
    #brand
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][4][values]    1
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][values][0][value]    ${brand_1}
    And Response body has correct self link

Search_by_several_attributes
    When I send a GET request:    /catalog-search?q=${color_3}+${material_3}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    20
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}

##### FILTERING #####

Filter_by_rating_only_min
    When I send a GET request:    /catalog-search?q=&rating[min]=3
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    20
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    #rating facets
    And Response body parameter should be:    [data][0][attributes][rangeFacets][1][activeMin]    3
    And Response body parameter should be:    [data][0][attributes][rangeFacets][1][activeMax]    ${default_max_rating}


Filter_by_rating_only_max
    When I send a GET request:    /catalog-search?q=&rating[max]=${default_min_rating}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    18
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    #rating facets
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMin]    ${default_min_rating}
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMax]    ${default_min_rating}


Filter_by_rating_Min_max
    When I send a GET request:    /catalog-search?q=&rating[min]=3&rating[max]=3
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    0
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    0
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    0
    #rating facets
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMin]    3
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMax]    3

Filter_by_brand_one_brand
    When I send a GET request:    /catalog-search?q=&brand=${brand_1}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    18
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][activeValue]    ${brand_1}
    And Response body has correct self link

Filter_by_brand_two_brands
    When I send a GET request:    /catalog-search?q=&brand[]=${brand_2}&brand[]=${brand_1}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    38
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][activeValue][0]    ${brand_2}
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][activeValue][1]    ${brand_1}

Filter_by_brand_empty_brand
    When I send a GET request:    /catalog-search?q=&brand=
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    ${total_number_of_products_in_search}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][activeValue]    ${EMPTY}
    And Response body has correct self link

Filter_by_brand_non_existing_brand
    When I send a GET request:    /catalog-search?q=&brand=test123
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    0
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    0
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    0
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][activeValue]    test123
    And Response body has correct self link

Filter_by_label_one_label
    When I send a GET request:    /catalog-search?q=&label=${manual_label}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    5
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    5
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue]    ${manual_label}
    And Response body has correct self link

Filter_by_label_two_labels
    When I send a GET request:    /catalog-search?q=&label[]=${new_label}&label[]=${manual_label}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    39
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue][0]    ${new_label}
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue][1]    ${manual_label}

Filter_by_label_non_existing_label
    When I send a GET request:    /catalog-search?q=&label[]=test123
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    0
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    0
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    0
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue][0]    test123

Filter_by_label_empty_label
    When I send a GET request:    /catalog-search?q=&label[]=
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    ${total_number_of_products_in_search}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    ${default_ipp_pages_qty}
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue][0]    ${EMPTY}

Filter_by_color_one_color
    When I send a GET request:    /catalog-search?q=&farbe=${color_1}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    4
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    4
    And Response body parameter should be:    [data][0][attributes][valueFacets][2][activeValue]    ${color_1}
    #additional checks that other filers react accordingly and reduce the number of available facets to match facets present for the found products
    And Response should contain the array smaller than a certain size:   [data][0][attributes][valueFacets][0]    ${default_categories_qty}
    And Response should contain the array smaller than a certain size:   [data][0][attributes][valueFacets][3]    ${default_materials_qty}
    And Response should contain the array smaller than a certain size:    [data][0][attributes][valueFacets][4]    ${default_brands_qty}
    And Response body has correct self link

Filter_by_color_two_colors
    When I send a GET request:    /catalog-search?q=&farbe[]=${color_1}&farbe[]=${color_2}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    10
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    10
    And Response body parameter should be:    [data][0][attributes][valueFacets][2][activeValue][0]    ${color_1}
    And Response body parameter should be:    [data][0][attributes][valueFacets][2][activeValue][1]    ${color_2}

Filter_by_color_non_existing_color
    When I send a GET request:    /catalog-search?q=&farbe[]=test123
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    0
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    0
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    0
    And Response body parameter should be:    [data][0][attributes][valueFacets][2][activeValue][0]    test123

Filter_by_color_empty_color
    When I send a GET request:    /catalog-search?q=&farbe[]=
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    ${total_number_of_products_in_search}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    ${default_ipp_pages_qty}
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Response body parameter should be:    [data][0][attributes][valueFacets][2][activeValue][0]    ${EMPTY}

Filter_by_material_one_material
    When I send a GET request:    /catalog-search?q=&material=${material_1}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    4
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    4
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][activeValue]    ${material_1}
    #additional checks that other filers react accordingly and reduce the number of available facets to match facets present for the found products
    And Response should contain the array smaller than a certain size:   [data][0][attributes][valueFacets][0]    ${default_categories_qty}
    And Response should contain the array smaller than a certain size:   [data][0][attributes][valueFacets][2]    ${default_colors_qty}
    And Response should contain the array smaller than a certain size:    [data][0][attributes][valueFacets][4]    ${default_brands_qty}
    And Response body has correct self link

Filter_by_material_two_materails
    When I send a GET request:    /catalog-search?q=&material[]=${material_1}&material[]=${material_2}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    15
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][activeValue][0]    ${material_1}
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][activeValue][1]    ${material_2}

Filter_by_material_non_existing_materail
    When I send a GET request:    /catalog-search?q=&material[]=test123
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    0
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    0
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    0
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][activeValue][0]    test123

Filter_by_material_empty_material
    When I send a GET request:    /catalog-search?q=&material[]=
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    ${total_number_of_products_in_search}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    ${default_ipp_pages_qty}
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][activeValue][0]    ${EMPTY}

Filter_by_valid_main_category
    When I send a GET request:    /catalog-search?q=&category=${category_id_lvl1}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    ${category_items_qty_lvl1}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][activeValue]    ${category_id_lvl1}
    # check that category tree is correctly updated
    And Response should contain the array of a certain size:    [data][0][attributes][categoryTreeFilter]    ${category_tree_branches_qty}
    And Response body parameter should be:    [data][0][attributes][categoryTreeFilter][0][docCount]    0
    And Response body parameter should be:    [data][0][attributes][categoryTreeFilter][3][docCount]    ${category_items_qty_lvl1}  
    And Response body parameter should be greater than:    [data][0][attributes][categoryTreeFilter][3][children][0][docCount]    0  
    And Response body parameter should be greater than:    [data][0][attributes][categoryTreeFilter][3][children][1][docCount]    0   
    And Response body parameter should be greater than:    [data][0][attributes][categoryTreeFilter][3][children][0][children][0][docCount]    0  
    And Response body has correct self link

Filter_by_valid_subcategory
    When I send a GET request:    /catalog-search?q=&category=${category_id_lvl2}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    ${category_items_qty_lvl2}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][activeValue]    ${category_id_lvl2}
    # check that category tree is correctly updated
    And Response should contain the array of a certain size:    [data][0][attributes][categoryTreeFilter]    ${category_tree_branches_qty}
    And Response body parameter should be:    [data][0][attributes][categoryTreeFilter][0][docCount]    0
    And Response body parameter should be:    [data][0][attributes][categoryTreeFilter][3][docCount]    ${category_items_qty_lvl2}  
    And Response body parameter should be:    [data][0][attributes][categoryTreeFilter][3][children][0][docCount]    ${category_items_qty_lvl2}  
    And Response body parameter should be:    [data][0][attributes][categoryTreeFilter][3][children][1][docCount]    0   
    And Response body parameter should be greater than:    [data][0][attributes][categoryTreeFilter][3][children][0][children][0][docCount]    0  
    And Response body parameter should be less than:    [data][0][attributes][categoryTreeFilter][3][children][0][children][0][docCount]    ${category_items_qty_lvl2} 
    And Response body has correct self link

Filter_by_valid_sub_subcategory
    When I send a GET request:    /catalog-search?q=&category=${category_id_lvl3}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    ${category_items_qty_lvl3}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][activeValue]    ${category_id_lvl3}
    # check that category tree is correctly updated
    And Response should contain the array of a certain size:    [data][0][attributes][categoryTreeFilter]    ${category_tree_branches_qty}
    And Response body parameter should be:    [data][0][attributes][categoryTreeFilter][0][docCount]    0
    And Response body parameter should be:    [data][0][attributes][categoryTreeFilter][3][docCount]    ${category_items_qty_lvl3}  
    And Response body parameter should be:    [data][0][attributes][categoryTreeFilter][3][children][0][docCount]    ${category_items_qty_lvl3}  
    And Response body parameter should be:    [data][0][attributes][categoryTreeFilter][3][children][1][docCount]    0   
    And Response body parameter should be:    [data][0][attributes][categoryTreeFilter][3][children][0][children][0][docCount]    ${category_items_qty_lvl3} 
    And Response body parameter should be:    [data][0][attributes][categoryTreeFilter][3][children][0][children][1][docCount]    0
    And Response body has correct self link

Search_with_specific_currency
    When I send a GET request:    /catalog-search?q=&currency=${currency_code_chf}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be less than:    [data][0][attributes][pagination][numFound]    ${total_number_of_products_in_search}
    And Response body parameter should be greater than:    [data][0][attributes][pagination][numFound]    1
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][prices][0][currency][code]    ${currency_code_chf}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][prices][0][currency][symbol]    ${currency_symbol_chf} 
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][prices][0][currency][name]    ${currency_name_chf} 
    And Response body parameter should be greater than:    [data][0][attributes][abstractProducts][0][prices][0][DEFAULT]    1   
    And Response body has correct self link

##### PAGINATION AND SORTING #####

Search_set_specific_page_with_default_ipp
    # here page 4 is selected using offset because 36/12=3 full pages, search shows the next page after the offset
    When I send a GET request:    /catalog-search?q=&page[limit]=${default_ipp}&page[offset]=36
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    ${total_number_of_products_in_search}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    4
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    ${default_ipp_pages_qty}
    And Response body parameter should be:    [data][0][attributes][pagination][config][defaultItemsPerPage]    ${default_ipp}
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Response body parameter should not be EMPTY:    [links][self]
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][prev]
    And Response body parameter should not be EMPTY:    [links][next]


Search_set_specific_page_and_nondefault_ipp
    When I send a GET request:    /catalog-search?q=&page[limit]=${ipp_middle}&page[offset]=36
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    ${total_number_of_products_in_search}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    2
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    18
    And Response body parameter should be:    [data][0][attributes][pagination][config][defaultItemsPerPage]    ${default_ipp}
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp_middle}
    And Response body parameter should not be EMPTY:    [links][self]
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][prev]
    And Response body parameter should not be EMPTY:    [links][next]

Search_set_last_page_and_nondefault_ipp
    When I send a GET request:    /catalog-search?q=&page[limit]=${ipp_biggest}&page[offset]=${total_number_of_products_in_search}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    ${total_number_of_products_in_search}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    12
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    12
    And Response body parameter should be:    [data][0][attributes][pagination][config][defaultItemsPerPage]    ${default_ipp}
    And Response should contain the array larger than a certain size:    [data][0][attributes][abstractProducts]    1
    And Response body parameter should not be EMPTY:    [links][self]
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][prev]

Search_set_invalid_ipp
    When I send a GET request:    /catalog-search?q=&page[limit]=18&page[offset]=1
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    ${total_number_of_products_in_search}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    ${default_ipp_pages_qty}
    And Response body parameter should be:    [data][0][attributes][pagination][config][defaultItemsPerPage]    ${default_ipp}
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${default_ipp}
    And Response body parameter should not be EMPTY:    [links][self]
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][next]

Search_sort_by_name_asc
    When I send a GET request:    /catalog-search?q=&sort=name_asc
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][sort][currentSortParam]    name_asc
    And Response body parameter should be:    [data][0][attributes][sort][currentSortOrder]    asc
    And Response body parameter should start with:    [data][0][attributes][abstractProducts][0][abstractName]    A
    And Response body has correct self link

Search_sort_by_name_desc
    When I send a GET request:    /catalog-search?q=&sort=name_desc
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][sort][currentSortParam]    name_desc
    And Response body parameter should be:    [data][0][attributes][sort][currentSortOrder]    desc
    And Response body parameter should start with:    [data][0][attributes][abstractProducts][0][abstractName]    r
    And Response body has correct self link

Search_sort_by_rating
    When I send a GET request:    /catalog-search?q=&sort=rating
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][sort][currentSortParam]    rating
    And Response body parameter should be:    [data][0][attributes][sort][currentSortOrder]    desc
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractSku]    ${abstract_sku_highest_rating}
    And Response body has correct self link


Search_sort_by_price_asc
    When I send a GET request:    /catalog-search?q=&sort=price_asc
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][sort][currentSortParam]    price_asc
    And Response body parameter should be:    [data][0][attributes][sort][currentSortOrder]    asc
    And Response body parameter should be less than:    [data][0][attributes][abstractProducts][0][prices][0][DEFAULT]    50
    And Response body has correct self link

Search_sort_by_price_desc
    When I send a GET request:    /catalog-search?q=&sort=price_desc
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][sort][currentSortParam]    price_desc
    And Response body parameter should be:    [data][0][attributes][sort][currentSortOrder]    desc
    And Response body parameter should be greater than:    [data][0][attributes][abstractProducts][0][prices][0][DEFAULT]    10000
    And Response body has correct self link

Search_sort_by_price_filter_query_parameter_and_pagination
    When I send a GET request:    /catalog-search?q=soe&sort=price_desc&brand=${brand_1}&page[limit]=${ipp_middle}&page[offset]=1
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][sort][currentSortParam]    price_desc
    And Response body parameter should be:    [data][0][attributes][sort][currentSortOrder]    desc
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    18
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    18
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][activeValue]    ${brand_1}
    And Response body parameter should be greater than:    [data][0][attributes][abstractProducts][0][prices][0][DEFAULT]    5000

Search_by_abstract_sku_with_abstract_include
    When I send a GET request:    /catalog-search?q=${abstract_product_with_alternative_sku}&include=abstract-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    1
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractSku]    ${abstract_product_with_alternative_sku}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractName]    ${abstract_product_with_alternative_name}
    And Response should contain the array of a certain size:    [data][0][relationships][abstract-products][data]    1
    And Response should contain the array of a certain size:    [included]    1
    And Response include should contain certain entity type:    abstract-products
    And Response include element has self link:   abstract-products
    And Response body parameter should be:    [included][0][id]  ${abstract_product_with_alternative_sku}
    And Response body has correct self link
