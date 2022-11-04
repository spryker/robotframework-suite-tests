*** Settings ***
Resource    ../pages/zed/zed_delete_user_confirmation_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_create_zed_user_page.robot
Resource    ../pages/zed/zed_user_role_page.robot
Resource    ../pages/zed/zed_user_group_page.robot
Resource    ../pages/zed/zed_catalog_attributes_page.robot

*** Keywords ***
Zed: delete Zed user with the following email:
    [Arguments]    ${zed_email}
    ${currentURL}=    Get Location
    IF    '/user' not in '${currentURL}'    Zed: go to second navigation item level:    Users    Users
    Zed: click Action Button in a table for row that contains:    ${zed_email}    Delete

    Wait Until Page Contains Element    ${zed_confirm_delete_user_button}
    Click    ${zed_confirm_delete_user_button}

Zed: create new role with name:
    [Arguments]    ${name}    ${full_access}=*
    Zed: go to second navigation item level:    Users    User Roles
    Zed: click button in Header:    Add new Role
    Type Text    ${zed_user_role_name}      ${name}
    Zed: submit the form
    Zed: message should be shown:    success    Role "${name}" successfully added.
    Type Text    ${zed_user_role_bundle_locator}     ${full_access}
    Type Text    ${zed_user_role_controller_locator}    ${full_access}
    Type Text    ${zed_user_role_action_locator}    ${full_access}
    Click    ${zed_add_rule_button}
    
Zed: apply restrictions for user role:
    [Arguments]    ${bundle_access}    ${controller_access}    ${action_access}    ${permission}
    Type Text    ${zed_user_role_bundle_locator}     ${bundle_access}
    Type Text    ${zed_user_role_controller_locator}    ${controller_access}
    Type Text    ${zed_user_role_action_locator}    ${action_access}
    Select From List By Label    ${zed_user_role_permission}    ${permission}
    Click    ${zed_add_rule_button}
    

Zed: create new group with role assigned:
    [Arguments]    ${Group_name}    ${role_name}
    Zed: go to second navigation item level:    Users    User Groups
    Zed: click button in Header:    Create Group
    Type Text   ${zed_user_group_title}      ${Group_name}
    Type Text     ${zed_user_group_assigned_role_textbox}      ${role_name}
    Keyboard Key    Press    Enter
    Zed: submit the form   
    Zed: message should be shown:    success    Group was created successfully. 

Zed: validate the message when permission is restricted:
    [Arguments]    ${message}
    Element Text Should Be    ${attribute_access_denied_header}    ${message}   

Zed: deactivate the created user:
    [Arguments]    ${email}
    Zed: go to second navigation item level:    Users    Users
    Zed: click Action Button in a table for row that contains:    ${email}    Deactivate
    Zed: message should be shown:    success   User was deactivated successfully.

Zed: add the created group to created user:
    [Arguments]    ${Group_name}
    Zed: go to second navigation item level:    Users    Users
    Zed: click Action Button in a table for row that contains:    abc${random}@gmail.com    Edit
    Zed: Check checkbox by Label:    ${Group_name}
    Zed: Uncheck Checkbox by Label:    Root group
    Zed: submit the form
    Zed: message should be shown:    success    User was updated successfully.

Zed: login with deactivated user:
    [Arguments]    ${email}    ${password}
    Zed: login on Zed with provided credentials:    ${email}    ${password}
    Zed: message should be shown:    fail   Authentication failed! 