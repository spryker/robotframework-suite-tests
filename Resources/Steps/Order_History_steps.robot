*** Settings ***
Resource    ../Pages/Yves/Yves_Order_History_page.robot
Resource    ../Pages/Yves/Yves_View_Order_page.robot

*** Keywords ***
Yves: 'View Order/ Reorder' on the order history page: 
    [Arguments]    ${orderAction}    ${lastPlacedOrder}
    Run Keyword If    '${orderAction}' == 'View Order'    Click element   xpath=//div[contains(@data-qa,'component order-table')]//td[@data-content='Order Id'][text()='${lastPlacedOrder}']/..//*[@data-qa='component table-action-list']//a[contains(.,'${orderAction}')]
    ...    ELSE IF    '${orderAction}' == 'Reorder'    Click element    xpath=//div[contains(@data-qa,'component order-table')]//td[@data-content='Order Id'][text()='${lastPlacedOrder}']/..//*[@data-qa='component table-action-list']//a[contains(.,'${orderAction}')]


Yves: reorder all items from 'View Order' page
    Click Element    ${view_order_reorder_all_button}
    Wait For Document Ready    
    Yves: remove flash messages
    