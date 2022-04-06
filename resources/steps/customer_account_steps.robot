*** Settings ***
Resource    ../common/common.robot
Resource    ../steps/header_steps.robot
Resource    ../steps/quick_order_steps.robot
Resource    ../pages/yves/yves_customer_account_page.robot

*** Keywords ***
Yves: go to 'Customer Account' page
    Yves: go to URL:    en/customer/overview

Yves: go to user menu item in the left bar:
    [Documentation]    Case sensitive, accepts: Overview, Profile, Addresses, Order History, Newsletter, Shopping lists, Shopping carts, Quote Requests
    [Arguments]    ${left_navigation_node}
    Run Keyword If    '${env}'=='b2b'    Run Keywords
    ...    Wait Until Element Is Visible    xpath=//ul[@class='navigation-sidebar__list']//*[contains(.,'${left_navigation_node}')]/a    AND
    ...    Click    xpath=//ul[@class='navigation-sidebar__list']//*[contains(.,'${left_navigation_node}')]/a
    ...    ELSE IF    '${env}'=='suite-nonsplit'    Run Keywords
    ...    Wait Until Element Is Visible    xpath=//nav[contains(@class,'customer-navigation')]//a[contains(text(),'${left_navigation_node}')]    AND
    ...    Click    xpath=//nav[contains(@class,'customer-navigation')]//a[contains(text(),'${left_navigation_node}')]
    ...    ELSE    Run Keywords
    ...    Wait Until Element Is Visible    xpath=//a[contains(@class,'menu__link menu__link--customer-navigation') and contains(text(),'${left_navigation_node}')]    AND
    ...    Click    xpath=//a[contains(@class,'menu__link menu__link--customer-navigation') and contains(text(),'${left_navigation_node}')]

Yves: create a new customer address in profile:
    [Documentation]
    [Arguments]    ${salutation}    ${firstName}    ${lastName}    ${street}    ${houseNumber}    ${postCode}    ${city}    ${country}    ${isDefaultShipping}=True     ${isDefaultBilling}=True       ${company}=    ${phone}=    ${additionalAddress}=
    Run Keyword If    '${env}'=='b2c'    Yves: go to user menu item in header:    My Profile
    ...    ELSE    Run Keyword If    '${env}'=='b2b'    Yves: go to user menu item in header:    Profile
    Yves: go to user menu item in the left bar:    Addresses
    Wait Until Element Is Visible    ${customer_account_add_new_address_button}[${env}]
    Click    ${customer_account_add_new_address_button}[${env}]
    Wait Until Element Is Visible    ${customer_account_address_form}
#  Click    ${customer_account_address_salutation_dropdown_field}
#  Click    xpath=//li[@class='select2-results__option' and contains(text(),'${salutation}')]
    Type Text    ${customer_account_address_first_name_field}     ${firstName}
    Type Text    ${customer_account_address_last_name_field}     ${lastName}
    Type Text    ${customer_account_address_company_name_field}     ${company}
    Type Text    ${customer_account_address_street_field}     ${street}
    Type Text    ${customer_account_address_house_number_field}     ${houseNumber}
    Type Text    ${customer_account_address_additional_address_field}     ${additionalAddress}
    Type Text    ${customer_account_address_zip_code_field}     ${postCode}
    Type Text    ${customer_account_address_city_field}     ${city}
#  Click    ${customer_account_address_country_drop_down_field}
#  Click    xpath=//li[contains(@class,'select2-results__option') and contains(text(),'${country}')]
    Type Text    ${customer_account_address_phone_field}     ${phone}
#    Run keyword if    '${isDefaultShipping}'=='True'    Add/Edit element attribute with JavaScript:    ${customer_account_address_is_default_shipping_checkbox}    checked    checked
#    Run keyword if    '${isDefaultBilling}'=='True'    Add/Edit element attribute with JavaScript:    ${customer_account_address_is_default_billing_checkbox}
    Click    ${customer_account_address_submit_button}


Yves: check that user has address exists/doesn't exist:
    [Arguments]    ${exists}    ${firstName}    ${lastName}    ${street}    ${houseNumber}    ${postCode}    ${city}    ${country}    ${isDefaultShipping}=True     ${isDefaultBilling}=True       ${company}=NUll    ${phone}=NUll    ${additionalAddress}=NUll
    Run Keyword If    '${env}'=='b2c'    Yves: go to user menu item in header:    My Profile
    ...    ELSE    Run Keyword If    '${env}'=='b2b'    Yves: go to user menu item in header:    Profile
    Yves: go to user menu item in the left bar:    Addresses
    Run Keyword If    '${exists}'=='true'    Run keywords
    ...    Element Should Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${firstName} ${lastName}')]    AND
    ...    Element Should Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${street} ${houseNumber}')]    AND
    ...    Element Should Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${postCode} ${city}, ${country}')]
    ...    ELSE    Run keywords
    ...    Element Should Not Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${firstName} ${lastName}')]    AND
    ...    Element Should Not Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${street} ${houseNumber}')]    AND
    ...    Element Should Not Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${postCode} ${city}, ${country}')]

Yves: delete user address:
    [Arguments]    ${street}
    Run Keyword If    '${env}'=='b2c'    Yves: go to user menu item in header:    My Profile
    ...    ELSE    Run Keyword If    '${env}'=='b2b'    Yves: go to user menu item in header:    Profile
    Yves: go to user menu item in the left bar:    Addresses
    Run Keyword If    '${env}'=='b2c'    Click    xpath=//li[contains(text(),'${street}')]/ancestor::div[@class='box']//button[contains(text(),'Delete')]
    ...    ELSE    Run Keyword If    '${env}'=='b2b'    Click    xpath=//li[contains(text(),'${street}')]/ancestor::div[@class='action-card']//button

    Element Should Be Visible    xpath=//flash-message//div[contains(text(),'Address deleted successfully')]   message="Flash message didn't appear"
