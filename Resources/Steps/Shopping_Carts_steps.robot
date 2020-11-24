*** Settings ***
Resource    ../Pages/Yves/Yves_Shopping_Carts_page.robot
Resource    ../Pages/Yves/Yves_Shopping_Cart_page.robot
Resource    ../Pages/Yves/Yves_Delete_Shopping_Cart_page.robot
Resource    ../Common/Common_Yves.robot

*** Variables ***
${upSellProducts}    ${shopping_cart_upp-sell_products_section}
${lockedCart}    ${shopping_cart_locked_cart_form}

*** Keywords ***
Yves: 'Shopping Carts' widget contains:
    [Arguments]    ${shoppingCartName}    ${accessLevel}
    Wait Until Element Is Visible    ${shopping_car_icon_header_menu_item} 
    Mouse Over    ${shopping_car_icon_header_menu_item} 
    Wait Until Element Is Visible    ${shopping_cart_sub_navigation_widget}
    Page Should Contain Element    xpath=//*[contains(@class,'icon--cart')]/ancestor::li//div[contains(@class,'js-user-navigation__sub-nav-cart')]//span[text()[contains(.,'${accessLevel}')]]/ancestor::div[@class='mini-cart-detail']//*[contains(@class,'mini-cart-detail__title')]/*[text()='${shoppingCartName}']

Go to 'Shopping Carts' page
    Mouse Over    ${shopping_car_icon_header_menu_item}
    Wait Until Page Contains Element    ${shopping_cart_sub_navigation_widget}
    Click Element with JavaScript    ${shopping_cart_sub_navigation_all_carts_button}
    Wait For Document Ready    

Yves: create new 'Shopping Cart' with name:
    [Arguments]    ${shoppingCartName}
    ${currentURL}=    Get Location        
    Run Keyword Unless    '/multi-cart' in '${currentURL}'    Go To    ${host}multi-cart
    Scroll and Click Element    ${create_shopping_cart_button}
    Wait For Document Ready
    Input Text    ${shopping_cart_name_input_field}    ${shoppingCartName}
    Scroll and Click Element    ${create_new_cart_submit_button}
    Wait For Document Ready    

Yves: the following shopping cart is shown:
    [Arguments]    ${shoppingCartName}    ${shoppingCartAccess}
    Page Should Contain Element    xpath=//*[@data-qa='component quote-table']//table//td[@data-content='Access'][contains(.,'${shoppingCartAccess}')]/../td[@data-content='Name'][contains(.,'${shoppingCartName}')]

Yves: share shopping cart with user:    
    [Arguments]    ${shoppingCartName}    ${customerToShare}    ${accessLevel}
    Share shopping cart with name:    ${shoppingCartName}
    Select access level to share shopping cart with:    ${customerToShare}    ${accessLevel}
    Scroll and Click Element    ${share_shopping_cart_confirm_button}
    Yves: 'Shopping Carts' page is displayed
    Yves: flash message 'should' be shown

Yves: go to the shopping cart through the header with name:
    [Arguments]    ${shoppingCartName}
    Wait Until Element Is Visible    ${shopping_car_icon_header_menu_item} 
    Mouse Over    ${shopping_car_icon_header_menu_item} 
    Wait Until Element Is Visible    ${shopping_cart_sub_navigation_widget}
    Scroll and Click Element    //*[contains(@class,'icon--cart')]/ancestor::li//div[contains(@class,'js-user-navigation__sub-nav-cart')]//div[@class='mini-cart-detail']//*[contains(@class,'mini-cart-detail__title')]/*[text()='${shoppingCartName}']
    
Yves: shopping cart contains the following products:
    [Arguments]    @{sku_list}    ${sku1}=${EMPTY}     ${sku2}=${EMPTY}     ${sku3}=${EMPTY}     ${sku4}=${EMPTY}     ${sku5}=${EMPTY}     ${sku6}=${EMPTY}     ${sku7}=${EMPTY}     ${sku8}=${EMPTY}     ${sku9}=${EMPTY}     ${sku10}=${EMPTY}     ${sku11}=${EMPTY}     ${sku12}=${EMPTY}     ${sku13}=${EMPTY}     ${sku14}=${EMPTY}     ${sku15}=${EMPTY}
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        Page Should Contain Element    xpath=//main[contains(@class,'cart-page')]//div[contains(@class,'product-card-item__col--description')]//div[contains(.,'SKU: ${sku_to_check}')]/ancestor::article
    END    
    
Yves: click on the '${buttonName}' button
    Run Keyword If    '${buttonName}' == 'Checkout'    Scroll and Click Element    ${shopping_cart_checkout_button}
    ...    ELSE IF    '${buttonName}' == 'Request a Quote'    Scroll and Click Element    ${shopping_cart_request_quote_button}

Yves: shopping cart contains product with unit price:
    [Documentation]    Already contains '€' sign inside
    [Arguments]    ${sku}    ${productPrice}
    Page Should Contain Element    xpath=//div[contains(@class,'product-card-item__col--description')]//div[contains(.,'SKU: ${sku}')]/ancestor::article//*[contains(@class,'product-card-item__col--description')]/div[1]//*[contains(@class,'money-price__amount')][contains(.,'€${productPrice}')]

Yves: shopping cart contains/doesn't contain the following elements:
    [Arguments]    ${condition}    @{shopping_cart_elements_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${shopping_cart_elements_list_count}=   get length  ${shopping_cart_elements_list}
    FOR    ${index}    IN RANGE    0    ${shopping_cart_elements_list_count}
        ${shopping_cart_element_to_check}=    Get From List    ${shopping_cart_elements_list}    ${index}
        Run Keyword If    '${condition}' == 'true'    
        ...    Run Keywords
        ...    Log    ${shopping_cart_element_to_check}    #Left as an example of multiple actions in Condition
        ...    AND    Page Should Contain Element    ${shopping_cart_element_to_check}    message=${shopping_cart_element_to_check} is not displayed
        Run Keyword If    '${condition}' == 'false'    
        ...    Run Keywords
        ...    Log    ${shopping_cart_element_to_check}    #Left as an example of multiple actions in Condition
        ...    AND    Page Should Not Contain Element    ${shopping_cart_element_to_check}    message=${shopping_cart_element_to_check} should not be displayed
    END

Yves: shopping cart with name xxx has the following status:
    [Arguments]    ${cartName}    ${status}
    Page Should Contain Element    //*[@data-qa='component quote-table']//table//td[@data-content='Name'][contains(.,'${cartName}')]/../td//*[contains(@data-qa,'component quote-status')][contains(.,'${status}')]

Yves: delete product from the shopping cart with sku:
    [Arguments]    ${sku}
    Scroll and Click Element    //main[contains(@class,'cart-page')]//div[contains(@class,'product-card-item__col--description')]//div[contains(.,'SKU: ${sku}')]/ancestor::article//a[contains(@href,'remove')]
    Wait For Document Ready    
    Yves: remove flash messages

Yves: shopping cart doesn't contain the following products:
    [Arguments]    @{sku_list}    ${sku1}=${EMPTY}     ${sku2}=${EMPTY}     ${sku3}=${EMPTY}     ${sku4}=${EMPTY}     ${sku5}=${EMPTY}     ${sku6}=${EMPTY}     ${sku7}=${EMPTY}     ${sku8}=${EMPTY}     ${sku9}=${EMPTY}     ${sku10}=${EMPTY}     ${sku11}=${EMPTY}     ${sku12}=${EMPTY}     ${sku13}=${EMPTY}     ${sku14}=${EMPTY}     ${sku15}=${EMPTY}
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        Page Should Not Contain Element    xpath=//main[contains(@class,'cart-page')]//div[contains(@class,'product-card-item__col--description')]//div[contains(.,'SKU: ${sku_to_check}')]/ancestor::article
    END  

Yves: get link for external cart sharing
    Expand shopping cart accordion:    Share Cart via link
    Scroll and Click Element    xpath=//input[@name='cart-share'][contains(@target-class-name,'external')]/ancestor::label
    Wait Until Element Is Visible    xpath=//input[@id='PREVIEW']
    ${externalURL}=    Get Element Attribute    xpath=//input[@id='PREVIEW']    value
    Set Suite Variable    ${externalURL}

Yves: Shopping Cart title should be equal:
    [Arguments]    ${expectedCartTitle}
    ${actualCartTitle}=    Get Text    ${shopping_cart_cart_title}
    Should Be Equal    ${actualCartTitle}    ${expectedCartTitle}

Yves: change quantity of the configurable bundle in the shopping cart on:
    [Documentation]    In case of multiple matches, changes quantity for the first product in the shopping cart
    [Arguments]    ${confBundleTitle}    ${quantity}
    Input Text    xpath=//article[@data-qa='component configured-bundle'][1]//*[contains(@class,'configured-bundle__title')][text()='${confBundleTitle}']/ancestor::article//input[@data-qa='quantity-input']    ${quantity}
    Scroll and Click Element    xpath=//article[@data-qa='component configured-bundle'][1]//*[contains(@class,'configured-bundle__title')][text()='${confBundleTitle}']
    Wait For Document Ready    

Yves: delete 'Shopping Cart' with name:
    [Arguments]    ${shoppingCartName}
    ${currentURL}=    Get Location        
    Run Keyword Unless    '/shopping-list' in '${currentURL}'    Go To    ${host}multi-cart
    Delete shopping cart with name:    ${shoppingCartName}
    Wait Until Element Is Visible    ${delete_shopping_cart_button}
    Click Element    ${delete_shopping_cart_button}
    Wait For Document Ready    
