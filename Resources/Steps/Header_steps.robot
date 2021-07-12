*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Library    String
Library    BuiltIn
Library    Collections
Resource    ../Pages/Yves/Yves_Header_section.robot
Resource    ../Pages/Yves/Yves_Catalog_page.robot
Resource    ../Steps/Request_for_Quote_steps.robot
Resource    ../Steps/Shopping_Carts_steps.robot
Resource    ../Steps/Shopping_Lists_steps.robot
Resource    ../Steps/Quick_Order_steps.robot
Resource    ../Steps/Request_for_Quote_steps.robot

*** Variable ***
${priceModeSwitcher}    ${price_mode_switcher_header_menu_item}
${currencySwitcher}    ${currency_switcher_header_menu_item}
${languageSwitcher}    ${language_switcher_header_menu_item}
${quickOrderIcon}    ${quick_order_icon_header_menu_item}
${accountIcon}    ${user_navigation_icon_header_menu_item}[${env}]
${shoppingListIcon}    ${shopping_list_icon_header_menu_item}
${shoppingCartIcon}    ${shopping_car_icon_header_menu_item}[${env}]
${customerSearchWidget}    ${agent_customer_search_widget}  
${quoteRequestsWidget}    ${agent_quote_requests_header_item}
${wishlistIcon}    ${wishlist_icon_header_navigation_widget}

*** Keywords ***   
Yves: perform search by:
    [Arguments]    ${searchTerm}
    Run keyword if    '${env}'=='b2c'    Click Element    xpath=//div[@class='header__search-open js-suggest-search__show']
    wait until element is visible    ${search_form_header_menu_item}
    Input text into field    ${search_form_header_menu_item}    ${searchTerm}
    Press Keys    None    RETURN
    Wait Until Page Contains Element    ${catalog_main_page_locator}[${env}]

Yves: go to company menu item:
    [Arguments]    ${company_menu_item}
    wait until element is visible  ${company_name_icon_header_menu_item}
    mouse over  ${company_name_icon_header_menu_item}
    element should be enabled    ${company_account_navigation_fly_out_header_menu_item}
    Scroll and Click Element    //div[@class='header__top']//a[contains(@class,'navigation-top__company')]/..//nav[contains(@class,'navigation-list')]/ul//a[text()='${company_menu_item}']
    Wait For Document Ready  

Yves: company menu '${condition}' be available for logged in user
    Run Keyword If    '${condition}' == 'should'   
    ...    Run Keywords
    ...    wait until element is visible  ${company_name_icon_header_menu_item}
    ...    AND    mouse over  ${company_name_icon_header_menu_item}
    ...    AND    element should be enabled    ${company_account_navigation_fly_out_header_menu_item}
    ...    ELSE    Page Should Not Contain Element    ${company_name_icon_header_menu_item}

Yves: header contains/doesn't contain: 
    [Arguments]    ${condition}    @{header_elements_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${header_elements_list_count}=   get length  ${header_elements_list}
    FOR    ${index}    IN RANGE    0    ${header_elements_list_count}
        ${header_element_to_check}=    Get From List    ${header_elements_list}    ${index}
        Run Keyword If    '${condition}' == 'true'    
        ...    Run Keywords
        ...    Log    ${header_element_to_check}    #Left as an example of multiple actions in Condition
        ...    AND    Page Should Contain Element    ${header_element_to_check}    message=${header_element_to_check} is not displayed
        Run Keyword If    '${condition}' == 'false'    
        ...    Run Keywords
        ...    Log    ${header_element_to_check}    #Left as an example of multiple actions in Condition
        ...    AND    Page Should Not Contain Element    ${header_element_to_check}    message=${header_element_to_check} should not be displayed
    END

Yves: go to '${pageName}' page through the header   
    Run Keyword If    '${pageName}' == 'Shopping Lists'    Go to 'Shopping Lists' page
    ...    ELSE IF    '${pageName}' == 'Shopping Carts'    Go to 'Shopping Carts' page  
    ...    ELSE IF    '${pageName}' == 'Quick Order'    Go to 'Quick Order' page
    ...    ELSE IF    '${pageName}' == 'Quote Requests'    Go to 'Quote Requests' page
    ...    ELSE IF    '${pageName}' == 'Wishlist'    Go to 'Wishlist' page

Yves: go to user menu item in header:
    [Arguments]    ${user_menu_item}
    wait until element is visible  ${user_navigation_icon_header_menu_item}[${env}]
    mouse over  ${user_navigation_icon_header_menu_item}[${env}]
    Wait Until Element Is Visible    ${user_navigation_fly_out_header_menu_item}[${env}]
    Run keyword if    '${env}'=='b2b'    Scroll and Click Element    //li[contains(@class,'user-navigation__item--user')]//nav[contains(@class,'user-navigation__sub-nav')]//ul[contains(@class,'list--secondary')]//a[text()='${user_menu_item}']
    ...    ELSE    Scroll and Click Element    //a[contains(@class,'user-block') and contains(text(),'${user_menu_item}')]
    Wait For Document Ready  

Yves: move mouse over header menu item:
    [Arguments]    @{header_elements_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${header_elements_list_count}=   get length  ${header_elements_list}
    FOR    ${index}    IN RANGE    0    ${header_elements_list_count}
        ${header_element_to_check}=    Get From List    ${header_elements_list}    ${index}
        Mouse Over    ${header_element_to_check}
        Sleep    1s
    END

Yves: '${headerItem}' widget is shown
    Run Keyword If    '${headerItem}' == 'Quote Requests'    
    ...    Run Keywords
    ...    Wait Until Element Is Visible    ${agent_quote_requests_widget}    
    ...    AND    Page Should Contain Element    ${agent_quote_requests_widget}