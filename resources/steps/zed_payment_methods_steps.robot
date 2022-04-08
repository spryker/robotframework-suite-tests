*** Settings ***
Resource    ../pages/zed/zed_payment_methods_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Keywords ***
Zed: wait for payment method:
    [Arguments]    ${provider}    ${name}
    Try reloading page until element is/not appear:    xpath=//table//tr/td[text()='${provider}']/../td[text()='${name}']/..//a[contains(@class,'btn-edit')]    true    20    10s

Zed: activate payment method:
    [Arguments]    ${provider}    ${name}
    Zed: go to second navigation item level:    Administration    Payment Methods
    Zed: wait for payment method:    ${provider}    ${name}
    Click    xpath=//table//tr/td[text()='${provider}']/../td[text()='${name}']/..//a[contains(@class,'btn-edit')]
    Zed: Check checkbox by Label:    Is the Payment Method active?
    Zed: go to tab:    Store Relation
    Zed: Check checkbox by Label:    DE
    Zed: Check checkbox by Label:    AT
    Zed: submit the form
    Element Should Be Visible    xpath=//div[contains(text(), 'Payment method has been successfully updated')]

Zed: deactivate payment method:
    [Arguments]    ${provider}    ${name}
    Zed: wait for payment method:    ${provider}    ${name}
    Click    xpath=//table//tr/td[text()='${provider}']/../td[text()='${name}']/..//a[contains(@class,'btn-edit')]
    Zed: Uncheck checkbox by Label:    Is the Payment Method active?
    Element Should Be Visible    xpath=//div[contains(text(), 'Payment method has been successfully updated')]
