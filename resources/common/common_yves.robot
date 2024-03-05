*** Settings ***
Resource    common_ui.robot
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

*** Variables ***
${notification_area}    xpath=//section[@data-qa='component notification-area']

*** Keywords ***
Yves: login on Yves with provided credentials:
    [Arguments]    ${email}    ${password}=${default_password}
    Set Browser Timeout    ${browser_timeout}
    ${currentURL}=    Get Url
    IF    '/login' not in '${currentURL}'
        IF    '.at.' in '${currentURL}'
            Delete All Cookies
            Reload
            Go To    ${yves_at_url}login
        ELSE
            Delete All Cookies
            Reload
            Go To    ${yves_url}login
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
    [Arguments]    ${sku}    ${wait_for_p&s}=${False}    ${iterations}=26    ${delay}=5s
    Yves: go to URL:    /search?q=${sku}
    ### *** promise for P&S *** ####
    ${wait_for_p&s}=    Convert To String    ${wait_for_p&s}
    ${wait_for_p&s}=    Convert To Lower Case    ${wait_for_p&s}
    IF    '${wait_for_p&s}' == 'true'
        ${wait_for_p&s}=    Set Variable    ${True}
    END
    IF    '${wait_for_p&s}' == 'false'
        ${wait_for_p&s}=    Set Variable    ${False}
    END
    IF    ${wait_for_p&s}
        FOR    ${index}    IN RANGE    1    ${iterations}
        ${result}=    Run Keyword And Ignore Error    Page Should Contain Element    ${catalog_product_card_locator}    timeout=1s
            IF    ${index} == ${iterations}-1
                Take Screenshot    EMBED    fullPage=True
                Fail    Product '${sku}' is not displayed in the search results
            END
            IF    'FAIL' in ${result}   
                Sleep    ${delay}
                Yves: go to URL:    /search?q=${sku}
                Continue For Loop
            ELSE
                ${pdp_url}=    Get Element Attribute    ${catalog_product_card_locator}    href
                Yves: go to URL:    ${pdp_url}?fake=${random}+${index}
                Repeat Keyword    3    Wait Until Network Is Idle
                ${pdp_available}=    Run Keyword And Ignore Error    Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]    timeout=0.5s
                IF    'PASS' in ${pdp_available}
                    Exit For Loop
                ELSE
                    Sleep    ${delay}
                    Yves: go to URL:    /search?q=${sku}
                    Continue For Loop
                END
            END
        END
    ELSE
        TRY
            Wait Until Page Contains Element    ${catalog_main_page_locator}[${env}]
            Wait Until Page Contains Element    ${catalog_product_card_locator}
            Click    ${catalog_product_card_locator}
            Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]
            Repeat Keyword    3    Wait Until Network Is Idle
        EXCEPT    
            Yves: go to URL:    /search?q=${sku}
            Reload
            Repeat Keyword    3    Wait Until Network Is Idle
            Wait Until Page Contains Element    ${catalog_main_page_locator}[${env}]
            Wait Until Page Contains Element    ${catalog_product_card_locator}
            ${pdp_url}=    Get Element Attribute    ${catalog_product_card_locator}    href
            Yves: go to URL:    ${pdp_url}?fake=${random}+${random}
            Repeat Keyword    3    Wait Until Network Is Idle
            Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]
        END
    END

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
    ...    ELSE IF    '${pageName}' == 'Wishlist'    Page Should Contain Element    ${wishlist_main_content_locator}[${env}]    ${pageName} page is not displayed
    ...    ELSE        Fail    '${pageName}' page is not displayed or the page name is incorrect

Yves: remove flash messages
    TRY
        ${flash_massage_state}=    Page Should Contain Element    ${notification_area}    message=Flash message is not shown    timeout=1s
        Remove element from HTML with JavaScript    //section[@data-qa='component notification-area']
    EXCEPT    
        Log    Flash message is not shown
    END

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
    Delete All Cookies
    Reload

Yves: go to the 'Home' page
    Set Browser Timeout    ${browser_timeout}
    ${currentURL}=    Get Location
    IF    '.at.' in '${currentURL}'
        Go To    ${yves_at_url}
    ELSE
        Go To    ${yves_url}
    END

Yves: go to AT store 'Home' page if other store not specified:
    [Arguments]    ${store}=AT
    Set Browser Timeout    ${browser_timeout}
    ${dms_state}=    Convert To String    ${dms}
    IF    '${dms_state}' != 'True'
        Go To    ${yves_at_url}
    ELSE
        Go To    ${yves_url}
        Wait Until Element Is Visible    ${store_switcher_header_menu_item}
        Select From List By Value    ${store_switcher_header_menu_item}    ${store}
        Wait Until Element Contains    //*[@data-qa='component header']//select[contains(@name,'store')]/option[@selected='']    ${store}
    END

Yves: get the last placed order ID by current customer
    [Documentation]    Returns orderID of the last order from customer account
    Set Browser Timeout    ${browser_timeout}
    Yves: go to URL:    /customer/order
    ${lastPlacedOrder}=    Get Text    xpath=//div[contains(@data-qa,'component order-table')]//tr[1]//td[1]
    Set Suite Variable    ${lastPlacedOrder}    ${lastPlacedOrder}
    RETURN    ${lastPlacedOrder}

Yves: go to URL:
    [Arguments]    ${url}
    ${url}=    Get URL Without Starting Slash    ${url}
    Set Browser Timeout    ${browser_timeout}
    ${currentURL}=    Get Location
    IF    '.at.' in '${currentURL}'
        Go To    ${yves_at_url}${url}
    ELSE
        Go To    ${yves_url}${url}
    END    

Yves: go to AT store URL if other store not specified:
    [Arguments]    ${url}    ${store}=AT
    Set Browser Timeout    ${browser_timeout}
    ${url}=    Get URL Without Starting Slash    ${url}
    ${dms_state}=    Convert To String    ${dms}
    IF   '${dms_state}' != 'True'
        Go To    ${yves_at_url}${url}
    ELSE
    Go To    ${yves_url}
        Wait Until Element Is Visible    ${store_switcher_header_menu_item}
        Select From List By Value    ${store_switcher_header_menu_item}    ${store}
        Wait Until Element Contains    //*[@data-qa='component header']//select[contains(@name,'store')]/option[@selected='']    ${store}
    Go To    ${yves_url}${url}
    END

Yves: go to newly created page by URL:
    [Arguments]    ${url}    ${delay}=5s    ${iterations}=31
    FOR    ${index}    IN RANGE    1    ${iterations}
        Go To    ${yves_url}${url}?${index}
        ${page_not_published}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//main//*[contains(text(),'ERROR 404')]
        Log    ${page_not_published}
        IF    '${page_not_published}'=='True'
            Sleep    ${delay}
        ELSE
            Exit For Loop
        END
        IF    ${index} == ${iterations}-1
            Take Screenshot    EMBED    fullPage=True
            Fail    Newly created URL is not accessible (404 error), check P&S
        END
    END

Yves: go to newly created page by URL on AT store if other store not specified:
    [Arguments]    ${url}    ${delay}=5s    ${iterations}=31    ${store}=AT
    ${dms_state}=    Convert To String    ${dms}
    Set Browser Timeout    ${browser_timeout}    
    FOR    ${index}    IN RANGE    1    ${iterations}
        IF   '${dms_state}' != 'True'
            Go To    ${yves_at_url}${url}?${index}
        ELSE
            Go To    ${yves_url}
            Wait Until Element Is Visible    ${store_switcher_header_menu_item}
            Select From List By Value    ${store_switcher_header_menu_item}    ${store}
            Wait Until Element Contains    //*[@data-qa='component header']//select[contains(@name,'store')]/option[@selected='']    ${store}
            Go To    ${yves_url}${url}?${index}
        END
        ${page_not_published}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//main//*[contains(text(),'ERROR 404')]
        Log    ${page_not_published}
        IF    '${page_not_published}'=='True'
            Sleep    ${delay}
        ELSE
            Exit For Loop
        END
        IF    ${index} == ${iterations}-1
            Take Screenshot    EMBED    fullPage=True
            Fail    Newly created CMS page is not accessible (404 error), check P&S
        END
    END

Yves: navigate to specified AT store URL if no other store is specified and refresh until 404 occurs:
    [Arguments]    ${url}    ${delay}=5s    ${iterations}=31    ${store}=AT
    ${dms_state}=    Convert To String    ${dms}
    Set Browser Timeout    ${browser_timeout}
    FOR    ${index}    IN RANGE    1    ${iterations}
        IF   '${dms_state}' != 'True'
            Go To    ${url}
        ELSE
            Go To    ${yves_url}
            Wait Until Element Is Visible    ${store_switcher_header_menu_item}
            Select From List By Value    ${store_switcher_header_menu_item}    ${store}
            Wait Until Element Contains    //*[@data-qa='component header']//select[contains(@name,'store')]/option[@selected='']    ${store}
            Go To    ${url}
        END
        ${page_not_published}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//main//*[contains(text(),'ERROR 404')]
        Log    ${page_not_published}
        IF    '${page_not_published}'=='False'
            Run Keyword    Sleep    ${delay}
        ELSE
            Exit For Loop
        END
        IF    ${index} == ${iterations}-1
            Take Screenshot    EMBED    fullPage=True
            Fail    URL is still accessible but should not, check P&S
        END
    END

Yves: go to external URL:
    [Arguments]    ${url}
    Set Browser Timeout    ${browser_timeout}
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
    Repeat Keyword    3    Wait Until Network Is Idle

Yves: go to first navigation item level:
    [Arguments]     ${navigation_item_level1}
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']
        Wait Until Element Is Visible    xpath=//div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']
        Click Element by xpath with JavaScript    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']
        Repeat Keyword    3    Wait Until Network Is Idle
    ELSE IF    '${env}' in ['ui_suite']
        Wait Until Element Is Visible    xpath=(//header//nav[contains(@data-qa,'navigation-multilevel')]/ul/li[contains(.,'${navigation_item_level1}')])[1]
        Click    xpath=(//header//nav[contains(@data-qa,'navigation-multilevel')]/ul/li[contains(.,'${navigation_item_level1}')])[1]
        Repeat Keyword    3    Wait Until Network Is Idle
    ELSE
        Wait Until Element Is Visible    xpath=//*[contains(@class,'header') and @data-qa='component header']//*[contains(@data-qa,'navigation-multilevel')]/*[contains(@class,'navigation-multilevel-node__link--lvl-1') and contains(text(),'${navigation_item_level1}')]
        Click Element by xpath with JavaScript    //*[contains(@class,'header') and @data-qa='component header']//*[contains(@data-qa,'navigation-multilevel')]/*[contains(@class,'navigation-multilevel-node__link--lvl-1') and contains(text(),'${navigation_item_level1}')]
        Repeat Keyword    3    Wait Until Network Is Idle
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
    Repeat Keyword    3    Wait Until Network Is Idle

Yves: get index of the first available product
    [Documentation]    For B2B this keyword should be used only for logged in customers, otherwise add to cart buttons are absent and it returns wrong index
    Yves: perform search by:    ${EMPTY}
    Wait Until Page Contains Element    ${catalog_main_page_locator}[${env}]
    ${productsCount}=    Get Element Count    xpath=//product-item[@data-qa='component product-item']
    Log    ${productsCount}
    FOR    ${index}    IN RANGE    1    ${productsCount}+1
        ${status}=    IF    '${env}'=='ui_b2b'    Run Keyword And Ignore Error     Page should contain element    xpath=(//product-item[@data-qa='component product-item'])[${index}]//*[@class='product-item__actions']//ajax-add-to-cart//button[@disabled='']    timeout=10ms
        ${status}=    IF    '${env}'=='ui_suite'    Run Keyword And Ignore Error     Page should contain element    xpath=(//product-item[@data-qa='component product-item'])[${index}]//*[@class='product-item__actions']//ajax-add-to-cart//button[@disabled='']    timeout=10ms
        ...    ELSE IF    '${env}' in ['ui_b2c','ui_mp_b2c']    Run Keyword And Ignore Error    Page should contain element    xpath=(//product-item[@data-qa='component product-item'])[${index}]//ajax-add-to-cart//button    Add to cart button is missing    timeout=10ms
        Log    ${index}
        ${pdp_url}=    IF    '${env}' in ['ui_b2b','ui_suite']    Get Element Attribute    xpath=(//product-item[@data-qa='component product-item'])[${index}]//a[@itemprop='url']    href
        IF    'PASS' in ${status} and '${env}' in ['ui_b2b','ui_suite']    Continue For Loop
        IF    'bundle' in '${pdp_url}' and '${env}' in ['ui_b2b','ui_suite']    Continue For Loop
        IF    'FAIL' in ${status} and '${env}' in ['ui_b2b','ui_suite']
            Return From Keyword  ${index}
            Log ${index}
            Exit For Loop
        END
        ${pdp_url}=    IF    '${env}' in ['ui_b2c','ui_mp_b2c']    Get Element Attribute    xpath=(//product-item[@data-qa='component product-item'])[${index}]//div[contains(@class,'product-item__image')]//a[contains(@class,'link-detail-page')]    href
        IF    'FAIL' in ${status} and '${env}' in ['ui_b2c','ui_mp_b2c']    Continue For Loop
        IF    'bundle' in '${pdp_url}' and '${env}' in ['ui_b2c','ui_mp_b2c']    Continue For Loop
        IF    'PASS' in ${status} and '${env}' in ['ui_b2c','ui_mp_b2c']
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
        Click    xpath=(//product-item[@data-qa='component product-item'])[${index}]//a[contains(@class,'link-detail-page') and (contains(@class,'info')) or (contains(@class,'name'))]
        Wait Until Network Is Idle
        Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]
        ${status}=    Run Keyword And Ignore Error     Page should contain element    &{pdp_add_to_cart_disabled_button}[${env}]    timeout=10ms
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
        Click    xpath=(//product-item[@data-qa='component product-item'])[${index}]//a[contains(@class,'link-detail-page') and (contains(@class,'info')) or (contains(@class,'name'))]
    END
    Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]

Yves: go to the PDP of the first available product on open catalog page
    Click    xpath=(//product-item[@data-qa='component product-item'][1]//a[contains(@class,'link-detail-page') and (contains(@class,'info')) or (contains(@class,'name'))])[1]
    Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]

Yves: check if cart is not empty and clear it
    Yves: go to the 'Home' page
    Yves: go to b2c shopping cart
    ${productsInCart}=    Get Element Count    xpath=//article[@class='product-card-item']//div[contains(@class,'product-card-item__box')]
    ${cartIsEmpty}=    Run Keyword And Return Status    Element should be visible    xpath=//*[contains(@class,'spacing-top') and text()='Your shopping cart is empty!']    timeout=1s
    IF    '${cartIsEmpty}'=='False'    Helper: delete all items in cart

Helper: delete all items in cart

    IF    '${env}' in ['ui_suite']
        ${productsInCart}=    Get Element Count    xpath=//main//cart-items-list//product-item[contains(@data-qa,'component product-cart-item')]
        FOR    ${index}    IN RANGE    0    ${productsInCart}
            TRY
                Click    xpath=(//main//cart-items-list//product-item[contains(@data-qa,'component product-cart-item')]//form[contains(@name,'removeFromCart')]//button)[1]
                Yves: remove flash messages
            EXCEPT    
                Log    Shopping cart is empty now
            END
        END
    ELSE
        ${productsInCart}=    Get Element Count    xpath=//article[@class='product-card-item']//div[contains(@class,'product-card-item__box')]
        FOR    ${index}    IN RANGE    0    ${productsInCart}
            TRY
                Click    xpath=(//div[@class='page-layout-cart__items-wrap']//ancestor::div/following-sibling::div//form[contains(@name,'removeFromCart')]//button[text()='Remove'])[1]
                Yves: remove flash messages
            EXCEPT    
                Log    Shopping cart is empty now
            END
        END
    END

Yves: try reloading page if element is/not appear:
    [Arguments]    ${element}    ${isDisplayed}    ${iterations}=26    ${sleep}=5s
    ${isDisplayed}=    Convert To Lower Case    ${isDisplayed}
    FOR    ${index}    IN RANGE    1    ${iterations}
        ${elementAppears}=    Run Keyword And Return Status    Element Should Be Visible    ${element}
        IF    '${isDisplayed}'=='true' and '${elementAppears}'=='False'
            Run Keywords    Sleep    ${sleep}    AND    Reload
        ELSE IF    '${isDisplayed}'=='false' and '${elementAppears}'=='True'
            Run Keywords    Sleep    ${sleep}    AND    Reload
        ELSE
            Exit For Loop
        END
        
        IF    ${index} == ${iterations}-1
            Take Screenshot    EMBED    fullPage=True
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