*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_zed.robot
Resource    ../../resources/pages/zed/zed_edit_global_threshold_page.robot
Resource    ../../resources/pages/yves/yves_shopping_cart_page.robot
Resource    ../../resources/pages/yves/yves_checkout_summary_page.robot


*** Keywords ***
Zed: change global threshold settings:
    [Arguments]    @{args}
    ${thresholdData}=    Set Up Keyword Arguments    @{args}
    Zed: go to second navigation item level:    Administration    Global Threshold
    Wait Until Element Is Visible    ${zed_global_threshold_store_currency_span}
    FOR    ${key}    ${value}    IN    &{thresholdData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='store & currency' and '${value}' != '${EMPTY}'    Select From List By Label    ${zed_global_threshold_store_currency_select}    ${value}
        IF    '${key}'=='minimum hard value' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_minimum_hard_value_input}    ${value}
        IF    '${key}'=='minimum hard en message' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_minimum_hard_en_message_input}    ${value}
        IF    '${key}'=='minimum hard de message' and '${value}' != '${EMPTY}'
            ${de_section_expanded}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${zed_global_threshold_minimum_hard_de_message_input}    timeout=3s
            IF    '${de_section_expanded}'=='False'
                Scroll Element Into View    ${zed_global_threshold_minimum_hard_de_collapce_section}
                Click    ${zed_global_threshold_minimum_hard_de_collapce_section}
                Type Text    ${zed_global_threshold_minimum_hard_de_message_input}    ${value}
            END
        END
        IF    '${key}'=='maximun hard value' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_maximum_hard_value_input}    ${value}
        IF    '${key}'=='maximun hard en message' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_maximum_hard_en_message_input}    ${value}
        IF    '${key}'=='maximun hard de message' and '${value}' != '${EMPTY}'
            ${de_section_expanded}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${zed_global_threshold_maximum_hard_de_message_input}    timeout=3s
            IF    '${de_section_expanded}'=='False'
                Scroll Element Into View    ${zed_global_threshold_maximum_hard_de_collapce_section}
                Click    ${zed_global_threshold_maximum_hard_de_collapce_section}
                Type Text    ${zed_global_threshold_maximum_hard_de_message_input}    ${value}
            END
        END
        IF    '${key}'=='soft threshold' and '${value}' != '${EMPTY}'    Click    xpath=//input[contains(@name,'global-threshold[softThreshold][strategy]')]/../../label[contains(.,'${value}')]
        IF    '${key}'=='soft threshold value' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_soft_value_input}    ${value}
        IF    '${key}'=='soft threshold en message' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_soft_en_message_input}    ${value}
        IF    '${key}'=='soft threshold de message' and '${value}' != '${EMPTY}'
            ${de_section_expanded}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${zed_global_threshold_soft_de_message_input}    timeout=3s
            IF    '${de_section_expanded}'=='False'
                Scroll Element Into View    ${zed_global_threshold_soft_de_collapce_section}
                Click    ${zed_global_threshold_soft_de_collapce_section}
                Type Text    ${zed_global_threshold_soft_de_message_input}    ${value}
            END
        END
        IF    '${key}'=='soft threshold fixed fee' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_soft_fixed_fee_value_input}    ${value}
        IF    '${key}'=='soft threshold flexible fee' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_soft_flexible_fee_value_input}    ${value}
    END     
    Zed: submit the form
    Zed: flash message should be shown:    success

Yves: soft threshold surcharge is added in the cart:
    [Arguments]    ${expectedSurchargeAmount}
    Wait Until Element Is Visible    ${shopping_cart_surcharge_amount}
    ${actualSurchargeAmount}=    Get Text    ${shopping_cart_surcharge_amount}
    Should Be Equal    ${actualSurchargeAmount}    ${expectedSurchargeAmount}  

Yves: soft threshold surcharge is added on summary page:
    [Arguments]    ${expectedSurchargeAmount}
    Wait Until Element Is Visible    ${checkout_summary_surcharge_amount}
    ${actualSurchargeAmount}=    Get Text    ${checkout_summary_surcharge_amount}
    Should Be Equal    ${actualSurchargeAmount}    ${expectedSurchargeAmount}  

Yves: hard threshold is applied with the following message:
    [Arguments]    ${expectedMessage}
    Element Should Be Visible    ${checkout_summary_alert_message}
    Page Should Not Contain Element    ${checkout_summary_submit_order_button}
    ${actualAlertMessage}=    Get Text    ${checkout_summary_alert_message}
    Should Be Equal    ${actualAlertMessage}    ${expectedMessage}

