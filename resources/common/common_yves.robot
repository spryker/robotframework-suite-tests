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
            ${currentURL}=    Get Location
                IF    '.at.' in '${currentURL}'
                    Go To    ${host_at}
                    delete all cookies
                    Reload
                    Wait Until Element Is Visible    ${header_login_button}[${env}]
                    Click    ${header_login_button}[${env}]
                    Wait Until Element Is Visible    ${email_field}
                ELSE
                    Go To    ${host}
                    delete all cookies
                    Reload
                    Wait Until Element Is Visible    ${header_login_button}[${env}]
                    Click    ${header_login_button}[${env}]
                    Wait Until Element Is Visible    ${email_field}
                END
        ELSE
                ${currentURL}=    Get Location
                    IF    '.at.' in '${currentURL}'
                        Go To    ${host_at}
                        delete all cookies
                        Reload
                        mouse over  ${user_navigation_icon_header_menu_item}[${env}]
                        Wait Until Element Is Visible    ${user_navigation_menu_login_button}
                        Click    ${user_navigation_menu_login_button}
                        Wait Until Element Is Visible    ${email_field}
                    ELSE
                        Go To    ${host}
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
    ${currentURL}=    Get Location
    IF    '.at.' in '${currentURL}'
        Go To    ${host_at}
    ELSE
        Go To    ${host}
    END

