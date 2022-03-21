*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_aop_pbc_details_page.robot


*** Keywords ***
Zed: fill in new delivery address for a product:
    [Documentation]    Possible argument names: product (SKU or Name), salutation, firstName, lastName, street, houseNumber, postCode, city, country, company, phone, additionalAddress
    [Arguments]    @{args}
    ${newAddressData}=    Set Up Keyword Arguments    @{args}
    # Wait Until Element Is Visible    ${checkout_shipping_address_item_form}
    FOR    ${key}    ${value}    IN    &{newAddressData}
        Log    Key is '${key}' and value is '${value}'.
        ${item}=    Set Variable If    '${key}'=='product'    ${value}    ${item}
        Select From List By Label    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]//select    Define new address
        Run keyword if    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//select[contains(@name,'[salutation]')]    ${value}
        Run keyword if    '${key}'=='firstName' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[first_name]')]    ${value}
        Run keyword if    '${key}'=='lastName' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[last_name]')]    ${value}
        Run keyword if    '${key}'=='street' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[address1]')]    ${value}
        Run keyword if    '${key}'=='houseNumber' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[address2]')]    ${value}
        Run keyword if    '${key}'=='postCode' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[zip_code]')]    ${value}
        Run keyword if    '${key}'=='city' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[city]')]    ${value}
        Run keyword if    '${key}'=='country' and '${value}' != '${EMPTY}'    Select From List By Label    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//select[contains(@name,'[iso2_code]')]    ${value}
        Run keyword if    '${key}'=='company' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[company]')]    ${value}
        Run keyword if    '${key}'=='phone' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[phone]')]    ${value}
        Run keyword if    '${key}'=='additionalAddress' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[address3]')]    ${value}
    END