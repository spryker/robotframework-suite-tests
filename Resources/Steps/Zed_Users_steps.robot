*** Settings ***
Resource    ../Pages/Zed/Zed_Delete_User_Confirmation_page.robot
Resource    ../Common/Common_Zed.robot
Resource    ../Common/Common.robot

*** Keywords ***
Zed: delete Zed user with the following email:
    [Arguments]    ${zed_email}
    ${currentURL}=    Get Location        
    Run Keyword Unless    '/user' in '${currentURL}'    Zed: go to second navigation item level:    Users    Users
    Zed: click Action Button in a table for row that contains:    ${zed_email}    Delete
        
    Wait Until Page Contains Element    ${zed_confirm_delete_user_button}
    Click    ${zed_confirm_delete_user_button}
    

