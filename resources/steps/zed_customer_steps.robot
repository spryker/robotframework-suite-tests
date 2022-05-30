*** Settings ***
Resource    ../pages/zed/zed_customer_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Keywords ***
Zed: delete customer:
    [Documentation]    Possible argument names: email
        [Arguments]    @{args}
        Zed: login on Zed with provided credentials:    ${zed_admin_email}
        ${registrationData}=    Set Up Keyword Arguments    @{args}
        ${currentURL}=    Get Location
        IF    '/customer' not in '${currentURL}'    Zed: go to second navigation item level:    Customers    Customers
        FOR    ${key}    ${value}    IN    &{registrationData}
            Log    Key is '${key}' and value is '${value}'.
            Zed: perform search by:    ${value}
            ${customerExists}=    Run Keyword And Return Status    Element Text Should Be    xpath=//tbody//td[contains(@class,' column-email') and contains(text(),'${value}')]     ${value}
            IF    '${customerExists}'=='True'
                Run keywords
                    Zed: click Action Button in a table for row that contains:    ${value}    Edit
                    Wait Until Element Is Visible    ${zed_customer_edit_page_title}
                    Click    ${zed_customer_delete_button}
                    Wait Until Element Is Visible     ${zed_customer_delete_confirm_button}
                    Click    ${zed_customer_delete_confirm_button}
                    Zed: message should be shown:    Customer successfully deleted
            END
        END
