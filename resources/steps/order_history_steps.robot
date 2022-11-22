*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_yves.robot
Resource    ../steps/header_steps.robot
Resource    ../steps/customer_account_steps.robot
Resource    ../pages/yves/yves_order_history_page.robot
Resource    ../pages/yves/yves_order_details_page.robot

*** Keywords ***
Yves: go to 'Order History' page
    Yves: go to 'Customer Account' page
   IF   '${env}' in ['b2c','mp_b2c']
       Yves: go to user menu item in the left bar:    Orders History
   ELSE
       Yves: go to user menu item in the left bar:    Order History
   END
    
Yves: 'View Order/Reorder/Return' on the order history page:
    [Arguments]    ${orderAction}    ${lastPlacedOrder}
    IF    '${orderAction}' == 'View Order'
        Click   xpath=//div[contains(@data-qa,'component order-table')]//td[text()='${lastPlacedOrder}']/..//a[contains(.,'${orderAction}')]
    ELSE IF    '${orderAction}' == 'Reorder'
        Click    xpath=//div[contains(@data-qa,'component order-table')]//td[text()='${lastPlacedOrder}']/..//a[contains(.,'${orderAction}')]
    ELSE IF    '${orderAction}' == 'Return'
        Click    xpath=//div[contains(@data-qa,'component order-table')]//td[text()='${lastPlacedOrder}']/..//a[contains(.,'${orderAction}')]
    END

Yves: reorder all items from 'View Order' page
    Wait Until Element Is Visible    ${order_details_reorder_all_button}
    Click    ${order_details_reorder_all_button}
    Yves: remove flash messages

Yves: shipping address on the order details page is:
    [Arguments]    ${expectedShippingAddress}
    ${actualShippingAddress}=    Get Text    ${order_details_shipping_address_locator}
    ${actualShippingAddress}=    Replace String    ${actualShippingAddress}    \n    ${SPACE}
    Should Be Equal    ${expectedShippingAddress}    ${actualShippingAddress}

Yves: 'Order Details' page contains the following product title N times:
    [Arguments]    ${productTitle}    ${expectedQuantity}
    Wait Until Page Contains Element    xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']//div[@data-qa='component order-detail-table']
    ${productTitleCount}=    Get Element Count    xpath=//div[@data-qa='component order-detail-table']//article//*[contains(@class,'title')][text()='${productTitle}']
    ${productTitleCount}=    Convert To String    ${productTitleCount}
    Log    ${productTitleCount}
    Should Be Equal    ${productTitleCount}    ${expectedQuantity}

Yves: 'Order History' page contains the following order with a status:
    [Arguments]    ${orderID}    ${expectedStatus}
    ${actualOrderStatus}=    Get Text    xpath=//div[contains(@data-qa,'component order-table')]//td[text()='${orderID}']/..//span[@data-qa='component status']
    Should Be Equal    ${actualOrderStatus}    ${expectedStatus}    msg=None    values=True    ignore_case=True    formatter=str
