*** Settings ***
Suite Setup    SuiteSetup
Test Setup     TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
Get_cms_pages_list
    When I send a GET request:    /cms-pages
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    ${cms_pages.qty}
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body parameter should be in:    [data][0][attributes][name]    ${cms_pages.first_cms_page.name}    ${cms_pages.second_cms_page.name}    ${cms_pages.third_cms_page.name}    ${cms_page_collection_name}    ${cms_pages.cms_page_with_product_lists.name}
    And Response body parameter should be in:    [data][0][attributes][url]    ${cms_pages.first_cms_page.url_en}    ${cms_pages.second_cms_page.url_en}    ${cms_pages.third_cms_page.url_en}    ${cms_page_collection_url}    ${cms_pages.cms_page_with_product_lists.url}    
    And Each array element of array in response should contain property with value:    [data]    type    cms-pages  
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][isSearchable]    True
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    links
    And Each array element of array in response should contain value:    [data]    pageKey
    And Each array element of array in response should contain value:    [data]    name
    And Each array element of array in response should contain value:    [data]    validTo
    And Each array element of array in response should contain value:    [data]    url
    And Response body has correct self link

Get_specific_cms_page
    [Setup]    Run Keywords    I send a GET request:    /cms-pages
    ...    AND    Response status code should be:    200
    ...    AND    Save value to a variable:    [data][0][id]    cms_page_id    
    When I send a GET request:    /cms-pages/${cms_page_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cms_page_id}
    And Response body parameter should be:    [data][type]    cms-pages
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    And Response body parameter should not be EMPTY:    [data][attributes][url] 
    And Response body parameter should not be EMPTY:    [data][attributes][isSearchable]
    And Response body should contain:    pageKey
    And Response body should contain:    validTo
    And Response body has correct self link internal

Get_specific_cms_with_includes
    When I send a GET request:    /cms-pages/${cms_pages.cms_page_with_product_lists.id}?include=content-product-abstract-lists
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cms_pages.cms_page_with_product_lists.id}
    And Response body parameter should be:    [data][type]    cms-pages
    And Response body parameter should be:    [data][attributes][name]    ${cms_pages.cms_page_with_product_lists.name}
    And Response body has correct self link internal
    And Response should contain the array of a certain size:    [data][relationships][content-product-abstract-lists][data]    4
    And Response should contain the array larger than a certain size:    [included]    1
    And Response include should contain certain entity type:    content-product-abstract-lists
    And Response include element has self link:   content-product-abstract-lists

