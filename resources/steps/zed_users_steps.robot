*** Settings ***
Resource   ../pages/zed/zed_delete_user_confirmation_page.robot
Resource   ../common/common_zed.robot
Resource   ../common/common.robot
 
*** Variables ***
${user_email_field_locator}    id=user_username
${user_password_field_locator}    id=user_password_first
${user_repeat_password_field_locator}    id=user_password_second
${user_first_name_field_locator}    id=user_first_name
${user_last_name_field_locator}    id=user_last_name
${root_group_checkbox_locator}    xpath=//input[@name="user[group][]"]
${agent_checkbox_locator}    xpath=//input[@name="user[is_agent]"]
${interface_language_dropdown_locator}    id=user_fk_locale
 
*** Keywords ***
Zed: delete Zed user with the following email:
   [Arguments]    ${zed_email}
   ${currentURL}=    Get Location
   IF    '/user' not in '${currentURL}'    Zed: go to second navigation item level:    Users    Users
   Zed: click Action Button in a table for row that contains:    ${zed_email}    Delete
   Wait Until Page Contains Element    ${zed_confirm_delete_user_button}
   Click    ${zed_confirm_delete_user_button}
 
Zed: Add new users in with following email:
   [Arguments]    @{args}
   ${userdata}=    Set Up Keyword Arguments    @{args}
   FOR    ${key}    ${value}    IN    &{userdata}
       Log    Key is '${key}' and value is '${value}'.
       IF    '${key}'=='Email' and '${value}' != '${EMPTY}'    Type Text    ${user_email_field_locator}    ${value}
       IF    '${key}'=='Password' and '${value}' != '${EMPTY}'    Type Text    ${user_password_field_locator}    ${value}
       IF    '${key}'=='Repeat password' and '${value}' != '${EMPTY}'    Type Text    ${user_repeat_password_field_locator}    ${value}
       IF    '${key}'=='First name' and '${value}' != '${EMPTY}'     Type Text    ${user_first_name_field_locator}    ${value}
       IF    '${key}'=='Last name' and '${value}' != '${EMPTY}'     Type Text    ${user_last_name_field_locator}    ${value}
   END
   Check Checkbox    ${root_group_checkbox_locator}
   Check Checkbox    ${agent_checkbox_locator}
   Zed: select interface language:    en_US
Zed: select interface language:
   [Arguments]    ${interface_language}
   IF    '${interface_language}' == 'en_US'
       Select From List By Label    id=user_fk_locale    en_US
   ELSE
       Select From List By Label    id=user_fk_locale    de_DE
   END
Zed: validation of translation:
   [Documentation]    ${type} can be: EN,DE
   [Arguments]    ${type}   
   IF    '${type}' == 'EN'
       ${text}    Get Text    //span[@class="m-r-sm text-muted welcome-message"]
   Should Be Equal As Strings    ${text}     Welcome abcd wxyz [docker.dev]
   END
   IF  '${type}' == 'DE' 
       ${text}    Get Text    //span[@class="m-r-sm text-muted welcome-message"]
       Should Be Equal As Strings    ${text}     Willkommen abcd wxyz [docker.dev]
   END