*** Settings ***
Library    String
Library    Browser
Library    DatabaseLibrary
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
${default_db_host}         127.0.0.1
${default_db_name}         eu-docker
${default_db_password}     secret
${default_db_port}         3306
${default_db_user}         spryker
${api_timeout}             60
${default_allow_redirects}     true
${default_auth}                ${NONE}
${current_url}        http://glue.de.spryker.local
*** Keywords ***
Yves: login on Yves with provided credentials:
    [Arguments]    ${email}    ${password}=${default_password}
    ${currentURL}=    Get Url
    IF    '/login' not in '${currentURL}'
        IF    '${env}' in ['b2b','suite-nonsplit','mp_b2b']
            Run Keywords
                Go To    ${host}
                delete all cookies
                Reload
                Wait Until Element Is Visible    ${header_login_button}[${env}]
                Click    ${header_login_button}[${env}]
                Wait Until Element Is Visible    ${email_field}
        ELSE
            Run Keywords
                Go To    ${host}
                delete all cookies
                Reload
                mouse over  ${user_navigation_icon_header_menu_item}[${env}]
                Wait Until Element Is Visible    ${user_navigation_menu_login_button}
                Click    ${user_navigation_menu_login_button}
                Wait Until Element Is Visible    ${email_field}
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
    Yves: perform search by:    ${sku}
    Wait Until Page Contains Element    ${catalog_product_card_locator}
    Click    ${catalog_product_card_locator}
    Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]

Yves: '${pageName}' page is displayed
    IF    '${pageName}' == 'Company Users'    Page Should Contain Element    ${company_users_main_content_locator}    ${pageName} page is not displayed
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
    ...    ELSE IF    '${pageName}' == 'Merchant Profile'    Page Should Contain Element    ${merchant_profile_main_content_locator}    ${pageName} page is not displayed

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
    Go To    ${host}

Yves: get the last placed order ID by current customer
    [Documentation]    Returns orderID of the last order from customer account
    IF    '${env}'=='suite-nonsplit'    Yves: go to URL:    /customer/order
    ${currentURL}=    Get Location
    IF    '${env}' in ['b2b','mp_b2b']
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
    Go To    ${host}${url}

Yves: go to newly created page by URL:
    [Arguments]    ${url}
    FOR    ${index}    IN RANGE    0    26
        Go To    ${host}${url}
        ${page_not_published}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//main//*[contains(text(),'ERROR 404')]
        Log    ${page_not_published}
        IF    '${page_not_published}'=='True'
            Run Keyword    Sleep    3s
        ELSE
            Exit For Loop
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
    IF    '${env}' in ['b2b','mp_b2b']
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
        ${status}=    IF    '${env}'=='b2b'    Run Keyword And Ignore Error     Page should contain element    xpath=//product-item[@data-qa='component product-item'][${index}]//*[@class='product-item__actions']//ajax-add-to-cart//button[@disabled='']
        ...    ELSE IF    '${env}' in ['b2c','mp_b2c']    Run Keyword And Ignore Error    Page should contain element    xpath=//product-item[@data-qa='component product-item'][${index}]//ajax-add-to-cart//button    Add to cart button is missing    ${browser_timeout}
        Log    ${index}
        ${pdp_url}=    IF    '${env}'=='b2b'    Get Element Attribute    xpath=//product-item[@data-qa='component product-item'][${index}]//a[@itemprop='url']    href
        IF    'PASS' in ${status} and '${env}'=='b2b'    Continue For Loop
        IF    'bundle' in '${pdp_url}' and '${env}'=='b2b'    Continue For Loop
        IF    'FAIL' in ${status} and '${env}'=='b2b'
            Run Keywords
                Return From Keyword  ${index}
                Log ${index}
                Exit For Loop
        END
        ${pdp_url}=    IF    '${env}' in ['b2c','mp_b2c']    Get Element Attribute    xpath=//product-item[@data-qa='component product-item'][${index}]//div[contains(@class,'product-item__image')]//a[contains(@class,'link-detail-page')]    href
        IF    'FAIL' in ${status} and '${env}' in ['b2c','mp_b2c']    Continue For Loop
        IF    'bundle' in '${pdp_url}' and '${env}' in ['b2c','mp_b2c']    Continue For Loop
        IF    'PASS' in ${status} and '${env}' in ['b2c','mp_b2c']
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
    IF    '${env}' in ['mp_b2b','mp_b2c']    
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
    ${cartIsEmpty}=    Run Keyword And Return Status    Element should be visible    xpath=//*[contains(@class,'spacing-top') and text()='Your shopping cart is empty!']
    IF    '${cartIsEmpty}'=='False'    Helper: delete all items in cart

Helper: delete all items in cart
    ${productsInCart}=    Get Element Count    xpath=//article[@class='product-card-item']//div[contains(@class,'product-card-item__box')]
    FOR    ${index}    IN RANGE    0    ${productsInCart}
        Click    xpath=(//div[@class='page-layout-cart__items-wrap']//ancestor::div/following-sibling::div//form[contains(@name,'removeFromCart')]//button[text()='Remove'])\[1\]
        Yves: remove flash messages
    END

Yves: try reloading page if element is/not appear:
    [Arguments]    ${element}    ${isDisplayed}
    FOR    ${index}    IN RANGE    0    26
        ${elementAppears}=    Run Keyword And Return Status    Element Should Be Visible    ${element}
        IF    '${isDisplayed}'=='True' and '${elementAppears}'=='False'
            Run Keywords    Sleep    3s    AND    Reload
        ELSE IF    '${isDisplayed}'=='False' and '${elementAppears}'=='True'
            Run Keywords    Sleep    3s    AND    Reload
        ELSE
            Exit For Loop
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
Yves: login after signup during checkout:
    [Arguments]    ${email}    ${password}
    Type Text    ${email_field}     ${email}
    Type Text    ${password_field}     ${password}
    Click    ${form_login_button}
Save the result of a SELECT DB query to a variable:
    [Documentation]    This keyword saves any value which you receive from DB using SQL query ``${sql_query}`` to a test variable called ``${variable_name}``.
    ...
    ...    It can be used to save a value returned by any query into a custom test variable.
    ...    This variable, once created, can be used during the specific test where this keyword is used and can be re-used by the keywords that follow this keyword in the test.
    ...    It will not be visible to other tests.
    ...    NOTE: Make sure that you expect only 1 value from DB, you can also check your query via external SQL tool.
    ...
    ...    *Examples:*
    ...
    ...    ``Save the result of a SELECT DB query to a variable:    select registration_key from spy_customer where customer_reference = '${user_reference_id}'    confirmation_key``
    [Arguments]    ${sql_query}    ${variable_name}
    Connect To Database    pymysql    ${default_db_name}    ${default_db_user}    ${default_db_password}    ${default_db_host}    ${default_db_port}
    ${var_value} =    Query    ${sql_query}
    Disconnect From Database
    ${var_value}=    Convert To String    ${var_value}
    ${var_value}=    Replace String    ${var_value}    '   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    ,   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    (   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    )   ${EMPTY}
    Set Test Variable    ${${variable_name}}    ${var_value}
    [Return]    ${variable_name}
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
    [Arguments]   ${path}    ${json}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    ${data}=    Evaluate    ${json}
    ${hasValue}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${hasValue}   run keyword    POST    ${current_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}
    ...    ELSE    POST    ${current_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=ANY
    ${response_body}=    IF    ${response.status_code} != 204    Set Variable    ${response.json()}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${current_url}${path}
    [Return]    ${response_body}

Yves: change current locale language:
    [Documentation]    Change locale language to EN,DE 
    [Arguments]    ${language}
    Select From List By Text     ${yves_language_dropdown_locator}    ${language}  

Yves: verify current locale language:
    [Arguments]    ${current_lang}
    ${lang}=    Yves: get current lang
    ${lang}=    Convert To Upper Case    ${lang}
    Should Be Equal    ${current_lang}    ${lang}    msg= Current locale language is not changed