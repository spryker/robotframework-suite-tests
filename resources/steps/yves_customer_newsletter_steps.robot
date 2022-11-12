*** Settings ***
Resource    ../common/common.robot
Resource    ../../resources/common/common.robot
Resource    ../steps/customer_account_steps.robot
Resource    ../common/common_yves.robot
Resource    ../pages/yves/yves_newsletter_page.robot

*** Keywords ***
Yves: subscribe to newsletter
    Yves: go to user menu item in the left bar:    Newsletter
    Check Checkbox    ${newletter_checkbox}
    Click    ${newsletter_subscription_checkbox}

Yves: newletters confirmation:
    [Arguments]    ${email}
    Save the result of a SELECT DB query to a variable:    select email from spy_newsletter_subscriber where email = '${email}'    user_email
    Should Not Be Empty    ${user_email}