*** Settings ***
Library           Collections

*** Variables ***
${zed_role_company_dropdown_locator}     id=company_role_create_form_fkCompany
${zed_role_name_field}      id=company_role_create_form_name
${zed_role_is_default_checkbox}     id=company_role_create_form_isDefault


*** Keywords ***
Zed: Create New Company Role with Prodided Permissions
    [Documentation]     Creates new company role with provided permission. Permissions are optional
    [Arguments]     ${select_company_for_role}     ${new_role_name}    ${is_default}      @{permissions_list}    ${permission1}=${EMPTY}     ${permission2}=${EMPTY}     ${permission3}=${EMPTY}     ${permission4}=${EMPTY}     ${permission5}=${EMPTY}     ${permission6}=${EMPTY}     ${permission7}=${EMPTY}     ${permission8}=${EMPTY}     ${permission9}=${EMPTY}     ${permission10}=${EMPTY}     ${permission11}=${EMPTY}     ${permission12}=${EMPTY}     ${permission13}=${EMPTY}     ${permission14}=${EMPTY}     ${permission15}=${EMPTY}
    Zed: Go to Second Navigation Item Level     Company Account    Company Roles
    Zed: Click Button in Header    Add company user role
    ${new_list_of_permissions}=   get length  ${permissions_list}
    log  ${new_list_of_permissions}
    run keyword if  '${is_default}'=='true'     Zed: Select Checkbox by Lable  Is Default
    : FOR    ${index}    IN RANGE    0    ${new_list_of_permissions}
    \    ${permission_to_set}=    Get From List    ${permissions_list}    ${index}
    \    Log    ${permission_to_set}
    \    Zed: Select Checkbox by Lable   ${permission_to_set}
    select from list by label   ${zed_role_company_dropdown_locator}    ${select_company_for_role}
    input text  ${zed_role_name_field}  ${new_role_name}
    Zed: Submit the Form
    Zed: Perform Search By:  ${new_role_name}
    table should contain  ${zed_table_locator}  ${new_role_name}
