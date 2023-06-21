*** Settings ***
Resource    ../pages/yves/yves_shopping_carts_page.robot
Resource    ../pages/yves/yves_shopping_cart_page.robot
Resource    ../pages/yves/yves_delete_shopping_cart_page.robot
Resource    ../common/common_yves.robot
Resource    ../common/common.robot

*** Variables ***
${upSellProducts}    ${shopping_cart_upp-sell_products_section}[${env}]
${lockedCart}    ${shopping_cart_locked_cart_form}

*** Keywords ***
Yves: 'Shopping Carts' widget contains:
    [Arguments]    ${shoppingCartName}    ${accessLevel}
    Wait Until Element Is Visible    ${shopping_car_icon_header_menu_item}[${env}]
    Mouse Over    ${shopping_car_icon_header_menu_item}[${env}]
    Wait Until Element Is Visible    ${shopping_cart_sub_navigation_widget}
    Page Should Contain Element    xpath=//*[contains(@class,'icon--cart')]/ancestor::li//div[contains(@class,'js-user-navigation__sub-nav-cart')]//span[text()[contains(.,'${accessLevel}')]]/ancestor::div[@class='mini-cart-detail']//*[contains(@class,'mini-cart-detail__title')]/*[text()='${shoppingCartName}']

Yves: Go to 'Shopping Carts' page
    Mouse Over    ${shopping_car_icon_header_menu_item}[${env}]
    Wait Until Page Contains Element    ${shopping_cart_sub_navigation_widget}
    Click Element by xpath with JavaScript    ${shopping_cart_sub_navigation_all_carts_button}


Yves: create new 'Shopping Cart' with name:
    [Arguments]    ${shoppingCartName}
    ${currentURL}=    Get Location
    IF    '/multi-cart' not in '${currentURL}'    
            IF    '.at.' in '${currentURL}'
                Go To    ${yves_at_url}multi-cart
            ELSE
                Go To    ${yves_url}multi-cart
            END    
    END
    Click    ${create_shopping_cart_button}
    Type Text    ${shopping_cart_name_input_field}    ${shoppingCartName}
    Click    ${create_new_cart_submit_button}

Yves: the following shopping cart is shown:
    [Arguments]    ${shoppingCartName}    ${shoppingCartAccess}
    Page Should Contain Element    xpath=//*[@data-qa='component quote-table']//table//td[@data-content='Access'][contains(.,'${shoppingCartAccess}')]/../td[@data-content='Name'][contains(.,'${shoppingCartName}')]

Yves: share shopping cart with user:
    [Arguments]    ${shoppingCartName}    ${customerToShare}    ${accessLevel}
    Share shopping cart with name:    ${shoppingCartName}
    Select access level to share shopping cart with:    ${customerToShare}    ${accessLevel}
    Click    ${share_shopping_cart_confirm_button}
    Yves: 'Shopping Carts' page is displayed
    Yves: flash message 'should' be shown

Yves: go to the shopping cart through the header with name:
    [Arguments]    ${shoppingCartName}
    Yves: remove flash messages
    Wait Until Element Is Visible    ${shopping_car_icon_header_menu_item}[${env}]
    Mouse Over    ${shopping_car_icon_header_menu_item}[${env}]
    Wait Until Element Is Visible    ${shopping_cart_sub_navigation_widget}
    Click    xpath=//*[contains(@class,'icon--cart')]/ancestor::li//div[contains(@class,'js-user-navigation__sub-nav-cart')]//div[@class='mini-cart-detail']//*[contains(@class,'mini-cart-detail__title')]/*[text()='${shoppingCartName}']

Yves: go to b2c shopping cart
    Yves: remove flash messages
    Wait Until Element Is Visible    ${shopping_car_icon_header_menu_item}[${env}]
    Click     ${shopping_car_icon_header_menu_item}[${env}]
    Wait Until Element Is Visible    ${shopping_cart_main_content_locator}[${env}]


Yves: shopping cart contains the following products:
    [Documentation]    For item listing you can use sku or name of the product
    [Arguments]    @{items_list}
    ${items_list_count}=   get length  ${items_list}
    FOR    ${index}    IN RANGE    0    ${items_list_count}
        ${item_to_check}=    Get From List    ${items_list}    ${index}
        Page Should Contain Element    xpath=(//main[contains(@class,'cart')]//article[(contains(@data-qa,'product-cart-item') or contains(@data-qa,'product-card-item'))]//*[contains(.,'${item_to_check}')]/ancestor::article)[1]
    END

Yves: click on the '${buttonName}' button in the shopping cart
    Yves: remove flash messages
    IF    '${buttonName}' == 'Checkout'
        Click    ${shopping_cart_checkout_button}
        Wait Until Page Does Not Contain Element    ${shopping_cart_checkout_button}
    ELSE IF    '${buttonName}' == 'Request a Quote'
        Click    ${shopping_cart_request_quote_button}
        Wait Until Page Does Not Contain Element    ${shopping_cart_request_quote_button}
    END

Yves: shopping cart contains product with unit price:
    [Documentation]    Already contains '€' sign inside
    [Arguments]    ${sku}    ${productName}    ${productPrice}
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']
        TRY
            Page Should Contain Element    xpath=//div[contains(@class,'product-card-item__col--description')]//div[contains(.,'SKU: ${sku}')]/ancestor::article//*[contains(@class,'product-card-item__col--description')]/div[1]//*[contains(@class,'money-price__amount')][contains(.,'€${productPrice}')]
        EXCEPT
            Page Should Contain Element    xpath=//div[contains(@class,'product-cart-item__col--description')]//div[contains(.,'SKU: ${sku}')]/ancestor::article//*[contains(@class,'product-cart-item__col--description')]/div[1]//*[contains(@class,'money-price__amount')][contains(.,'€${productPrice}')]
        END  
    ELSE
        Page Should Contain Element    xpath=//main[@class='page-layout-cart']//article[contains(@data-qa,'component product-card-item')]//a[contains(text(),'${productName}')]/following-sibling::span/span[contains(@class,'money-price__amount') and contains(.,'${productPrice}')]
    END

Yves: shopping cart contains/doesn't contain the following elements:
    [Arguments]    ${condition}    @{shopping_cart_elements_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${shopping_cart_elements_list_count}=   get length  ${shopping_cart_elements_list}
    FOR    ${index}    IN RANGE    0    ${shopping_cart_elements_list_count}
        ${shopping_cart_element_to_check}=    Get From List    ${shopping_cart_elements_list}    ${index}
        IF    '${condition}' == 'true'
            Run Keywords
                Log    ${shopping_cart_element_to_check}    #Left as an example of multiple actions in Condition
                Page Should Contain Element    ${shopping_cart_element_to_check}    message=${shopping_cart_element_to_check} is not displayed
        END
        IF    '${condition}' == 'false'
            Run Keywords
                Log    ${shopping_cart_element_to_check}    #Left as an example of multiple actions in Condition
                Page Should Not Contain Element    ${shopping_cart_element_to_check}    message=${shopping_cart_element_to_check} should not be displayed
        END
    END

Yves: shopping cart with name xxx has the following status:
    [Arguments]    ${cartName}    ${status}
    Page Should Contain Element    //*[@data-qa='component quote-table']//table//td[@data-content='Name'][contains(.,'${cartName}')]/../td//*[contains(@data-qa,'component quote-status')][contains(.,'${status}')]

Yves: delete product from the shopping cart with sku:
    [Arguments]    ${sku}
    Click    xpath=//form[contains(@name,'removeFromCartForm_${sku}')]//button
    Yves: remove flash messages

Yves: delete product from the shopping cart with name:
    [Arguments]    ${productName}
    Click    //main[@class='page-layout-cart']//article[contains(@data-qa,'component product-card-item')]//a[contains(text(),'${productName}')]/ancestor::article//form[contains(@name,'removeFromCartForm')]//button
    Yves: remove flash messages

Yves: shopping cart doesn't contain the following products:
    [Arguments]    @{sku_list}    ${sku1}=${EMPTY}     ${sku2}=${EMPTY}     ${sku3}=${EMPTY}     ${sku4}=${EMPTY}     ${sku5}=${EMPTY}     ${sku6}=${EMPTY}     ${sku7}=${EMPTY}     ${sku8}=${EMPTY}     ${sku9}=${EMPTY}     ${sku10}=${EMPTY}     ${sku11}=${EMPTY}     ${sku12}=${EMPTY}     ${sku13}=${EMPTY}     ${sku14}=${EMPTY}     ${sku15}=${EMPTY}
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        Page Should Not Contain Element    xpath=//form[contains(@name,'removeFromCartForm_${sku_to_check}')]
    END

Yves: get link for external cart sharing
    Yves: Expand shopping cart accordion:    Share Cart via link
    Click    xpath=//input[@name='cart-share'][contains(@target-class-name,'external')]/ancestor::label
    Wait Until Element Is Visible    xpath=//input[@id='PREVIEW']
    ${externalURL}=    Get Element Attribute    xpath=//input[@id='PREVIEW']    value
    ${externalURL}=    Replace String Using Regexp    ${externalURL}    ${EMPTY}.*.com/    ${EMPTY}
    Set Suite Variable    ${externalURL}

Yves: Expand shopping cart accordion:
     [Arguments]    ${accordionTitle}
     ${accordionState}=    Get Element Attribute    xpath=//div[@data-qa='component cart-sidebar']//*[contains(@class,'cart-sidebar-item__title')][contains(.,'${accordionTitle}')]    class
     ${accordionState}=    Replace String    ${accordionState}    ${SPACE}    ${EMPTY}
     ${accordionState}=    Replace String    ${accordionState}    _    ${SPACE}
     ${accordionState}=    Replace String    ${accordionState}    -    ${SPACE}
     ${accordionState}=    Replace String    ${accordionState}    \r    ${EMPTY}
     ${accordionState}=    Replace String    ${accordionState}    \n    ${EMPTY}
     Log    ${accordionState}
     IF    'active' not in '${accordionState}'
         Run Keywords
            Click    xpath=//div[@data-qa='component cart-sidebar']//*[contains(@class,'cart-sidebar-item__title')][contains(.,'${accordionTitle}')]    delay=1s
            Wait Until Element Is Visible    xpath=//div[@data-qa='component cart-sidebar']//*[contains(@class,'cart-sidebar-item__title')][contains(.,'${accordionTitle}')]/../div[contains(@class,'cart-sidebar-item__content')]
     END

Yves: Shopping Cart title should be equal:
    [Arguments]    ${expectedCartTitle}
    ${actualCartTitle}=    Get Text    ${shopping_cart_cart_title}
    Should Be Equal    ${actualCartTitle}    ${expectedCartTitle}

Yves: change quantity of the configurable bundle in the shopping cart on:
    [Documentation]    In case of multiple matches, changes quantity for the first product in the shopping cart
    [Arguments]    ${confBundleTitle}    ${quantity}
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']
        Type Text    xpath=//main//article[contains(@data-qa,'configured-bundle')][1]//a[text()='Presentation bundle']/ancestor::article//input[contains(@class, 'formatted-number-input__input')]    ${quantity}
    ELSE
        Type Text    xpath=//article[contains(@data-qa,'configured-bundle-secondary')][1]//ancestor::*[contains(@data-qa, 'component formatted-number-input')]//input[contains(@class,'formatted-number-input')][contains(@data-min-quantity,'1')]    ${quantity}
    END
    Click    xpath=//main//article[contains(@data-qa,'configured-bundle')][1]//a[text()='${confBundleTitle}']/ancestor::article    delay=1s
    Yves: remove flash messages

Yves: delete all shopping carts
    Yves: create new 'Shopping Cart' with name:    Z
    #create new empty cart that will be the last one in the list
    ${currentURL}=    Get Location
    IF    '/multi-cart' not in '${currentURL}'    Go To    ${yves_url}multi-cart
    ${shoppingCartsCount}=    Get Element Count    xpath=//*[@data-qa='component quote-table']//table/tbody/tr//ul//a[contains(.,'Delete')]
    Log    ${shoppingCartsCount}
    FOR    ${index}    IN RANGE    0    ${shoppingCartsCount}-1
        Log    ${index}
        Delete first available shopping cart
        Wait Until Element Is Visible    ${delete_shopping_cart_button}
        Click    ${delete_shopping_cart_button}
    END

Yves: delete 'Shopping Cart' with name:
    [Arguments]    ${shoppingCartName}
    ${currentURL}=    Get Location
    IF      '/multi-cart' not in '${currentURL}'    Go To    ${yves_url}multi-cart
    Delete shopping cart with name:    ${shoppingCartName}
    Wait Until Element Is Visible    ${delete_shopping_cart_button}
    Click    ${delete_shopping_cart_button}

Yves: delete from b2c cart products with name:
    [Arguments]    @{productNameList}
    FOR    ${product}    IN    @{productNameList}
        Click    xpath=//div[@class='page-layout-cart__items-wrap']//a[contains(text(),'${product}')]/ancestor::div/following-sibling::div//form[contains(@name,'removeFromCart')]//button[text()='Remove']
        Yves: flash message should be shown:    success    Products were removed successfully
        Yves: remove flash messages
        IF    '${env}' in ['ui_b2b','ui_mp_b2b']
            Page Should Not Contain Element    xpath=//div[contains(@class,'product-card-item__col--description')]//div[contains(.,'${namproducte}')]
        ELSE
            Page Should Not Contain Element    xpath=//main[@class='page-layout-cart']//article[contains(@data-qa,'component product-card-item')]//a[contains(text(),'${product}')]
        END
    END

Yves: apply discount voucher to cart:
    [Arguments]    ${voucherCode}
    ${expanded}=    Set Variable    ${EMPTY}
    ${expanded}=    IF    '${env}' in ['ui_b2c','ui_mp_b2c']    Run Keyword And Return Status    Get Element States    ${shopping_cart_voucher_code_field}    ==    hidden    return_names=False
    IF    '${env}' in ['ui_b2c','ui_mp_b2c'] and '${expanded}'=='False'    Click    ${shopping_cart_voucher_code_section_toggler}
    Type Text    ${shopping_cart_voucher_code_field}    ${voucherCode}
    Click    ${shopping_cart_voucher_code_redeem_button}
    Yves: flash message should be shown:    success    Your voucher code has been applied
    Yves: remove flash messages


Yves: discount is applied:
#TODO: make from this method somth real, because Sum is not used
    [Arguments]    ${discountType}    ${discountName}    ${expectedDiscountSum}
    IF    '${env}' in ['ui_b2c','ui_mp_b2c'] and '${discountType}'=='voucher'
        Element should be visible    xpath=//span[contains(text(),'${expectedDiscountSum}')]/preceding-sibling::span[contains(text(),'${discountName}')]/ancestor::*[contains(@data-qa,'cart-discount-summary')]/*[contains(.,'Vouchers')]
    ELSE IF    '${env}' in ['ui_b2c','ui_mp_b2c'] and '${discountType}'=='cart rule'
        Element should be visible    xpath=//span[contains(text(),'${expectedDiscountSum}')]/preceding-sibling::span[contains(text(),'${discountName}')]/ancestor::*[contains(@data-qa,'cart-discount-summary')]/*[contains(.,'Discounts')]
    ELSE IF     '${env}' in ['ui_b2b','ui_mp_b2b'] and '${discountType}'=='voucher'
        Element should be visible    xpath=//span[contains(text(),'${expectedDiscountSum}')]/preceding-sibling::span[contains(text(),'${discountName}')]/ancestor::*[contains(@data-qa,'cart-code-summary')]/*[contains(.,'Vouchers')]
    ELSE IF    '${env}' in ['ui_b2b','ui_mp_b2b'] and '${discountType}'=='cart rule'
        Element should be visible    xpath=//span[contains(text(),'${expectedDiscountSum}')]/preceding-sibling::span[contains(text(),'${discountName}')]/ancestor::*[contains(@data-qa,'cart-code-summary')]/*[contains(.,'Discounts')]
    END

Yves: promotional product offer is/not shown in cart:
    [Arguments]    ${isShown}
    ${isShown}=    Convert To Lower Case    ${isShown}
    IF    '${isShown}'=='true'
        Try reloading page until element is/not appear:    ${shopping_cart_promotional_product_section}    true    5
        Element Should Be Visible    ${shopping_cart_promotional_product_section}    message=Promotional products are not displayed but should be    timeout=${browser_timeout}
    ELSE IF    '${isShown}'=='false'
        Try reloading page until element is/not appear:    ${shopping_cart_promotional_product_section}    false    5
        Element Should Not Be Visible    ${shopping_cart_promotional_product_section}    message=Promotional products are displayed but should not    timeout=${browser_timeout}
    END
    

Yves: change quantity of promotional product and add to cart:
    [Documentation]    set ${action} to + or - to change quantity. ${clickCount} indicates how many times to click
    [Arguments]    ${action}    ${clicksCount}
    FOR    ${index}    IN RANGE    0    ${clicksCount}
        IF    '${action}' == '+'
            Click    ${shopping_cart_promotional_product_increase_quantity_button}[${env}]
        ELSE IF    '${action}' == '-'
            Click    ${shopping_cart_promotional_product_decrease_quantity_button}[${env}]
        END
    END
    Click    ${shopping_cart_promotional_product_add_to_cart_button}
    Yves: flash message should be shown:    success    Items added successfully
    Yves: remove flash messages

Yves: assert merchant of product in b2c cart:
    [Documentation]    Method for MP which asserts value in 'Sold by' label of item in cart or list. Requires concrete SKU
    [Arguments]    ${product_name}    ${merchant_name_expected}
    Page Should Contain Element    xpath=//main[contains(@class,'cart')]//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${product_name}')]/ancestor::article//*[@data-qa='component sold-by-merchant']/a[text()='${merchant_name_expected}']

