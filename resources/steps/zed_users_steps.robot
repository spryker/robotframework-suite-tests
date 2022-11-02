*** Settings ***
Resource   ../pages/zed/zed_delete_user_confirmation_page.robot
Resource   ../pages/zed/zed_create_zed_user_page.robot
Resource   ../common/common_zed.robot
Resource   ../common/common.robot
 
*** Keywords ***
Zed: delete Zed user with the following email:
   [Arguments]    ${zed_email}
   ${currentURL}=    Get Location
   IF    '/user' not in '${currentURL}'    Zed: go to second navigation item level:    Users    Users
   Zed: click Action Button in a table for row that contains:    ${zed_email}    Delete
   Wait Until Page Contains Element    ${zed_confirm_delete_user_button}
   Click    ${zed_confirm_delete_user_button}
 
Zed: select interface language:
   [Arguments]    ${interface_language}
   IF    '${interface_language}' == 'en_US'
       Select From List By Label    ${zed_user_interface_language}    en_US
   ELSE
       Select From List By Label    ${zed_user_interface_language}    de_DE
   END
   
Zed: validate that the back office content is in:
   [Documentation]    ${locale} can be: EN,DE
   [Arguments]    ${locale}   
   IF    '${locale}' == 'EN'
       Element Should Contain    ${zed_log_out_button}    ${logout_button_en}
   END
   IF  '${locale}' == 'DE' 
       Element Should Contain    ${zed_log_out_button}    ${logout_button_de}
   END