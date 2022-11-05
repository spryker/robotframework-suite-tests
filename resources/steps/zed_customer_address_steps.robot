*** Settings ***
Resource    ../common/common.robot
Resource    ../../resources/common/common.robot
Resource    ../../resources/common/common_zed.robot
Resource    ../../resources/pages/zed/zed_customer_page.robot

*** Keywords **    
Zed: go to customer new address creation page through view mode:
    [Arguments]    ${customer_email}
    Zed: perform search by:     ${customer_email} 
    Click    ${zed_customer_view_button} 
    Zed: click button in Header:    Add new Address 
     
Zed: add new address details:
      [Arguments]    @{args}
    ${registrationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{registrationData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='customer_first_name'    Type Text    ${zed_customer_first_name}    ${value}
        IF    '${key}'=='customer_last_name'    Type Text    ${zed_customer_last_name}    ${value}
        IF    '${key}'=='address line 1'    Type Text    ${zed_customer_address_line_1}    ${value}
        IF    '${key}'=='address line 2'    Type Text    ${zed_customer_address_line_2}    ${value}
        IF    '${key}'=='customer_zipcode'    Type Text    ${zed_customer_zipcode}    ${value}
        IF    '${key}'=='customer_city'    Type Text    ${zed_customer_city}     ${value}
        IF    '${key}'=='customer_phone'    Type Text    ${zed_customer_phone}     ${value}
    END
    Select From List By Label    ${zed_customer_salutation}    Mr
    Select From List By Label    ${zed_customer_country}    Norway
    Click    ${zed_customer_save_button}

Zed: edit customer address by selecting address from billing address dropdown:
    [Arguments]    ${address_label}
    Zed: click button in Header:     Edit Customer 
    Select From List By Label    ${zed_customer_billing_address}    ${address_label}  
    Zed: submit the form
    Zed: message should be shown:    Customer was updated successfully.