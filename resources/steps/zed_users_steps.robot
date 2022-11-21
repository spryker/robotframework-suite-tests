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

Zed: create new role with name:
    [Documentation]    Create a new role with full access.
    [Arguments]    ${name}
    Zed: go to second navigation item level:    Users    User Roles
    Zed: click button in Header:    Add new Role
    Type Text    ${zed_user_role_name}      ${name}
    Zed: submit the form
    Zed: message should be shown:    success    Role "${name}" successfully added.
    Zed: apply restrictions for user role:    ${full_access}    ${full_access}    ${full_access}   ${permission_allow}
    
Zed: apply restrictions for user role:
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
    Zed: message should be shown:    success    Group was created successfully. 

Zed: validate the message when permission is restricted:
    [Arguments]    ${message}
    Element Text Should Be    ${zed_attribute_access_denied_header}    ${message}   

Zed: deactivate the created user:
    [Arguments]    ${email}
    Zed: go to second navigation item level:    Users    Users
    Zed: click Action Button in a table for row that contains:    ${email}    Deactivate
    Zed: message should be shown:    success   User was deactivated successfully.

Zed: add the created group to created user:
    [Arguments]    ${user_email}    ${group_name}
    Zed: go to second navigation item level:    Users    Users
    Zed: click Action Button in a table for row that contains:    ${user_email}    Edit
    Zed: Check checkbox by Label:    ${group_name}
    Zed: Uncheck Checkbox by Label:    Root group
    Zed: submit the form
    Zed: message should be shown:    success    User was updated successfully.

Zed: login with deactivated user:
    [Arguments]    ${email}    ${password}
    Zed: login on Zed with provided credentials:    ${email}    ${password}
    Zed: message should be shown:    fail   Authentication failed! 