*** Settings ***
Resource    ../common/common.robot
Resource    ../pages/yves/yves_shopping_lists_page.robot
Resource    ../common/common_yves.robot
Resource    ../pages/yves/yves_delete_shopping_list_page.robot
Resource    ../pages/yves/yves_shopping_list_page.robot

*** Keywords ***
Yves: 'Shopping List' widget contains:
    [Arguments]    ${shoppingListName}    ${accessLevel}
    Wait Until Element Is Visible    ${shopping_list_icon_header_menu_item}
    Mouse Over    ${shopping_list_icon_header_menu_item}
    Wait Until Element Is Visible    ${shopping_list_sub_navigation_widget}
    Page Should Contain Element    xpath=//*[contains(@class,'icon--header-shopping-list')]/ancestor::li//div[contains(@class,'js-user-navigation__sub-nav-shopping-list')]//span[text()[contains(.,'${accessLevel}')]]/..//a/*[text()='${shoppingListName}']

Yves: go To 'Shopping Lists' Page
    Mouse Over    ${shopping_list_icon_header_menu_item}
    ${button_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${shopping_list_sub_navigation_all_lists_button}
    IF    ${button_exists}=='PASS'
        Click Element by xpath with JavaScript    ${shopping_list_sub_navigation_all_lists_button}
    ELSE
        Click    ${shopping_list_icon_header_menu_item}
    END

Yves: create new 'Shopping List' with name:
    [Arguments]    ${shoppingListName}
    ${currentURL}=    Get Location
    IF    '/shopping-list' not in '${currentURL}'    Go To    ${host}shopping-list
    Type Text    ${shopping_list_name_input_field}    ${shoppingListName}
    Click    ${create_shopping_list_button}

Yves: the following shopping list is shown:
    [Arguments]    ${shoppingListName}    ${shoppingListOwner}    ${shoppingListAccess}
    Page Should Contain Element    xpath=//*[@data-qa="component shopping-list-overview-table"]//table//td[@data-content='Access'][contains(.,'${shoppingListAccess}')]/../td[@data-content='Owner'][contains(.,'${shoppingListOwner}')]/../td[@data-content='Name'][contains(.,'${shoppingListName}')]

Yves: share shopping list with user:
    [Arguments]    ${shoppingListName}    ${customer}    ${accessLevel}
    Share shopping list with name:    ${shoppingListName}
    Select access level to share shopping list with:    ${customer}    ${accessLevel}
    Click    ${share_shopping_list_confirm_button}
    Yves: 'Shopping Lists' page is displayed
    Yves: flash message 'should' be shown

Yves: shopping list contains the following products:
    [Arguments]    @{sku_list}    ${sku1}=${EMPTY}     ${sku2}=${EMPTY}     ${sku3}=${EMPTY}     ${sku4}=${EMPTY}     ${sku5}=${EMPTY}     ${sku6}=${EMPTY}     ${sku7}=${EMPTY}     ${sku8}=${EMPTY}     ${sku9}=${EMPTY}     ${sku10}=${EMPTY}     ${sku11}=${EMPTY}     ${sku12}=${EMPTY}     ${sku13}=${EMPTY}     ${sku14}=${EMPTY}     ${sku15}=${EMPTY}
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        Page Should Contain Element    xpath=//*[@data-qa='component shopping-list-table']//div[contains(@class,'product-card-item__col--description')]//div[contains(.,'SKU: ${sku_to_check}')]/ancestor::article
    END

Yves: delete 'Shopping List' with name:
    [Arguments]    ${shoppingListName}
    ${currentURL}=    Get Location
    IF    '/shopping-list' not in '${currentURL}'    Go To    ${host}shopping-list
    Delete shopping list with name:    ${shoppingListName}
    Wait Until Element Is Visible    ${delete_shopping_list_button}
    Click    ${delete_shopping_list_button}

Yves: view shopping list with name:
    [Arguments]    ${shoppingListName}
    ${currentURL}=    Get Location
    IF    '/shopping-list' not in '${currentURL}'    Go To    ${host}shopping-list
    View shopping list with name:   ${shoppingListName}

Yves: add all available products from list to cart
    Wait Until Element Is Visible    ${shopping_list_main_content_locator}
    Click    ${add_all_available_products_to_cart_locator} 

Yves: Select shopping list on PDP from multiple lists:    [Arguments]    ${product_sku}    ${shopping_list_name}
    Input Text    ${searchbox_input_field_locator}    ${product_sku}
    Keyboard Key    press    Enter
    Click    ${searched_product}
    Click    ${shoppingList_dropdown} 
    Click    //li[contains(text(),'${shopping_list_name}')]
    Click    ${add_to_shopinglist_button}

Yves: add products to a SL:
    [Arguments]    ${shopinglist_name}    ${product_sku}
    Input Text    ${shoppinglist_page_searchbox_input_field_locator}    ${product_sku}
    Wait Until Element Is Visible    //li[contains(text(),'${product_sku}')]
    Keyboard Key    press    Enter
    Input Text    ${quantity_input_field}    1
    Click    ${add_button_shoppinglist_page}    
    Yves: flash message should be shown:    success    Item ${product_sku} was added to the List.
    Yves: flash message should be shown:    success    Item has been added to the shopping list.

Yves: add all products from a shopping list to the cart:    
    [Arguments]    ${shopping_list_name}
    IF    '${shopping_list_name}'!= '${EMPTY}'
        Yves: go To 'Shopping Lists' Page
        Yves: 'Shopping Lists' page is displayed
        Yves: view shopping list with name:    ${shopping_list_name} 
    END
    Wait Until Element Is Visible    ${add_product_to_cart}
    Click    ${add_product_to_cart}