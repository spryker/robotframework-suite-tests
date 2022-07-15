*** Settings ***
Library    BuiltIn
Resource                  common.robot
Resource                  ../pages/mp/mp_login_page.robot

*** Variable ***
${mp_user_menu_button}    xpath=//button[contains(@class,'spy-user-menu__action')]

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
