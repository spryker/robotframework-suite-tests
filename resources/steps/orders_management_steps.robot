*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_zed.robot
Resource    ../pages/yves/yves_return_slip_page.robot
Resource    ../pages/zed/zed_create_return_page.robot
Resource    ../pages/zed/zed_return_details_page.robot
Resource    ../steps/order_history_steps.robot

*** Keywords ***
Zed: go to order page:
    [Arguments]    ${orderID}
    Zed: go to second navigation item level:    Sales    Orders
    Zed: perform search by:    ${orderID}
    Zed: click Action Button in a table for row that contains:    ${orderID}    View

Zed: go to my order page:
    [Documentation]    Marketplace specific method, to see this page you should be logged in as zed_spryker_merchant_admin_email
    [Arguments]    ${orderID}
    Zed: go to second navigation item level:    Sales    My Orders
    Zed: perform search by:    ${orderID}
    Try reloading page until element is/not appear:    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${orderID}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]    true    20    30s
    Zed: click Action Button in a table for row that contains:    ${orderID}    View

Zed: trigger all matching states inside xxx order:
    [Arguments]    ${orderID}    ${status}
    Zed: go to order page:    ${orderID}
    Zed: trigger all matching states inside this order:    ${status}

Zed: trigger all matching states inside this order:
    [Arguments]    ${status}
    Reload
    FOR    ${index}    IN RANGE    0    21
        ${order_state_reached}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']
        IF    '${order_state_reached}'=='False'
            Run Keywords    Sleep    3s    AND    Reload
        ELSE
            Exit For Loop
        END
    END
    Click    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']
    ${order_changed_status}=    Run Keyword And Ignore Error    Element Should Not Be Visible    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']
    IF    'FAIL' in ${order_changed_status}
        Run Keywords
           Reload
           Click    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']
    END

Zed: trigger matching state of xxx merchant's shipment:
    [Documentation]    Marketplace specific method, suitable for My Orders of merchant. Triggers action for whole shipment
    [Arguments]    ${shipment_number}    ${event}
    ${elementSelector}=    Set Variable    xpath=//div[@id='items']//h3[contains(.,'Shipment ${shipment_number}')]/../../following-sibling::div[2]//form[@name='event_trigger_form']//button[@id='event_trigger_form_submit'][text()='${event}']
    Try reloading page until element is/not appear:    ${elementSelector}    true    20    10s
    Click    ${elementSelector}
    ${order_changed_status}=    Run Keyword And Ignore Error    Element Should Not Be Visible    ${elementSelector}
    IF    'FAIL' in ${order_changed_status}
        Run Keywords
            Reload
            Click    ${elementSelector}
    END

# Zed: trigger matching state of order item inside merchant's shipment:
#     [Documentation]    Marketplace specific method, suitable for My Orders of merchant. Triggers action for separate item
#     [Arguments]    ${shipment_number}    ${sku}    ${event}
#     ${elementSelector}=    Set Variable    xpath=//table[@data-qa='order-item-list'][${shipment_number}]/tbody//td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr//td/form[@name='event_item_trigger_form']//button[contains(text(),'${event}')]
#     Try reloading page until element is/not appear:    ${elementSelector}    true    20    10s
#     Click    ${elementSelector}
#     ${order_changed_status}=    Run Keyword And Ignore Error    Element Should Not Be Visible    ${elementSelector}
#     IF    'FAIL' in ${order_changed_status}
#         Run Keywords
#             Reload
#             Click    ${elementSelector}
#     END

Zed: trigger matching state of order item inside xxx shipment:
    [Arguments]    ${sku}    ${event}    ${shipment}=1
    IF    '${env}' in ['mp_b2b','mp_b2c']
        ${elementSelector}=    Set Variable    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr//td/form[@name='event_item_trigger_form']//button[contains(text(),'${event}')]
    ELSE
       ${elementSelector}=    Set Variable    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//td/div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr/td/form[@class='oms-trigger-form']//button[contains(text(),'${event}')] 
    END   
    Try reloading page until element is/not appear:    ${elementSelector}    true    20    10s
    Click    ${elementSelector}
    ${order_changed_status}=    Run Keyword And Ignore Error    Element Should Not Be Visible    ${elementSelector}
    IF    'FAIL' in ${order_changed_status}
        Run Keywords
            Reload
            Click    ${elementSelector}
    END

Zed: wait for order item to be in state:
    [Arguments]    ${sku}    ${state}    ${shipment}=1
    ${elementSelector}=    Set Variable    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//td/div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr/td[@class='state-history']//a[contains(text(),'${state}')]
    Try reloading page until element is/not appear:    ${elementSelector}    true    20    10s

Yves: create return for the following products:
    [Arguments]    @{sku_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        Click    xpath=(//form[@name='return_create_form']//div[@data-qa='component return-product-item']//*[contains(text(),'${sku_to_check}')]/ancestor::div[@data-qa='component return-product-item']/../div[contains(@class,'col')]//span[contains(@class,'checkbox')])[1]
    END
    Click    ${create_return_button}[${env}]

Yves: check that 'Print Slip' contains the following products:
    [Arguments]    @{sku_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    Click    ${return_details_print_slip_button}
    Switch Page    NEW
    Wait Until Page Contains Element    ${return_slip_products_table}
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        Table Should Contain    ${return_slip_products_table}    ${sku_to_check}
    END

Zed: create a return for the following order and product in it:
    [Arguments]    ${orderID}    @{sku_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    Zed: go to second navigation item level:    Sales    Orders
    Zed: perform search by:    ${orderID}
    Zed: click Action Button in a table for row that contains:    ${orderID}    View
    Wait Until Page Contains Element    xpath=//div[@class='title-action']/a[contains(.,'Return')]
    Click Element by xpath with JavaScript    //div[@class='title-action']/a[contains(.,'Return')]
    Wait Until Page Contains Element    ${zed_create_return_main_content_locator}
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        Click    xpath=//table[@data-qa='order-item-list']//td/div[contains(text(),'SKU: ${sku_to_check}')]/ancestor::tr//div[@class='checkbox']//input
    END
    Click    ${zed_create_return_button}
    Wait Until Page Contains Element    ${zed_return_details_main_content_locator}

Zed: grand total for the order equals:
    [Arguments]    ${orderID}    ${grandTotal}
    Zed: go to second navigation item level:    Sales    Orders
    Zed: perform search by:    ${orderID}
    Table Should Contain    ${zed_table_locator}  ${grandTotal}

Zed: get the last placed order ID of the customer by email:
    [Documentation]    Returns orderID of the last order from the Backoffice by email
    [Arguments]    ${email}
    Zed: go to second navigation item level:    Sales    Orders
    Zed: perform search by:    ${email}
    ${zedLastPlacedOrder}=    Get Text    xpath=//table[contains(@data-ajax,'sales')][contains(@class,'dataTable')]/tbody/tr[1]/td[2]
    Set Suite Variable    ${zedLastPlacedOrder}    ${zedLastPlacedOrder}
    [Return]    ${zedLastPlacedOrder}

Zed: order has the following number of shipments:
    [Arguments]    ${orderID}    ${expectedShipments}
    Zed: go to second navigation item level:    Sales    Orders
    Zed: perform search by:    ${orderID}
    Zed: click Action Button in a table for row that contains:    ${orderID}    View
    Wait Until Element Is Visible    xpath=//table[@data-qa='order-item-list'][1]
    ${actualShipments}=    Get Element Count    xpath=//table[@data-qa='order-item-list']
    Should Be Equal    '${expectedShipments}'    '${actualShipments}'
