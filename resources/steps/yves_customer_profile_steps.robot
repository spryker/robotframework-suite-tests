*** Settings ***
Resource    ../common/common.robot
Resource    ../pages/yves/yves_customer_account_page.robot
Resource    ../../resources/common/common.robot
Resource    ../steps/customer_account_steps.robot
Resource    ../common/common_yves.robot
Resource    ../pages/yves/yves_customer_profile_page.robot

*** Keywords ***
Yves: reset login credentials for user:
    [Arguments]    ${email}    ${old_password}    ${new_password}
    Yves: go to user menu item in header:    My Profile
    Type Text    ${customer_profile_email_field}   ${email}
    Click    ${customer_profile_submit_button}
    Type Text    ${customer_profile_old_password_field}     ${old_password} 
    Type Text    ${customer_profile_new_password_field}    ${new_password}
    Type Text    ${customer_profile_confirm_password_field}   ${new_password}
    Click    ${customer_profile_password_reset_submit_button} 

Yves: delete the customer
    Yves: go to user menu item in header:    My Profile
    Click   ${customer_profile_delete_button} 
    Click    ${customer_profile_confirm_delete_button} 

Yves: validate profile section:
    [Arguments]    ${f_name}    ${l_name}    ${user_email}
    Yves: go to user menu item in header:    My Profile
    Element Text Should Be     ${customer_profile_first_name}    ${f_name}
    Element Text Should Be     ${customer_profile_last_name}    ${l_name}
    Element Text Should Be     ${customer_profile_email_field}    ${user_email}

Yves: edit profile details of user:
    [Arguments]    ${first_name}    ${last_name}    ${email}
    Type Text    ${customer_profile_first_name}    ${first_name}
    Type Text    ${customer_profile_last_name}    ${last_name}
    Type Text    ${customer_profile_email_field}    ${email}
    Click    ${customer_profile_submit_button}   