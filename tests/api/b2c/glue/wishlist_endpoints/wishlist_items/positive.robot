*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup     TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
        TestSetup

#Post

Adding_item_in_wishlist 
    [Documentation]   #CC-16555 API: JSON response is missing product availability and price
    [Tags]    skip-due-to-issue 
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${product_availability.concrete_available_product_with_stock}"}}}
    Then Response status code should be:    201 
    And Response reason should be:    Created
    And Save value to a variable:    [data][id]    wishlist_items_id
    And Response body parameter should not be EMPTY:    [data][attributes][sku]
    And Response body parameter should be:    [data][type]    wishlist-items
    And Response body parameter should be:    [data][id]    ${wishlist_items_id}
    And Response body parameter should be:    [data][attributes][sku]    ${product_availability.concrete_available_product_with_stock}
    And Response body parameter should be:    [data][attributes][id]    ${wishlist_items_id}
    And Response body parameter should not be EMPTY:    [data][attributes][availability]
    And Response body parameter should not be EMPTY:    [data][attributes][price]
    And Response body parameter should not be EMPTY:    [data][links][self]
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204

Adding_multiple_variant_of_abstract_product_in_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${multivariant.concrete_product.sku_variant1}"}}}
    Then Response status code should be:    201 
    And Response reason should be:    Created
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${multivariant.concrete_product.sku_variant2}"}}}
    Then Response status code should be:    201 
    And Response reason should be:    Created
    And Save value to a variable:    [data][id]    wishlist_items_id
    And Response body parameter should not be EMPTY:    [data][attributes][sku]
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items
    Then Response status code should be:    200 
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    wishlists
    And Response body parameter should be:    [data][id]    ${wishlist_id}
    And Response body parameter should be:    [data][attributes][name]    ${wishlist_name}
    And Response body parameter should be:    [data][attributes][numberOfItems]    2
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][wishlist-items][data][0]
    And Response body parameter should not be EMPTY:    [data][relationships][wishlist-items][data][1]
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204

#Delete
Deleting_item_from_wishlist
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${product_availability.concrete_available_product_with_stock}"}}}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    When I send a DELETE request:    /wishlists/${wishlist_id}/wishlist-items/${product_availability.concrete_available_product_with_stock}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204

Add_a_configurable_product_with_first_product_variant_to_the_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku_1}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Afternoon","Date":"09.09.2050"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku_1}
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {"Preferred time of the day":"Afternoon","Date":"09.09.2050"} 
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  True  
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items,concrete-products
    And Response status code should be:    200
    And Response body parameter should be:  [data][type]    wishlists
    And Response body parameter should be:  [data][id]    ${wishlist_id}
    And Response body parameter should be:    [data][attributes][numberOfItems]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response body parameter should be:    [data][relationships][wishlist-items][data][0][type]   wishlist-items
    And Response body parameter should be:    [data][relationships][wishlist-items][data][0][id]   ${configurable_product.sku_1}
    And Response should contain the array of a certain size:    [included]    2
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    wishlist-items
    And Response body parameter should be:    [included][0][type]    concrete-products
    And Response body parameter should be:    [included][1][type]    wishlist-items
    And Response body parameter should be:    [included][1][id]    ${configurable_product.sku_1}
    And Response body parameter should be:    [included][1][attributes][productConfigurationInstance][isComplete]  True 
    And Response body parameter should be:    [included][1][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"09.09.2050\"}
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_configurable_product_with_second_product_variant_to_the_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku_2}","quantity":1,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Evening","Date":"09.09.2050"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku_2}
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {"Preferred time of the day":"Evening","Date":"09.09.2050"} 
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  True  
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items,concrete-products
    And Response status code should be:    200
    And Response body parameter should be:  [data][type]    wishlists
    And Response body parameter should be:  [data][id]    ${wishlist_id}
    And Response body parameter should be:    [data][attributes][numberOfItems]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response body parameter should be:    [data][relationships][wishlist-items][data][0][type]   wishlist-items
    And Response body parameter should be:    [data][relationships][wishlist-items][data][0][id]   ${configurable_product.sku_2}
    And Response should contain the array of a certain size:    [included]    2
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    wishlist-items
    And Response body parameter should be:    [included][0][type]    concrete-products
    And Response body parameter should be:    [included][1][type]    wishlist-items
    And Response body parameter should be:    [included][1][id]    ${configurable_product.sku_2}
    And Response body parameter should be:    [included][1][attributes][productConfigurationInstance][isComplete]  True 
    And Response body parameter should be:    [included][1][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Evening\",\"Date\":\"09.09.2050\"}
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_preferred_time_of_the_day_of_the_configurable_product_in_the_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku_1}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Afternoon","Date":"09.09.2050"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku_1}
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {"Preferred time of the day":"Afternoon","Date":"09.09.2050"} 
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  True  
    I send a PATCH request:    /wishlists/${ wishlist_id}/wishlist-items/${WishListItemId}?include=concrete-products    {"data":{"type":"wishlist-items","attributes":{"sku":"${configurable_product.sku_1}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Evening","Date":"9.09.2050"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${configurable_product.sku_1}
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku_1}
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {"Preferred time of the day":"Evening","Date":"9.09.2050"} 
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  True
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content
 
Change_preferred_date_of_the_configurable_product_in_the_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku_2}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Afternoon","Date":"09.09.2050"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku_2}
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {"Preferred time of the day":"Afternoon","Date":"09.09.2050"} 
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  True  
    I send a PATCH request:    /wishlists/${ wishlist_id}/wishlist-items/${WishListItemId}?include=concrete-products    {"data":{"type":"wishlist-items","attributes":{"sku":"${configurable_product.sku_2}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Afternoon","Date":"10.10.2030"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${configurable_product.sku_2}
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku_2}
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {"Preferred time of the day":"Afternoon","Date":"10.10.2030"} 
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  True
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Set_configuration_for_the_configurable_product_in_the_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku_1}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Afternoon","Date":"11.11.2029"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":False,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku_1}
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {"Preferred time of the day":"Afternoon","Date":"11.11.2029"} 
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  False 
    I send a PATCH request:    /wishlists/${ wishlist_id}/wishlist-items/${WishListItemId}?include=concrete-products    {"data":{"type":"wishlist-items","attributes":{"sku":"${configurable_product.sku_1}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"11.11.2029"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items,concrete-products
    And Response status code should be:    200
    And Response body parameter should be:  [data][type]    wishlists
    And Response body parameter should be:  [data][id]    ${wishlist_id}
    And Response body parameter should be:    [data][attributes][numberOfItems]    1
    And Response should contain the array of a certain size:    [included]    2
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    wishlist-items
    And Response body parameter should be:    [included][1][attributes][productConfigurationInstance][isComplete]  True 
    And Response body parameter should be:    [included][1][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Morning\",\"Date\":\"11.11.2029\"}
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_2_Configurable_products_but_with_different_configurations
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku_1}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Afternoon","Date":"11.11.2029"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":False,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku_1}
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku_2}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"11.12.2029"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId2
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku_2}
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items,concrete-products
    And Response status code should be:    200
    And Response body parameter should be:  [data][type]    wishlists
    And Response body parameter should be:  [data][id]    ${wishlist_id}
    And Response body parameter should be:    [data][attributes][numberOfItems]    2
    And Response should contain the array of a certain size:    [included]    4
    And Response body parameter should be:   [included][0][type]    concrete-products
    And Response body parameter should be:   [included][0][id]    ${configurable_product.sku_1}
    And Response body parameter should be:   [included][1][type]    wishlist-items
    And Response body parameter should be:   [included][1][id]    ${configurable_product.sku_1}
    And Response body parameter should be:   [included][1][attributes][sku]    ${configurable_product.sku_1}
    And Response body parameter should be:   [included][1][attributes][productConfigurationInstance][displayData]    {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"11.11.2029\"}
    And Response body parameter should be:   [included][1][attributes][productConfigurationInstance][isComplete]    False
    And Response body parameter should be:   [included][2][type]    concrete-products
    And Response body parameter should be:   [included][2][id]    ${configurable_product.sku_2}
    And Response body parameter should be:   [included][3][type]    wishlist-items
    And Response body parameter should be:   [included][3][id]    ${WishListItemId2}
    And Response body parameter should be:   [included][3][attributes][sku]    ${configurable_product.sku_2}
    And Response body parameter should be:    [included][3][attributes][productConfigurationInstance][displayData]    {\"Preferred time of the day\":\"Morning\",\"Date\":\"11.12.2029\"}
    And Response body parameter should be:    [included][3][attributes][productConfigurationInstance][isComplete]    True
    And Response include element has self link:   wishlist-items
   [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content 

Add_2_product_variant_of_Configurable_products_without_configurations_and_set_configuration
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku_1}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Afternoon","Date":"11.11.2029"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":False,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku_1}
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku_2}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"11.12.2029"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":False,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId2
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku_2}
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items
    And Response status code should be:    200
    And Response body parameter should be:  [data][type]    wishlists
    And Response body parameter should be:  [data][id]    ${wishlist_id}
    And Response body parameter should be:    [data][attributes][numberOfItems]    2
    And Response should contain the array of a certain size:    [included]    2
    And Response body parameter should be:   [included][0][type]    wishlist-items
    And Response body parameter should be:   [included][0][id]    ${configurable_product.sku_1}
    And Response body parameter should be:   [included][0][attributes][sku]    ${configurable_product.sku_1}
    And Response body parameter should be:   [included][0][attributes][productConfigurationInstance][displayData]    {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"11.11.2029\"}
    And Response body parameter should be:   [included][0][attributes][productConfigurationInstance][isComplete]    False
    And Response body parameter should be:   [included][1][type]    wishlist-items
    And Response body parameter should be:   [included][1][id]    ${WishListItemId2}
    And Response body parameter should be:   [included][1][attributes][sku]    ${configurable_product.sku_2}
    And Response body parameter should be:    [included][1][attributes][productConfigurationInstance][displayData]    {\"Preferred time of the day\":\"Morning\",\"Date\":\"11.12.2029\"}
    And Response body parameter should be:    [included][1][attributes][productConfigurationInstance][isComplete]    False
    And Response include element has self link:   wishlist-items
    I send a PATCH request:    /wishlists/${ wishlist_id}/wishlist-items/${WishListItemId}?include=concrete-products    {"data":{"type":"wishlist-items","attributes":{"sku":"${configurable_product.sku_1}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"11.11.2029"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    200
    I send a PATCH request:    /wishlists/${ wishlist_id}/wishlist-items/${WishListItemId2}?include=concrete-products    {"data":{"type":"wishlist-items","attributes":{"sku":"${configurable_product.sku_2}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"11.11.2029"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    200
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items
    And Response status code should be:    200
    And Response body parameter should be:   [included][0][attributes][productConfigurationInstance][isComplete]    True
    And Response body parameter should be:   [included][1][attributes][productConfigurationInstance][isComplete]    True
   [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_Configurable_products_and_regular_product
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku_1}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Afternoon","Date":"11.11.2029"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku_1}
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${product_availability.concrete_available_product_with_stock}"}}}
    Then Response status code should be:    201 
    And Save value to a variable:    [data][id]    wishlist_items_id2
    And Response body parameter should be:    [data][attributes][sku]    ${product_availability.concrete_available_product_with_stock}
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items
    And Response status code should be:    200
    And Response body parameter should be:    [data][attributes][numberOfItems]    2
    And Response should contain the array of a certain size:    [included]    2
    And Response body parameter should be:   [included][0][id]    ${configurable_product.sku_1}
    And Response body parameter should be:   [included][0][attributes][sku]    ${configurable_product.sku_1}
    And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][displayData]    {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"11.11.2029\"}
    And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][isComplete]    True
    And Response body parameter should be:   [included][1][id]    ${product_availability.concrete_available_product_with_stock}
    And Response body parameter should be:   [included][1][attributes][sku]    ${product_availability.concrete_available_product_with_stock}
    And Response body parameter should be:    [included][1][attributes][productConfigurationInstance]    None
    And Response include element has self link:   wishlist-items
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content 

Remove_a_configurable_product_from_the_wishlist    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku_2}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Afternoon","Date":"11.11.2029"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku_2}
    I send a DELETE request:    /wishlists/${wishlist_id}/wishlist-items/${WishListItemId}
    And Response status code should be:    204
    And Response reason should be:    No Content
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content 

Remove_a_configurable_product_from_the_wishlist_and_leave_a_regular_product
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku_1}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Afternoon","Date":"11.11.2029"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId1
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku_1}
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${product_availability.concrete_available_product_with_stock}"}}}
    Then Response status code should be:    201 
    And Save value to a variable:    [data][id]    wishlist_items_id2
    And Response body parameter should be:    [data][attributes][sku]    ${product_availability.concrete_available_product_with_stock}
    I send a DELETE request:    /wishlists/${wishlist_id}/wishlist-items/${WishListItemId1}
    And Response status code should be:    204
    And Response reason should be:    No Content
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items
    And Response status code should be:    200
    And Response body parameter should be:    [data][attributes][numberOfItems]    1
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should be:   [included][0][id]    ${product_availability.concrete_available_product_with_stock}
    And Response body parameter should be:   [included][0][attributes][sku]    ${product_availability.concrete_available_product_with_stock}
    And Response body parameter should be:    [included][0][attributes][productConfigurationInstance]    None
    And Response include element has self link:   wishlist-items
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content  