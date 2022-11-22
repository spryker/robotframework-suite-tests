*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_mp.robot
Resource    ../pages/mp/mp_order_drawer.robot

*** Keywords ***
MP: wait for order to appear:
    [Arguments]    ${orderReference}
    Sleep    60s
    MP: perform search by:    ${orderReference}
    Table Should Contain    ${mp_items_table}     ${orderReference}
 
MP: order grand total should be:
    [Arguments]    ${expectedTotal}
    Wait Until Element Is Visible    ${order_grand_total}
    Element Text Should Be    ${order_grand_total}    ${expectedTotal}

MP: order state on drawer should be:
    [Arguments]    ${expectedState}
    Wait Until Element Is Visible    ${order_state_label_on_drawer}
    Element Text Should Be    ${order_state_label_on_drawer}    ${expectedState}

MP: update order state using header button:
    [Arguments]    ${buttonName}
    Wait Until Element Is Enabled    xpath=//div[@class='mp-manage-order__transitions']//button[contains(text(),'${buttonName}')]
    Click    xpath=//div[@class='mp-manage-order__transitions']//button[contains(text(),'${buttonName}')]
    Wait Until Element Is Visible    xpath=//span[text()='The state is updated successfully.']
    Wait Until Element Is Not Visible    xpath=//span[text()='The state is updated successfully.']

