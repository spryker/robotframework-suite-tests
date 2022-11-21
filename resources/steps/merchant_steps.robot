*** Settings ***
Resource    ../common/common.robot
Resource    ../../resources/common/common_zed.robot
Resource    ../pages/yves/yves_merchant_profile.robot
Resource    ../pages/yves/yves_header_section.robot
Resource    ../../resources/pages/zed/zed_create_merchant_page.robot
Resource    ../../resources/pages/zed/zed_merchant_relation_page.robot
Resource    ../../resources/steps/zed_marketplace_steps.robot

*** Keywords ***
Zed: create merchant relation between a BU of a company and the merchant:
    [Arguments]    ${merchant}    ${company}    ${bussiness_unit_owner}    ${assigned_bussiness_units}    ${assigned_product}
    Click    ${merchant_dropdown_locator}
    Type Text    ${merchant_input_filed_locator}    ${merchant}
    Keyboard Key    Press    Enter
    Click    ${company_dropdown_locator}
    Type Text    ${company_input_filed_locator}    ${company}
    Keyboard Key    Press    Enter
    click    ${confirm_button_locator}
    Wait Until Element Is Visible    ${bussiness_unit_owner_locator}
    Click    ${bussiness_unit_owner_locator}
    Type Text    ${bussiness_unit_owner_input_locator}     ${bussiness_unit_owner}
    Keyboard Key    Press    Enter
    Click    ${assigned_product_lists_locator} 
    Type Text    ${assigned_product_lists_input_locator}    ${assigned_bussiness_units}
    Keyboard Key    Press    Enter
    Click    ${assigned_product_lists_locator}
    Type Text    ${assigned_product_lists_input_locator}    ${assigned_product}
    Keyboard Key    Press    Enter
    Zed: submit the form
    Zed: message should be shown:    Merchant relation created successfully.

Zed: deactivate merchant:
    [Arguments]    ${merchant_name}
    Zed: go to second navigation item level:    Marketplace    Merchants  
    Zed: click Action Button in a table for row that contains:    ${merchant_name}    Deactivate 

Zed: delete merchant relation:
    [Arguments]    ${merchant_name}   
    Zed: go to second navigation item level:    Marketplace    Merchant Relations
    Zed: click Action Button in a table for row that contains:    ${merchant_name}    Delete 

Zed: verify merchant relation:
    [Arguments]    ${company_name}    ${merchant_name}
    Zed: go to second navigation item level:    Marketplace    Merchant Relations
    Select From List By Label    ${company_dropdown_merchant_relation_locator}    ${company_name}
    Zed: table should contain:    ${merchant_name}
    