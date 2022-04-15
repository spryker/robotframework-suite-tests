*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_zed.robot
Resource    ../pages/yves/yves_return_slip_page.robot
Resource    ../pages/zed/zed_create_return_page.robot
Resource    ../pages/zed/zed_return_details_page.robot

*** Keywords ***
Zed: trigger all matching states inside xxx order:
    [Arguments]    ${orderID}    ${status}
    Zed: go to second navigation item level:    Sales    Orders
    Zed: perform search by:    ${orderID}
    Zed: click Action Button in a table for row that contains:    ${orderID}    View
    Zed: trigger all matching states inside this order:    ${status}

Zed: trigger all matching states inside this order:
    [Arguments]    ${status}
    Reload
    FOR    ${index}    IN RANGE    0    21
        ${order_state_reached}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']
        Run Keyword If    '${order_state_reached}'=='False'    Run Keywords    Sleep    3s    AND    Reload
        ...    ELSE    Exit For Loop
    END
    Click    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']
    ${order_changed_status}=    Run Keyword And Ignore Error    Element Should Not Be Visible    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']
    Run Keyword If    'FAIL' in ${order_changed_status}    Run Keywords
    ...    Reload
    ...    AND    Click    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']

Zed: trigger matching state of order item inside xxx shipment:
    [Arguments]    ${sku}    ${event}    ${shipment}=1
    FOR    ${index}    IN RANGE    0    21
        ${order_state_reached}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//td/div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr/td[last()]/form//button[contains(text(),'${event}')]
        Run Keyword If    '${order_state_reached}'=='False'    Run Keywords    Sleep    3s    AND    Reload
        ...    ELSE    Exit For Loop
    END
    Click    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//td/div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr/td[last()]/form//button[contains(text(),'${event}')]
    ${order_changed_status}=    Run Keyword And Ignore Error    Element Should Not Be Visible    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//td/div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr/td[last()]/form//button[contains(text(),'${event}')]
    Run Keyword If    'FAIL' in ${order_changed_status}    Run Keywords
    ...    Reload
    ...    AND    Click    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//td/div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr/td[last()]/form//button[contains(text(),'${event}')]

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
