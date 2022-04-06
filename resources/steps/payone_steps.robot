*** Settings ***
Library    Browser
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_aop_pbc_details_page.robot
Resource    ../pages/zed/zed_aop_payone_datails_page.robot
Resource    ../pages/yves/yves_product_details_page.robot
Resource    ../pages/yves/yves_bazaarvoice_review_popup_form.robot
Resource    ../pages/apps/apps_payone_cc_payment_page.robot

*** Keywords ***
Zed: configure payone pbc with the following data:
    [Documentation]    Possible argument names: credentialsKey, merchantId, subAccountId, paymentPortalId, mode, methods
    [Arguments]    @{args}
    ${payoneCondifurationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{payoneCondifurationData}
        Log    Key is '${key}' and value is '${value}'.
        Run keyword if    '${key}'=='credentialsKey' and '${value}' != '${EMPTY}'    Type Text    ${pbc_payone_credentials_key_input}    ${value}
        Run keyword if    '${key}'=='merchantId' and '${value}' != '${EMPTY}'    Type Text    ${pbc_payone_merchant_id_input}    ${value}
        Run keyword if    '${key}'=='subAccountId' and '${value}' != '${EMPTY}'    Type Text    ${pbc_payone_sub_account_id_input}    ${value}
        Run keyword if    '${key}'=='paymentPortalId' and '${value}' != '${EMPTY}'    Type Text    ${pbc_payone_payment_portal_id_input}    ${value}
        Run keyword if    '${key}'=='mode' and '${value}' != '${EMPTY}'    Click    //spy-radio-group[@id='isLiveMode']//label//span[contains(text(),'${value}')]/ancestor::label
        Run keyword if    '${key}'=='methods' and '${value}' != '${EMPTY}'    Run Keywords
        ...    Conver string to List by separator:    ${value}
        ...    AND    Log    ${covertedList}
        ...    AND    Check payone configuration checkbox:    ${covertedList}
    END

Check payone configuration checkbox:
    [Arguments]    ${checkboxes}
    ${checkbox_count}=   get length  ${checkboxes}
    FOR    ${index}    IN RANGE    0    ${checkbox_count}
        ${checkbox_to_check}=    Get From List    ${checkboxes}    ${index}
        Run Keywords
        ...    Log    ${checkbox_to_check}
        ...    AND    Click    xpath=//spy-checkbox/label//span[contains(text(),'${checkbox_to_check}')]/ancestor::label
    END

Payone: cancel payment
    Wait Until Element Is Visible    ${apps_payone_payment_cancel_btn}
    Click    ${apps_payone_payment_cancel_btn}

Payone: submit credit card form with the following data:
    [Documentation]    Possible argument names: cardType (V, M), cardNumber, nameOnCard, expireYear, expireMonth, cvc
    [Arguments]    @{args}
    ${cardData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{cardData}
        Log    Key is '${key}' and value is '${value}'.
        Run keyword if    '${key}'=='cardType' and '${value}' != '${EMPTY}'    Select From List By Value When Element Is Visible    ${apps_payone_payment_cc_card_type}    ${value}
        Run keyword if    '${key}'=='cardNumber' and '${value}' != '${EMPTY}'    Type Text When Element Is Visible    ${apps_payone_payment_cc_card_number}    ${value}
        Run keyword if    '${key}'=='nameOnCard' and '${value}' != '${EMPTY}'    Type Text When Element Is Visible    ${apps_payone_payment_cc_name_on_card}    ${value}
        Run keyword if    '${key}'=='expireMonth' and '${value}' != '${EMPTY}'    Select From List By Value When Element Is Visible    ${apps_payone_payment_cc_expire_month}    ${value}
        Run keyword if    '${key}'=='expireYear' and '${value}' != '${EMPTY}'    Select From List By Value When Element Is Visible    ${apps_payone_payment_cc_expire_year}    ${value}
        Run keyword if    '${key}'=='cvc' and '${value}' != '${EMPTY}'    Type Text When Element Is Visible    ${apps_payone_payment_cc_cvc}    ${value}
    END
    Click    ${apps_payone_payment_pay_btn}
