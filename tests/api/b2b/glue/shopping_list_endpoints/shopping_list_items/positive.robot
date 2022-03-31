*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
Add_a_concrete_product_to_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_available_product_sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_concrete_product_to_the_shopping_list_with_includes    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items?include=concrete-products    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_available_product_sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array larger than a certain size:    [data][relationships]    0
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:   concrete-products
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_one_more_product_to_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundle_product_concrete_sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${bundle_product_concrete_sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_the_same_product_to_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_available_product_sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_bundle_concrete_product_to_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundle_product_concrete_sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${bundle_product_concrete_sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_bundle_concrete_product_with_includes_to_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items?include=concrete-products     {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundle_product_concrete_sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${bundle_product_concrete_sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array larger than a certain size:    [data][relationships]    0
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:   concrete-products
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

# need to find unavailable product
# Add_an_unavailable_product_to_the_shopping_list    
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${unavailable_product_concrete_sku}","quantity":1}}}
#     And Response status code should be:    201
#     And Response body parameter should be:    [data][attributes][quantity]    1
#     And Response body parameter should be:    [data][attributes][sku]    ${unavailable_product_concrete_sku}
#     And Response header parameter should be:    Content-Type    ${default_header_content_type}
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content

Change_quantity_of_the_concrete_product_in_the_shopping_list_with_includes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a PATCH request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}?include=concrete-product-prices,concrete-product-image-sets,concrete-product-availabilities,product-labels    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][quantity]    2
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array larger than a certain size:    [data][relationships]    0
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:   concrete-products
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_quantity_of_the_bundle_concrete_product_in_the_shopping_list_with_includes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundle_product_concrete_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a PATCH request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}?include=concrete-products    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][quantity]    2
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array larger than a certain size:    [data][relationships]    0
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:   concrete-products
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_quantity_of_the_concrete_product_in_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a PATCH request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][quantity]    2
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_quantity_of_the_concrete_product_in_the_shopping_list_with_includes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a PATCH request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}?include=concrete-product-prices,concrete-product-image-sets,concrete-product-availabilities,product-labels    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][quantity]    2
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_quantity_of_the_bundle_concrete_product_in_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundle_product_concrete_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a PATCH request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][quantity]    2
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Remove_a_concrete_product_from_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a DELETE request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}
    And Response status code should be:    204
    And Response reason should be:    No Content
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content    

Remove_a_bundle_concrete_product_from_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundle_product_concrete_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a DELETE request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}
    And Response status code should be:    204
    And Response reason should be:    No Content
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content   