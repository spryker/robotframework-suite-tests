*** Settings ***
Resource    ../pages/zed/zed_customer_page.robot
Resource    ../pages/zed/zed_add_customer_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Keywords ***
Zed: add customer:
    [Arguments]    ${email}    ${salutation}    ${first_name}    ${last_name}    ${gender}    ${locale}    ${dob}    ${phone}    ${company}
    Type Text    ${customer_email}    ${email}
    Select From List By Label    ${customer_salutation}    ${salutation}
    Type Text    ${customer_first_name}    ${first_name}
    Type Text    ${customer_last_name}    ${last_name}
    Select From List By Label    ${customer_gender}    ${gender}
    Select From List By Label    ${customer_locale}    ${locale}
    Type Text    ${customer_dob}    ${dob}
    Type Text    ${customer_phone}    ${phone}
    Type Text    ${customer_company}    ${company}
    Zed: Check checkbox by Label:    Send password token through email
    Zed: submit the form

Zed: edit customer details:
    [Arguments]    @{args}    
    ${editData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{editData}
        Log    Key is '${key}' and value is '${value}'.
    IF    '${key}'=='salutation'    Select From List By Label    ${customer_salutation}    ${value}
    IF    '${key}'=='first name'    Type Text    ${customer_first_name}    ${value}
    IF    '${key}'=='last name'    Type Text    ${customer_last_name}    ${value}
    IF    '${key}'=='gender'    Select From List By Label    ${customer_gender}    ${value}
    IF    '${key}'=='locale'    Select From List By Label    ${customer_locale}    ${value}
    IF    '${key}'=='date of birth'    Type Text    ${customer_dob}    ${value}
    IF    '${key}'=='phone'    Type Text    ${customer_phone}    ${value}
    IF    '${key}'=='company'    Type Text    ${customer_company}    ${value}
    END
    Zed: submit the form