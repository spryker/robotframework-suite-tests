*** Settings ***
Resource    ../Pages/Zed/Zed_Delete_User_Confirmation_page.robot
Resource    ../Common/Common_Zed.robot
Resource    ../Common/Common.robot

*** Keywords ***
Zed: delete Zed user with the following email:
    [Arguments]    ${zed_email}
    Zed: login on Zed with provided credentials:    admin@spryker.com       
    Run Keyword Unless    '/user' in '${zed_url}'    Zed: go to second navigation item level:    Users    Users
    Zed: click Action Button in a table for row that contains:    ${zed_email}    Delete
    Wait For Document Ready    
    Wait Until Page Contains Element    ${zed_confirm_delete_user_button}
    Click Element    ${zed_confirm_delete_user_button}
    Wait For Document Ready    
