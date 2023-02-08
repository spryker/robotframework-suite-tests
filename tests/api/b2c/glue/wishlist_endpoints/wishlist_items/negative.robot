*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup     TestSetup
Default Tags    glue

*** Test Cases ***
ENABLER
        TestSetup
#Post

# Adding_item_in_wishlist_by_invalid_Access_Token
#     [Setup]    I set Headers:    Authorization=3485h7
#     When I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
#     Then Response status code should be:    401
#     And Response reason should be:    Unauthorized
#     And Response should return error code:    001
#     And Response should return error message:    Invalid access token.
    
# Adding_item_in_wishlist_by_without_Access_Token
#     [Setup]    I set Headers:    Authorization=   
#     When I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
#     Then Response status code should be:    403
#     And Response reason should be:    Forbidden
#     And Response should return error code:    002
#     And Response should return error message:    Missing access token.

# Adding_item_with_abstract_sku
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
#     ...    AND    Response status code should be:    201 
#     ...    AND    Response reason should be:    Created
#     ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
#     When I send a POST request:   /wishlists/${wishlist_reference_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${abstract_available_product_with_stock.sku}"}}}
#     Then Response status code should be:    422
#     And Response reason should be:    Unprocessable Content  
#     And Response should return error code:    206
#     And Response should return error message:        "Cant add an item."
#     [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_reference_id}
#     ...    AND    Response status code should be:    204

# Adding_item_with_invalid_sku
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
#     ...    AND    Response status code should be:    201 
#     ...    AND    Response reason should be:    Created
#     ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
#     When I send a POST request:   /wishlists/${wishlist_reference_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "SK123445666"}}}
#     Then Response status code should be:    422
#     And Response reason should be:    Unprocessable Content  
#     And Response should return error code:    206 
#     And Response should return error message:        "Cant add an item."
#     [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_reference_id}
#     ...    AND    Response status code should be:    204

# Adding_item_with_empty_sku
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
#     ...    AND    Response status code should be:    201 
#     ...    AND    Response reason should be:    Created
#     ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
#     When I send a POST request:   /wishlists/${wishlist_reference_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": ""}}}
#     Then Response status code should be:    422
#     And Response reason should be:    Unprocessable Content  
#     And Response should return error code:    901 
#     And Response should return error message:        sku => This value should not be blank.
#     [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_reference_id}
#     ...    AND    Response status code should be:    204

# Adding_item_after_enter_space_in_sku
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
#     ...    AND    Response status code should be:    201 
#     ...    AND    Response reason should be:    Created
#     ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
#     When I send a POST request:   /wishlists/${wishlist_reference_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": " "}}}
#     Then Response status code should be:    422
#     And Response reason should be:    Unprocessable Content  
#     And Response should return error code:    206 
#     And Response should return error message:        "Cant add an item."
#     [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_reference_id}
#     ...    AND    Response status code should be:    204

# Adding_item_with_invalid_wishilist_id
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     When I send a POST request:   /wishlists/Mywishlist/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${product_availability.concrete_available_product_with_stock}"}}}
#     Then Response status code should be:    422
#     And Response reason should be:    Unprocessable Content  
#     And Response should return error code:    206 
#     And Response should return error message:        "Cant add an item."
 
# Adding_item_without_wishilist_id
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     When I send a POST request:   /wishlists//wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${product_availability.concrete_available_product_with_stock}"}}}
#     Then Response status code should be:    404
#     And Response reason should be:    Not Found
#     And Response should return error code:    201
#     And Response should return error message:    "Cant find wishlist."

# Adding_items_in_wishlist_by_another_customer_wishlist
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}" } }}
#     ...    AND    Save value to a variable:    [data][id]    wishlist_id
#     ...    AND    I get access token for the customer:   ${yves_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     When I send a POST request:   /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${product_availability.concrete_available_product_with_stock}"}}}
#     Then Response status code should be:    422
#     And Response reason should be:    Unprocessable Content
#     And Response should return error code:    206
#     And Response should return error message:    "Cant add an item."
#     [Teardown]    Run Keywords     I get access token for the customer:    ${yves_second_user.email}
#     ...     AND    I set Headers:    Authorization=${token}   
#     ...    AND    I send a DELETE request:    /wishlists/${wishlist_id}
#     ...    AND    Response status code should be:    204

# # There is no demo data for this test case
# Adding_item_with_deactivated_item_sku
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
#     ...    AND    Response status code should be:    201 
#     ...    AND    Response reason should be:    Created
#     ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
#     When I send a POST request:   /wishlists/${wishlist_reference_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "Demo-SKU-Id"}}}
#     Then Response status code should be:    422
#     And Response reason should be:    Unprocessable Content
#     And Response should return error code:    206
#     And Response should return error message:    "Cant add an item."
#     [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_reference_id}
#     ...    AND    Response status code should be:    204

# #Delete
# Deleting_item_in_wishlist_by_invalid_Access_Token
#     [Setup]    I set Headers:    Authorization=3485h7
#     When I send a DELETE request:    /wishlists/mywishlist/wishlist-items/${product_availability.concrete_available_product_with_stock}
#     Then Response status code should be:    401 
#     And Response reason should be:    Unauthorized
#     And Response should return error code:    001
#     And Response should return error message:    Invalid access token.
 
# Deleting_item_in_wishlist_by_without_Access_Token
#     [Setup]    I set Headers:    Authorization=
#     When I send a DELETE request:    /wishlists/mywishlist/wishlist-items/${product_availability.concrete_available_product_with_stock}
#     Then Response status code should be:    403
#     And Response reason should be:    Forbidden
#     And Response should return error code:    002
#     And Response should return error message:    Missing access token.

# Deleting_item_in_wishlist_with_empty_sku
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
#     ...    AND    Response status code should be:    201 
#     ...    AND    Response reason should be:    Created
#     ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
#     When I send a DELETE request:    /wishlists/${wishlist_reference_id}/wishlist-items/
#     Then Response status code should be:   400
#     And Response reason should be:    Bad Request
#     And Response should return error message:    Resource id is not specified.
#     [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
#     ...  AND    I send a DELETE request:    /wishlists/${wishlist_reference_id}
#     ...  AND    Response status code should be:    204

# Deleting_item_after_enter_space_in_sku
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
#     ...    AND    Response status code should be:    201 
#     ...    AND    Response reason should be:    Created
#     ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
#     When I send a DELETE request:    /wishlists/${wishlist_reference_id}/wishlist-items/" "
#     Then Response status code should be:   404
#     And Response reason should be:    Not Found
#     And Response should return error code:    208
#     And Response should return error message:    No item with provided sku in wishlist.
#     [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
#     ...  AND    I send a DELETE request:    /wishlists/${wishlist_reference_id}
#     ...  AND    Response status code should be:    204

# Deleting_item_which_is_not_exist_in_wishlist
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
#     ...    AND    Response status code should be:    201 
#     ...    AND    Response reason should be:    Created
#     ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
#     When I send a DELETE request:    /wishlists/${wishlist_reference_id}/wishlist-items/${product_availability.concrete_available_product_with_stock}
#     Then Response status code should be:    404
#     And Response reason should be:    Not Found
#     And Response should return error code:    208
#     And Response should return error message:    No item with provided sku in wishlist.
#     [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_reference_id}
#     ...    AND    Response status code should be:    204

# Delete_wishlist_item_from_already_deleted_wishlist
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
#     ...    AND    Response status code should be:    201 
#     ...    AND    Response reason should be:    Created
#     ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
#     When I send a POST request:    /wishlists/${wishlist_reference_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${product_availability.concrete_available_product_with_stock}"}}}
#     Then Response status code should be:    201 
#     And Response reason should be:    Created
#     When I send a DELETE request:    /wishlists/${wishlist_reference_id}
#     Then Response status code should be:    204
#     And Response reason should be:    No Content
#     When I send a DELETE request:    /wishlists/${wishlist_reference_id}/wishlist-items/${product_availability.concrete_available_product_with_stock}
#     Then Response status code should be:    404
#     And Response reason should be:    Not Found
#     And Response should return error code:    201
#     And Response should return error message:    "Cant find wishlist."

# Deleting_item_with_invalid_wishilist_id
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     When I send a DELETE request:   /wishlists/Mywishlist/wishlist-items/${product_availability.concrete_available_product_with_stock}
#     Then Response status code should be:    404
#     And Response reason should be:    Not Found
#     And Response should return error code:    201
#     And Response should return error message:        "Cant find wishlist."

# Deleting_item_without_wishilist_id
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     When I send a DELETE request:   /wishlists//wishlist-items/${product_availability.concrete_available_product_with_stock}
#     Then Response status code should be:    400
#     And Response reason should be:    Bad Request
#     And Response should return error message:    Resource id is not specified.

# Deleting_items_in_wishlist_by_another_customer_wishlist
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}" } }}
#     ...    AND    Save value to a variable:    [data][id]    wishlist_id
#     ...    AND    I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${product_availability.concrete_available_product_with_stock}"}}}
#     ...    AND    Save value to a variable:    [data][id]    wishlist_item_id
#     ...    AND    I get access token for the customer:   ${yves_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     When I send a DELETE request:   /wishlists/${wishlist_id}/wishlist-items/${wishlist_item_id}
#     Then Response status code should be:    404
#     And Response reason should be:    Not Found
#     And Response should return error code:    201
#     And Response should return error message:        "Cant find wishlist."
#     [Teardown]    Run Keywords     I get access token for the customer:    ${yves_second_user.email}
#     ...    AND    I set Headers:    Authorization=${token}   
#     ...    AND    I send a DELETE request:    /wishlists/${wishlist_id}
#     ...    AND    Response status code should be:    204

# Deleting_concrete_product_by_abstract_product_sku
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Authorization=${token}
#     ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}" } }}
#     ...    AND    Response status code should be:    201 
#     ...    AND    Response reason should be:    Created
#     ...    AND    Save value to a variable:    [data][id]    wishlist_id
#     ...    AND    I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${concrete_available_product.sku}"}}}
#     ...    AND    Response status code should be:    201 
#     ...    AND    Response reason should be:    Created
#     When I send a DELETE request:    /wishlists/${wishlist_id}/wishlist-items/${abstract_available_product_with_stock.sku}
#     Then Response status code should be:    404
#     And Response reason should be:    Not Found
#     And Response should return error code:    208
#     And Response should return error message:        No item with provided sku in wishlist.
#     [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
#     ...    AND    Response status code should be:    204


Add_a_non-configurable_product_to_the_shopping_list_with_configuration
    [Documentation]   https://spryker.atlassian.net/browse/CC-23115
    [Tags]    skip-due-to-issue  
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"01.01.01"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
  [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
   ...    AND    Response status code should be:    204
   ...    AND    Response reason should be:    No Content

# Add_a_non-configurable_product_to_the_shopping_list_with_configuration_and_configurable_product
#     [Documentation]   https://spryker.atlassian.net/browse/CC-23115
#     [Tags]    skip-due-to-issue  
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":3,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"01.01.01"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":True,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response header parameter should be:    Content-Type    ${default_header_content_type}
#     And Response status code should be:    422
#     And Response should return error code:    901
#     And Response reason should be:    Unprocessable Content
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":1,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Afternoon","Date":"11.11.2040"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":False,"quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response status code should be:    201
#     And Save value to a variable:    [data][id]    shoppingListItemId2
#     And Response body parameter should be:    [data][attributes][quantity]    1
#     And I send a GET request:    /shopping-lists/${shoppingListId}?include=shopping-list-items,concrete-products
#     And Response status code should be:    200
#     And Response body parameter should be:   [included][1][id]    ${shoppingListItemId2}
#     And Response body parameter should be:   [included][1][attributes][quantity]    1
#     And Response body parameter should be:   [included][1][attributes][sku]    ${configurable_product.sku}
#     And Response body parameter should be:    [included][1][attributes][productConfigurationInstance][displayData]    {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"11.11.2040\"}
#     And Response body parameter should be:    [included][1][attributes][productConfigurationInstance][isComplete]    False
#     And Response include element has self link:   shopping-list-items
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content

# Add_a_configurable_product_with_zero_quantity_to_the_shopping_list  
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items     {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":0,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"10.10.2040"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response status code should be:    422
#     And Response should return error code:    901
#     And Response reason should be:    Unprocessable Content
#     And Response should return error message:    quantity => This value should be greater than 0.
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content

# Add_a_configurable_product_with_string_quantity_to_the_shopping_list  
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items     {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":"fake","productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"10.10.2040"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response status code should be:    422
#     And Response should return error code:    901
#     And Response reason should be:    Unprocessable Content
#     And Response should return error message:    quantity => This value should be of type integer.
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content

# Add_a_configurable_product_with_negative_quantity_to_the_shopping_list  
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items     {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":-2,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"10.10.2040"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response status code should be:    422
#     And Response should return error code:    901
#     And Response reason should be:    Unprocessable Content
#     And Response should return error message:    quantity => This value should be greater than 0.
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content

# Add_a_configurable_product_with_missing_quantity_to_the_shopping_list  
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items     {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"10.10.2040"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response status code should be:    422
#     And Response should return error code:    901
#     And Response reason should be:    Unprocessable Content
#     And Response should return error message:    quantity => This field is missing.
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content

# Add_a_configurable_product_with_empty_quantity_value_of_to_the_shopping_list  
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items     {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":"","productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"10.10.2040"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response status code should be:    422
#     And Response should return error code:    901
#     And Response reason should be:    Unprocessable Content
#     And Response should return error message:    quantity => This value should not be blank.
#     And I send a GET request:    /shopping-lists/${shoppingListId}?include=shopping-list-items,concrete-products
#     And Response status code should be:    200
#     And Response body parameter should be:  [data][type]    shopping-lists
#     And Response body parameter should be:  [data][id]    ${shoppingListId}
#     And Response body parameter should be:    [data][attributes][numberOfItems]    0
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content    

# Add_a_configurable_product_with_zero_availableQuantity_to_the_shopping_list
#     [Documentation]   https://spryker.atlassian.net/browse/CC-25383
#     [Tags]    skip-due-to-issue   
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items     {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":2,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"10.10.2040"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":2,"availableQuantity":0,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response status code should be:    422
#     And Response should return error code:    901
#     And Response reason should be:    Unprocessable Content
#     And Response should return error message:    availableQuantity => This value should be greater than 0
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content

# Add_a_configurable_product_with_negative_availableQuantity_to_the_shopping_list
#     [Documentation]   https://spryker.atlassian.net/browse/CC-25383
#     [Tags]    skip-due-to-issue    
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items     {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":2,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"10.10.2040"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":2,"availableQuantity":-1,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response status code should be:    422
#     And Response should return error code:    901
#     And Response reason should be:    Unprocessable Content
#     And Response should return error message:    availableQuantity => This value should be greater than 0.
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content

# Add_a_configurable_product_with_empty_availableQuantity_value_of_to_the_shopping_list
#     [Documentation]   https://spryker.atlassian.net/browse/CC-25381
#     [Tags]    skip-due-to-issue    
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items     {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":2,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"10.10.2040"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":2,"availableQuantity":"","prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response status code should be:    422
#     And Response should return error code:    901
#     And Response reason should be:    Unprocessable Content
#     And Response should return error message:    availableQuantity => This value should not be blank.
#     And Response should return error message:    availableQuantity => This value should be of type numeric.
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content

# Add_aconfigurable_product_with_missing_availableQuantity_value_of_to_the_shopping_list
#     [Documentation]   https://spryker.atlassian.net/browse/CC-25381
#     [Tags]    skip-due-to-issue    
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items     {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":2,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"10.10.2040"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":2,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response status code should be:    422
#     And Response should return error code:    901
#     And Response reason should be:    Unprocessable Content
#     And Response should return error message:    availableQuantity => This field is missing.
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content 

# Add_aconfigurable_product_with_string_availableQuantity_value_of_to_the_shopping_list
#     [Documentation]   https://spryker.atlassian.net/browse/CC-25381
#     [Tags]    skip-due-to-issue    
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items     {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":2,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"10.10.2040"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":2,"availableQuantity":"string","prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response status code should be:    422
#     And Response should return error code:    901
#     And Response reason should be:    Unprocessable Content
#     And Response should return error message:    availableQuantity => This value should be of type numeric.
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content

# Add_a_configurable_product_with_numeric_isComplete_value_of_to_the_shopping_list
#     [Documentation]   https://spryker.atlassian.net/browse/CC-25381
#     [Tags]    skip-due-to-issue    
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items     {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":2,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"10.10.2040"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":1,"quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response status code should be:    422
#     And Response should return error code:    901
#     And Response reason should be:    Unprocessable Content
#     And Response should return error message:    isComplete => This value should be of type boolean.
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content

# Add_a_configurable_product_with_string_isComplete_value_of_to_the_shopping_list
#     [Documentation]   https://spryker.atlassian.net/browse/CC-25381
#     [Tags]    skip-due-to-issue    
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items     {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":2,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"10.10.2040"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":"True","quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response status code should be:    422
#     And Response should return error code:    901
#     And Response reason should be:    Unprocessable Content
#     And Response should return error message:    isComplete => This value should be of type boolean.
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content

# Add_a_configurable_product_with_missing_isComplete_value_of_to_the_shopping_list
#     [Documentation]   https://spryker.atlassian.net/browse/CC-25381
#     [Tags]    skip-due-to-issue    
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items     {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":2,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"10.10.2040"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response status code should be:    422
#     And Response should return error code:    901
#     And Response reason should be:    Unprocessable Content
#     And Response should return error message:    isComplete => This field is missing.
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content

# Add_a_configurable_product_with_negative_price_value_of_to_the_shopping_list
#     [Documentation]   https://spryker.atlassian.net/browse/CC-25381
#     [Tags]    skip-due-to-issue    
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items     {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":2,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"10.10.2040"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":-23434,"grossAmount":-42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response status code should be:    422
#     And Response should return error code:    901
#     And Response reason should be:    Unprocessable Content
#     And Response should return error message:    netAmount => This value should be greater than 0.
#     And Response should return error message:    grossAmount => This value should be greater than 0.
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content   

# Add_a_configurable_product_with_empty_price_value_of_to_the_shopping_list
#     [Documentation]   https://spryker.atlassian.net/browse/CC-25381
#     [Tags]    skip-due-to-issue    
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items     {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":2,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"10.10.2040"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":"","grossAmount":"","currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response status code should be:    422
#     And Response should return error code:    901
#     And Response reason should be:    Unprocessable Content
#     And Response should return error message:    netAmount => This value should not be blank.
#     And Response should return error message:    netAmount => This value should be of type numeric.
#     And Response should return error message:    grossAmount => This value should not be blank.
#     And Response should return error message:    grossAmount => This value should be of type numeric.
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content    

# Add_a_configurable_product_to_the_shopping_list_with_missing_price
#     [Documentation]   https://spryker.atlassian.net/browse/CC-25381
#     [Tags]    skip-due-to-issue    
#     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
#     ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
#     ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
#     ...    AND    Response status code should be:    201
#     ...    AND    Save value to a variable:    [data][id]    shoppingListId
#     I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items     {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":2,"productConfigurationInstance":{"displayData":'{"Preferred time of the day":"Morning","Date":"10.10.2040"}',"configuration":'{"time_of_day":"4"}',"configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":True,"quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
#     And Response status code should be:    422
#     And Response should return error code:    901
#     And Response reason should be:    Unprocessable Content
#     And Response should return error message:    netAmount => This field is missing.
#     And Response should return error message:    grossAmount => This field is missing.
#     [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
#     ...    AND    Response status code should be:    204
#     ...    AND    Response reason should be:    No Content