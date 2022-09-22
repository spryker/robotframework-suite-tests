*** Settings ***
Resource    ../common/common.robot
Resource    ../../resources/common/common.robot
Resource    ../../resources/pages/zed/zed_login_page.robot

*** Keywords ***
Zed:login:
     [Arguments]    ${user_email}    ${user_password}
    Go To    ${host_zed}${login_url}
    Input Text    ${zed_user_name_field}    ${user_email}
    Input Text    ${zed_password_field}    ${user_password}
     Click    ${zed_login_button}
     
Zed:customer address navigation
    Click    xpath=//li[4]//a[1]//span[2]
     Click    xpath=//a[@href='/customer']//span[@class='nav-label'][normalize-space()='Customers']
     Go To    http://backoffice.de.spryker.local/customer/view?id-customer=4
     Click    xpath=//a[normalize-space()='Add new Address']   
Zed:New address registraton:
      [Arguments]    @{args}
    ${registrationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{registrationData}
        Log    Key is '${key}' and value is '${value}'.
         IF    '${key}'=='customer_first_name'    Type Text    ${customer_first_name}    ${value}
        IF    '${key}'=='customer_last_name'    Type Text    ${customer_last_name}    ${value}
        IF    '${key}'=='address line 1'    Type Text    ${address line 1}    ${value}
        IF    '${key}'=='address line 2'    Type Text    ${address line 2}    ${value}
         IF    '${key}'=='customer_zipcode'    Type Text    ${customer_zipcode}    ${value}
        IF    '${key}'=='customer_city'    Type Text    ${customer_city}     ${value}
        IF    '${key}'=='customer_phone'    Type Text    ${customer_phone}     ${value}
    END
    Select From List By Label    ${salutation}    Mr
    Select From List By Label    ${country}    Norway
    Click    ${save}
Zed:Edit customer address:
    Click    xpath=//li[4]//a[1]//span[2]
     Click    xpath=//a[@href='/customer']//span[@class='nav-label'][normalize-space()='Customers']
     Click    xpath=//tbody/tr[4]/td[7]/a[2]
     Select From List By Label    ${billing address}   Bill Martin (Vrhloga, 1000 Ljubljana)
     Click    ${save}
Zed:message should be shown:
    [Documentation]    ${type} can be: error, success
    [Arguments]    ${type}    ${text}
    IF    '${type}' == 'error'
        Element Should Be Visible    xpath=//div[contains(@class,'alert')]//div[contains(text(),'${text}')]
    ELSE
        IF  '${type}' == 'success'  Element Should Be Visible    xpath=//div[contains(@class,'success')]//div[contains(text(),'${text}')]
    END