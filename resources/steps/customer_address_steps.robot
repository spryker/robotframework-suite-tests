*** Settings ***
Resource    ../common/common.robot
Resource    ../../resources/common/common.robot

*** Keywords ***
Yves:login:
     [Arguments]    ${user_email}    ${user_password}
    Go To    ${host}${login_page_url}
    Input Text    ${email_input_field_locator}    ${user_email}
    Input Text    ${password_input_field_locator}    ${user_password}
     Click    ${login_button_locator}
Yves:Address registration through customer profile
    [Arguments]    @{args}
     Go To    ${host}${adress}
   Click    ${add_new_address}
    ${registrationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{registrationData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='street'    Type Text    ${street}    ${value}
        IF    '${key}'=='house_no'    Type Text    ${house_no}    ${value}
         IF    '${key}'=='post_code'    Type Text    ${post_code}    ${value}
        IF    '${key}'=='city'    Type Text    ${city}     ${value}
        IF    '${key}'=='phone'    Type Text    ${phone}     ${value}
    END
    Check Checkbox    ${Is default shipping address}
    Check Checkbox    ${Is default billing address}
    Click    ${submit}

Yves: Checkout
    Hover    ${camera category}
    Click    ${digital camera}
    Click    xpath=//product-item[1]//div[1]//div[1]//a[1]
    Click    ${Add to cart}
    Go To    ${host}${checkout address}

Yves:message should be shown:
    [Documentation]    ${type} can be: error, success
    [Arguments]    ${type}    ${text}
    IF    '${type}' == 'error'
        Element Should Be Visible    xpath=//flash-message[contains(@class,'alert')]//div[contains(text(),'${text}')]
    ELSE
        IF  '${type}' == 'success'  Element Should Be Visible    xpath=//flash-message[contains(@class,'success')]//div[contains(text(),'${text}')]
    END
Yves:Address registration through checkout process
    [Arguments]    @{args}
    ${registrationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{registrationData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='shipping_first_name'    Type Text    ${shipping_first_name}    ${value}
        IF    '${key}'=='shipping_last_name'    Type Text    ${shipping_last_name}    ${value}
         IF    '${key}'=='shipping_street'    Type Text    ${shipping_street}    ${value}
        IF    '${key}'=='shipping_house_no'    Type Text    ${shipping_house_no}     ${value}
        IF    '${key}'=='shipping_city'    Type Text    ${shipping_city}     ${value}
         IF    '${key}'=='shipping_post_code'    Type Text    ${shipping_post_code}     ${value}
          IF    '${key}'=='shipping_phone'    Type Text    ${shipping_phone}     ${value}
    END
    Click    ${next}
    Click    xpath=(//span[@class='radio__box'])[1]
    Click    ${next}
    Click    ${invoice}
    Input Text    xpath=//input[@id='paymentForm_dummyPaymentInvoice_date_of_birth']    05.07.1993
    Click    ${Go to Summary}
    Check Checkbox    ${accept term checkbox}
    Click    ${submit your order}
Yves:change address:
    [Arguments]    @{args}
    
    ${registrationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{registrationData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='street'    Type Text    ${street}    ${value}
        IF    '${key}'=='house_no'    Type Text    ${house_no}    ${value}
         IF    '${key}'=='post_code'    Type Text    ${post_code}    ${value}
        IF    '${key}'=='city'    Type Text    ${city}     ${value}
        IF    '${key}'=='phone'    Type Text    ${phone}     ${value}
    END
    Click    ${submit}
Yves:clear text in address
   
   Clear Text    ${house_no}
   Clear Text    ${post_code}
   Clear Text    ${city}
   Clear Text    ${phone}

Yves: logout
   Hover    xpath=//a[@class='navigation-top__link js-navigation-top__trigger']//*[name()='svg']
   Click    xpath=//a[@class='user-block-item user-block-item--small']
   
Yves: delete address
    ${counter}    Get Element Count    xpath=//button[contains(text(),'Delete')]
    Log    ${counter}
    Click    xpath=(//button[contains(text(),'Delete')])[${counter}]
Yves:click edit
    ${counter}    Get Element Count    xpath=//a[contains(text(),'Edit')]
    Log    ${counter}
    Click    xpath=(//a[contains(text(),'Edit')])[${counter}] 

Yves: navigate to address section
    Hover    xpath=//a[@class='navigation-top__link js-navigation-top__trigger']//*[name()='svg']
   Click    xpath=//a[@class='user-block-item'][normalize-space()='Overview']
   Go To    http://yves.de.spryker.local/en/customer/address

Yves: address navigation
     Go To    ${host}${adress}  