*** Settings ***
Library    ../../Resources/Common/support.py

Resource    Common.robot
Resource    ../Pages/Yves/Yves_Catalog_page.robot
Resource    ../Pages/Yves/Yves_Product_Details_Page.robot
Resource    ../Pages/Yves/Yves_Company_Users_page.robot
Resource    ../Pages/Yves/Yves_Shopping_Lists_page.robot
Resource    ../Pages/Yves/Yves_Shopping_Carts_page.robot
Resource    ../Pages/Yves/Yves_Shopping_Cart_page.robot
Resource    ../Pages/Yves/Yves_Shopping_List_page.robot
Resource    ../Pages/Yves/Yves_Checkout_Success_page.robot
Resource    ../Pages/Yves/Yves_Order_History_page.robot
Resource    ../Pages/Yves/Yves_Order_Details_page.robot
Resource    ../Pages/Yves/Yves_Customer_Account_page.robot
Resource    ../Pages/Yves/Yves_Quote_Requests_page.robot
Resource    ../Pages/Yves/Yves_Quote_Request_page.robot
Resource    ../Pages/Yves/Yve_Choose_Bundle_to_Configure_page.robot

*** Variable ***
${notification_area}    xpath=//section[@data-qa='component notification-area']

*** Keywords ***
Yves: login on Yves with provided credentials:
    [Arguments]    ${email}    ${password}=${default_password}
    ${currentURL}=    Get Location        
    Run Keyword Unless    '/login' in '${currentURL}'    
    ...    Run Keywords   
    ...    Go To    ${host}
    ...    AND    delete all cookies 
    ...    AND    Reload Page
    ...    AND    Wait Until Element Is Visible    ${header_login_button}
    ...    AND    Click Element    ${header_login_button}
    ...    AND    Wait Until Element Is Visible    ${email_field}
    input text    ${email_field}    ${email}
    input text    ${password_field}    ${password}
    Scroll and Click Element    ${form_login_button}
    Run Keyword Unless    'fake' in '${email}' or 'agent' in '${email}'  Wait Until Element Is Visible    ${user_navigation_icon_header_menu_item}    ${loading_time}    Login Failed!
    Run Keyword If    'agent' in '${email}'    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: remove flash messages
    Wait For Document Ready    

Yves: go to PDP of the product with sku:
    [Arguments]    ${sku}
    Yves: perform search by:    ${sku}
    Wait Until Page Contains Element    ${catalog_product_card_locator}
    Wait For Document Ready    
    Scroll and Click Element    ${catalog_product_card_locator}
    Wait For Document Ready
    Wait Until Page Contains Element    ${pdp_main_container_locator}

Yves: '${pageName}' page is displayed
    Run Keyword If    '${pageName}' == 'Company Users'    Page Should Contain Element    ${company_users_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Shopping Lists'    Page Should Contain Element    ${shopping_lists_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Shopping List'    Page Should Contain Element    ${shopping_list_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Shopping Cart'    Page Should Contain Element    ${shopping_cart_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Shopping Carts'    Page Should Contain Element    ${shopping_carts_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Quick Order'    Page Should Contain Element    ${quick_order_main_content_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Thank you'    Page Should Contain Element    ${success_page_main_container_locator}    ${pageName} page is not displayed
    ...    ELSE IF    '${pageName}' == 'Order History'    Page Should Contain Element    ${order_history_main_content_locator}    ${pageName} page is not displayed     
    ...    ELSE IF    '${pageName}' == 'Order Details'    Page Should Contain Element    ${order_details_main_content_locator}    ${pageName} page is not displayed 
    ...    ELSE IF    '${pageName}' == 'Select Business Unit'    Page Should Contain Element    ${customer_account_business_unit_selector}    ${pageName} page is not displayed 
    ...    ELSE IF    '${pageName}' == 'Summary'    Page Should Contain Element    ${checkout_summary_main_content_locator}    ${pageName} page is not displayed 
    ...    ELSE IF    '${pageName}' == 'Quote Requests'    Page Should Contain Element    ${quote_requests_main_content_locator}    ${pageName} page is not displayed 
    ...    ELSE IF    '${pageName}' == 'Quote Request Details'    Page Should Contain Element    ${quote_request_main_content_locator}    ${pageName} page is not displayed 
    ...    ELSE IF    '${pageName}' == 'Choose Bundle to configure'    Page Should Contain Element    ${choose_bundle_main_content_locator}    ${pageName} page is not displayed 

Yves: remove flash messages    ${flash_massage_state}=    Run Keyword And Ignore Error    Wait Until Page Contains Element        ${notification_area}    1s
    Log    ${flash_massage_state}
    Run Keyword If    'PASS' in ${flash_massage_state}     Remove element from HTML with JavaScript    //section[@data-qa='component notification-area']

Yves: flash message '${condition}' be shown
   Run Keyword If    '${condition}' == 'should'    Wait Until Element Is Visible    ${notification_area}    ${loading_time}
    ...    ELSE    Page Should Not Contain Element    ${notification_area}

Yves: logout on Yves as a customer
    delete all cookies
    Reload Page    

Yves: go to the 'Home' page
    Go To    ${host}

Yves: get the last placed order ID by current customer
    ${currentURL}=    Get Location        
    Run Keyword Unless    '/customer/order' in '${currentURL}'
    ...    Run Keywords   
    ...    Yves: go to the 'Home' page 
    ...    AND    Yves: go to user menu item in header:    Order History
    ...    AND    Yves: 'Order History' page is displayed
    ${lastPlacedOrder}=    Get Text    xpath=//div[contains(@data-qa,'component order-table')]//tr[1]//td[@data-content='Order Id'][1]
    Set Suite Variable    ${lastPlacedOrder}    ${lastPlacedOrder}
    [Return]    ${lastPlacedOrder}

Yves: go to relative URL:
    [Arguments]    ${url}
    ${url}=    Get URL Without Starting Slash    ${url}
    Go To    ${host}${url}

Yves: go to URL:
    [Arguments]    ${url}
    Go To    ${host}${url}

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
    Click Element with JavaScript    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'menu--lvl-1')]//li[contains(@class,'menu__item--lvl-1')]/span/*[contains(@class,'lvl-1')][1][text()='${navigation_item_level2}']
    Wait For Document Ready    

Yves: go to first navigation item level:
    [Arguments]     ${navigation_item_level1}
    Wait Until Element Is Visible    xpath=//div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']
    Click Element with JavaScript    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']
    Wait For Document Ready  

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
    Click Element with JavaScript    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'menu--lvl-2')]//li[contains(@class,'menu__item--lvl-2')]/span/*[contains(@class,'lvl-2')][1][text()='${navigation_item_level3}']
    Wait For Document Ready 