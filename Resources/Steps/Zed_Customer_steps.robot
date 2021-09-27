*** Settings ***
Resource    ../Pages/Zed/Zed_Customer_page.robot
Resource    ../Common/Common_Zed.robot
Resource    ../Common/Common.robot

*** Keywords ***
Zed: delete customer:
    [Documentation]    Possible argument names: email
        [Arguments]    @{args}
        Zed: login on Zed with provided credentials:    ${zed_admin_email}    
        ${registrationData}=    Set Up Keyword Arguments    @{args}
        ${currentURL}=    Get Location        
        Run Keyword Unless    '/customer' in '${currentURL}'    Zed: go to second navigation item level:    Customers    Customers
        
        FOR    ${key}    ${value}    IN    &{registrationData}
            Log    Key is '${key}' and value is '${value}'.
            Zed: perform search by:    ${value}
            ${customerExists}=    Run Keyword And Return Status    Element Text Should Be    xpath=//tbody//td[contains(@class,' column-email') and contains(text(),'${value}')]     ${value}
            Run Keyword If    '${customerExists}'=='True'    Run keywords
            ...    Zed: click Action Button in a table for row that contains:    ${value}    Edit    AND
            ...    Wait Until Element Is Visible    ${zed_customer_edit_page_title}    AND
            ...    Click    ${zed_customer_delete_button}    AND
            ...    Wait Until Element Is Visible     ${zed_customer_delete_confirm_button}    AND
            ...    Click    ${zed_customer_delete_confirm_button}    AND
            ...    Zed: message should be shown:    Customer successfully deleted
        END