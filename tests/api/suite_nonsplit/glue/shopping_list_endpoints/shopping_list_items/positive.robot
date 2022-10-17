*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup

Add_a_concrete_product_to_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_available_product.sku}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_concrete_product_to_the_shopping_list_with_includes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items?include=concrete-products    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_available_product.sku}
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:   concrete-products
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_one_more_product_to_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundle_product.concrete.product_1_sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${bundle_product.concrete.product_1_sku}
    And I send a GET request:    /shopping-lists/${shoppingListId}
    And Response status code should be:    200
    And Response body parameter should be:    [data][attributes][numberOfItems]    2
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_the_same_product_to_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_available_product.sku}
    And I send a GET request:    /shopping-lists/${shoppingListId}
    And Response status code should be:    200
    And Response body parameter should be:    [data][attributes][numberOfItems]    2
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content


Add_a_bundle_concrete_product_to_the_shopping_list_with_includes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items?include=concrete-products     {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundle_product.concrete.product_1_sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${bundle_product.concrete.product_1_sku}
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:   concrete-products
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_an_unavailable_product_to_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${product_availability.concrete_unavailable_product}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${product_availability.concrete_unavailable_product}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_concrete_product_to_the_shared_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a GET request:    /shopping-lists/
    ...    AND    Save value to a variable:    [data][0][id]    sharedShoppingListId
    ...    AND    I get access token for the customer:    ${yves_shared_shopping_list_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    I send a POST request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    shoppingListItemId
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_available_product.sku}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items/${shoppingListItemId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_quantity_of_the_concrete_product_in_the_shopping_list_with_includes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a PATCH request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}?include=concrete-products    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response body parameter should be:    [data][attributes][quantity]    2
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:   concrete-products
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_quantity_of_the_bundle_concrete_product_in_the_shopping_list_with_includes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundle_product.concrete.product_1_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a PATCH request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}?include=concrete-products    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response body parameter should be:    [data][attributes][quantity]    2
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:   concrete-products
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_quantity_of_the_concrete_product_in_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a PATCH request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response body parameter should be:    [data][attributes][quantity]    2
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_quantity_of_a_concrete_product_at_the_shared_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a GET request:    /shopping-lists/
    ...    AND    Save value to a variable:    [data][0][id]    sharedShoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    ...    AND    I get access token for the customer:    ${yves_shared_shopping_list_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    I send a PATCH request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items/${shoppingListItemId}    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response body parameter should be:    [data][attributes][quantity]    2
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items/${shoppingListItemId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_quantity_of_the_bundle_concrete_product_in_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundle_product.concrete.product_1_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a PATCH request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response body parameter should be:    [data][attributes][quantity]    2
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Remove_a_concrete_product_from_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a DELETE request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}
    And Response status code should be:    204
    And Response reason should be:    No Content
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content    

Remove_a_bundle_concrete_product_from_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundle_product.concrete.product_1_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a DELETE request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}
    And Response status code should be:    204
    And Response reason should be:    No Content
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content   

Remove_a_concrete_product_from_the_shared_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a GET request:    /shopping-lists/
    ...    AND    Response status code should be:    200
    ...    AND    Save value to a variable:    [data][0][id]    sharedShoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    ...    AND    I get access token for the customer:    ${yves_shared_shopping_list_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    I send a DELETE request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items/${shoppingListItemId}
    And Response status code should be:    204
    And Response reason should be:    No Content

Add_a_configurable_product_to_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred_time_of_the_day":"Afternoon","Date":"9.09.2050"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    3
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
   [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
   ...    AND    Response status code should be:    204
   ...    AND    Response reason should be:    No Content

Change_preferred_time_of_the_day_of_the_configurable_product_in_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred_time_of_the_day":"Afternoon","Date":"9.09.2050"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    shoppingListItemId
    I send a PATCH request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}?include=concrete-products    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred_time_of_the_day":"Evening","Date":"9.09.2050"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${shoppingListItemId}
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${ShoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content
    
Change_preferred_date_of_the_configurable_product_in_the_shopping_list
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
   I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred_time_of_the_day":"Afternoon","Date":"9.09.2050"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    201
   And Save value to a variable:    [data][id]    shoppingListItemId
   I send a PATCH request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}?include=concrete-products    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred_time_of_the_day":"Afternoon","Date":"20.10.2030"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    200
   And Response header parameter should be:    Content-Type    ${default_header_content_type}
   And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
   [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${ShoppingListId}/shopping-list-items/${shoppingListItemId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content 