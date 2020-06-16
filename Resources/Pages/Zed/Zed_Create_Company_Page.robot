*** Settings ***


*** Variables ***
${zed_company_name_input_field}    id=company_name

*** Keywords ***
Zed: Create New Company with Provided Name
    [Arguments]    ${company_name}
    Zed: Go to Second Navigation Item Level    Company Account    Companies
    Zed: Click Button in Header    Create Company
    wait until element is visible    id=company_name
    input text    ${zed_company_name_input_field}    ${company_name}
    Zed: Submit the Form
    wait until element is visible  ${zed_success_flash_message}
    wait until element is visible  ${zed_table_locator}
    table should contain  ${zed_table_locator}  ${company_name}

