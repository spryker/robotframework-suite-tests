*** Settings ***
Resource    ../pages/zed/zed_delete_user_confirmation_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Keywords ***
Zed: delete Zed user with the following email:
    [Arguments]    ${zed_email}
    ${currentURL}=    Get Location
    IF    '/user' not in '${currentURL}'    Zed: go to second navigation item level:    Users    Users
    Zed: click Action Button in a table for row that contains:    ${zed_email}    Delete
    Wait Until Page Contains Element    ${zed_confirm_delete_user_button}
    Click    ${zed_confirm_delete_user_button}

Zed: update Zed user:
    [Arguments]    @{args}
    ${newUserData}=    Set Up Keyword Arguments    @{args}
    ${currentURL}=    Get Location
    IF    '/user' not in '${currentURL}'    Zed: go to second navigation item level:    Users    Users
    Zed: click Action Button in a table for row that contains:    ${oldEmail}    Edit
    Wait Until Element Is Visible    ${zed_user_email_field}
    FOR    ${key}    ${value}    IN    &{newUserData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='newEmail' and '${value}' != '${EMPTY}'    Type Text    ${zed_user_email_field}    ${value}
        IF    '${key}'=='password' and '${value}' != '${EMPTY}'
            Type Text    ${zed_user_password_filed}    ${value}
            Type Text    ${zed_user_repeat_password_field}    ${value}
        END
        IF    '${key}'=='firstName' and '${value}' != '${EMPTY}'    Type Text    ${zed_user_first_name_field}    ${value}
        IF    '${key}'=='lastName' and '${value}' != '${EMPTY}'    Type Text    ${zed_user_last_name_field}    ${value}
    END
    Zed: submit the form

