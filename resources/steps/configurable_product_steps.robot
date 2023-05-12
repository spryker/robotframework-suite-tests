*** Settings ***
Resource    ../common/common.robot
Resource    ../../resources/pages/yves/yves_product_configurator_page.robot
Resource    ../../resources/pages/yves/yves_product_details_page.robot
Resource    ../../resources/pages/zed/zed_order_details_page.robot

*** Keywords ***
Yves: change the product configuration to:
    [Documentation]    fill the fields for product configuration.
    [Arguments]    @{args}
    ${configurationData}=    Set Up Keyword Arguments    @{args}
    Click    ${pdp_configure_button}
    Wait Until Element Is Visible    ${configurator_date_input}
    FOR    ${key}    ${value}    IN    &{configurationData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='date' and '${value}' != '${EMPTY}'   Type Text    ${configurator_date_input}    ${value}
            IF    '${key}'=='date' and '${value}' == '${EMPTY}'   Clear Text    ${configurator_date_input}
        IF    '${key}'=='date_time' and '${value}' != '${EMPTY}'   Select From List By Label    ${configurator_day_time_selector}    ${value}
    END
    Click    ${configurator_day_time_selector}
    ### sleep 1 seconds to process background event
    Sleep    1s
    Click    ${configurator_save_button}
    Wait Until Element Is Visible    ${pdp_configure_button}

Yves: product configuration status should be equal:
    [Arguments]    ${expected_status}
    Element Text Should Be    ${pdp_configuration_status}    ${expected_status}

Yves: configuration should be equal:
    [Arguments]    @{args}
    ${configurationData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${pdp_configure_button}
    FOR    ${key}    ${value}    IN    &{configurationData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='date' and '${value}' != '${EMPTY}'   Element Text Should Be    ${pdp_configuration_date}[${env}]    ${value}
        IF    '${key}'=='date_time' and '${value}' != '${EMPTY}'   Element Text Should Be    ${pdp_configuration_date_time}[${env}]    ${value}
    END

Yves: check and go back that configuration page contains:
    [Arguments]    @{args}
    ${configuratorData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${pdp_configure_button}
    Click    ${pdp_configure_button}
    FOR    ${key}    ${value}    IN    &{configuratorData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'   Element Should Contain    ${configurator_store}    ${value}
        IF    '${key}'=='locale' and '${value}' != '${EMPTY}'   Element Should Contain    ${configurator_locale}    ${value}
        IF    '${key}'=='price_mode' and '${value}' != '${EMPTY}'   Element Should Contain    ${configurator_price_mode}    ${value}
        IF    '${key}'=='currency' and '${value}' != '${EMPTY}'   Element Should Contain    ${configurator_currency}    ${value}
        IF    '${key}'=='customer_id' and '${value}' != '${EMPTY}'   Element Should Contain    ${configurator_customer_id}    ${value}
        IF    '${key}'=='sku' and '${value}' != '${EMPTY}'   Element Should Contain    ${configurator_sku}    ${value}
    END
    Click    ${configurator_cancel_button}
    Wait Until Element Is Visible    ${pdp_configure_button}


Zed: product configuration should be equal:
    [Arguments]    @{args}
    ${configurationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{configurationData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='shipment' and '${value}' != '${EMPTY}'   
            ${shipment}=    Set Variable    ${shipment}
        ELSE IF    '${key}'=='shipment' and '${value}' == '${EMPTY}'
            ${shipment}=    Set Variable    1
        END
        IF    '${key}'=='sku' and '${value}' != '${EMPTY}'   
            ${sku}=    Set Variable    ${value}
        END
        IF    '${key}'=='position' and '${value}' != '${EMPTY}'
            ${position}=    Set Variable    ${value}
        ELSE IF    '${key}'=='position' and '${value}' == '${EMPTY}'
            ${position}=    Set Variable    1
        END
        IF    '${key}'=='date' and '${value}' != '${EMPTY}'    Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//tr[${position}]/td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr//td//*[contains(@class,'sku')]/../div[last()]    ${value}
        IF    '${key}'=='date_time' and '${value}' != '${EMPTY}'    
            IF    '${env}' in ['ui_b2b','ui_mp_b2b']
                Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//tr[${position}]/td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr//td//*[contains(@class,'sku')]/../div[3]    ${value}
            ELSE
                Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//tr[${position}]/td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr//td//*[contains(@class,'sku')]/../div[4]    ${value}
            END
        END
    END