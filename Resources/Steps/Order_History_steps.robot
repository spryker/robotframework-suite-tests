*** Settings ***
Library    String
Library    BuiltIn
Resource    ../Pages/Yves/Yves_Order_History_page.robot
Resource    ../Pages/Yves/Yves_Order_Details_page.robot

*** Keywords ***
Yves: 'View Order/ Reorder' on the order history page: 
    [Arguments]    ${orderAction}    ${lastPlacedOrder}
    Run Keyword If    '${orderAction}' == 'View Order'    Click element   xpath=//div[contains(@data-qa,'component order-table')]//td[@data-content='Order Id'][text()='${lastPlacedOrder}']/..//*[@data-qa='component table-action-list']//a[contains(.,'${orderAction}')]
    ...    ELSE IF    '${orderAction}' == 'Reorder'    Click element    xpath=//div[contains(@data-qa,'component order-table')]//td[@data-content='Order Id'][text()='${lastPlacedOrder}']/..//*[@data-qa='component table-action-list']//a[contains(.,'${orderAction}')]

Yves: reorder all items from 'View Order' page
    Click Element    ${order_details_reorder_all_button}
    Wait For Document Ready    
    Yves: remove flash messages

Yves: shipping address on the order details page is:
    [Arguments]    ${expectedShippingAddress}
    ${actualShippingAddress}=    Get Text    ${order_details_shipping_address_locator}
    ${actualShippingAddress}=    Replace String    ${actualShippingAddress}    \n    ${SPACE}
    Should Be Equal    ${expectedShippingAddress}    ${actualShippingAddress}

Yves: 'Order Details' page contains the following product title N times:
    [Arguments]    ${productTitle}    ${expectedQuantity}
    ${productTitleCount}=    Get Element Count    xpath=//div[@data-qa='component order-detail-table']//article//*[contains(@class,'title')][text()='${productTitle}']
    ${productTitleCount}=    Convert To String    ${productTitleCount}
    Log    ${productTitleCount}
    Should Be Equal    ${productTitleCount}    ${expectedQuantity}