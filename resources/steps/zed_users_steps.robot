*** Settings ***
Resource    ../pages/zed/zed_delete_user_confirmation_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_create_zed_user_page.robot
Resource    ../pages/zed/zed_user_role_page.robot
Resource    ../pages/zed/zed_user_group_page.robot

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

Zed: create new role with name:
    [Documentation]    Create a new role.
    [Arguments]    ${name}
    Zed: go to second navigation item level:    Users    User Roles
    Zed: click button in Header:    Add new Role
    Type Text    ${zed_user_role_name}      ${name}
    Zed: submit the form
    Wait Until Element Is Visible    ${zed_success_flash_message}

Zed: apply access permissions for user role:
    [Arguments]    ${zed_user_role_bundle_access}    ${zed_user_role_controller_access}    ${zed_user_role_action_access}    ${permission_access}
    Type Text    ${zed_user_role_bundle_locator}     ${zed_user_role_bundle_access}
    Type Text    ${zed_user_role_controller_locator}    ${zed_user_role_controller_access}
    Type Text    ${zed_user_role_action_locator}    ${zed_user_role_action_access}
    Select From List By Label    ${zed_user_role_permission}    ${permission_access}
    Click    ${zed_user_add_rule_button}

Zed: create new group with role assigned:
    [Arguments]    ${group_name}    ${role_name}
    Zed: go to second navigation item level:    Users    User Groups
    Zed: click button in Header:    Create Group
    Type Text   ${zed_user_group_title}      ${group_name}
    Type Text     ${zed_user_group_assigned_role_textbox}      ${role_name}
    Keyboard Key    Press    Enter
    Zed: submit the form   
    Wait Until Element Is Visible    ${zed_success_flash_message}

Zed: validate the message when permission is restricted:
    [Arguments]    ${message}
    Element Text Should Be    ${zed_attribute_access_denied_header}    ${message}   

Zed: deactivate the created user:
    [Arguments]    ${email}
    Zed: go to second navigation item level:    Users    Users
    Zed: click Action Button in a table for row that contains:    ${email}    Deactivate
    Wait Until Element Is Visible    ${zed_success_flash_message}