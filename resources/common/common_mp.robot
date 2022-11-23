*** Settings ***
Library    BuiltIn
Resource    common.robot
Resource    ../pages/mp/mp_login_page.robot

*** Variable ***
${mp_user_menu_button}    xpath=//button[contains(@class,'spy-user-menu__action')]
${mp_navigation_slider_menu}    xpath=//spy-navigation
${mp_submit_button}    xpath=//button[@type='submit']
${mp_items_table}    xpath=//nz-table-inner-default//table
${mp_search_box}    xpath=//spy-table//input[contains(@placeholder,'Search')]
${mp_close_drawer_button}    xpath=//button[contains(@class,'spy-drawer-wrapper__action--close')]
${spinner_loader}    xpath=//span[contains(@class,'ant-spin-dot')]

*** Keywords ***
MP: login on MP with provided credentials:
    [Arguments]    ${email}    ${password}=${default_password}
    go to    ${mp_url}
    delete all cookies
    Reload
    Wait Until Element Is Visible    ${mp_user_name_field}
    Type Text    ${mp_user_name_field}    ${email}
    Type Text    ${mp_password_field}    ${password}
    Click    ${mp_login_button}
    Wait Until Element Is Visible    ${mp_user_menu_button}    MP: user menu is not displayed

MP: login on MP with provided credentials and expect error:
    [Arguments]    ${email}    ${password}=${default_password}
    go to    ${mp_url}
    delete all cookies
    Reload
    Wait Until Element Is Visible    ${mp_user_name_field}
    Type Text    ${mp_user_name_field}    ${email}
    Type Text    ${mp_password_field}    ${password}
    Click    ${mp_login_button}
    Wait Until Element Is Visible    ${mp_login_failed_message}
    Page Should Not Contain Element    ${mp_user_menu_button}

MP: open navigation menu tab:
    [Arguments]    ${tabName}
    Wait Until Element Is Visible    ${mp_navigation_slider_menu}
    Click Element by xpath with JavaScript    xpath=//spy-navigation//span[contains(@class,'spy-navigation__title-text')][text()='${tabName}']
    Wait Until Element Is Visible    //div[@class='mp-layout-main-cnt__main']//span[contains(@class,'headline__title')]//*[text()='${tabName}']

MP: click submit button
    Wait Until Element Is Visible    ${mp_submit_button}
    Click    ${mp_submit_button}

MP: perform search by:
    [Arguments]    ${searchKey}
    Type Text    ${mp_search_box}    ${searchKey}
    Wait Until Element Is Visible    ${spinner_loader}
    Wait Until Element Is Not Visible    ${spinner_loader}
    Wait Until Element Is Enabled    ${mp_items_table}

MP: click on a table row that contains:
    [Arguments]    ${rowContent}
    Wait Until Element Is Visible    xpath=//div[@class='spy-table-column-text'][contains(text(),'${rowContent}')]/ancestor::tr[contains(@class,'ant-table-row')] 
    Click    xpath=//div[@class='spy-table-column-text'][contains(text(),'${rowContent}')]/ancestor::tr[contains(@class,'ant-table-row')]

MP: close drawer
    Wait Until Element Is Visible    ${mp_close_drawer_button}
    Click    ${mp_close_drawer_button}
    Wait Until Element Is Visible    ${mp_items_table}
   
MP: click on create new entity button:
    [Arguments]        ${buttonName}
    Wait Until Element Is Visible    xpath=//spy-headline//*[contains(text(),'${buttonName}')]
    Click    xpath=//spy-headline//*[contains(text(),'${buttonName}')]
    Wait Until Element Is Not Visible    ${mp_items_table}
    Wait Until Element Is Visible    ${mp_items_table}

MP: select option in expanded dropdown:
    [Arguments]    ${optionName}
    Wait Until Element Is Visible    xpath=//nz-option-container[contains(@class,'ant-select-dropdown')]//span[contains(text(),'${optionName}')]
    Click    xpath=//nz-option-container[contains(@class,'ant-select-dropdown')]//span[contains(text(),'${optionName}')]

    

    