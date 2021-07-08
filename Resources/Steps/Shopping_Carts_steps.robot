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
    Wait Until Element Is Visible    ${shopping_car_icon_header_menu_item}[${env}] 
    Mouse Over    ${shopping_car_icon_header_menu_item}[${env}] 
    Wait Until Element Is Visible    ${shopping_cart_sub_navigation_widget}
    Page Should Contain Element    xpath=//*[contains(@class,'icon--cart')]/ancestor::li//div[contains(@class,'js-user-navigation__sub-nav-cart')]//span[text()[contains(.,'${accessLevel}')]]/ancestor::div[@class='mini-cart-detail']//*[contains(@class,'mini-cart-detail__title')]/*[text()='${shoppingCartName}']

Go to 'Shopping Carts' page
    Mouse Over    ${shopping_car_icon_header_menu_item}[${env}]
    Wait Until Page Contains Element    ${shopping_cart_sub_navigation_widget}
    Click Element by xpath with JavaScript    ${shopping_cart_sub_navigation_all_carts_button}
    Wait For Document Ready    

Yves: create new 'Shopping Cart' with name:
    [Arguments]    ${shoppingCartName}
    ${currentURL}=    Get Location        
    Run Keyword Unless    '/multi-cart' in '${currentURL}'    Go To    ${host}multi-cart
    Scroll and Click Element    ${create_shopping_cart_button}
    Wait For Document Ready
    Input text into field    ${shopping_cart_name_input_field}    ${shoppingCartName}
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
    Wait Until Element Is Visible    ${shopping_car_icon_header_menu_item}[${env}] 
    Mouse Over    ${shopping_car_icon_header_menu_item}[${env}] 
    Wait Until Element Is Visible    ${shopping_cart_sub_navigation_widget}
    Scroll and Click Element    //*[contains(@class,'icon--cart')]/ancestor::li//div[contains(@class,'js-user-navigation__sub-nav-cart')]//div[@class='mini-cart-detail']//*[contains(@class,'mini-cart-detail__title')]/*[text()='${shoppingCartName}']
    
Yves: go to b2c shopping cart
    Wait Until Element Is Visible    ${shopping_car_icon_header_menu_item}[${env}] 
    Scroll and Click Element     ${shopping_car_icon_header_menu_item}[${env}]
    Wait Until Element Is Visible    ${shopping_cart_main_content_locator}[${env}]
    Wait For Document Ready         
    
Yves: shopping cart contains the following products:
    [Documentation]    For item listing you can use sku or name of the product
    [Arguments]    @{items_list}
    ${items_list_count}=   get length  ${items_list}
    FOR    ${index}    IN RANGE    0    ${items_list_count}
        ${item_to_check}=    Get From List    ${items_list}    ${index}
        Page Should Contain Element    xpath=//main[contains(@class,'cart')]//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item_to_check}')]/ancestor::article
    END    
    
Yves: click on the '${buttonName}' button in the shopping cart
    Run Keyword If    '${buttonName}' == 'Checkout'    Scroll and Click Element    ${shopping_cart_checkout_button}
    ...    ELSE IF    '${buttonName}' == 'Request a Quote'    Scroll and Click Element    ${shopping_cart_request_quote_button}

Yves: shopping cart contains product with unit price:
    [Documentation]    Already contains '€' sign inside
    [Arguments]    ${sku}    ${productName}    ${productPrice}
    Run Keyword If    '${env}'=='b2b'    Page Should Contain Element    xpath=//div[contains(@class,'product-card-item__col--description')]//div[contains(.,'SKU: ${sku}')]/ancestor::article//*[contains(@class,'product-card-item__col--description')]/div[1]//*[contains(@class,'money-price__amount')][contains(.,'€${productPrice}')]
    ...    ELSE    Page Should Contain Element    xpath=//main[@class='page-layout-cart']//article[contains(@data-qa,'component product-card-item')]//a[contains(text(),'${productName}')]/following-sibling::span/span[contains(@class,'money-price__amount') and contains(.,'${productPrice}')]

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
    Scroll and Click Element    xpath=//form[@name='removeFromCartForm_${sku}']//button
    Wait For Document Ready    
    Yves: remove flash messages

Yves: shopping cart doesn't contain the following products:
    [Arguments]    @{sku_list}    ${sku1}=${EMPTY}     ${sku2}=${EMPTY}     ${sku3}=${EMPTY}     ${sku4}=${EMPTY}     ${sku5}=${EMPTY}     ${sku6}=${EMPTY}     ${sku7}=${EMPTY}     ${sku8}=${EMPTY}     ${sku9}=${EMPTY}     ${sku10}=${EMPTY}     ${sku11}=${EMPTY}     ${sku12}=${EMPTY}     ${sku13}=${EMPTY}     ${sku14}=${EMPTY}     ${sku15}=${EMPTY}
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        Page Should Not Contain Element    xpath=//form[@name='removeFromCartForm_${sku_to_check}']
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
    Input text into field    xpath=//main//article[contains(@data-qa,'configured-bundle')][1]//*[contains(@class,'configured-bundle') and text()='${confBundleTitle}']/ancestor::article//input[@data-qa='quantity-input']    ${quantity}
    Scroll and Click Element    xpath=//main//article[contains(@data-qa,'configured-bundle')][1]//*[contains(@class,'configured-bundle') and text()='${confBundleTitle}']
    Wait For Document Ready    

Yves: delete 'Shopping Cart' with name:
    [Arguments]    ${shoppingCartName}
    ${currentURL}=    Get Location        
    Run Keyword Unless    '/shopping-list' in '${currentURL}'    Go To    ${host}multi-cart
    Delete shopping cart with name:    ${shoppingCartName}
    Wait Until Element Is Visible    ${delete_shopping_cart_button}
    Scroll and Click Element    ${delete_shopping_cart_button}
    Wait For Document Ready  

Yves: delete from b2c cart products with name:
    [Arguments]    @{productNameList}
    FOR    ${product}    IN    @{productNameList}
        Scroll and Click Element    xpath=//div[@class='page-layout-cart__items-wrap']//a[contains(text(),'${product}')]/ancestor::div/following-sibling::div//form[contains(@name,'removeFromCart')]//button[text()='Remove']
        Yves: flash message should be shown:    success    Products were removed successfully
        Yves: remove flash messages
        Run Keyword If    '${env}'=='b2b'    Page Should Not Contain Element    xpath=//div[contains(@class,'product-card-item__col--description')]//div[contains(.,'${namproducte}')]
        ...    ELSE    Page Should Not Contain Element    xpath=//main[@class='page-layout-cart']//article[contains(@data-qa,'component product-card-item')]//a[contains(text(),'${product}')]
    END

Yves: apply discount voucher to cart:
    [Arguments]    ${voucherCode}
    ${expanded}=    Run Keyword And Return Status    ${shopping_cart_voucher_code_section_toggler}
    Run Keyword If    '${expanded}'=='False'    Scroll and click element    ${shopping_cart_voucher_code_section_toggler}
    Input text into field    ${shopping_cart_voucher_code_field}    ${voucherCode}
    Scroll and Click Element    ${shopping_cart_voucher_code_redeem_button}
    Wait For Document Ready
    Yves: flash message should be shown:    success    Your voucher code has been applied
    Yves: remove flash messages
    Wait For Document Ready

Yves: discount is applied:
    [Arguments]    ${discountName}    ${discountType}    ${expectedDiscountSum}
    Run Keyword If    '${discountType}'=='voucher'    Element should be visible    xpath=//span[contains(text(),'${expectedDiscountSum}')]/preceding-sibling::span[contains(text(),'${discountName}')]/ancestor::*[contains(@data-qa,'cart-discount-summary')]/*[contains(text(),'Vouchers')]
    ...    ELSE    Run Keyword If    '${discountType}'=='cart ruled'    Element should be visible    xpath=//span[contains(text(),'${expectedDiscountSum}')]/preceding-sibling::span[contains(text(),'${discountName}')]/ancestor::*[contains(@data-qa,'cart-discount-summary')]/*[contains(text(),'Discounts')]

Yves: promotional product offer is/not shown in cart:
    [Arguments]    ${isShown}    
    Run Keyword If    '${isShown}'=='True'    Element Should Be Visible    ${shopping_cart_promotional_product_section}    message=Promotional products are not displayed but should be
    ...    ELSE    Run Keyword If    '${isShown}'=='False'    Element Should Not Be Visible    ${shopping_cart_promotional_product_section}    message=Promotional products are displayed but should not

Yves: change quantity of promotional product and add to cart:
    [Documentation]    set ${action} to + or - to change quantity. ${clickCount} indicates how many times to click
    [Arguments]    ${action}    ${clicksCount}
    FOR    ${index}    IN RANGE    0    ${clicksCount}
        Run Keyword If    '${action}' == '+'    Scroll and Click Element    ${shopping_cart_promotional_product_increase_quantity_button}
        ...    ELSE IF    '${action}' == '-'    Scroll and Click Element    ${shopping_cart_promotional_product_decrease_quantity_button} 
    END
    Scroll and Click Element    ${shopping_cart_promotional_product_add_to_cart_button}
    Wait For Document Ready    
    Yves: flash message should be shown:    success    Items added successfully
    Yves: remove flash messages 

    
    