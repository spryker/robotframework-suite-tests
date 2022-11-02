*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Keywords ***
Zed: validating root menus:
    [Arguments]    @{args}
    FOR    ${element}    IN    @{args}
    Zed: go to first navigation item level:    ${element}
    END

Zed: validating root menu icons
    ${counter}=    Set Variable    2
    WHILE  ${counter} <= 12
        Log    ${counter}
        Page should contain element    xpath=//ul[@class='nav metismenu']/li[${counter}]/a[1]/i[1]
        ${counter}=    Evaluate    ${counter} + 1
    END