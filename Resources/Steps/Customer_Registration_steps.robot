*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Resource    ../Steps/Quick_Order_steps.robot
Resource    ../Pages/Yves/Yves_Customer_Account_page.robot
Resource    ../../Resources/Common/Common.robot
Resource    ../Pages/Yves/Yves_Customer_Registration_page.robot

*** Keywords ***
Register a new customer with data:
    [Documentation]    Possible argument names: e-mail, salutation, first name, last name, password
    [Arguments]    @{args}
    ${registrationData}=    Set Up Keyword Arguments    @{args}
    Yves: go to user menu item in header:    Sign Up
    Wait For Document Ready    
    Wait Until Element Is Visible    ${registration_page_title}
    FOR    ${key}    ${value}    IN    &{registrationData}
        Log    Key is '${key}' and value is '${value}'.
        Run keyword if    '${key}'=='first name'    Input text into field    ${registration_first_name_field}    ${value}
        Run keyword if    '${key}'=='last name'    Input text into field    ${registration_last_name_field}    ${value}
        Run keyword if    '${key}'=='e-mail'    Input text into field    ${registration_email_field}     ${value}
        Run keyword if    '${key}'=='password'    Run keywords    
        ...    Input text into field    ${registration_password_field}     ${value}   AND
        ...    Input text into field    ${registration_password_confirmation_field}     ${value}
#        Run keyword if    '${key}'=='salutation'    Input text into field    ${checkout_shipping_address_company_name_field}     ${company}
    END
    Click Element by id with JavaScript    registerForm_accept_terms
    Scroll and Click Element    ${registration_submit_button}
    Wait For Document Ready