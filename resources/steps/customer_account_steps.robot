*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_yves.robot
Resource    ../steps/header_steps.robot
Resource    ../steps/quick_order_steps.robot
Resource    ../pages/yves/yves_customer_account_page.robot

*** Keywords ***
Yves: go to 'Customer Account' page
    ${lang}=    Yves: get current lang
    Yves: go to URL:    ${lang}/customer/overview

Yves: go to user menu item in the left bar:
    [Documentation]    Case sensitive, accepts: Overview, Profile, Addresses, Order History, Newsletter, Shopping lists, Shopping carts, Quote Requests
    [Arguments]    ${left_navigation_node}
    IF    '${env}' in ['b2b','mp_b2b']
        Run Keywords
            Wait Until Element Is Visible    xpath=//ul[@class='navigation-sidebar__list']//*[contains(.,'${left_navigation_node}')]/a    AND
            Click    xpath=//ul[@class='navigation-sidebar__list']//*[contains(.,'${left_navigation_node}')]/a
    ELSE IF    '${env}'=='suite-nonsplit'
        Run Keywords
            Wait Until Element Is Visible    xpath=//nav[contains(@class,'customer-navigation')]//a[contains(text(),'${left_navigation_node}')]    AND
            Click    xpath=//nav[contains(@class,'customer-navigation')]//a[contains(text(),'${left_navigation_node}')]
    ELSE
        Run Keywords
            Wait Until Element Is Visible    xpath=//a[contains(@class,'menu__link menu__link--customer-navigation') and contains(text(),'${left_navigation_node}')]    AND
            Click    xpath=//a[contains(@class,'menu__link menu__link--customer-navigation') and contains(text(),'${left_navigation_node}')]
    END

Yves: create a new customer address in profile:
    [Documentation]
    [Arguments]    ${salutation}    ${firstName}    ${lastName}    ${street}    ${houseNumber}    ${postCode}    ${city}    ${country}    ${isDefaultShipping}=True     ${isDefaultBilling}=True       ${company}=    ${phone}=    ${additionalAddress}=
    IF    '${env}'=='b2c'
        Yves: go to user menu item in header:    My Profile
    ELSE IF   '${env}' in ['b2b','mp_b2b']
        Yves: go to user menu item in header:    Profile
    END
    Yves: go to user menu item in the left bar:    Addresses
    Wait Until Element Is Visible    ${customer_account_add_new_address_button}[${env}]
    Click    ${customer_account_add_new_address_button}[${env}]
    Wait Until Element Is Visible    ${customer_account_address_form}
     Click    ${customer_account_address_salutation_dropdown_field}
     Click    xpath=//li[@class='select2-results__option' and contains(text(),'${salutation}')]
    Type Text    ${customer_account_address_first_name_field}     ${firstName}
    Type Text    ${customer_account_address_last_name_field}     ${lastName}
    Type Text    ${customer_account_address_company_name_field}     ${company}
    Type Text    ${customer_account_address_street_field}     ${street}
    Type Text    ${customer_account_address_house_number_field}     ${houseNumber}
    Type Text    ${customer_account_address_additional_address_field}     ${additionalAddress}
    Type Text    ${customer_account_address_zip_code_field}     ${postCode}
    Type Text    ${customer_account_address_city_field}     ${city}
     Click    ${customer_account_address_country_drop_down_field}
     Click    xpath=//li[contains(@class,'select2-results__option') and contains(text(),'${country}')]
    Type Text    ${customer_account_address_phone_field}     ${phone}
#    Run keyword if    '${isDefaultShipping}'=='True'    Add/Edit element attribute with JavaScript:    ${customer_account_address_is_default_shipping_checkbox}    checked    checked
#    Run keyword if    '${isDefaultBilling}'=='True'    Add/Edit element attribute with JavaScript:    ${customer_account_address_is_default_billing_checkbox}
    Click    ${customer_account_address_submit_button}


Yves: check that user has address exists/doesn't exist:
    [Arguments]    ${exists}    ${firstName}    ${lastName}    ${street}    ${houseNumber}    ${postCode}    ${city}    ${country}    ${isDefaultShipping}=True     ${isDefaultBilling}=True       ${company}=NUll    ${phone}=NUll    ${additionalAddress}=NUll
    IF    '${env}'=='b2c'
        Yves: go to user menu item in header:    My Profile
    ELSE IF     '${env}' in ['b2b','mp_b2b']
        Yves: go to user menu item in header:    Profile
    END
    Yves: go to user menu item in the left bar:    Addresses
    Wait Until Element Is Visible    ${customer_account_add_new_address_button}[${env}]
    IF    '${exists}'=='true'
        Run keywords
            Element Should Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${firstName} ${lastName}')]    AND
            Element Should Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${street} ${houseNumber}')]    AND
            Element Should Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${postCode} ${city}, ${country}')]
    ELSE
        Run keywords
            Element Should Not Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${firstName} ${lastName}')]    AND
            Element Should Not Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${street} ${houseNumber}')]    AND
            Element Should Not Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${postCode} ${city}, ${country}')]
    END

Yves: delete user address:
    [Arguments]    ${street}
    IF    '${env}'=='b2c'
        Yves: go to user menu item in header:    My Profile
    ELSE IF    '${env}' in ['b2b','mp_b2b']
        Yves: go to user menu item in header:    Profile
    END
    Yves: go to user menu item in the left bar:    Addresses
    IF    '${env}'=='b2c'
        Click    xpath=//li[contains(text(),'${street}')]/ancestor::div[@class='box']//button[contains(text(),'Delete')]
    ELSE IF    '${env}' in ['b2b','mp_b2b']
        Click    xpath=//li[contains(text(),'${street}')]/ancestor::div[@class='action-card']//button
    END
    Element Should Be Visible    xpath=//flash-message//div[contains(text(),'Address deleted successfully')]   message="Flash message didn't appear"
Yves: Change customer address:
    [Arguments]    @{args}
    
    ${registrationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{registrationData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='street'    Type Text    ${customer_account_address_street_field}    ${value}
        IF    '${key}'=='house_no'    Type Text    ${customer_account_address_house_number_field}    ${value}
         IF    '${key}'=='post_code'    Type Text    ${customer_account_address_zip_code_field}    ${value}
        IF    '${key}'=='city'    Type Text    ${customer_account_address_city_field}     ${value}
        IF    '${key}'=='phone'    Type Text    ${customer_account_address_phone_field}     ${value}
    END
    Click    ${customer_account_address_submit_button}
Yves:Edit the latest address created
     ${counter}    Get Element Count    xpath=${customer_account_address_edit_button}
    Log    ${counter}
    Click    xpath=(${customer_account_address_edit_button})[${counter}] 

Yves:clear customer address fields
    Clear Text    ${customer_account_address_street_field}
   Clear Text    ${customer_account_address_house_number_field}
   Clear Text    ${customer_account_address_zip_code_field}
   Clear Text    ${customer_account_address_city_field}
   Clear Text    ${customer_account_address_phone_field}