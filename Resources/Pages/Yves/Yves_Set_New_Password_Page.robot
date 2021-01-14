*** Settings ***
Resource          ../../../../Global_Keywords_and_Variables/Common.robot

*** Variables ***
${new_password_field}   id=restoreForm_password_pass
${confirm_new_password_field}      id=restoreForm_password_confirm
${new_password_submit_button}    xpath=//form[@name='restoreForm']//*[contains(@class,'button')][@type='submit']

*** Keywords ***
Yves: set new password on Restore Password page
    wait until element is visible  ${new_password_field}
    Input text into field  ${new_password_field}   ${default_password}
    Input text into field  ${confirm_new_password_field}   ${default_password}
    Scroll and Click Element  ${new_password_submit_button}
    wait until page does not contain element  ${new_password_submit_button}