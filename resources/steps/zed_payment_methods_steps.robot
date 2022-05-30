*** Settings ***
Library    String
Resource    ../pages/zed/zed_payment_methods_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Keywords ***
Zed: wait for payment method:
    [Arguments]    ${provider}    ${name}
    Try reloading page until element is/not appear:    xpath=//table//tr/td[text()='${provider}']/../td[text()='${name}']/..//a[contains(@class,'btn-edit')]    true    20    10s

Zed: activate/deactivate payment method:
    [Arguments]    ${provider}    ${name}    ${activate}=${TRUE}    ${stores}=DE,AT
    Zed: go to second navigation item level:    Administration    Payment Methods
    Zed: wait for payment method:    ${provider}    ${name}
    Click    xpath=//table//tr/td[text()='${provider}']/../td[text()='${name}']/..//a[contains(@class,'btn-edit')]
    IF    ${activate}
        Zed: check checkbox by label:    Is the Payment Method active?
    ELSE
        Zed: uncheck checkbox by label:    Is the Payment Method active?
    END
    Zed: go to tab:    Store Relation
    ${storesList}=    split string    ${stores}    ,
    ${storesListLength}=    get length    ${storesList}
    FOR    ${index}    IN RANGE    0    ${storesListLength}
        ${store}=    get from list    ${storesList}    ${index}
        IF    ${activate}
            Zed: check checkbox by label:    ${store}
        ELSE
            Zed: uncheck checkbox by label:    ${store}
        END
    END
    Zed: submit the form
    Zed: flash message should be shown:    success
