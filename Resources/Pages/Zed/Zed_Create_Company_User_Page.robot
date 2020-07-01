*** Settings ***

*** Variables ***
${zed_create_company_user_email_field}          id=company-user_customer_email
${zed_create__company_user_salutation_dropdown}  id=company-user_customer_salutation
${zed_create_company_user_first_name_field}     id=company-user_customer_first_name
${zed_create_company_user_last_name_field}      id=company-user_customer_last_name
${zed_create_company_user_gender_dropdow}       id=company-user_customer_gender
${zed_create_company_user_dob_picker}           id=company-user_customer_date_of_birth
${zed_create_company_user_phone_field}          id=company-user_customer_phone
${zed_create_company_company_name_dropdown}     id=company-user_fk_company
${zed_create_company_business_unit_dropdown}    id=company-user_fk_company_business_unit

*** Keywords ***
Zed: Create new Company User with provided email/company/business unit and role(s):
    [Arguments]  ${email}   ${company}   ${business_unit}    ${role}
    Zed: Go to Second Navigation Item Level     Company Account    Company Users
    wait until element is visible  ${zed_table_locator}
    Zed: click button in Header:  Add User
    input text  ${zed_create_company_user_email_field}  ${email}
    select from list by label  ${zed_create__company_user_salutation_dropdown}  Mr
    Zed: select checkbox by Label:  Send password token through email
    input text  ${zed_create_company_user_first_name_field}     Robot First+${random}
    input text  ${zed_create_company_user_last_name_field}      robot Last+${random}
    select from list by label  ${zed_create_company_user_gender_dropdow}    Male
    input text  ${zed_create_company_user_dob_picker}   25.10.1989
    input text  ${zed_create_company_user_phone_field}  495-123-45-67
    select from list by label  ${zed_create_company_company_name_dropdown}  ${company}
    sleep  2s
    select from list by label  ${zed_create_company_business_unit_dropdown}      ${business_unit}
    Zed: select checkbox by Label:  ${role}
    Zed: submit the form
    wait until element is visible  ${zed_success_flash_message}
    wait until element is visible  ${zed_table_locator}
    Zed: perform search by:  Robot First+${random}
    table should contain  ${zed_table_locator}  Robot First+${random}