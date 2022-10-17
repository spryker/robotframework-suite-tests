*** Settings ***
Resource    ../common/common.robot
Resource    ../../resources/common/common_zed.robot
Resource    ../pages/yves/yves_merchant_profile.robot
Resource    ../pages/yves/yves_header_section.robot
Resource    ../../resources/pages/zed/zed_create_merchant_page.robot

*** Keywords ***
Zed: Add new merchant:
    [Arguments]    @{args}
    ${merchantdata}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{merchantdata}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='Name' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_name_field}    ${value}
        IF    '${key}'=='Registration_number' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_registration_number_filed}    ${value}
        IF    '${key}'=='Reference_number' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_reference_field}    ${value}
        IF    '${key}'=='Email' and '${value}' != '${EMPTY}'     Type Text    ${zed_create_merchant_email_field}    ${value}
        IF    '${key}'=='En_url' and '${value}' != '${EMPTY}'     Type Text    ${zed_create_merchant_url_en_locale_field}    ${value}
        IF    '${key}'=='De_url' and '${value}' != '${EMPTY}'     Type Text    ${zed_create_merchant_url_de_locale_field}    ${value}
    END  
    Check Checkbox    ${merchant_is_active_checkbox_locator} 
    Check Checkbox    ${merchant_checkbox_en_locator}
    Check Checkbox    ${merchant_checkbox_de_locator}
   
Zed: Create Merchant Relation between a BU of a company and the merchant
    Click    ${merchant_dropdown_locator}
    Click    ${dropdown_value_Impala_locator}
    Click    ${company_dropdown_locator}
    Click    ${dropdown_value_Proof_locator}
    click    ${confirm_button_locator}
    Wait Until Element Is Visible    ${Bussiness_unit_owner_locator}
    Click    ${Bussiness_unit_owner_locator}
    Click    ${dropdown_value_Bar_locator}
    Click    ${Assigned_bussiness_units_locator} 
    Click    ${dropdown_value_Cleaning_locator}
    Click    ${Assigned_product_lists_locator} 
    Wait Until Element Is Visible    ${dropdown_value_Computer_locator} 
    Click    ${dropdown_value_Computer_locator} 