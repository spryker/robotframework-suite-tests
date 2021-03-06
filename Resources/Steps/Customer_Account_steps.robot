*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Resource    ../Steps/Quick_Order_steps.robot
Resource    ../Pages/Yves/Yves_Customer_Account_page.robot

*** Keywords ***
Yves: go to user menu item in the left bar:
    [Documentation]    Case sensitive, accepts: Overview, Profile, Addresses, Order History, Newsletter, Shopping lists, Shopping carts, Quote Requests
    [Arguments]    ${left_navigation_node}
    Run Keyword If    '${env}'=='b2b'    Run Keywords
    ...    Wait Until Element Is Visible    xpath=//ul[@class='navigation-sidebar__list']//*[contains(.,'${left_navigation_node}')]/a    AND
    ...    Scroll and Click Element    xpath=//ul[@class='navigation-sidebar__list']//*[contains(.,'${left_navigation_node}')]/a
    ...    ELSE    Run Keywords    
    ...    Wait Until Element Is Visible    xpath=//a[contains(@class,'menu__link menu__link--customer-navigation') and contains(text(),'${left_navigation_node}')]    AND
    ...    Scroll and Click Element    xpath=//a[contains(@class,'menu__link menu__link--customer-navigation') and contains(text(),'${left_navigation_node}')]

Yves: create a new customer address in profile:
    [Documentation]
    [Arguments]    ${salutation}    ${firstName}    ${lastName}    ${street}    ${houseNumber}    ${postCode}    ${city}    ${country}    ${isDefaultShipping}=True     ${isDefaultBilling}=True       ${company}=    ${phone}=    ${additionalAddress}=
    Yves: go to user menu item in header:    My Profile
    Yves: go to user menu item in the left bar:    Addresses
    Wait Until Element Is Visible    ${customer_account_add_new_address_button}
    Click Element    ${customer_account_add_new_address_button}
    Wait Until Element Is Visible    ${customer_account_address_form}
#  Click Element    ${customer_account_address_salutation_dropdown_field}
#  Scroll and Click Element    xpath=//li[@class='select2-results__option' and contains(text(),'${salutation}')]
    Input text into field    ${customer_account_address_first_name_field}     ${firstName}
    Input text into field    ${customer_account_address_last_name_field}     ${lastName}
    Input text into field    ${customer_account_address_company_name_field}     ${company}
    Input text into field    ${customer_account_address_street_field}     ${street}
    Input text into field    ${customer_account_address_house_number_field}     ${houseNumber}
    Input text into field    ${customer_account_address_additional_address_field}     ${additionalAddress}
    Input text into field    ${customer_account_address_zip_code_field}     ${postCode}
    Input text into field    ${customer_account_address_city_field}     ${city}
#  Click Element    ${customer_account_address_country_drop_down_field}
#  Scroll and Click Element    xpath=//li[contains(@class,'select2-results__option') and contains(text(),'${country}')]
    Input text into field    ${customer_account_address_phone_field}     ${phone}
#    Run keyword if    '${isDefaultShipping}'=='True'    Add/Edit element attribute with JavaScript:    ${customer_account_address_is_default_shipping_checkbox}    checked    checked    
#    Run keyword if    '${isDefaultBilling}'=='True'    Add/Edit element attribute with JavaScript:    ${customer_account_address_is_default_billing_checkbox}
    Click Button    ${customer_account_address_submit_button}   
    Wait For Document Ready 

Yves: check that user has address exists/doesn't exist:
    [Arguments]    ${exists}    ${salutation}    ${firstName}    ${lastName}    ${street}    ${houseNumber}    ${postCode}    ${city}    ${country}    ${isDefaultShipping}=True     ${isDefaultBilling}=True       ${company}=NUll    ${phone}=NUll    ${additionalAddress}=NUll
    Yves: go to user menu item in header:    My Profile
    Yves: go to user menu item in the left bar:    Addresses
    Run Keyword If    '${exists}'=='true'    Run keywords
    ...    Element Should Be Visible    xpath=//div[@class='box']//ul[@class='display-address menu menu--customer-account']//li[contains(text(),'${salutation} ${firstName} ${lastName}')]    AND
    ...    Element Should Be Visible    xpath=//div[@class='box']//ul[@class='display-address menu menu--customer-account']//li[contains(text(),'${street} ${houseNumber}')]    AND    
    ...    Element Should Be Visible    xpath=//div[@class='box']//ul[@class='display-address menu menu--customer-account']//li[contains(text(),'${postCode} ${city}, ${country}')]
    ...    ELSE    Run keywords
    ...    Element Should Not Be Visible    xpath=//div[@class='box']//ul[@class='display-address menu menu--customer-account']//li[contains(text(),'${salutation} ${firstName} ${lastName}')]    AND
    ...    Element Should Not Be Visible    xpath=//div[@class='box']//ul[@class='display-address menu menu--customer-account']//li[contains(text(),'${street} ${houseNumber}')]    AND    
    ...    Element Should Not Be Visible    xpath=//div[@class='box']//ul[@class='display-address menu menu--customer-account']//li[contains(text(),'${postCode} ${city}, ${country}')]

Yves: delete user address:
    [Arguments]    ${salutation}    ${firstName}    ${lastName}    ${street}    ${houseNumber}    ${postCode}    ${city}    ${country}    ${isDefaultShipping}=True     ${isDefaultBilling}=True       ${company}=NUll    ${phone}=NUll    ${additionalAddress}=NUll
    Yves: go to user menu item in header:    My Profile
    Yves: go to user menu item in the left bar:    Addresses
    Scroll and Click Element    xpath=//li[contains(text(),'${salutation} ${firstName} ${lastName}')]/following-sibling::li[contains(text(),'${street} ${houseNumber}')]/following-sibling::li[contains(text(),'${postCode} ${city}, ${country}')]/ancestor::div[@class='box']//button[contains(text(),'Delete')]
    Wait For Document Ready    
    Element Should Be Visible    xpath=//flash-message//div[contains(text(),'Address deleted successfully')]   message="Flash message didn't appear"
