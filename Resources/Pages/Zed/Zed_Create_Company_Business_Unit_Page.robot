*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${zed_bu_company_dropdown_locator}  id=company-business-unit_fk_company
${zed_bu_parent_dropdown_locator}   id=company-business-unit_fk_parent_company_business_unit
${zed_bu_name_field}    id=company-business-unit_name
${zed_bu_iban_field}    id=company-business-unit_iban
${zed_bu_bic_field}     id=company-business-unit_bic


*** Keywords ***
Zed: create new Company Business Unit with provided name and company:
    [Documentation]     Creates new company BU with provided BU Name and for provided company.
    [Arguments]  ${bu_name_to_set}  ${company_business_unit}
    Zed: Go to Second Navigation Item Level     Company Account    Company Units
    Zed: click button in Header:    Create Company Business Unit
    select from list by label   ${zed_bu_company_dropdown_locator}  ${company_business_unit}
    input text  ${zed_bu_name_field}    ${bu_name_to_set}
    input text  ${zed_bu_iban_field}    testiban+${random}
    input text  ${zed_bu_bic_field}     testbic+${random}
    Zed: submit the form
    wait until element is visible  ${zed_success_flash_message}
    wait until element is visible  ${zed_table_locator}
    Zed: perform search by:  ${bu_name_to_set}
    table should contain  ${zed_table_locator}  ${bu_name_to_set}
    ${newly_created_business_unit_id}=      get text    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${bu_name_to_set}')]/../td[1]
    log  ${newly_created_business_unit_id}
    set suite variable  ${newly_created_business_unit_id}
