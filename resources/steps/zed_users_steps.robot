*** Settings ***
Resource    ../pages/zed/zed_delete_user_confirmation_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_create_zed_user_page.robot

*** Keywords ***
Zed: delete Zed user with the following email:
    [Arguments]    ${zed_email}
    ${currentURL}=    Get Location
    IF    '/user' not in '${currentURL}'    Zed: go to second navigation item level:    Users    Users
    Zed: click Action Button in a table for row that contains:    ${zed_email}    Delete

    Wait Until Page Contains Element    ${zed_confirm_delete_user_button}
    Click    ${zed_confirm_delete_user_button}

Zed: add a new user detatils:
    [Arguments]     ${user_name}    ${password}    ${confirm_password}    ${name}    ${last_name}
    Type Text    ${zed_user_email_field}   ${user_name}
    Type Text    ${zed_user_password_filed}    ${password}
    Type Text    ${zed_user_repeat_password_field}   ${confirm_password}
    Type Text    ${zed_user_first_name_field}    ${name}
    Type Text    ${zed_user_last_name_field}    ${last_name}
    Zed: Check checkbox by Label:    Root group
    Select From List By Label    ${zed_user_interface_language}    en_US
    Zed: submit the form

Zed: Add role name:
    [Arguments]    ${name}
     Type Text    ${zed_user_role_name}      ${name}

Zed: add new group:
     [Arguments]    ${Group_name}
    Type Text   ${zed_user_group_title}      ${Group_name}
     Type Text     ${zed_user_group_assigned_role_textbox}      role${random}
     Keyboard Key    Press    Enter
     Zed: submit the form
Zed: edit user Details
    Click    ${zed_user_edit_button} 

Zed: deactivate user
    Click    ${zed_user_deactivate_button}