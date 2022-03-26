*** Settings ***
Suite Setup       SuiteSetup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Create_a_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    shoppingListId
    And Save value to a variable:    [data][attributes][createdAt]    createdAt
    And Save value to a variable:    [data][attributes][updatedAt]    updatedAt
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    shopping-lists
    And Response body parameter should be:    [data][id]    ${shoppingListId}
    And Response body parameter should be:    [data][attributes][owner]    ${yves_user_first_name} ${yves_user_last_name}
    And Response body parameter should be:    [data][attributes][name]    ${shopping_list_name}${random}
    And Response body parameter should be:    [data][attributes][numberOfItems]    0
    And Response body parameter should be:    [data][attributes][createdAt]    ${createdAt}
    And Response body parameter should be:    [data][attributes][updatedAt]    ${updatedAt}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Create_a_shopping_list_with_special_characters_in_the_name
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}!@#$%^&*()-_"}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    shoppingListId
    And Save value to a variable:    [data][attributes][createdAt]    createdAt
    And Save value to a variable:    [data][attributes][updatedAt]    updatedAt
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    shopping-lists
    And Response body parameter should be:    [data][id]    ${shoppingListId}
    And Response body parameter should be:    [data][attributes][owner]    ${yves_user_first_name} ${yves_user_last_name}
    And Response body parameter should be:    [data][attributes][name]    ${shopping_list_name}${random}!@#$%^&*()-_
    And Response body parameter should be:    [data][attributes][numberOfItems]    0
    And Response body parameter should be:    [data][attributes][createdAt]    ${createdAt}
    And Response body parameter should be:    [data][attributes][updatedAt]    ${updatedAt}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content


Delete_a_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    And Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a DELETE request:    /shopping-lists/${shoppingListId}
    And Response status code should be:    204
    And Response reason should be:    No Content

Update_a_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a PATCH request:    /shopping-lists/${shoppingListId}    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}"}}}
    And Response status code should be:    200
    And Save value to a variable:    [data][attributes][updatedAt]    updatedAt
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][name]    ${shopping_list_name}
    And Response body parameter should be:    [data][attributes][updatedAt]    ${updatedAt}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Update_a_shopping_list_with_the_same_name
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a PATCH request:    /shopping-lists/${shoppingListId}    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    And Response status code should be:    200
    And Save value to a variable:    [data][attributes][updatedAt]    updatedAt
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][name]    ${shopping_list_name}${random}
    And Response body parameter should be:    [data][attributes][updatedAt]    ${updatedAt}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Update_a_shopping_list_name_with_the_special_characters
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a PATCH request:    /shopping-lists/${shoppingListId}    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}!@#$%^&*()-_"}}}
    And Response status code should be:    200
    And Save value to a variable:    [data][attributes][updatedAt]    updatedAt
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][name]    ${shopping_list_name}${random}!@#$%^&*()-_
    And Response body parameter should be:    [data][attributes][updatedAt]    ${updatedAt}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Get_a_shopping_list_info
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    Save value to a variable:    [data][attributes][createdAt]    createdAt
    ...    AND    Save value to a variable:    [data][attributes][updatedAt]    updatedAt
    I send a GET request:    /shopping-lists/${shoppingListId}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    shopping-lists
    And Response body parameter should be:    [data][id]    ${shoppingListId}
    And Response body parameter should be:    [data][attributes][owner]    ${yves_user_first_name} ${yves_user_last_name}
    And Response body parameter should be:    [data][attributes][name]    ${shopping_list_name}${random}
    And Response body parameter should be:    [data][attributes][numberOfItems]    0
    And Response body parameter should be:    [data][attributes][createdAt]    ${createdAt}
    And Response body parameter should be:    [data][attributes][updatedAt]    ${updatedAt}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Get_several_shopping_lists_info
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user_email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}1"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId1
    ...    AND    Save value to a variable:    [data][attributes][createdAt]    createdAt1
    ...    AND    Save value to a variable:    [data][attributes][updatedAt]    updatedAt1
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}2"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId2
    ...    AND    Save value to a variable:    [data][attributes][createdAt]    createdAt2
    ...    AND    Save value to a variable:    [data][attributes][updatedAt]    updatedAt2
    I send a GET request:    /shopping-lists
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][3][type]    shopping-lists
    And Response body parameter should be:    [data][3][id]    ${shoppingListId1}
    And Response body parameter should be:    [data][3][attributes][owner]    ${yves_user_first_name} ${yves_user_last_name}
    And Response body parameter should be:    [data][3][attributes][name]    ${shopping_list_name}1
    And Response body parameter should be:    [data][3][attributes][numberOfItems]    None
    And Response body parameter should be:    [data][3][attributes][createdAt]    ${createdAt1}
    And Response body parameter should be:    [data][3][attributes][updatedAt]    ${updatedAt1}
    And Response body parameter should be:    [data][4][type]    shopping-lists
    And Response body parameter should be:    [data][4][id]    ${shoppingListId2}
    And Response body parameter should be:    [data][4][attributes][owner]    ${yves_user_first_name} ${yves_user_last_name}
    And Response body parameter should be:    [data][4][attributes][name]    ${shopping_list_name}2
    And Response body parameter should be:    [data][4][attributes][numberOfItems]    None
    And Response body parameter should be:    [data][4][attributes][createdAt]    ${createdAt2}
    And Response body parameter should be:    [data][4][attributes][updatedAt]    ${updatedAt2}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId1}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content
    ...    AND    I send a DELETE request:    /shopping-lists/${shoppingListId2}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content