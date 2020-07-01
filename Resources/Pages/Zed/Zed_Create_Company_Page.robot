*** Settings ***


*** Variables ***
${zed_company_name_input_field}    id=company_name

*** Keywords ***
Zed: create new Company with provided name:
    [Arguments]    ${company_name}
    Zed: Go to Second Navigation Item Level    Company Account    Companies
    Zed: click button in Header:    Create Company
    wait until element is visible    id=company_name
    input text    ${zed_company_name_input_field}    ${company_name}
    Zed: submit the form
    wait until element is visible  ${zed_success_flash_message}
    wait until element is visible  ${zed_table_locator}
    table should contain  ${zed_table_locator}  ${company_name}
