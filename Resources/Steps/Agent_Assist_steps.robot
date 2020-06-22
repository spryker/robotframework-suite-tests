*** Settings ***
Resource    ../Pages/Zed/Zed_Create_Zed_User_page.robot
Resource    ../Common/Common_Zed.robot

*** Keywords ***
Zed: create new Zed user with the following data:
    [Arguments]    ${zedUserEmail}    ${zedUserPassword}    ${zedUserFirstName}    ${zedUserLastName}    ${checkboxGroup}   ${checkboxAgent}    ${userInterfaceLanguage}
    ${currentURL}=    Get Location        
    Run Keyword Unless    '/user' in '${currentURL}'    Zed: Go to Second Navigation Item Level:    Users Control    User
    Zed: Click Button in Header    Add New User
    Wait Until Element Is Visible    ${zed_user_email_field}
    Input Text    ${zed_user_email_field}    ${zedUserEmail}
    Input Text    ${zed_user_password_filed}    ${zedUserPassword}
    Input Text    ${zed_user_repeat_password_field}    ${zedUserPassword}
    Input Text    ${zed_user_first_name_field}    ${zedUserFirstName}
    Input Text    ${zed_user_last_name_field}    ${zedUserLastName}
    Zed: Select Checkbox by Label    ${checkboxGroup}
    Zed: Select Checkbox by Label    ${checkboxAgent}
    Select From List By Label    ${zed_user_interface_language}    ${userInterfaceLanguage}
    Zed: Submit the Form
    Wait For Document Ready
    Zed: Table should contain:    ${zedUserEmail}  

Yves: perform search by customer:
    [Arguments]    ${searchQuery}
    Input Text    ${agent_customer_search_widget}    ${searchQuery}
    Wait For Testability Ready    
    Wait For Document Ready    

Yves: agent widget contains:
    [Arguments]    ${searchQuery}
    Page Should Contain Element    xpath=//ul[@data-qa='component customer-list']/li[@data-value='${searchQuery}']

Yves: login under the customer:
    [Arguments]    ${searchQuery} 
    Yves: perform search by customer:    ${searchQuery}
    Wait Until Element Is Visible    //ul[@data-qa='component customer-list']/li[@data-value='${searchQuery}']
    Click Element    xpath=//ul[@data-qa='component customer-list']/li[@data-value='${searchQuery}']
    Click Element    ${agent_confirm_login_button}
    Wait For Testability Ready    
    Wait For Document Ready 