*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../../resources/pages/zed/zed_delivery_method_page.robot

*** Keywords ***
Zed: create carrier company:
    [Arguments]    ${carrier_name}
    Click    ${create_carrier_company_button_locator}
    Type Text    ${shipment_carrier_name_input_field_locator}    ${carrier_name}
    Zed: Check checkbox by Label:    Enabled?
    Zed: submit the form

Zed: create delivery method:
    [Arguments]    @{args}
    Click    ${create_delivery_method_button_locator}
    ${deliverymethod}=    Set Up Keyword Arguments    @{args}
    log    ${deliverymethod}
    FOR    ${key}    ${value}    IN    &{deliverymethod}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='method_key' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_key_locator}    ${value}
        IF    '${key}'=='method_name' and '${value}' != '${EMPTY}'    Type Text    ${shipment_method_name_locator}    ${value}
        IF    '${key}'=='carrier' and '${value}' != '${EMPTY}'    Select From List By Text    ${delivery_method_carrier_dropdown_locator}    ${value}
        IF    '${key}'=='label' and '${value}' != '${EMPTY}'    Zed: Check checkbox by Label:   ${value}
        IF    '${key}'=='current_page_1' and '${value}' == 'Price & Tax'    Zed: go to tab:    ${value}
        IF    '${key}'=='gross_price_de_chf' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_gross_price_de_chf}    ${value}
        IF    '${key}'=='gross_price_de_euro' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_gross_price_de_euro}    ${value}
        IF    '${key}'=='gross_price_at_chf' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_gross_price_at_chf}    ${value}
        IF    '${key}'=='gross_price_at_euro' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_gross_price_at_euro}    ${value}
        IF    '${key}'=='net_price_de_chf' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_net_price_de_chf}    ${value}
        IF    '${key}'=='net_price_de_euro' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_net_price_de_euro}    ${value}
        IF    '${key}'=='net_price_at_chf' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_net_price_at_chf}    ${value}
        IF    '${key}'=='net_price_at_euro' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_net_price_at_euro}    ${value}
        IF    '${key}'=='tax_set' and '${value}' != '${EMPTY}'    Select From List By Text    ${delivery_method_tax_set_dropdown_locator}    ${value}
        IF    '${key}'=='current_page_2' and '${value}' == 'Store Relation'    Zed: go to tab:    ${value}

        IF    '${key}'=='store_1' and '${value}' != '${EMPTY}'   
            Zed: check/uncheck store relation checkbox in delivery method:    ${value}    true
        END        
        IF    '${key}'=='store_2' and '${value}' == 'AT'
            Zed: check/uncheck store relation checkbox in delivery method:    AT    true
        END
    END  
    Zed: submit the form

Zed: verify the header text of delivery method in view mode:
    [Arguments]    ${header_text}
    Element Should Contain    ${delivery_method_view_mode_header}     ${header_text}

Zed: check/uncheck store relation checkbox in delivery method:
    [Arguments]    ${store_name}    ${state}
    ${checkboxState}=    Set Variable    ${EMPTY}
    ${checkboxState}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//input[@type='checkbox']/../../label[contains(text(),'${store_name}')]//input[@checked]
    IF    '${checkboxState}'=='False' and '${state}' == 'true'    Click     xpath=//input[@type='checkbox']/../../label[contains(text(),'${store_name}')]//input
    IF    '${checkboxState}'=='True' and '${state}' == 'false'    Click     xpath=//input[@type='checkbox']/../../label[contains(text(),'${store_name}')]//input

Zed: delete delivery method:
    [Arguments]    ${delivery_method_name}
    Zed: go to second navigation item level:    Administration    Delivery Methods
    Zed: click Action Button in a table for row that contains:    ${delivery_method_name}    Delete
    Wait Until Element Is Visible    ${confirm_delete_shipment_method_button_locator}
    Click    ${confirm_delete_shipment_method_button_locator}
    Zed: message should be shown:    Delivery method was deleted successfully.

Zed: activate/deactivate delivery method:
    [Documentation]    Activating/deactivating delivery method 
    [Arguments]    ${delivery_method_name}    ${condition}
    Zed: click Action Button in a table for row that contains:    ${delivery_method_name}    Edit
    IF    '${condition}' == 'activate'    Zed: Check checkbox by Label:    Is active
    IF    '${condition}' == 'deactivate'    Zed: Uncheck checkbox by Label:    Is active
    Zed: submit the form

Zed: unset delivery method for store:
    [Documentation]    Removing store relation of delivery method 
   [Arguments]    ${delivery_method_name}    @{storelist}
    Zed: click Action Button in a table for row that contains:    ${delivery_method_name}    Edit 
    Zed: go to tab:    Store Relation
    FOR    ${element}    IN    @{storelist}
        Log    ${element}
        Zed: check/uncheck store relation checkbox in delivery method:    ${element}    false
    END
    Zed: submit the form

Zed: edit delivery method:
    [Arguments]    @{args}
    ${deliverymethod}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{deliverymethod}
        Log    Key is '${key}' and value is '${value}'
        IF    '${key}'=='method_name' and '${value}' != '${EMPTY}'    Type Text    ${shipment_method_name_locator}    ${value}
        IF    '${key}'=='carrier' and '${value}' != '${EMPTY}'    Select From List By Text    ${delivery_method_carrier_dropdown_locator}    ${value}
        IF    '${key}'=='availability_plugin' and '${value}' != '${EMPTY}'    Select From List By Text    ${delivery_method_availability_plugin_dropdown_locator}    ${value}
        IF    '${key}'=='price_plugin' and '${value}' != '${EMPTY}'    Select From List By Text    ${delivery_method_price_plugin_dropdown_locator}    ${value}
        IF    '${key}'=='delivery_time_plugin' and '${value}' != '${EMPTY}'    Select From List By Text    ${delivery_method_delivery_time_plugin}    ${value}
        IF    '${key}'=='current_page_1' and '${value}' == 'Price & Tax'    Zed: go to tab:    ${value}
        IF    '${key}'=='gross_price_de_chf' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_gross_price_de_chf}    ${value}
        IF    '${key}'=='gross_price_de_euro' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_gross_price_de_euro}    ${value}
        IF    '${key}'=='gross_price_at_chf' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_gross_price_at_chf}    ${value}
        IF    '${key}'=='gross_price_at_euro' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_gross_price_at_euro}    ${value}
        IF    '${key}'=='net_price_de_chf' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_net_price_de_chf}    ${value}
        IF    '${key}'=='net_price_de_euro' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_net_price_de_euro}    ${value}
        IF    '${key}'=='net_price_at_chf' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_net_price_at_chf}    ${value}
        IF    '${key}'=='net_price_at_euro' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_net_price_at_euro}    ${value}
        IF    '${key}'=='tax_set' and '${value}' != '${EMPTY}'    Select From List By Text    ${delivery_method_tax_set_dropdown_locator}    ${value}
        IF    '${key}'=='current_page_2' and '${value}' == 'Store Relation'    Zed: go to tab:    ${value}
        IF    '${key}'=='store_1' and '${value}' != '${EMPTY}'   
            Zed: check/uncheck store relation checkbox in delivery method:    ${value}    true
        END        
        IF    '${key}'=='store_2' and '${value}' == 'AT'
            Zed: check/uncheck store relation checkbox in delivery method:    AT    true
        END
    END 
    
Zed: check the delivery method status:
    [Arguments]    ${delivery_method}    ${carrier_company}    ${status}
    Zed: table should contain:    ${delivery_method}
    Zed: table should contain non-searchable value:    ${carrier_company}
    Zed: table should contain non-searchable value:    ${status}