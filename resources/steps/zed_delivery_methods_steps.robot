*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../../resources/pages/zed/zed_delivery_method_pages.robot
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
    FOR    ${key}    ${value}    IN    &{deliverymethod}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='Method_key' and '${value}' != '${EMPTY}'    Type Text    ${delivery_method_key_locator}    ${value}
        IF    '${key}'=='Method_Name' and '${value}' != '${EMPTY}'    Type Text    ${shipment_method_name_locator}    ${value}
        IF    '${key}'=='Carrier' and '${value}' != '${EMPTY}'    Select From List By Text    ${carrier_dropdown_locator}    ${value}
    END  
    Check Checkbox    ${is_active_chekbox_locator}
    Zed: Check checkbox by Label:     Is active
    
Zed: add price & tax of delivery method and store relation:
    [Arguments]    @{args}
    ${deliverymethod}=    Set Up Keyword Arguments    @{args}
    Zed: go to tab:    Price & Tax
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
        
        IF    '${key}'=='store_1' and '${value}' == 'DE'   
            Zed: go to tab:    Store Relation
            Zed: checkbox/uncheckbox store relation in delivery method:    DE    true
        END        
        IF    '${key}'=='store_2' and '${value}' == 'AT'
            Zed: go to tab:    Store Relation
            Zed: checkbox/uncheckbox store relation in delivery method:    AT    true
        END
    END  
    Zed: submit the form
    
Zed: checkbox/uncheckbox store relation in delivery method:
    [Arguments]    ${store_name}    ${state}
    ${checkboxState}=    Set Variable    ${EMPTY}
    ${checkboxState}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//input[@type='checkbox']/../../label[contains(text(),'${store_name}')]//input[@checked]
    IF    '${checkboxState}'=='False' and '${state}' == 'true'    Click     xpath=//input[@type='checkbox']/../../label[contains(text(),'${store_name}')]//input
    IF    '${checkboxState}'=='True' and '${state}' == 'false'    Click     xpath=//input[@type='checkbox']/../../label[contains(text(),'${store_name}')]//input

Yves: check availability carrier company and delivery method:
    [Arguments]    ${delivery_method_name}    ${carrier_name}    ${condition}
    Page Should Contain Element    xpath=(//span[contains(text(),'${delivery_method_name}')]//parent::h4//following-sibling::ul)[1]//span[contains(text(),'${carrier_name}')] 
    IF    '${condition}' == 'true'    Page Should Contain Element    xpath=(//span[contains(text(),'${delivery_method_name}')]//parent::h4//following-sibling::ul)[1]//span[contains(text(),'${carrier_name}')]
    IF    '${condition}' == 'false'    Page Should Not Contain Element    xpath=(//span[contains(text(),'${delivery_method_name}')]//parent::h4//following-sibling::ul)[1]//span[contains(text(),'${carrier_name}')]

Zed: delete delivery method:
    [Arguments]    ${delivery_method_name}
    Zed: go to second navigation item level:    Administration    Delivery Methods
    Zed: click Action Button in a table for row that contains:    ${delivery_method_name}    Delete
    Wait Until Element Is Visible    ${confirm_delete_shipment_method_button_locator}
    Click    ${confirm_delete_shipment_method_button_locator}

Zed: deactivate/unset delivery method:
    [Documentation]    deactivating delivery method and removing relations from all demoshops
    [Arguments]    ${delivery_method_name}    @{storelist}
    Zed: click Action Button in a table for row that contains:    ${delivery_method_name}    Edit
    Zed: Uncheck checkbox by Label:    Is active
    Zed: go to tab:    Store Relation
    FOR    ${element}    IN    @{storelist}
        Log    ${element}
            Zed: checkbox/uncheckbox store relation in delivery method:    ${element}    false
    END
    Zed: submit the form

Zed: edit delivery method:
    [Arguments]    @{args}
    ${deliverymethod}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{deliverymethod}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='Method_Name' and '${value}' != '${EMPTY}'    Type Text    ${shipment_method_name_locator}    ${value}
        IF    '${key}'=='Carrier' and '${value}' != '${EMPTY}'    Select From List By Text    ${carrier_dropdown_locator}    ${value}
        IF    '${key}'=='availability_plugin' and '${value}' != '${EMPTY}'    Select From List By Text    ${availability_plugin_dropdown_locator}    ${value}
        IF    '${key}'=='price_plugin' and '${value}' != '${EMPTY}'    Select From List By Text    ${price_plugin_dropdown_locator}    ${value}
        IF    '${key}'=='delivery_time_plugin' and '${value}' != '${EMPTY}'    Select From List By Text    ${delivery_time_plugin}    ${value}
    END  
    
Yves: verifying deactivated/unset delivery method not present on page:
    [Arguments]    ${delivery_method_name}
    Page Should Not Contain Element    xpath=//span[contains(@class,"radio__label")]//span[contains(text(),'${delivery_method_name}')] 

Zed: check the delivery method status:
    [Arguments]    ${delivery_method}    ${carrier_company}    ${status}
    Zed: table should contain:    ${delivery_method}
    Zed: table should contain non-searchable value:    ${carrier_company}
    Zed: table should contain non-searchable value:    ${status}