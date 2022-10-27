*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Variables ***
${create_company_button_locator}    xpath=//a[contains(@href,"/shipment-gui/create-carrier/index")]
${create_delivery_method_button_locator}    xpath=//a[contains(@href,"/shipment-gui/create-shipment-method")]
${delivery_method_key_locator}    id=shipment_method_shipmentMethodKey
${name_locator}    id=shipment_method_name
${carrier_dropdown_locator}    id=shipment_method_fkShipmentCarrier
${de_locator}    xpath=//input[@type='checkbox']/../../label[contains(text(),'DE')]//input
${at_locator}    xpath=//input[@type='checkbox']/../../label[contains(text(),'AT')]//input
${is_active_chekbox_locator}    id=shipment_method_isActive
${gross_price_de_chf}    id=shipment_method_prices_0_gross_amount
${gross_price_de_euro}    id=shipment_method_prices_1_gross_amount
${gross_price_at_chf}    id=shipment_method_prices_2_gross_amount
${gross_price_at_euro}    id=shipment_method_prices_3_gross_amount
${net_price_de_chf}    id=shipment_method_prices_0_net_amount
${net_price_de_euro}    id=shipment_method_prices_1_net_amount
${net_price_at_chf}    id=shipment_method_prices_2_net_amount
${net_price_at_euro}    id=shipment_method_prices_3_net_amount
${tax_set_locator}    id=shipment_method_fkTaxSet
${confirm_delete_button_locator}    id=shipment_method_delete_form_submit

*** Keywords ***

Zed: create carrier company:
    [Arguments]    ${carrier_name}
    Click    xpath=//a[contains(@href,"/shipment-gui/create-carrier/index")]
    Type Text    id=shipment_carrier_name    ${carrier_name}
    Zed: Check checkbox by Label:    Enabled?
    Zed: submit the form
Zed: create delivery method
     Click    ${create_delivery_method_button_locator}

Zed: delivery method details:
    [Arguments]    @{args}
    ${deliverymethod}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{deliverymethod}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='Method_key' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_key_locator}    ${value}
        IF    '${key}'=='Name' and '${value}' != '${EMPTY}'    Type Text    ${name_locator}    ${value}
        IF    '${key}'=='Carrier' and '${value}' != '${EMPTY}'    Select From List By Text    ${carrier_dropdown_locator}    ${value}
    END  
    Check Checkbox    ${is_active_chekbox_locator}
    
Zed: Price & Tax:
    [Arguments]    @{args}
    ${deliverymethod}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{deliverymethod}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='gross_price_de_chf' and '${value}' != '${EMPTY}'    Type Text    ${gross_price_de_chf}    ${value}
        IF    '${key}'=='gross_price_de_euro' and '${value}' != '${EMPTY}'    Type Text    ${gross_price_de_euro}    ${value}
        IF    '${key}'=='gross_price_at_chf' and '${value}' != '${EMPTY}'    Type Text    ${gross_price_at_chf}    ${value}
        IF    '${key}'=='gross_price_at_euro' and '${value}' != '${EMPTY}'    Type Text    ${gross_price_at_euro}    ${value}
         IF    '${key}'=='net_price_de_chf' and '${value}' != '${EMPTY}'    Type Text    ${net_price_de_chf}    ${value}
        IF    '${key}'=='net_price_de_euro' and '${value}' != '${EMPTY}'    Type Text    ${net_price_de_euro}    ${value}
        IF    '${key}'=='net_price_at_chf' and '${value}' != '${EMPTY}'    Type Text    ${net_price_at_chf}    ${value}
        IF    '${key}'=='net_price_at_euro' and '${value}' != '${EMPTY}'    Type Text    ${net_price_at_euro}    ${value}
        IF    '${key}'=='tax_set' and '${value}' != '${EMPTY}'    Select From List By Text    ${tax_set_locator}    ${value}
    END  

Zed: Store Relation checkbox
    ${state_de}=    Get Checkbox State    ${de_locator}
    ${state_at}=    Get Checkbox State    ${at_locator}
    IF    '${state_de}' == 'False'
        Zed: Check checkbox by Label:     DE
    END
    IF    '${state_at}' == 'False'
        Zed: Check checkbox by Label:     AT
    END

Zed: Store Relation uncheckbox
    ${state_de}=    Get Checkbox State    ${de_locator}
    ${state_at}=    Get Checkbox State    ${at_locator}
    IF    '${state_de}' == 'True'
        Zed: Uncheck checkbox by Label:     DE
    END
    IF    '${state_at}' == 'True'
        Zed: Uncheck checkbox by Label:     AT
    END

Yves: Check carrier company:
    [Arguments]    ${carrier_name}
    Page Should Contain Element    xpath=//span[contains(text(),'${carrier_name}')]    

Yves: Check delivery method:
    [Arguments]    ${delivery_method_name}
    Page Should Contain Element    xpath=//span[@class="radio__label radio__label--expand label "]//span[contains(text(),'${delivery_method_name}')] 

Zed: delete delivery method:
    [Arguments]    ${delivery_method_name}
    Zed: go to second navigation item level:    Administration    Delivery Methods
    Zed: click Action Button in a table for row that contains:    ${delivery_method_name}    Delete
    Wait Until Element Is Visible    ${confirm_delete_button_locator}
    Click    ${confirm_delete_button_locator}

Zed: deactivate/unset delivery method:
    [Arguments]    ${delivery_method_name}   
    Zed: click Action Button in a table for row that contains:    ${delivery_method_name}    Edit
    Zed: Uncheck checkbox by Label:    Is active
    Zed: go to tab:    Store Relation
    Zed: Store Relation uncheckbox
    Zed: submit the form

Zed: unset delivery method for store:
    [Arguments]    ${delivery_method_name} 
    Zed: click Action Button in a table for row that contains:    ${delivery_method_name}     View
    Zed: Store Relation uncheckbox

Zed: edit delivery method:
    [Arguments]    ${new_name}
    Click    ${name_locator}
    Clear Text    ${name_locator}
    Type Text    ${name_locator}    ${new_name}

Yves: verifying deactivated/unset delivery method not present on page:
    [Arguments]    ${delivery_method_name}
    Page Should Not Contain Element    xpath=//span[@class="radio__label radio__label--expand label "]//span[contains(text(),'${delivery_method_name}')] 