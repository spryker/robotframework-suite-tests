*** Settings ***
Resource    ../Common/Common.robot

*** Keywords ***
Yves: set new password on Restore Password page
    wait until element is visible  ${new_password_field}
    Type Text  ${new_password_field}   ${default_password}
    Type Text  ${confirm_new_password_field}   ${default_password}
    Click  ${new_password_submit_button}
    wait until page does not contain element  ${new_password_submit_button}