*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

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
    And Response should contain the array of a certain size:    [data][relationships]    1
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
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundled_product_1_concrete_sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${bundled_product_1_concrete_sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And I send a GET request:    /shopping-lists/${shoppingListId}
    And Response status code should be:    200
    And Response body parameter should be:    [data][attributes][numberOfItems]    2
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
    And I send a GET request:    /shopping-lists/${shoppingListId}
    And Response status code should be:    200
    And Response body parameter should be:    [data][attributes][numberOfItems]    2
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

#need to find a concrete product with random weight in mp-b2b
Add_a_concrete_product_with_random_weight_to_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_product_random_weight_sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_product_random_weight_sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_bundle_concrete_product_to_the_shopping_list_with_includes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items?include=concrete-products     {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundled_product_1_concrete_sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${bundled_product_1_concrete_sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:   concrete-products
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

# need to find unavailable product in mp-b2b
Add_an_unavailable_product_to_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_unavailable_product_sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_unavailable_product_sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_concrete_product_to_the_shared_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a GET request:    /shopping-lists/
    ...    AND    Save value to a variable:    [data][0][id]    sharedShoppingListId
    ...    AND    I get access token for the customer:    ${yves_shared_shopping_list_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    I send a POST request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    shoppingListItemId
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_available_product_sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items/${shoppingListItemId}
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
    I send a PATCH request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}?include=concrete-products    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][quantity]    2
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
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
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundled_product_1_concrete_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a PATCH request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}?include=concrete-products    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][quantity]    2
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
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

Change_quantity_of_a_concrete_product_at_the_shared_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a GET request:    /shopping-lists/
    ...    AND    Save value to a variable:    [data][0][id]    sharedShoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    ...    AND    I get access token for the customer:    ${yves_shared_shopping_list_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    I send a PATCH request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items/${shoppingListItemId}    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response body parameter should be:    [data][attributes][quantity]    2
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items/${shoppingListItemId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_quantity_of_the_bundle_concrete_product_in_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundled_product_1_concrete_sku}","quantity":1}}}
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
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundled_product_1_concrete_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a DELETE request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}
    And Response status code should be:    204
    And Response reason should be:    No Content
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content   

Remove_a_concrete_product_from_the_shared_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a GET request:    /shopping-lists/
    ...    AND    Response status code should be:    200
    ...    AND    Save value to a variable:    [data][0][id]    sharedShoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    ...    AND    I get access token for the customer:    ${yves_shared_shopping_list_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    I send a DELETE request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items/${shoppingListItemId}
    And Response status code should be:    204
    And Response reason should be:    No Content