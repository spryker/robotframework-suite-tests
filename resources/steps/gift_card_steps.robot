*** Settings ***
Library    XML
Resource    ../../resources/common/common.robot
Resource    ../../resources/common/common_yves.robot
Resource    ../../resources/common/common_zed.robot

*** Keywords ***
Yves: get gift card code:
    [Documentation]    Get gift card code from database after purchasing gift card 
    [Arguments]    ${lastPlacedOrder}    ${product_name}
    Save the result of a SELECT DB query to a variable:    select id_sales_order from spy_sales_order where order_reference='${lastPlacedOrder}'    order_id
    Save the result of a SELECT DB query to a variable:    select id_sales_order_item from spy_sales_order_item where fk_sales_order = '${order_id}' and name = '${product_name}'    item_id
    Save the result of a SELECT DB query to a variable:    Select code from spy_sales_order_item_gift_card where fk_sales_order_item = '${item_id}'    gift_card_code
    Set Suite Variable    ${gift_card_code}    ${gift_card_code}
    [Return]    ${gift_card_code}

Yves: check gift card ammount is applied in order details page:
    [Arguments]    ${gift_card_ammount}
    ${grand_total_ammount}=    Get Element Text    ${order_details_grand_total_locator}
    ${invoice_ammount}    Get Element Text    ${order_details_invoice_ammount_locator}
    Element Text Should Be    ${order_details_gift_card_ammount_locator}    ${gift_card_ammount}   
    ${result}    Evaluate    ${grand_total_ammount} - ${gift_card_ammount}
    Should Be Equal As Numbers    ${invoice_ammount}    ${result}
