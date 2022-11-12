*** Settings ***
Resource  ../common/common_zed.robot
Resource  ../common/common.robot
Resource  ../../resources/common/common_yves.robot
Resource  ../../resources/pages/zed/zed_shipment_page.robot
Resource  ../../resources/pages/zed/zed_order_shipment_page.robot
Resource  ../../resources/pages/zed/zed_order_details_page.robot

*** Keywords ***
Zed: edit order shipment:
    [Arguments]    ${lastPlacedOrder}
    Zed: click Action Button(without search) in a table for row that contains:    ${lastPlacedOrder}    View 
    Click    ${edit_shipment_button}

Zed: create a new shipment for order:
    [Arguments]    ${lastPlacedOrder}
    Zed: click Action Button(without search) in a table for row that contains:    ${lastPlacedOrder}    View 
    Click    ${create_shipment_button}

Zed: enter shipment details for order: 
    [Arguments]    @{args}          
    ${registrationData}=    Set Up Keyword Arguments    @{args}
    Select From List By Label    ${delivery_address_shipment_page}    New address    
    FOR    ${key}    ${value}    IN    &{registrationData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='fname'    Type Text    ${shipment_address_first_name}    ${value}
        IF    '${key}'=='lname'    Type Text    ${shipment_address_last_name}    ${value}
        IF    '${key}'=='email'    Type Text    ${shipment_address_email}    ${value}
        IF    '${key}'=='address1'    Type Text    ${shipment_address_address1}     ${value}
        IF    '${key}'=='address2'    Type Text    ${shipment_address_address2}     ${value}
        IF    '${key}'=='city'    Type Text    ${shipment_address_city}     ${value}
        IF    '${key}'=='zipcode'    Type Text    ${shipment_address_zipcode}     ${value}
        IF    '${key}'=='salutation'    Select From List By Value    ${salutation_shipment_page}    ${value}
        IF    '${key}'== 'country'        Select From List By Text    ${country_create_new_shipment_page}    ${value}  
        IF    '${key}'== 'shipmentmethod'        Select From List By Text    ${shipment_method_dropdown}    ${value}  
    END
    Zed: submit the form
    Zed: flash message should be shown:    success