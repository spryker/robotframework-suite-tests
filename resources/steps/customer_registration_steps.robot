*** Settings ***
Resource    ../Common/Common.robot
Resource    ../Steps/Quick_Order_steps.robot
Resource    ../Pages/Yves/Yves_Customer_Account_page.robot
Resource    ../../Resources/Common/Common.robot
Resource    ../Pages/Yves/Yves_Customer_Registration_page.robot
Resource    ../Steps/Customer_Account_steps.robot

*** Keywords ***
Register a new customer with data:
    [Documentation]    Possible argument names: e-mail, salutation, first name, last name, password
    [Arguments]    @{args}
    ${registrationData}=    Set Up Keyword Arguments    @{args}
    Yves: go to user menu item in header:    Sign Up
        
    Wait Until Element Is Visible    ${registration_page_title}
    FOR    ${key}    ${value}    IN    &{registrationData}
        Log    Key is '${key}' and value is '${value}'.
        Run keyword if    '${key}'=='first name'    Type Text    ${registration_first_name_field}    ${value}
        Run keyword if    '${key}'=='last name'    Type Text    ${registration_last_name_field}    ${value}
        Run keyword if    '${key}'=='e-mail'    Type Text    ${registration_email_field}     ${value}
        Run keyword if    '${key}'=='password'    Run keywords    
        ...    Type Text    ${registration_password_field}     ${value}   AND
        ...    Type Text    ${registration_password_confirmation_field}     ${value}
#        Run keyword if    '${key}'=='salutation'    Type Text    ${checkout_shipping_address_company_name_field}     ${company}
    END
    Click Element by id with JavaScript    registerForm_accept_terms
    Click    ${registration_submit_button}
    