*** Settings ***
Suite Setup       SuiteSetup
Test Setup    TestSetup
Resource    ../../../../../../resources/common/common_api.robot
Default Tags    glue

*** Test Cases ***
ENABLER
    TestSetup
    
Add_a_concrete_product_to_the_shopping_list_without_access_token
    I send a POST request:    /shopping-lists/${1st_shopping_list.id}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    And Response status code should be:    403
    And Response should return error code:    002
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.

Add_a_concrete_product_to_the_shopping_list_with_wrong_access_token  
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I set Headers:    Authorization=3485h7
    I send a POST request:    /shopping-lists/${1st_shopping_list.id}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    And Response status code should be:    401
    And Response should return error code:    001
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.
    [Teardown]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}    
    ...    AND    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content
Add_a_product_to_the_non_existing_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a POST request:    /shopping-lists/shoppingListId/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    And Response status code should be:    404
    And Response should return error code:    1503
    And Response reason should be:    Not Found
    And Response should return error message:    Shopping list not found.

# https://spryker.atlassian.net/browse/CC-19379
Add_a_product_with_non_existing_sku_to_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"sku${random}","quantity":1}}}
    And Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    Concrete product not found.
    And Response should return error code:    1508
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_product_with_zero_quantity_to_the_shopping_list  
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":0}}}
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    quantity => This value should be greater than 0.
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_product_with_negaive_quantity_to_the_shopping_list  
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":-1}}}
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    quantity => This value should be greater than 0.
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_product_with_empty_quantity_value_of_to_the_shopping_list  
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":""}}}
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    quantity => This value should not be blank.
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_too_big_amount_of_concrete_product_to_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":99999999999999999999}}}
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should be of type integer.
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should be less than 2147483647.
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_an_abstract_product_to_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundle_product.abstract.sku}","quantity":1}}}
    And Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    1508
    And Response should return error code:    Concrete product not found.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_concrete_product_with_empty_sku_value_to_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"","quantity":1}}}
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    sku => This value should not be blank.
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_concrete_product_without_sku_to_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"quantity":1}}}
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    sku => This field is missing.
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_concrete_product_without_quantity_to_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}"}}}    
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    quantity => This field is missing.
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_concrete_product_invalid_data_for_quantity_to_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":"test"}}}    
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should be of type integer.
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should be greater than 0.
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_concrete_product_without_shopping_list_id_to_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a POST request:    /shopping-lists/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    And Response status code should be:    404
    And Response reason should be:    Not Found
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Add_a_concrete_product_to_the_shopping_list_with_empty_request_body
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Post data is invalid.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_concrete_product_with_empty_type_in_request_to_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_concrete_product_without_type_in_request_to_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Post data is invalid.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_concrete_product_to_the_shared_shopping_list_without_write_access_permission
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a GET request:    /shopping-lists/
    ...    AND    Save value to a variable:    [data][1][id]    sharedShoppingListId
    ...    AND    I get access token for the customer:    ${yves_shared_shopping_list_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    I send a POST request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    And Response status code should be:    403
    And Response should return error code:    1505
    And Response reason should be:    Forbidden
    And Response should return error message:    Requested operation requires write access permission.

Update_product_to_the_shopping_list_without_access_token
    I send a PATCH request:    /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId    {"data":{"type":"shopping-list-items","attributes":{"quantity":1}}}    
    And Response status code should be:    403
    And Response should return error code:    002
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.

Update_product_to_the_shopping_list_with_wrong_access_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}1
    I send a PATCH request:    /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId    {"data":{"type":"shopping-list-items","attributes":{"quantity":1}}}    
    And Response status code should be:    401
    And Response should return error code:    001
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.

Update_product_in_the_non_existing_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a PATCH request:    /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    404
    And Response should return error code:    1503
    And Response reason should be:    Not Found
    And Response should return error message:    Shopping list not found.

Update_product_in_the_shopping_list_withot_shopping_list_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a PATCH request:    /shopping-lists//shopping-list-items/shoppingListItemId    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Update_quantity_of_the_product_at_the_shopping_list_to_zero
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a PATCH request:    /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId    {"data":{"type":"shopping-list-items","attributes":{"quantity":0}}}
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    quantity => This value should be greater than 0.

Update_product_quntity_at_the_shopping_list_to_non_digit_value
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a PATCH request:    /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId    {"data":{"type":"shopping-list-items","attributes":{"quantity":"test"}}}
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should be of type integer.
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should be greater than 0.

Update_product_in_the_shopping_list_withot_shopping_list_item_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a PATCH request:    /shopping-lists/shoppingListId/shopping-list-items/    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Update_product_in_the_shopping_list_without_quantity_in_the_request
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a PATCH request:    /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId    {"data":{"type":"shopping-list-items","attributes":{}}}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    quantity => This field is missing.

Update_product_in_the_shopping_list_with_empty_request_body
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a PATCH request:    /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId    {}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Post data is invalid.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_product_at_the_shopping_list_with_empty_type_in_request
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a PATCH request:    /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId    {"data":{"type":"","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_product_at_the_shopping_list_without_type_in_request   
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a PATCH request:    /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId    {"data":{"attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Post data is invalid.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Change_quantity_of_a_concrete_product_at_the_shared_shopping_list_without_write_access_permission 
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a GET request:    /shopping-lists/
    ...    AND    Save value to a variable:    [data][1][id]    sharedShoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    ...    AND    I get access token for the customer:    ${yves_shared_shopping_list_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    I send a PATCH request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items/${shoppingListItemId}    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    403
    And Response should return error code:    1505
    And Response reason should be:    Forbidden
    And Response should return error message:    Requested operation requires write access permission.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a DELETE request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items/${shoppingListItemId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Remove_a_product_from_the_shopping_list_without_access_token
    I send a DELETE request:    /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId 
    And Response status code should be:    403
    And Response should return error code:    002
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.

Remove_a_product_from_the_shopping_list_with_wrong_access_token  
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}1
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    I send a DELETE request:    /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId 
    And Response status code should be:    401
    And Response should return error code:    001
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.

Remove_a_product_from_the_non_existing_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a DELETE request:    /shopping-lists/shoppingListId/shopping-list-items/shoppingListItemId 
    And Response status code should be:    404
    And Response should return error code:    1503
    And Response reason should be:    Not Found
    And Response should return error message:    Shopping list not found.

Remove_a_product_with_non_existing_id_from_the_shopping_list    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a DELETE request:    /shopping-lists/${shoppingListId}/shopping-list-items/shoppingListItemId
    And Response status code should be:    404
    And Response should return error code:    1504
    And Response reason should be:    Not Found
    And Response should return error message:    Shopping list item not found.
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Remove_a_product_from_the_shopping_list_without_shopping_list_id_in_url  
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a DELETE request:    /shopping-lists//shopping-list-items/shoppingListItemId    
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Remove_a_product_from_the_shopping_list_without_shopping_list_item_id_in_url  
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a DELETE request:    /shopping-lists/shoppingListId/shopping-list-items/  
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Remove_a_concrete_product_from_the_shared_shopping_list_without_write_access_permission 
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a GET request:    /shopping-lists/
    ...    AND    Response status code should be:    200
    ...    AND    Save value to a variable:    [data][1][id]    sharedShoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete_available_product.sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    ...    AND    I get access token for the customer:    ${yves_shared_shopping_list_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    I send a DELETE request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items/${shoppingListItemId}
    And Response status code should be:    403
    And Response should return error code:    1505
    And Response reason should be:    Forbidden
    And Response should return error message:    Requested operation requires write access permission.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a DELETE request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items/${shoppingListItemId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content