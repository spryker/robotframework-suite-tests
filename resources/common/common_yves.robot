*** Settings ***
Library    String
Library    Browser
Library    ../../resources/libraries/common.py
Resource    common.robot
Resource    ../pages/yves/yves_catalog_page.robot
Resource    ../pages/yves/yves_product_details_page.robot
Resource    ../pages/yves/yves_company_users_page.robot
Resource    ../pages/yves/yves_shopping_lists_page.robot
Resource    ../pages/yves/yves_shopping_carts_page.robot
Resource    ../pages/yves/yves_shopping_cart_page.robot
Resource    ../pages/yves/yves_shopping_list_page.robot
Resource    ../pages/yves/yves_checkout_success_page.robot
Resource    ../pages/yves/yves_order_history_page.robot
Resource    ../pages/yves/yves_order_details_page.robot
Resource    ../pages/yves/yves_customer_account_page.robot
Resource    ../pages/yves/yves_quote_requests_page.robot
Resource    ../pages/yves/yves_quote_request_page.robot
Resource    ../pages/yves/yves_choose_bundle_to_configure_page.robot
Resource    ../pages/yves/yves_create_return_page.robot
Resource    ../pages/yves/yves_return_details_page.robot
Resource    ../pages/yves/yves_checkout_summary_page.robot
Resource    ../pages/yves/yves_checkout_cancel_payment_page.robot
Resource    ../steps/header_steps.robot

*** Variable ***
${notification_area}    xpath=//section[@data-qa='component notification-area']


*** Keywords ***
Yves: login with credentials:
    [Arguments]    ${email}    ${password}=${default_password}
    ${currentURL}=    Get Url
    Run Keyword Unless    '/login' in '${currentURL}'
    ...    Run keyword if    '${env}' in ['b2b','suite-nonsplit']
    ...    Run Keywords
    ...    Go To    ${host}
    ...    AND    delete all cookies
    ...    AND    Reload
    ...    AND    Wait Until Element Is Visible    ${header_login_button}[${env}]
    ...    AND    Click    ${header_login_button}[${env}]
    ...    AND    Wait Until Element Is Visible    ${email_field}
    ...    ELSE    Run Keywords
    ...    Go To    ${host}
    ...    AND    delete all cookies
    ...    AND    Reload
    ...    AND    mouse over  ${user_navigation_icon_header_menu_item}[${env}]
    ...    AND    Wait Until Element Is Visible    ${user_navigation_menu_login_button}
    ...    AND    Click    ${user_navigation_menu_login_button}
    ...    AND    Wait Until Element Is Visible    ${email_field}
    Type Text    ${email_field}    ${email}
    Type Text    ${password_field}    ${password}
    Click    ${form_login_button}
    Run Keyword Unless    'fake' in '${email}' or 'agent' in '${email}'  Wait Until Element Is Visible    ${user_navigation_icon_header_menu_item}[${env}]     Login Failed!
    Run Keyword If    'agent' in '${email}'    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: remove flash messages

Yves: go to PDP with sku:
    [Arguments]    ${sku}
    Yves: perform search by:    ${sku}
    Wait Until Page Contains Element    ${catalog_product_card_locator}
    Click    ${catalog_product_card_locator}
    Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]

Yves: '${pageName}' page is displayed
    Run Keyword If    '${pageName}' == 'Company Users'    Page Should Contain Element    ${company_users_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Shopping Lists'    Page Should Contain Element    ${shopping_lists_page_form_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Shopping List'    Page Should Contain Element    ${shopping_list_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Shopping Cart'    Page Should Contain Element    ${shopping_cart_main_content_locator}[${env}]    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Shopping Carts'    Page Should Contain Element    ${shopping_carts_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Quick Order'    Page Should Contain Element    ${quick_order_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Thank you'    Page Should Contain Element    ${success_page_main_container_locator}[${env}]    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Order History'    Page Should Contain Element    ${order_history_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Order Details'    Page Should Contain Element    ${order_details_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Select Business Unit'    Page Should Contain Element    ${customer_account_business_unit_selector}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Summary'    Page Should Contain Element    ${checkout_summary_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Quote Requests'    Page Should Contain Element    ${quote_requests_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Quote Request Details'    Page Should Contain Element    ${quote_request_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Choose Bundle to configure'    Page Should Contain Element    ${choose_bundle_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Create Return'    Page Should Contain Element    ${create_return_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Return Details'    Page Should Contain Element    ${return_details_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Payment cancellation'    Page Should Contain Element    ${cancel_payment_page_main_container_locator}    ${pageName} page is not displayed

Yves: remove flash messages
    ${flash_massage_state}=    Run Keyword And Ignore Error    Page Should Contain Element    ${notification_area}    1s
    Log    ${flash_massage_state}
    Run Keyword If    'PASS' in ${flash_massage_state}     Remove element from HTML with JavaScript    //section[@data-qa='component notification-area']

Yves: flash message '${condition}' be shown
   Run Keyword If    '${condition}' == 'should'    Wait Until Element Is Visible    ${notification_area}
    ...    ELSE    Page Should Not Contain Element    ${notification_area}

Yves: flash message should be shown:
    [Documentation]    ${type} can be: error, success
    [Arguments]    ${type}    ${text}
    Run Keyword If    '${type}' == 'error'    Element Should Be Visible    xpath=//flash-message[contains(@class,'alert')]//div[contains(text(),'${text}')]
    ...    ELSE    Run Keyword If    '${type}' == 'success'    Element Should Be Visible    xpath=//flash-message[contains(@class,'success')]//div[contains(text(),'${text}')]

Yves: logout on Yves as a customer
    delete all cookies
    Reload

Yves: go to the 'Home' page
    Go To    ${host}

Yves: get the last placed order ID by current customer
    [Documentation]    Returns orderID of the last order from customer account
    Run Keyword If    '${env}'=='suite-nonsplit'    Yves: go to URL:    /customer/order
    ${currentURL}=    Get Location
    Run Keyword If    '${env}'=='b2b'    Set Test Variable    ${menuItem}    Order History
    ...    ELSE    Set Test Variable    ${menuItem}    Orders History
    Run Keyword Unless    '/customer/order' in '${currentURL}'
    ...    Run Keywords
    ...    Yves: go to the 'Home' page
    ...    AND    Yves: go to user menu item in header:    ${menuItem}
    ...    AND    Yves: 'Order History' page is displayed
    ${lastPlacedOrder}=    Get Text    xpath=//div[contains(@data-qa,'component order-table')]//tr[1]//td[1]
    Set Suite Variable    ${lastPlacedOrder}    ${lastPlacedOrder}
    [Return]    ${lastPlacedOrder}

Yves: go to URL:
    [Arguments]    ${url}
    ${url}=    Get URL Without Starting Slash    ${url}
    Go To    ${host}${url}

Yves: go to newly created page by URL:
    [Arguments]    ${url}
    FOR    ${index}    IN RANGE    0    26
        Go To    ${host}${url}
        ${page_not_published}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//main//*[contains(text(),'ERROR 404')]
        Log    ${page_not_published}
        Run Keyword If    '${page_not_published}'=='True'    Run Keyword    Sleep    3s
        ...    ELSE    Exit For Loop
    END

Yves: go to external URL:
    [Arguments]    ${url}
    Go To    ${url}

Yves: go to second navigation item level:
    [Arguments]     ${navigation_item_level1}   ${navigation_item_level2}
    ${nodeClass}=    Get Element Attribute    xpath=//div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li    class
    ${nodeClass}=    Replace String    ${nodeClass}    \n    ${EMPTY}
    ${nodeShownClass}=    Set Variable    is-shown
    ${nodeUpdatedClass}=    Set Variable    ${nodeClass} ${nodeShownClass}
    Log    ${nodeClass}
    ${1LevelXpath}=    Set Variable    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li
    Add/Edit element attribute with JavaScript:    ${1LevelXpath}    class    ${nodeUpdatedClass}
    Wait Until Element Is Visible    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'menu--lvl-1')]
    Click Element by xpath with JavaScript    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'menu--lvl-1')]//li[contains(@class,'menu__item--lvl-1')]/span/*[contains(@class,'lvl-1')][1][text()='${navigation_item_level2}']

Yves: go to first navigation item level:
    [Arguments]     ${navigation_item_level1}
    BuiltIn.Run Keyword If    '${env}'=='b2b'    Run keywords
    ...    Wait Until Element Is Visible    xpath=//div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']    AND
    ...    Click Element by xpath with JavaScript    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']
    ...    ELSE    Run keywords
    ...    Wait Until Element Is Visible    xpath=//*[contains(@class,'header') and @data-qa='component header']//*[contains(@data-qa,'navigation-multilevel')]/*[contains(@class,'navigation-multilevel-node__link--lvl-1') and contains(text(),'${navigation_item_level1}')]    AND
    ...    Click Element by xpath with JavaScript    //*[contains(@class,'header') and @data-qa='component header']//*[contains(@data-qa,'navigation-multilevel')]/*[contains(@class,'navigation-multilevel-node__link--lvl-1') and contains(text(),'${navigation_item_level1}')]

Yves: go to third navigation item level:
    [Arguments]     ${navigation_item_level1}   ${navigation_item_level3}
    ${nodeClass}=    Get Element Attribute    xpath=//div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li    class
    ${nodeClass}=    Replace String    ${nodeClass}    \n    ${EMPTY}
    ${nodeShownClass}=    Set Variable    is-shown
    ${nodeUpdatedClass}=    Set Variable    ${nodeClass} ${nodeShownClass}
    Log    ${nodeClass}
    ${1LevelXpath}=    Set Variable    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li
    Add/Edit element attribute with JavaScript:    ${1LevelXpath}    class    ${nodeUpdatedClass}
    Wait Until Element Is Visible    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'menu--lvl-1')]
    Click Element by xpath with JavaScript    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'menu--lvl-2')]//li[contains(@class,'menu__item--lvl-2')]/span/*[contains(@class,'lvl-2')][1][text()='${navigation_item_level3}']

Yves: get index of the first available product
    Yves: perform search by:    ${EMPTY}
    Wait Until Page Contains Element    ${catalog_main_page_locator}[${env}]
    ${productsCount}=    Get Element Count    xpath=//product-item[@data-qa='component product-item']
    Log    ${productsCount}
    FOR    ${index}    IN RANGE    1    ${productsCount}+1
        ${status}=    Run Keyword And Ignore Error
        ...    Run keyword if    '${env}'=='b2b'    Page should contain element    xpath=//product-item[@data-qa='component product-item'][${index}]//*[@class='product-item__actions']//ajax-add-to-cart//button[@disabled='']
        ...    ELSE    Run keyword if    '${env}'=='b2c'    Page should contain element    xpath=//product-item[@data-qa='component product-item'][${index}]//ajax-add-to-cart//button
        Log    ${index}
        ${pdp_url}=    Run keyword if    '${env}'=='b2b'    Get Element Attribute    xpath=//product-item[@data-qa='component product-item'][${index}]//a[@itemprop='url']    href
        Run keyword if    'PASS' in ${status} and '${env}'=='b2b'    Continue For Loop
        Run keyword if    'bundle' in '${pdp_url}' and '${env}'=='b2c'    Continue For Loop
        Run keyword if    'FAIL' in ${status} and '${env}'=='b2b'    Run Keywords
        ...    Return From Keyword    ${index}
        ...    AND    Exit For Loop
        ${pdp_url}=    Run keyword if    '${env}'=='b2c'    Get Element Attribute    xpath=//product-item[@data-qa='component product-item'][${index}]//div[contains(@class,'product-item__image')]//a[contains(@class,'link-detail-page')]    href
        Run keyword if    'FAIL' in ${status} and '${env}'=='b2c'    Continue For Loop
        Run keyword if    'bundle' in '${pdp_url}' and '${env}'=='b2c'    Continue For Loop
        Run keyword if    'PASS' in ${status} and '${env}'=='b2c'    Run Keywords
        ...    Return From Keyword    ${index}
        ...    AND    Exit For Loop
    END
        ${productIndex}=    Set Variable    ${index}
        Return From Keyword    ${productIndex}

Yves: go to the PDP of the first available product
    ${index}=    Yves: get index of the first available product
    Click    xpath=//product-item[@data-qa='component product-item'][${index}]//a[contains(@class,'link-detail-page') and (contains(@class,'info')) or (contains(@class,'name'))]
    Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]

Yves: go to the PDP of the first available product on open catalog page
    Click    xpath=//product-item[@data-qa='component product-item'][1]//a[contains(@class,'link-detail-page') and (contains(@class,'info')) or (contains(@class,'name'))]
    Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]

Yves: check if cart is not empty and clear it
    Yves: go to the 'Home' page
    Yves: go to b2c shopping cart
    ${productsInCart}=    Get Element Count    xpath=//article[@class='product-card-item']//div[contains(@class,'product-card-item__box')]
    ${cartIsEmpty}=    Run Keyword And Return Status    Element should be visible    xpath=//*[contains(@class,'spacing-top') and text()='Your shopping cart is empty!']
    Run Keyword If    '${cartIsEmpty}'=='False'    Helper: delete all items in cart

Helper: delete all items in cart
    ${productsInCart}=    Get Element Count    xpath=//article[@class='product-card-item']//div[contains(@class,'product-card-item__box')]
    FOR    ${index}    IN RANGE    0    ${productsInCart}
        Click    xpath=(//div[@class='page-layout-cart__items-wrap']//ancestor::div/following-sibling::div//form[contains(@name,'removeFromCart')]//button[text()='Remove'])\[1\]
        Yves: remove flash messages
    END

Yves: try reloading page if element is/not appear:
    [Arguments]    ${element}    ${isDisplayed}
    FOR    ${index}    IN RANGE    0    21
        ${elementAppears}=    Run Keyword And Return Status    Element Should Be Visible    ${element}
        Run Keyword If    '${isDisplayed}'=='True' and '${elementAppears}'=='False'    Run Keywords    Sleep    1s    AND    Reload
        ...    ELSE    Run Keyword If    '${isDisplayed}'=='False' and '${elementAppears}'=='True'    Run Keywords    Sleep    1s    AND    Reload
        ...    ELSE    Exit For Loop
    END

Yves: get current lang
    ${lang}=    get attribute    xpath=//html    lang
    return from keyword   ${lang}
