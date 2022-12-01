*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_yves.robot
Resource    ../common/common_zed.robot
Resource    ../pages/zed/zed_attach_to_business_unit_page.robot
Resource    ../pages/yves/yves_customer_account_page.robot
Resource    ../pages/zed/zed_delete_company_user_page.robot
Resource    ../pages/yves/yves_company_business_unit_page.robot
Resource    ../pages/yves/yves_company_register_page.robot
Resource    ../pages/yves/yves_company_role_page.robot
Resource    ../pages/yves/yves_company_users_page.robot

*** Keywords ***
Zed: create new Company Business Unit with provided name and company:
    [Documentation]     Creates new company BU with provided BU Name and for provided company.
    [Arguments]    ${bu_name_to_set}    ${company_business_unit}
    Zed: go to second navigation item level:    Company Account    Company Units
    Zed: click button in Header:    Create Company Business Unit
    select from list by label    ${zed_bu_company_dropdown_locator}    ${company_business_unit}
    Type Text    ${zed_bu_name_field}    ${bu_name_to_set}
    Type Text    ${zed_bu_iban_field}    testiban+${random}
    Type Text    ${zed_bu_bic_field}    testbic+${random}
    Zed: submit the form
    wait until element is visible    ${zed_success_flash_message}
    wait until element is visible    ${zed_table_locator}
    Zed: perform search by:    ${bu_name_to_set}
    Table Should Contain    ${zed_table_locator}    ${bu_name_to_set}
    ${newly_created_business_unit_id}=      get text    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${bu_name_to_set}')]/../td[1]
    log    ${newly_created_business_unit_id}
    set suite variable    ${newly_created_business_unit_id}

Zed: create new Company with provided name:
    [Arguments]    ${company_name}
    Zed: go to second navigation item level:    Company Account    Companies
    Zed: click button in Header:    Create Company
    wait until element is visible    id=company_name
    Type Text    ${zed_company_name_input_field}    ${company_name}
    Zed: submit the form
    wait until element is visible    ${zed_success_flash_message}
    wait until element is visible    ${zed_table_locator}
    Table Should Contain    ${zed_table_locator}    ${company_name}

Zed: create new Company Role with provided permissions:
    [Documentation]     Creates new company role with provided permission. Permissions are optional
    [Arguments]     ${select_company_for_role}     ${new_role_name}    ${is_default}      @{permissions_list}    ${permission1}=${EMPTY}     ${permission2}=${EMPTY}     ${permission3}=${EMPTY}     ${permission4}=${EMPTY}     ${permission5}=${EMPTY}     ${permission6}=${EMPTY}     ${permission7}=${EMPTY}     ${permission8}=${EMPTY}     ${permission9}=${EMPTY}     ${permission10}=${EMPTY}     ${permission11}=${EMPTY}     ${permission12}=${EMPTY}     ${permission13}=${EMPTY}     ${permission14}=${EMPTY}     ${permission15}=${EMPTY}
    Zed: go to second navigation item level:     Company Account    Company Roles
    Zed: click button in Header:    Add company user role
    ${new_list_of_permissions}=    get length    ${permissions_list}
    log    ${new_list_of_permissions}
    IF  '${is_default}'=='true'     Zed: Check checkbox by Label:  Is Default
    FOR    ${index}    IN RANGE    0    ${new_list_of_permissions}
        ${permission_to_set}=    Get From List    ${permissions_list}    ${index}
        Log    ${permission_to_set}
        Zed: Check checkbox by Label:   ${permission_to_set}
    END
    select from list by label    ${zed_role_company_dropdown_locator}    ${select_company_for_role}
    Type Text    ${zed_role_name_field}    ${new_role_name}
    Zed: submit the form
    Zed: perform search by:    ${new_role_name}
    Table Should Contain    ${zed_table_locator}    ${new_role_name}

Zed: Create new Company User with provided email/company/business unit and role(s):
    [Arguments]    ${email}    ${company}    ${business_unit}    ${role}
    Zed: go to second navigation item level:    Company Account    Company Users
    wait until element is visible    ${zed_table_locator}
    Zed: click button in Header:    Add User
    Type Text    ${zed_create_company_user_email_field}  ${email}
    select from list by label    ${zed_create__company_user_salutation_dropdown}    Mr
    Zed: Check checkbox by Label:    Send password token through email
    Type Text    ${zed_create_company_user_first_name_field}    Robot First+${random}
    Type Text    ${zed_create_company_user_last_name_field}    robot Last+${random}
    select from list by label    ${zed_create_company_user_gender_dropdow}    Male
    Type Text    ${zed_create_company_user_dob_picker}    25.10.1989
    Type Text    ${zed_create_company_user_phone_field}    495-123-45-67
    select from list by label    ${zed_create_company_company_name_dropdown}    ${company}
    sleep    2s
    select from list by label    ${zed_create_company_business_unit_dropdown}    ${business_unit}
    Zed: Check checkbox by Label:    ${role}
    Zed: submit the form
    wait until element is visible    ${zed_success_flash_message}
    wait until element is visible    ${zed_table_locator}
    Zed: perform search by:    Robot First+${random}
    Table Should Contain    ${zed_table_locator}    Robot First+${random}

Zed: attach company user to the following BU with role:
    [Arguments]    ${business_unit}    ${role_checkbox}
    Wait Until Element Is Visible    ${zed_business_unit_selector}
    Select From List By Label    ${zed_business_unit_selector}    ${business_unit}
    Zed: Check checkbox by Label:    ${role_checkbox}
    Zed: submit the form


Yves: 'Business Unit' dropdown contains:
    [Arguments]    @{business_units_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${business_units_list_count}=   get length  ${business_units_list}
    FOR    ${index}    IN RANGE    0    ${business_units_list_count}
        ${business_unit_to_check}=    Get From List    ${business_units_list}    ${index}
        Page Should Contain Element    //select[@id='company_user_account_selector_form_companyUserAccount']/option[contains(.,'${business_unit_to_check}')]
    END

Zed: delete company user xxx withing xxx company business unit:
    [Documentation]    Possible argument names: company user name
    [Arguments]    ${companyUserName}    ${companyBusinessUnit}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ${currentURL}=    Get Location
    IF    '/customer' not in '${currentURL}'    Zed: go to second navigation item level:    Customers    Company Users
    Zed: perform search by:    ${companyUserName}
    ${customerExists}=    Run Keyword And Return Status    Table should contain    ${zed_table_locator}    ${companyBusinessUnit}
    IF    '${customerExists}'=='True'
        Run keywords
            Zed: click Action Button(without search) in a table for row that contains:    ${companyBusinessUnit}    Delete
            Click    ${zed_confirm_delete_company_user_button}
    END

Yves: company registration:
    [Arguments]    @{args}
    Yves: go to URL:   company/register
    ${registrationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{registrationData}
        IF    '${key}' == 'salutation'    Select From List By Text    ${yves_register_company_user_salutation}    ${value}
        IF    '${key}' == 'firstName'    Type Text    ${yves_register_company_first_name}    ${value}
        IF    '${key}' == 'lastName'    Type Text  ${yves_register_company_last_name}    ${value}
        IF    '${key}' == 'company'    Type Text    ${yves_register_company_name}    ${value}
        IF    '${key}' == 'email'    Type Text    ${yves_register_company_email}    ${value}
        IF    '${key}' == 'password'    Type Text    ${yves_register_company_password}    ${value}
        IF    '${key}' == 'confirmPassword'    Type Text    ${yves_register_company_confirm_password}    ${value}
    END    
    Check Checkbox    ${yves_register_accept_company_terms}
    Click    ${yves_register_company_click_submit_button}
    Yves: flash message 'should' be shown

Yves: confirm newly created company user:
    [Arguments]    ${email}
    Save the result of a SELECT DB query to a variable:    select registration_key from spy_customer where email = '${email}'    confirmation_key
    I send a POST request:     /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"${confirmation_key}"}}}

Zed: approve/deny company by admin:
    [Arguments]    ${company_name}     ${condition}
    IF    '${condition}' == 'approve'
        Zed: click Action Button in a table for row that contains:    ${company_name}    Approve
    ELSE
        Zed: click Action Button in a table for row that contains:    ${company_name}    Deny    
    END
    Zed: flash message should be shown:    success

Zed: activate/deactivate company by admin:
    [Arguments]    ${company_name}     ${condition}
    IF    '${condition}' == 'activate'
        Zed: click Action Button in a table for row that contains:    ${company_name}    Activate
    ELSE
        Zed: click Action Button in a table for row that contains:    ${company_name}    Deactivate
    END
    Zed: flash message should be shown:    success    

    
Yves: create company user:
    [Arguments]    @{args}
    Yves: go to company menu item:    Users
    Click    ${yves_company_create_user_button}
    ${userregistrationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{userregistrationData}
        IF    '${key}' == 'companyBusinessUnit'    Select From List By Label    ${yves_company_user_bu_dropdown}    ${value}
        IF    'role' in '${key}'    Yves: Check checkbox by Label:    ${value}
        IF    '${key}' == 'salutation'    Select From List By Text    ${yves_company_user_salutation_locator}    ${value}
        IF    '${key}' == 'firstName'    Type Text    ${yves_company_user_first_name}    ${value}
        IF    '${key}' == 'lastName'    Type Text  ${yves_company_user_last_name}    ${value}
        IF    '${key}' == 'email'    Type Text    ${yves_company_user_email}    ${value}
    END
    Click    ${yves_company_user_submit}

Yves: check checkbox by Label:
    [Arguments]    ${checkbox_label}
    ${state}=    Get Checkbox State    xpath=(//span[contains(text(),'${checkbox_label}')]//parent::label//child::span)[1]
    IF    '${state}' == 'False'
        wait until element is visible    xpath=(//span[contains(text(),'${checkbox_label}')]//parent::label//child::span)[1]
        Check checkbox    xpath=(//span[contains(text(),'${checkbox_label}')]//parent::label//child::span)[1]
    END

Yves: uncheck checkbox by label:
    [Arguments]    ${checkbox_label}
    ${state}=    Get Checkbox State    xpath=(//span[contains(text(),'${checkbox_label}')]//parent::label//child::span)[1]
    IF    '${state}' == 'True'
        wait until element is visible    xpath=(//span[contains(text(),'${checkbox_label}')]//parent::label//child::span)[1]
        Uncheck Checkbox    xpath=(//span[contains(text(),'${checkbox_label}')]//parent::label//child::span)[1]
    END

Yves: create Business unit:
    [Arguments]    @{args}
    Yves: go to company menu item:    Business Units
    Click    ${create_business_unit_button}
    ${businessUnitData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{businessUnitData}
        IF    '${key}' == 'businessUnitName'    Type Text    ${create_business_name_locator}    ${value}
        IF    '${key}' == 'parent'    Select From List By Text    ${create_business_parent_bu_locator}    ${value}
        IF    '${key}' == 'email'    Type Text    ${create_business_unit_email_locator}    ${value}
        IF    '${key}' == 'phone'    Type Text    ${create_business_unit_phone_number_locator}    ${value}
        IF    '${key}' == 'externalURL'    Type Text    ${business_unit_external_url_locator}    ${value}
    END 
    Click    ${business_unit_submit_button}

Yves: go to business unit with name:
    [Arguments]    ${businessUnit}
    Yves: go to company menu item:    Business Units
    Click    xpath=//a[contains(@class,"business-unit-chart-item__link--level-1")]//span[contains(text(),'${businessUnit}')]

Yves: create new business unit address of a business unit:
    [Arguments]    ${businessUnit}    @{args}
    Yves: go to business unit with name:    ${businessUnit}
    Click    ${create_business_unit_button}
    ${addressData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{addressData}
        IF    '${key}' == 'street'    Type Text    ${business_unit_street_locator}    ${value}
        IF    '${key}' == 'number'    Type Text    ${business_unit_number_locator}    ${value}
        IF    '${key}' == 'address'    Type Text    ${business_unit_address_locator}    ${value}
        IF    '${key}' == 'zipcode'    Type Text    ${business_unit_zipcode_locator}    ${value}
        IF    '${key}' == 'city'    Type Text    ${business_unit_city_locator}    ${value}
        IF    '${key}' == 'country'    Select From List By Text    ${business_unit_country_locator}        ${value}
        IF    '${key}' == 'phoneNumber'    Type Text    ${business_unit_phone_number_locator}    ${value}
    END
    Click    ${business_unit_submit_button}

Yves: add multiple company user:
    [Arguments]    ${path}
    Yves: go to company menu item:    Users
    Click    ${yves_company_invite_user_button}
    Upload File By Selector    ${yves_company_user_invitation_file_import_button}    ${EXECDIR}/${path}
    Click    ${yves_company_user_import_submit_button}

Yves: check user invitation import successfully or not:
    [Arguments]    ${state}
    IF    '${state}' == 'true'
        Page Should Not Contain Element    ${yves_company_user_import_error_locator}
        Page Should Contain Element   ${yves_company_all_invite_user_table_locator}    
    ELSE
        Page Should Contain Element    ${yves_company_user_import_error_locator}
    END
Yves: send invitations to all new company users
    Wait Until Element Is Visible    ${yves_company_user_send_all_button}
    Click    ${yves_company_user_send_all_button}
    Yves: flash message should be shown:    success    All invitations sent successfully 

Yves: send/delete invitation to a company user:
    [Documentation]    accepts arguments email and action(send, delete) 
    [Arguments]    ${email}    ${action}
    Click    xpath=//td[@data-content="Mail" and text()='${email}']//following-sibling::td[contains(@class,'spacing--reset')]//div//div//a[contains(@href,'${action}')]

Yves: check new company user get the invitation mail:
    [Arguments]    ${email}
    Save the result of a SELECT DB query to a variable:    select registration_key from spy_customer where email = '${email}'    confirmation_key
    Should Not Be Empty    ${confirmation_key}    Company user doesn't get any invitation mail

Yves: create new company role:
    [Arguments]    ${role_name}    ${default_status}=false
    Yves: go to company menu item:    Roles
    Click    ${yves_company_role_create_button}
    Wait Until Element Is Visible    ${yves_company_role_name_locator}
    Type Text    ${yves_company_role_name_locator}    ${role_name}
    IF    '${default_status}' == 'true'    Check Checkbox    ${yves_company_role_is_default_checkbox}
    Click    ${yves_company_role_submit_button}
    Yves: flash message should be shown:    success    Role has been successfully created.

Yves: verify new user role is created:
    [Arguments]    ${role_name}
    Page Should Contain Element    xpath=//td[contains(@class,"spacing-top--big") and text()='${role_name}']

Yves: validate and set password for newly created company user:
    [Arguments]    ${email}    ${password}=${yves_user_password}
   Save the result of a SELECT DB query to a variable:    select registration_key from spy_customer where email = '${email}'    confirmation_key
   Save the result of a SELECT DB query to a variable:    select customer_reference from spy_customer where email = '${email}'    customer_id
   I send a POST request:     /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"${confirmation_key}"}}}
   Save the result of a SELECT DB query to a variable:    select restore_password_key from spy_customer where email = '${email}'    restore_key
   I send a PATCH request:    /customer-restore-password/${customer_id}   {"data":{"type":"customer-restore-password","id":"${customer_id}","attributes":{"restorePasswordKey":"${restore_key}","password":"${password}","confirmPassword":"${password}"}}}

Yves: add all permission to a role:
    [Arguments]    ${role_name}
    Yves: go to company menu item:    Roles
    Click    xpath=//td[text()='${role_name}']//following-sibling::td[contains(@class,'spacing--reset')]/div/div/a[contains(@href,'update')]
    ${permissionCount}=    Get Element Count    ${yves_company_role_permission_toggle_button}
    ${counter}=    Set Variable    1
    WHILE    ${counter} <= ${permissionCount}
        Wait Until Element Is Visible    xpath=(//a[contains(@class,"switch") and not (contains(@class,'switch--active'))])[${counter}]
        Click    xpath=(//a[contains(@class,"switch") and not (contains(@class,'switch--active'))])[${counter}]
        ${counter}=    Evaluate    ${counter}+1
    END

Yves: enable/disable role permission:
    [Arguments]    ${role_name}    ${permissionName}    ${state}
    Yves: go to company menu item:    Roles
    Click    xpath=//td[text()='${role_name}']//following-sibling::td[contains(@class,'spacing--reset')]/div/div/a[contains(@href,'update')]
    ${currentState}=    Get Attribute    xpath=//td[text()='${permissionName}']//following-sibling::td//a[contains(@class,'switch')]    class
    IF    'active' not in '${currentState}' and '${state}' == 'activate'
        Click    xpath=//td[text()='${permissionName}']//following-sibling::td//a[contains(@class,'switch')]
    ELSE IF    'active' in '${currentState}' and '${state}' == 'deactivate'
        Click    xpath=//td[text()='${permissionName}']//following-sibling::td//a[contains(@class,'switch')]
    END

Yves: assign/unassign a role to company user:
    [Arguments]    ${userFullName}    ${role_name}    ${condition}
    Yves: go to company menu item:    Users
    Click    xpath=//td[contains(@class,"spacing-top--big")]/strong[contains(text(),'${userFullName}')]//parent::td//following-sibling::td/div/div/a[contains(@href,'update')]
    IF    '${condition}' == 'true' 
        Yves: check checkbox by Label:    ${role_name}
    ELSE IF    '${condition}' == 'false' 
        Yves: uncheck checkbox by label:    ${role_name}
    END
    ${yves_company_user_submit}

Yves: delete a company role:
    [Arguments]    ${role_name}
    Yves: go to company menu item:    Roles
    Click    xpath=//td[text()='${role_name}']//following-sibling::td[contains(@class,'spacing--reset')]/div/div/a[contains(@href,'delete')]
    Wait Until Element Is Visible    ${yves_company_role_delete_button}
    Click    ${yves_company_role_delete_button}
    Yves: flash message 'should' be shown

Yves: check the user info of company users:
   [Arguments]    ${company_user_first_name}    ${bu_name}   
   Page Should Contain Element    xpath=//td[@data-content='Name']/*[contains(text(),'${company_user_first_name}')]//parent::td//following-sibling::td[@data-content="Business unit" and contains(text(),'${bu_name}')]
    
Yves: check the business unit info of company:
    [Arguments]    ${businessUnit}
    Yves: go to company menu item:    Business Units
    Page Should Contain Element    xpath=//span[@class="business-unit-chart-item__name" and text()='${businessUnit}']