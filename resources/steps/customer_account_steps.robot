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
    IF    '${env}' in ['b2c','mp_b2c']
        Yves: go to user menu item in header:    My Profile
    ELSE IF   '${env}' in ['b2b','mp_b2b']
        Yves: go to user menu item in header:    Profile
    END
    Yves: go to user menu item in the left bar:    Addresses
    Wait Until Element Is Visible    ${customer_account_add_new_address_button}[${env}]
    Click    ${customer_account_add_new_address_button}[${env}]
    Wait Until Element Is Visible    ${customer_account_address_form}
    Type Text    ${customer_account_address_first_name_field}     ${firstName}
    Type Text    ${customer_account_address_last_name_field}     ${lastName}
    Type Text    ${customer_account_address_company_name_field}     ${company}
    Type Text    ${customer_account_address_street_field}     ${street}
    Type Text    ${customer_account_address_house_number_field}     ${houseNumber}
    Type Text    ${customer_account_address_additional_address_field}     ${additionalAddress}
    Type Text    ${customer_account_address_zip_code_field}     ${postCode}
    Type Text    ${customer_account_address_city_field}     ${city}
    Type Text    ${customer_account_address_phone_field}     ${phone}
    Click    ${customer_account_address_submit_button}

Yves: check that user has address exists/doesn't exist:
    [Arguments]    ${exists}    ${firstName}    ${lastName}    ${street}    ${houseNumber}    ${postCode}    ${city}    ${country}    ${isDefaultShipping}=True     ${isDefaultBilling}=True       ${company}=NUll    ${phone}=NUll    ${additionalAddress}=NUll
    IF    '${env}' in ['b2c','mp_b2c']
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
    IF    '${env}' in ['b2c','mp_b2c']
        Yves: go to user menu item in header:    My Profile
    ELSE IF    '${env}' in ['b2b','mp_b2b']
        Yves: go to user menu item in header:    Profile
    END
    Yves: go to user menu item in the left bar:    Addresses
    IF    '${env}' in ['b2c','mp_b2c']
        Click    xpath=//li[contains(text(),'${street}')]/ancestor::div/div[@data-qa='component title-box']//form[contains(@action,'address/delete')]//button
    ELSE IF    '${env}' in ['b2b','mp_b2b']
        Click    xpath=//li[contains(text(),'${street}')]/ancestor::div[@data-qa="component action-card"]//form[contains(@action,'address/delete')]//button
    END

Yves: delete all user addresses
    IF    '${env}' in ['b2c','mp_b2c']
        Yves: go to user menu item in header:    My Profile
    ELSE IF    '${env}' in ['b2b','mp_b2b']
        Yves: go to user menu item in header:    Profile
    END
    Yves: go to user menu item in the left bar:    Addresses
    ${userAddresses}=    Get Element Count    xpath=//form[contains(@action,'address/delete')]//button
    IF    ${userAddresses} != 0
        FOR    ${index}    IN RANGE    0    ${userAddresses}
            IF    '${env}' in ['b2c','mp_b2c']
                Click    xpath=//main//div[contains(@class,'col--md')]/div[contains(@class,'grid')]/div[1]//div[@data-qa='component title-box']//form[contains(@action,'address/delete')]//button
            ELSE IF    '${env}' in ['b2b','mp_b2b']
                Click    xpath=//div[@data-qa='component action-card-grid']/div[1]/div[@data-qa="component action-card"]//form[contains(@action,'address/delete')]//button
            END
        END   
    END
