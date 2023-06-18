*** Settings ***
Library    String
Library    Browser
Library    DatabaseLibrary
Library    ../../resources/libraries/common.py
Resource    common.robot
Resource    ../pages/yves/yves_overview_page.robot
Resource    ../pages/yves/yves_profile_page.robot
Resource    ../pages/yves/yves_overview_page.robot
Resource    ../pages/yves/yves_profile_page.robot
Resource    ../pages/yves/yves_catalog_page.robot
Resource    ../pages/yves/yves_product_details_page.robot
Resource    ../pages/yves/yves_company_users_page.robot
Resource    ../pages/yves/yves_shopping_lists_page.robot
Resource    ../pages/yves/yves_shopping_carts_page.robot
Resource    ../pages/yves/yves_shopping_cart_page.robot
Resource    ../pages/yves/yves_shopping_list_page.robot
Resource    ../pages/yves/yves_checkout_success_page.robot
Resource    ../pages/yves/yves_address_page.robot
Resource    ../pages/yves/yves_address_page.robot
Resource    ../pages/yves/yves_order_history_page.robot
Resource    ../pages/yves/yves_returns_page.robot
Resource    ../pages/yves/yves_newsletter_page.robot
Resource    ../pages/yves/yves_returns_page.robot
Resource    ../pages/yves/yves_newsletter_page.robot
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
Resource    ../steps/checkout_steps.robot

*** Variable ***
${notification_area}    xpath=//section[@data-qa='component notification-area']

*** Keywords ***
Yves: login on Yves with provided credentials:
    [Arguments]    ${email}    ${password}=${default_password}
    ${currentURL}=    Get Url
    IF    '/login' not in '${currentURL}'
        IF    '${env}' in ['ui_b2b','ui_suite','ui_mp_b2b']
            ${currentURL}=    Get Location
                IF    '.at.' in '${currentURL}'
                    Go To    ${yves_at_url}
                    delete all cookies
                    Reload
                    Wait Until Element Is Visible    ${header_login_button}[${env}]
                    Click    ${header_login_button}[${env}]
                    Wait Until Element Is Visible    ${email_field}
                ELSE
                    Go To    ${yves_url}
                    delete all cookies
                    Reload
                    Wait Until Element Is Visible    ${header_login_button}[${env}]
                    Click    ${header_login_button}[${env}]
                    Wait Until Element Is Visible    ${email_field}
                END
        ELSE
                ${currentURL}=    Get Location
                    IF    '.at.' in '${currentURL}'
                        Go To    ${yves_at_url}
                        delete all cookies
                        Reload
                        mouse over  ${user_navigation_icon_header_menu_item}[${env}]
                        Wait Until Element Is Visible    ${user_navigation_menu_login_button}
                        Click    ${user_navigation_menu_login_button}
                        Wait Until Element Is Visible    ${email_field}
                    ELSE
                        Go To    ${yves_url}
                        delete all cookies
                        Reload
                        mouse over  ${user_navigation_icon_header_menu_item}[${env}]
                        Wait Until Element Is Visible    ${user_navigation_menu_login_button}
                        Click    ${user_navigation_menu_login_button}
                        Wait Until Element Is Visible    ${email_field}
                    END
                    
        END
    END
    Type Text    ${email_field}    ${email}
    Type Text    ${password_field}    ${password}
    Click    ${form_login_button}
    IF    'agent' in '${email}'    
    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
        ELSE    
        Wait Until Element Is Visible    ${user_navigation_icon_header_menu_item}[${env}]     Login Failed!
    END
    Yves: remove flash messages

Yves: go to PDP of the product with sku:
    [Arguments]    ${sku}
    Yves: go to the 'Home' page
    Yves: perform search by:    ${sku}
    Wait Until Page Contains Element    ${catalog_product_card_locator}
    Click    ${catalog_product_card_locator}
    Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]

Yves: '${pageName}' page is displayed
    IF    '${pageName}' == 'Company Users'    Page Should Contain Element    ${company_users_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Login'    Page Should Contain Element    ${login_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Overview'    Page Should Contain Element    ${overview_main_content_locator}[${env}]    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Profile'    Page Should Contain Element    ${profile_main_content_locator}[${env}]    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Shopping Lists'    Page Should Contain Element    ${shopping_lists_page_form_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Shopping List'    Page Should Contain Element    ${shopping_list_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Shopping Cart'    Page Should Contain Element    ${shopping_cart_main_content_locator}[${env}]    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Shopping Carts'    Page Should Contain Element    ${shopping_carts_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Quick Order'    Page Should Contain Element    ${quick_order_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Thank you'    Page Should Contain Element    ${success_page_main_container_locator}[${env}]    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Addresses'    Page Should Contain Element    ${address_main_content_locator}[${env}]    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Order History'    Page Should Contain Element    ${order_history_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Returns'    Page Should Contain Element    ${returns_main_content_locator}[${env}]    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Newsletter'    Page Should Contain Element    ${newsletter_main_content_locator}[${env}]    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Order Details'    Page Should Contain Element    ${order_details_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Select Business Unit'    Page Should Contain Element    ${customer_account_business_unit_selector}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Summary'    Page Should Contain Element    ${checkout_summary_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Quote Requests'    Page Should Contain Element    ${quote_requests_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Quote Request Details'    Page Should Contain Element    ${quote_request_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Choose Bundle to configure'    Page Should Contain Element    ${choose_bundle_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Create Return'    Page Should Contain Element    ${create_return_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Return Details'    Page Should Contain Element    ${return_details_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Payment cancellation'    Page Should Contain Element    ${cancel_payment_page_main_container_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Merchant Profile'    Page Should Contain Element    ${merchant_profile_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Wishlist'    Page Should Contain Element    ${wishlist_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE        Fail    '${pageName}' page is not displayed or the page name is incorrect

Yves: remove flash messages
    ${flash_massage_state}=    Run Keyword And Ignore Error    Page Should Contain Element    ${notification_area}    1s
    Log    ${flash_massage_state}
    IF    'PASS' in ${flash_massage_state}     Remove element from HTML with JavaScript    //section[@data-qa='component notification-area']

Yves: flash message '${condition}' be shown
    IF    '${condition}' == 'should'
        Wait Until Element Is Visible    ${notification_area}
    ELSE
        Page Should Not Contain Element    ${notification_area}
    END

Yves: flash message should be shown:
    [Documentation]    ${type} can be: error, success
    [Arguments]    ${type}    ${text}
    IF    '${type}' == 'error'
        Element Should Be Visible    xpath=//flash-message[contains(@class,'alert')]//div[contains(text(),'${text}')]
    ELSE
        IF  '${type}' == 'success'  Element Should Be Visible    xpath=//flash-message[contains(@class,'success')]//div[contains(text(),'${text}')]
    END

Yves: logout on Yves as a customer
    delete all cookies
    Reload

Yves: go to the 'Home' page
    ${currentURL}=    Get Location
    IF    '.at.' in '${currentURL}'
        Go To    ${yves_at_url}
    ELSE
        Go To    ${yves_url}
    END

Yves: go to AT store 'Home' page
    Go To    ${yves_at_url}

Yves: get the last placed order ID by current customer
    [Documentation]    Returns orderID of the last order from customer account
    IF    '${env}'=='ui_suite'    Yves: go to URL:    /customer/order
    ${currentURL}=    Get Location
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']
        Set Test Variable    ${menuItem}    Order History
    ELSE
        Set Test Variable    ${menuItem}    Orders History
    END
    IF    '/customer/order' not in '${currentURL}'
        Run Keywords
            Yves: go to the 'Home' page
            Yves: go to user menu item in header:    ${menuItem}
            Yves: 'Order History' page is displayed
    END
    ${lastPlacedOrder}=    Get Text    xpath=//div[contains(@data-qa,'component order-table')]//tr[1]//td[1]
    Set Suite Variable    ${lastPlacedOrder}    ${lastPlacedOrder}
    [Return]    ${lastPlacedOrder}

Yves: go to URL:
    [Arguments]    ${url}
    ${url}=    Get URL Without Starting Slash    ${url}
    Go To    ${yves_url}${url}

Yves: go to AT URL:
    [Arguments]    ${url}
    ${url}=    Get URL Without Starting Slash    ${url}
    Go To    ${yves_at_url}${url}

Yves: go to newly created page by URL:
    [Arguments]    ${url}    ${delay}=5s    ${iterations}=31
    FOR    ${index}    IN RANGE    0    ${iterations}
        Go To    ${yves_url}${url}
        ${page_not_published}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//main//*[contains(text(),'ERROR 404')]
        Log    ${page_not_published}
        IF    '${page_not_published}'=='True'
            Run Keyword    Sleep    ${delay}
        ELSE
            Exit For Loop
        END
        IF    ${index} == ${iterations}-1
            Take Screenshot
            Fail    Newly created URL is not accessible (404 error), check P&S
        END
    END

Yves: go to newly created page by URL on AT store:
    [Arguments]    ${url}    ${delay}=5s    ${iterations}=31
    FOR    ${index}    IN RANGE    0    ${iterations}
        Go To    ${yves_at_url}${url}
        ${page_not_published}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//main//*[contains(text(),'ERROR 404')]
        Log    ${page_not_published}
        IF    '${page_not_published}'=='True'
            Run Keyword    Sleep    ${delay}
        ELSE
            Exit For Loop
        END
        IF    ${index} == ${iterations}-1
            Take Screenshot
            Fail    Newly created CMS page is not accessible (404 error), check P&S
        END
    END

Yves: go to URL and refresh until 404 occurs:
    [Arguments]    ${url}    ${delay}=5s    ${iterations}=31
    FOR    ${index}    IN RANGE    0    ${iterations}
        Go To    ${url}
        ${page_not_published}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//main//*[contains(text(),'ERROR 404')]
        Log    ${page_not_published}
        IF    '${page_not_published}'=='False'
            Run Keyword    Sleep    ${delay}
        ELSE
            Exit For Loop
        END
        IF    ${index} == ${iterations}-1
            Take Screenshot
            Fail    URL is still accessible but should not, check P&S
        END
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
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']
        Run keywords
            Wait Until Element Is Visible    xpath=//div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']    AND
            Click Element by xpath with JavaScript    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']
    ELSE
        Run keywords
            Wait Until Element Is Visible    xpath=//*[contains(@class,'header') and @data-qa='component header']//*[contains(@data-qa,'navigation-multilevel')]/*[contains(@class,'navigation-multilevel-node__link--lvl-1') and contains(text(),'${navigation_item_level1}')]    AND
            Click Element by xpath with JavaScript    //*[contains(@class,'header') and @data-qa='component header']//*[contains(@data-qa,'navigation-multilevel')]/*[contains(@class,'navigation-multilevel-node__link--lvl-1') and contains(text(),'${navigation_item_level1}')]
    END

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
    [Documentation]    For B2B this keyword should be used only for logged in customers, otherwise add to cart buttons are absent and it returns wrong index
    Yves: perform search by:    ${EMPTY}
    Wait Until Page Contains Element    ${catalog_main_page_locator}[${env}]
    ${productsCount}=    Get Element Count    xpath=//product-item[@data-qa='component product-item']
    Log    ${productsCount}
    FOR    ${index}    IN RANGE    1    ${productsCount}+1
        ${status}=    IF    '${env}'=='ui_b2b'    Run Keyword And Ignore Error     Page should contain element    xpath=//product-item[@data-qa='component product-item'][${index}]//*[@class='product-item__actions']//ajax-add-to-cart//button[@disabled='']
        ...    ELSE IF    '${env}' in ['ui_b2c','ui_mp_b2c']    Run Keyword And Ignore Error    Page should contain element    xpath=//product-item[@data-qa='component product-item'][${index}]//ajax-add-to-cart//button    Add to cart button is missing    ${browser_timeout}
        Log    ${index}
        ${pdp_url}=    IF    '${env}'=='ui_b2b'    Get Element Attribute    xpath=//product-item[@data-qa='component product-item'][${index}]//a[@itemprop='url']    href
        IF    'PASS' in ${status} and '${env}'=='ui_b2b'    Continue For Loop
        IF    'bundle' in '${pdp_url}' and '${env}'=='ui_b2b'    Continue For Loop
        IF    'FAIL' in ${status} and '${env}'=='ui_b2b'
            Run Keywords
                Return From Keyword  ${index}
                Log ${index}
                Exit For Loop
        END
        ${pdp_url}=    IF    '${env}' in ['ui_b2c','ui_mp_b2c']    Get Element Attribute    xpath=//product-item[@data-qa='component product-item'][${index}]//div[contains(@class,'product-item__image')]//a[contains(@class,'link-detail-page')]    href
        IF    'FAIL' in ${status} and '${env}' in ['ui_b2c','ui_mp_b2c']    Continue For Loop
        IF    'bundle' in '${pdp_url}' and '${env}' in ['ui_b2c','ui_mp_b2c']    Continue For Loop
        IF    'PASS' in ${status} and '${env}' in ['ui_b2c','ui_mp_b2c']
            Run Keywords
                Return From Keyword    ${index}
                Log ${index}
                Exit For Loop
        END
    END
        ${productIndex}=    Set Variable    ${index}
        Return From Keyword    ${productIndex}

Yves: get index of the first available product on marketplace
    Yves: perform search by:    ${EMPTY}
    Wait Until Page Contains Element    ${catalog_main_page_locator}[${env}]
    ${productsCount}=    Get Element Count    xpath=//product-item[@data-qa='component product-item']
    Log    ${productsCount}   
    FOR    ${index}    IN RANGE    1    ${productsCount}+1
        Click    xpath=//product-item[@data-qa='component product-item'][${index}]//a[contains(@class,'link-detail-page') and (contains(@class,'info')) or (contains(@class,'name'))]
        Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]
        ${status}=    Run Keyword And Ignore Error     Page should contain element    &{pdp_add_to_cart_disabled_button}[${env}]
        Log    ${index}
        IF    'PASS' in ${status}    Continue For Loop
        IF    'FAIL' in ${status}
            Run Keywords
                Return From Keyword  ${index}
                Log ${index}
                Exit For Loop
        END
    END
        ${productIndex}=    Set Variable    ${index}
        Return From Keyword    ${productIndex}

Yves: go to the PDP of the first available product
    IF    '${env}' in ['ui_mp_b2b','ui_mp_b2c']    
        ${index}=    Yves: get index of the first available product on marketplace
    ELSE    
        ${index}=    Yves: get index of the first available product
        Click    xpath=//product-item[@data-qa='component product-item'][${index}]//a[contains(@class,'link-detail-page') and (contains(@class,'info')) or (contains(@class,'name'))]
    END
    Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]

Yves: go to the PDP of the first available product on open catalog page
    Click    xpath=//product-item[@data-qa='component product-item'][1]//a[contains(@class,'link-detail-page') and (contains(@class,'info')) or (contains(@class,'name'))]
    Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]

Yves: check if cart is not empty and clear it
    Yves: go to the 'Home' page
    Yves: go to b2c shopping cart
    ${productsInCart}=    Get Element Count    xpath=//article[@class='product-card-item']//div[contains(@class,'product-card-item__box')]
    ${cartIsEmpty}=    Run Keyword And Return Status    Element should be visible    xpath=//*[contains(@class,'spacing-top') and text()='Your shopping cart is empty!']    timeout=1s
    IF    '${cartIsEmpty}'=='False'    Helper: delete all items in cart

Helper: delete all items in cart
    ${productsInCart}=    Get Element Count    xpath=//article[@class='product-card-item']//div[contains(@class,'product-card-item__box')]
    FOR    ${index}    IN RANGE    0    ${productsInCart}
        Click    xpath=(//div[@class='page-layout-cart__items-wrap']//ancestor::div/following-sibling::div//form[contains(@name,'removeFromCart')]//button[text()='Remove'])\[1\]
        Yves: remove flash messages
    END

Yves: try reloading page if element is/not appear:
    [Arguments]    ${element}    ${isDisplayed}    ${iterations}=26    ${sleep}=3s
    ${isDisplayed}=    Convert To Lower Case    ${isDisplayed}
    FOR    ${index}    IN RANGE    0    ${iterations}
        ${elementAppears}=    Run Keyword And Return Status    Element Should Be Visible    ${element}
        IF    '${isDisplayed}'=='true' and '${elementAppears}'=='False'
            Run Keywords    Sleep    ${sleep}    AND    Reload
        ELSE IF    '${isDisplayed}'=='false' and '${elementAppears}'=='True'
            Run Keywords    Sleep    ${sleep}    AND    Reload
        ELSE
            Exit For Loop
        END
        IF    ${index} == ${iterations}-1
            Take Screenshot
            Fail    expected element state is not reached
        END
    END

Yves: get current lang
    ${lang}=    get attribute    xpath=//html    lang
    return from keyword   ${lang}

Yves: page should contain script with attribute:
    [Arguments]    ${attribute}    ${value}
    Try reloading page until element is/not appear:    xpath=//head//script[@${attribute}='${value}']    true
    Page Should Contain Element    xpath=//head//script[@${attribute}='${value}']

Yves: page should contain script with id:
    [Arguments]    ${scriptId}
    Yves: page should contain script with attribute:    id    ${scriptId}

Yves: validate the page title:
    [Arguments]    ${title}
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']
        Yves: try reloading page if element is/not appear:    xpath=//h3[contains(text(),'${title}')]     True
    ELSE
        Yves: try reloading page if element is/not appear:    xpath=//h1[contains(@class,'title')][contains(text(),'${title}')]     True
    END
    
Yves: login after signup during checkout:
    [Arguments]    ${email}    ${password}
    Type Text    ${email_field}     ${email}
    Type Text    ${password_field}     ${password}
    Click    ${form_login_button}

I send a POST request:
    [Documentation]    This keyword is used to make POST requests. It accepts the endpoint *without the domain* and the body in JOSN.
    ...    Variables can and should be used in the endpoint url and in the body JSON.
    ...
    ...    If the endpoint needs to have any headers (e.g. token for authorisation), ``I set Headers`` keyword should be called before this keyword to set the headers beforehand.
    ...
    ...    After this keyword is called, response body, selflink, response status and headers are recorded into the test variables which have the scope of the current test and can then be used by other keywords to get and compare data.
    ...
    ...    *Example:*
    ...
    ...    ``I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}``
    [Arguments]   ${path}    ${json}    ${timeout}=60    ${allow_redirects}=true    ${auth}=${NONE}    ${expected_status}=ANY
    ${data}=    Evaluate    ${json}
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${headers_not_empty}   run keyword    POST    ${glue_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ...    ELSE    POST    ${glue_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=ANY    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204    
        TRY    
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${response_headers}=    Set Variable    ${response.headers}
    IF    ${response.status_code} == 204    
        ${response_body}=    Set Variable    ${EMPTY}
    END
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${glue_url}${path}
    [Return]    ${response_body}

I set Headers:
    [Documentation]    Keyword sets any number of headers for the further endpoint calls.
    ...    Headers can have any name and any value, they are set as test variable - which means they can be used throughtout one test if set once.
    ...    This keyword can be used to add access token to the next endpoint calls or to set header for the guest customer, etc.
    ...
    ...    It accepts a list of pairs haader-name=header-value as an argument. The list items should be separated by 4 spaces.
    ...
    ...    *Example:*
    ...
    ...    ``I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}``

    [Arguments]    &{headers}
    Set Test Variable    &{headers}
    [Return]    &{headers}

Yves: checkout is blocked with the following message:
    [Arguments]    ${expectedMessage}
    ${currentURL}=    Get Url
    IF    '/cart' in '${currentURL}'
        ${checkout_button_state}=    Get Element Attribute    ${shopping_cart_checkout_button}    class
        Should Contain    ${checkout_button_state}    disabled
        Get Text    ${shopping_cart_checkout_error_message_locator}    contains    ${expectedMessage}
    ELSE
        TRY
            Element Should Be Visible    ${checkout_summary_alert_message}[${env}]
            Page Should Not Contain Element    ${checkout_summary_submit_order_button}
            ${actualAlertMessage}=    Get Text    ${checkout_summary_alert_message}[${env}]
            Should Be Equal    ${actualAlertMessage}    ${expectedMessage}
        EXCEPT    
            Yves: accept the terms and conditions:    true
            Click    ${checkout_summary_submit_order_button}
            Yves: flash message should be shown:    error    ${expectedMessage}
        END
    END