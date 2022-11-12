*** Settings ***
Resource    ../common/common.robot
Resource    ../steps/quick_order_steps.robot
Resource    ../pages/yves/yves_customer_account_page.robot
Resource    ../../resources/common/common.robot
Resource    ../pages/yves/yves_customer_registration_page.robot
Resource    ../steps/customer_account_steps.robot

*** Keywords ***
Yves: register a new customer with data:
    [Documentation]    Possible argument names: e-mail, salutation, first name, last name, password
    [Arguments]    @{args}
    ${registrationData}=    Set Up Keyword Arguments    @{args}
    Yves: go to user menu item in header:    Sign Up
    FOR    ${key}    ${value}    IN    &{registrationData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='first name'    Type Text    ${registration_first_name_field}    ${value}
        IF    '${key}'=='last name'    Type Text    ${registration_last_name_field}    ${value}
        IF    '${key}'=='e-mail'    Type Text    ${registration_email_field}     ${value}
        IF    '${key}'=='password'    Run keywords
            Type Text    ${registration_password_field}     ${value}
            Type Text    ${registration_password_confirmation_field}     ${value}
#        Run keyword if    '${key}'=='salutation'    Type Text    ${checkout_shipping_address_company_name_field}     ${company}
    END
    Click Element by id with JavaScript    registerForm_accept_terms
    Click    ${registration_submit_button}

Yves: validate the newly created user:
    [Arguments]    ${email}
   Save the result of a SELECT DB query to a variable:    select registration_key from spy_customer where email = '${email}'    confirmation_key
   Save the result of a SELECT DB query to a variable:    select customer_reference from spy_customer where email = '${email}'    customer_id
   I send a POST request:     /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"${confirmation_key}"}}}

Yves: restore password:
    [Arguments]    ${email}
   Save the result of a SELECT DB query to a variable:    select customer_reference from spy_customer where email = '${email}'    customer_id
   Save the result of a SELECT DB query to a variable:    select restore_password_key from spy_customer where email = '${email}'    restore_key
   I send a PATCH request:    /customer-restore-password/${customer_id}   {"data":{"type":"customer-restore-password","id":"${customer_id}","attributes":{"restorePasswordKey":"${restore_key}","password":"${yves_user_password}","confirmPassword":"${yves_user_password}"}}}