*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_zed.robot
Resource    ../pages/yves/yves_return_slip_page.robot
Resource    ../pages/zed/zed_create_return_page.robot
Resource    ../pages/zed/zed_return_details_page.robot
Resource    ../steps/order_history_steps.robot
Resource    ../pages/zed/zed_order_details_page.robot

*** Keywords ***
Zed: go to order page:
    [Arguments]    ${orderID}
    Zed: go to second navigation item level:    Sales    Orders
    Zed: click Action Button in a table for row that contains:    ${orderID}    View

Zed: go to my order page:
    [Documentation]    Marketplace specific method, to see this page you should be logged in as zed_spryker_merchant_admin_email
    [Arguments]    ${orderID}
    Zed: go to second navigation item level:    Sales    My Orders
    Zed: perform search by:    ${orderID}
    Try reloading page until element is/not appear:    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${orderID}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]    true    15    10s
    Zed: click Action Button in a table for row that contains:    ${orderID}    View

Zed: trigger all matching states inside xxx order:
    [Arguments]    ${orderID}    ${status}
    Zed: go to order page:    ${orderID}
    Zed: trigger all matching states inside this order:    ${status}

Zed: trigger all matching states inside this order:
    [Arguments]    ${status}    ${delay}=3s    ${iterations}=21
    Reload
    FOR    ${index}    IN RANGE    0    ${iterations}
        ${order_state_reached}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']
        IF    '${order_state_reached}'=='False'
            Run Keywords    Sleep    ${delay}    AND    Reload
        ELSE
            Exit For Loop
        END
        IF    ${index} == ${iterations}-1
            Scroll Element Into View    xpath=(//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'])[1]
            Take Screenshot
            ${order_state}=    Get Text    xpath=(//div[@id='order-overview']//form[@name='oms_trigger_form'])[1]
            Fail    Expected order state transition '${status}' is not available. Only '${order_state}' is available. Check if OMS is functional
        END
    END
    Click    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']
    ${order_changed_status}=    Run Keyword And Ignore Error    Element Should Not Be Visible    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']    timeout=1s
    IF    'FAIL' in ${order_changed_status}
            Reload
            Click    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']
    END
    ${order_changed_status}=    Run Keyword And Ignore Error    Element Should Not Be Visible    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']    timeout=1s
    IF    'FAIL' in ${order_changed_status}
            ${order_state}=    Get Text    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']
            Scroll Element Into View    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']
            Take Screenshot
            Fail    Order stuck in '${order_state}' state. Check if OMS is functional
    END

Zed: trigger matching state of xxx merchant's shipment:
    [Documentation]    Marketplace specific method, suitable for My Orders of merchant. Triggers action for whole shipment
    [Arguments]    ${shipment_number}    ${event}    ${delay}=10s    ${iterations}=20
    ${elementSelector}=    Set Variable    xpath=//div[@id='items']//h3[contains(.,'Shipment ${shipment_number}')]/../../following-sibling::div[2]//form[@name='event_trigger_form']//button[@id='event_trigger_form_submit'][text()='${event}']
    ${shipment_available_transitions_count}=    Get Element Count    xpath=//div[@id='items']//h3[contains(.,'Shipment ${shipment_number}')]/../../following-sibling::div[2]//form[@name='event_trigger_form']//button[@id='event_trigger_form_submit']
    ${shipment_available_transitions}=    Create List
    Set Browser Timeout    1s
    FOR    ${index}    IN RANGE    1    ${shipment_available_transitions_count}+1
        ${shipment_available_transition}=    Get Text    xpath=(//div[@id='items']//h3[contains(.,'Shipment ${shipment_number}')]/../../following-sibling::div[2]//form[@name='event_trigger_form']//button[@id='event_trigger_form_submit'])[${index}]
        Append To List    ${shipment_available_transitions}    ${shipment_available_transition}
    END
    Set Browser Timeout    ${browser_timeout}
    ${shipment_available_transitions}=    Convert To String    ${shipment_available_transitions}
    Try reloading page until element is/not appear:    ${elementSelector}    true    ${iterations}    ${delay}    message=Expected shipment state transition '${event}' for shipment# '${shipment_number}' is not available. Only '${shipment_available_transitions}' is/are available. Check if OMS is functional
    Click    ${elementSelector}
    ${order_changed_status}=    Run Keyword And Ignore Error    Element Should Not Be Visible    ${elementSelector}    timeout=1s
    IF    'FAIL' in ${order_changed_status}
            Reload
            Click    ${elementSelector}
    END
    ${order_changed_status}=    Run Keyword And Ignore Error    Element Should Not Be Visible    ${elementSelector}    timeout=1s
    IF    'FAIL' in ${order_changed_status}
            ${order_state}=    Get Text    ${elementSelector}
            Scroll Element Into View    ${elementSelector}
            Take Screenshot
            Fail    Order stuck in '${order_state}' state. Check if OMS is functional
    END

Zed: trigger matching state of order item inside xxx shipment:
    [Arguments]    ${sku}    ${event}    ${shipment}=1    ${delay}=10s    ${iterations}=20
    IF    '${env}' in ['ui_mp_b2b','ui_mp_b2c']
        ${elementSelector}=    Set Variable    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr//td/form[@name='event_item_trigger_form']//button[contains(text(),'${event}')]
    ELSE
        ${elementSelector}=    Set Variable    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//td/div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr/td/form[@class='oms-trigger-form']//button[contains(text(),'${event}')] 
    END   
    IF    '${env}' in ['ui_mp_b2b','ui_mp_b2c']
        ${item_available_transition_selector}=    Set Variable    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr//td/form[@name='event_item_trigger_form']//button
    ELSE
        ${item_available_transition_selector}=    Set Variable    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//td/div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr/td/form[@class='oms-trigger-form']//button
    END   
    ${item_available_transitions_count}=    Get Element Count    ${item_available_transition_selector}
    ${item_available_transitions}=    Create List
    Set Browser Timeout    1s
    FOR    ${index}    IN RANGE    1    ${item_available_transitions_count}+1
        IF    '${env}' in ['ui_mp_b2b','ui_mp_b2c']
            ${item_available_transition}=    Get Text    xpath=(//table[@data-qa='order-item-list'][${shipment}]/tbody//td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr//td/form[@name='event_item_trigger_form']//button)[${index}]
        ELSE
            ${item_available_transition}=    Get Text    xpath=(//table[@data-qa='order-item-list'][${shipment}]/tbody//td/div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr/td/form[@class='oms-trigger-form']//button)[${index}]
        END
        Append To List    ${item_available_transitions}    ${item_available_transition}
    END
    Set Browser Timeout    ${browser_timeout}
    ${item_available_transition}=    Convert To String    ${item_available_transition}
    Try reloading page until element is/not appear:    ${elementSelector}    true    ${iterations}    ${delay}    message=Expected item state transition '${event}' for item '${sku}' is not available. Only '${item_available_transitions}' is/are available. Check if OMS is functional
    Click    ${elementSelector}
    ${order_changed_status}=    Run Keyword And Ignore Error    Element Should Not Be Visible    ${elementSelector}    timeout=1s
    IF    'FAIL' in ${order_changed_status}
            Reload
            Click    ${elementSelector}
    END
    ${order_changed_status}=    Run Keyword And Ignore Error    Element Should Not Be Visible    ${elementSelector}    timeout=1s
    IF    'FAIL' in ${order_changed_status}
            ${order_item_state}=    Get Text    ${elementSelector}
            Scroll Element Into View    ${elementSelector}
            Take Screenshot
            Fail    Order item stuck in '${order_item_state}' state. Check if OMS is functional
    END

Zed: trigger matching state of xxx order item inside xxx shipment:
    [Arguments]    ${event}    ${item_number}=1    ${shipment}=1    ${delay}=10s    ${iterations}=20
    ${elementSelector}=    Set Variable    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//tr[${item_number}]//td//form[contains(@name,'trigger_form')]//button[contains(text(),'${event}')]
    ${item_available_transitions_count}=    Get Element Count    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//tr[${item_number}]//td//form[contains(@name,'trigger_form')]//button
    ${item_available_transitions}=    Create List
    Set Browser Timeout    1s
    FOR    ${index}    IN RANGE    1    ${item_available_transitions_count}+1
        ${item_available_transition}=    Get Text    xpath=(//table[@data-qa='order-item-list'][${shipment}]/tbody//tr[${item_number}]//td//form[contains(@name,'trigger_form')]//button)[${index}]
        Append To List    ${item_available_transitions}    ${item_available_transition}
    END
    Set Browser Timeout    ${browser_timeout}
    ${item_available_transitions}=    Convert To String    ${item_available_transitions}
    Try reloading page until element is/not appear:    ${elementSelector}    true    ${iterations}    ${delay}    message=Expected item state transition '${event}' for item number '${item_number}' is not available in shipment# '${shipment}'. Only '${item_available_transitions}' is/are available. Check if OMS is functional
    Click    ${elementSelector}
    ${order_changed_status}=    Run Keyword And Ignore Error    Element Should Not Be Visible    ${elementSelector}    timeout=1s
    IF    'FAIL' in ${order_changed_status}
            Reload
            Click    ${elementSelector}
    END
    ${order_changed_status}=    Run Keyword And Ignore Error    Element Should Not Be Visible    ${elementSelector}    timeout=1s
    IF    'FAIL' in ${order_changed_status}
            ${order_item_state}=    Get Text    ${elementSelector}
            Scroll Element Into View    ${elementSelector}
            Take Screenshot
            Fail    Order item stuck in '${order_item_state}' state. Check if OMS is functional
    END

Zed: wait for order item to be in state:
    [Arguments]    ${sku}    ${state}    ${shipment}=1    ${delay}=10s    ${iterations}=20
    ${elementSelector}=    Set Variable    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//td/div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr/td[@class='state-history']//a[contains(text(),'${state}')]
    Try reloading page until element is/not appear:    ${elementSelector}    true    ${iterations}    ${delay}    message=Expected order item state '${state}' is not available for the item '${sku}'. Check if OMS is functional

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
    Should Be Equal    '${expectedShipments}'    '${actualShipments}'    msg=Expected '${expectedShipments}' number of shipments inside the '${orderID}' order, but got '${actualShipments}'

Zed: return details page contains the following items:
    [Arguments]    @{sku_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    Wait Until Page Contains Element    ${zed_return_details_main_content_locator}
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        Page Should Contain Element    xpath=//table[@data-qa='return-items-table']//td//a[contains(@href,'view/variant')]/../div[@class='sku'][contains(text(),'SKU: ${sku_to_check}')]    message=Return details page doesn't contain '${sku_list}' but should.
    END

Zed: view the latest return from My Returns:
    [Arguments]    ${return_id}
    Zed: click Action Button in a table for row that contains:    ${return_id}    View
    Wait Until Page Contains Element    ${zed_return_details_main_content_locator}

Zed: billing address for the order should be:
    [Arguments]    ${expected_billing_address}
    Wait Until Page Contains Element    ${order_details_billng_address}
    Element Should Contain    ${order_details_billng_address}    ${expected_billing_address}

Zed: shipping address inside xxx shipment should be:
    [Arguments]    ${shipment}    ${expected_address}
    Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/preceding-sibling::div[2]//p[1]    ${expected_address}

Zed: create new shipment inside the order:
    [Arguments]    @{args}
    ${newShipmentData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${create_shipment_button}
    Click    ${create_shipment_button}
    Wait Until Element Is Visible    ${create_shipment_delivery_address_dropdown}
    FOR    ${key}    ${value}    IN    &{newShipmentData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='delivert address' and '${value}' != '${EMPTY}'    Select From List By Label    ${create_shipment_delivery_address_dropdown}    ${value}
        IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    ${create_shipment_salutation_dropdown}    ${value}
        IF    '${key}'=='first name' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_first_name_field}    ${value}
        IF    '${key}'=='last name' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_last_name_field}    ${value}
        IF    '${key}'=='email' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_email_field}    ${value}
        IF    '${key}'=='country' and '${value}' != '${EMPTY}'    Select From List By Label    ${create_shipment_country_dropdown}    ${value}
        IF    '${key}'=='address 1' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_address_1_field}    ${value}
        IF    '${key}'=='address 2' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_address_2_field}    ${value}
        IF    '${key}'=='city' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_city_field}    ${value}
        IF    '${key}'=='zip code' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_zip_code_field}    ${value}
        IF    '${key}'=='shipment method' and '${value}' != '${EMPTY}'    Select From List By Label    ${create_shipment_shipment_method}    ${value}
        IF    '${key}'=='requested delivery date' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_requested_delivery_date}    ${value}
        IF    '${key}'=='sku' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
        IF    '${key}'=='sku 2' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
        IF    '${key}'=='sku 3' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
        IF    '${key}'=='sku 4' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
        IF    '${key}'=='sku 5' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
    END
    Zed: submit the form
    Wait Until Element Is Visible    ${order_details_billng_address}

Zed: edit xxx shipment inside the order:
    [Arguments]    @{args}
    ${newShipmentData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    xpath=(//div[@class='ibox-content']//a[contains(@href,'shipment-gui/edit')])[${shipmentN}]
    Click    ${create_shipment_button}
    Wait Until Element Is Visible    ${create_shipment_delivery_address_dropdown}
    FOR    ${key}    ${value}    IN    &{newShipmentData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='delivert address' and '${value}' != '${EMPTY}'    Select From List By Label    ${create_shipment_delivery_address_dropdown}    ${value}
        IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    ${create_shipment_salutation_dropdown}    ${value}
        IF    '${key}'=='first name' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_first_name_field}    ${value}
        IF    '${key}'=='last name' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_last_name_field}    ${value}
        IF    '${key}'=='email' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_email_field}    ${value}
        IF    '${key}'=='country' and '${value}' != '${EMPTY}'    Select From List By Label    ${create_shipment_country_dropdown}    ${value}
        IF    '${key}'=='address 1' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_address_1_field}    ${value}
        IF    '${key}'=='address 2' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_address_2_field}    ${value}
        IF    '${key}'=='city' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_city_field}    ${value}
        IF    '${key}'=='zip code' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_zip_code_field}    ${value}
        IF    '${key}'=='shipment method' and '${value}' != '${EMPTY}'    Select From List By Label    ${create_shipment_shipment_method}    ${value}
        IF    '${key}'=='requested delivery date' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_requested_delivery_date}    ${value}
        IF    '${key}'=='sku' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
        IF    '${key}'=='sku 2' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
        IF    '${key}'=='sku 3' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
        IF    '${key}'=='sku 4' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
        IF    '${key}'=='sku 5' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
    END
    Zed: submit the form
    Wait Until Element Is Visible    ${order_details_billng_address}

Zed: shipment data inside xxx shipment should be:
    [Arguments]    @{args}
    ${shipmentData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{shipmentData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='shipment n' and '${value}' != '${EMPTY}'    
        ${shipment}=    Set Variable    ${value}
        END
        IF    '${key}'=='shipment n' and '${value}' == '${EMPTY}'    
        ${shipment}=    Set Variable    1
        END
        IF    '${key}'=='delivery method' and '${value}' != '${EMPTY}'    Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/preceding-sibling::div[2]//p[2]    ${value}
        IF    '${key}'=='shipping method' and '${value}' != '${EMPTY}'    Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/preceding-sibling::div[2]//p[3]    ${value}
        IF    '${key}'=='shipping costs' and '${value}' != '${EMPTY}'    Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/preceding-sibling::div[2]//p[4]    ${value}
        IF    '${key}'=='requested delivery date' and '${value}' != '${EMPTY}'    Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/preceding-sibling::div[2]//p[5]    ${value}
    END

Zed: xxx shipment should/not contain the following products:
    [Arguments]    ${shipment}    ${condition}    @{sku_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        IF    '${condition}' == 'true'
            Table Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]    ${sku_to_check}
        END
        IF    '${condition}' == 'false'
            Table Should Not Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]    ${sku_to_check}
        END
    END

Yves: cancel the order:
    [Arguments]    ${order_id}
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${order_id}
    Wait Until Element Is Visible    ${order_details_cancel_button_locator}
    Set Browser Timeout    3s
    TRY
        Click    ${order_details_cancel_button_locator}
        Wait Until Element Is Not Visible    ${order_details_cancel_button_locator}    timeout=5s
    EXCEPT    
        Click    ${order_details_cancel_button_locator}
        Wait Until Element Is Not Visible    ${order_details_cancel_button_locator}    timeout=5s
    END    
    Set Browser Timeout    ${browser_timeout}
    Yves: go to 'Order History' page
    Yves: 'Order History' page contains the following order with a status:    ${order_id}    Canceled