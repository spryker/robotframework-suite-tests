*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../../resources/common/common_yves.robot
Resource    ../../resources/pages/zed/zed_shipment_page.robot

*** Keywords ***
Zed: edit shipment
    Hover    ${view_order_last_placed} 
    Click    ${view_order_last_placed} 
    Click    ${edit_shipment_button} 
    Select From List By Label    ${delivery_address_edit_shipment_page}    New address
    Zed: new shipment for orders details:
    ...    || fname                             | lname                    |    email                                 |    address1              |    address2              |    city        |    zipcode     ||
    ...    || ${yves_user_first_name}${random}  | ${yves_user_last_name}   |    ${yves_user_email}${random}           |    address1+${random}    |    address2+${random}    |    Berlin      |    11${random} ||
    Input Text    ${shipment_address_address1}    aaa11
    Select From List By Text    ${shipment_method_dropdown}    DHL - Express
    Wait Until Element Is Visible    ${save_button_edit_shipment_page}
    Click    ${save_button_edit_shipment_page}
Zed: create shipment 
    Hover    ${view_order_last_placed} 
    Click    ${view_order_last_placed} 
    Click    ${create_shipment_button}
    Zed: new shipment for orders details:
    ...    || fname                             | lname                    |    email                                 |    address1              |    address2              |    city        |    zipcode     ||
    ...    || ${yves_user_first_name}${random}  | ${yves_user_last_name}   |    ${yves_user_email}${random}           |    address1+${random}    |    address2+${random}    |    Berlin      |    11${random} ||
    Input Text    ${shipment_address_address1}    aaa11
    Wait Until Element Is Visible    ${save_button_new_shipment_page}
    Click    ${save_button_new_shipment_page}
Zed: new shipment for orders details:
    [Arguments]    @{args}
    ${registrationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{registrationData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='fname'    Type Text    ${shipment_address_first_name}    ${value}
        IF    '${key}'=='lname'    Type Text    ${shipment_address_last_name}    ${value}
        IF    '${key}'=='email'    Type Text    ${shipment_address_email}    ${value}
        IF    '${key}'=='Address1'    Type Text    ${shipment_address_address1}     ${value}
        IF    '${key}'=='address2'    Type Text    ${shipment_address_address2}     ${value}
        IF    '${key}'=='city'    Type Text    ${shipment_address_city}     ${value}
        IF    '${key}'=='zipcode'    Type Text    ${shipment_address_zipcode}     ${value}
    END
    Select From List By Value    ${salutation_create_new_shipment_page}    Mr
    Select From List By Index    ${country_create_new_shipment_page}    4    
    Select From List By Text    ${shipment_method_dropdown_new_shipment_page}    DHL - Express