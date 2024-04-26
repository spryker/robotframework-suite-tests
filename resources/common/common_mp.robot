*** Settings ***
Resource    common_ui.robot
Resource    ../pages/mp/mp_login_page.robot

*** Variables ***
${mp_user_menu_button}    xpath=//button[contains(@class,'spy-user-menu__action')]
${mp_navigation_slider_menu}    xpath=//spy-navigation
${mp_submit_button}    xpath=//button[@type='submit'][not(contains(text(),'Back'))]
${mp_items_table}    xpath=//nz-table-inner-default//table
${mp_search_box}    xpath=//spy-table//input[contains(@placeholder,'Search')]
${mp_close_drawer_button}    xpath=(//button[contains(@class,'spy-drawer-wrapper__action--close')])[1]
${spinner_loader}    xpath=//span[contains(@class,'ant-spin-dot')]
${mp_success_flyout}    xpath=//span[contains(@class,'alert')][contains(@class,'icon')][contains(@class,'success')]
${mp_error_flyout}    xpath=//span[contains(@class,'alert')][contains(@class,'icon')][contains(@class,'error')]
${mp_notification_wrapper}    xpath=//spy-notification-wrapper
${mp_loading_icon}    xpath=//span[contains(@class,'spin-dot') and not(ancestor::div[contains(@style,'hidden')])]

*** Keywords ***
MP: login on MP with provided credentials:
    [Arguments]    ${email}    ${password}=${default_password}
    Go To    ${mp_url}
    Delete All Cookies
    Reload
    Wait Until Element Is Visible    ${mp_user_name_field}
    Type Text    ${mp_user_name_field}    ${email}
    Type Text    ${mp_password_field}    ${password}
    Click    ${mp_login_button}
    Wait Until Element Is Visible    ${mp_user_menu_button}    MP: user menu is not displayed

MP: login on MP with provided credentials and expect error:
    [Arguments]    ${email}    ${password}=${default_password}
    Go To    ${mp_url}
    Delete All Cookies
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
    Repeat Keyword    3    Wait For Load State
    Wait Until Element Is Visible    //div[@class='mp-layout-main-cnt__main']//span[contains(@class,'headline__title')]//*[text()='${tabName}']

MP: Wait until loader is no longer visible
    ${loader_displayed}=    Run Keyword And Ignore Error    Element Should Be Visible    ${mp_loading_icon}    timeout=1s
    IF    'PASS' in ${loader_displayed}
        TRY
            Wait Until Element Is Not Visible    ${mp_loading_icon}
        EXCEPT
            Take Screenshot    EMBED    fullPage=True
            Fail    Timeout exceeded. Loader is still displayed after ${browser_timeout}
        END
    ELSE
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${mp_loading_icon}    message=Timeout exceeded. Loader is still displayed after ${browser_timeout}
    END

MP: click submit button
    [Arguments]    ${timeout}=${browser_timeout}
    Wait Until Element Is Visible    ${mp_submit_button}    timeout=${timeout}
    Click    ${mp_submit_button}
    Repeat Keyword    3    Wait For Load State

MP: perform search by:
    [Arguments]    ${searchKey}
    Wait Until Element Is Visible    ${mp_search_box}
    Clear Text    ${mp_search_box}
    Type Text    ${mp_search_box}    ${searchKey}
    Keyboard Key    press    Enter
    TRY
        Wait For Response    timeout=10s
    EXCEPT
        Log    Search event is not fired
    END
    Repeat Keyword    3    Wait For Load State
    MP: Wait until loader is no longer visible

MP: click on a table row that contains:
    [Arguments]    ${rowContent}
    Wait Until Element Is Visible    xpath=//div[@class='spy-table-column-text'][contains(text(),'${rowContent}')]/ancestor::tr[contains(@class,'ant-table-row')]
    Click    xpath=//div[@class='spy-table-column-text'][contains(text(),'${rowContent}')]/ancestor::tr[contains(@class,'ant-table-row')]
    Wait Until Page Contains Element    ${mp_close_drawer_button}
    Repeat Keyword    3    Wait For Load State
    MP: Wait until loader is no longer visible

MP: close drawer
    Wait Until Element Is Visible    ${mp_close_drawer_button}
    Click    ${mp_close_drawer_button}
    Wait Until Element Is Visible    ${mp_items_table}

MP: click on create new entity button:
    [Arguments]        ${buttonName}
    Wait Until Element Is Visible    xpath=//spy-headline//*[contains(text(),'${buttonName}')]
    Click    xpath=//spy-headline//*[contains(text(),'${buttonName}')]
    Repeat Keyword    3    Wait For Load State
    MP: Wait until loader is no longer visible

MP: select option in expanded dropdown:
    [Arguments]    ${optionName}
    Wait Until Element Is Visible    xpath=//nz-option-container[contains(@class,'ant-select-dropdown')]//span[contains(text(),'${optionName}')]
    Click    xpath=//nz-option-container[contains(@class,'ant-select-dropdown')]//span[contains(text(),'${optionName}')]
    Repeat Keyword    3    Wait For Load State
    Sleep    0.5s

MP: switch to the tab:
    [Arguments]    ${tabName}
    Wait Until Element Is Visible    xpath=//web-spy-tabs[@class='spy-tabs']//div[@role='tablist'][contains(@class,'ant-tabs')]//div[contains(text(),'${tabName}')]
    Click    xpath=//web-spy-tabs[@class='spy-tabs']//div[@role='tablist'][contains(@class,'ant-tabs')]//div[contains(text(),'${tabName}')]
    Repeat Keyword    3    Wait For Load State
    MP: Wait until loader is no longer visible

MP: remove notification wrapper
    TRY
        ${flash_massage_state}=    Page Should Contain Element    ${mp_notification_wrapper}    message=Notification wrapper message is not shown    timeout=1s
        Remove element from HTML with JavaScript    //spy-notification-wrapper
        Remove element from HTML with JavaScript    (//spy-notification-wrapper//div)[1]
    EXCEPT
        Log    Flash message is not shown
    END
