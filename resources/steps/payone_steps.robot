*** Settings ***
Library     Browser
Resource    ../common/common_aop.robot
Resource    ../common/common.robot
Resource    ../common/common_zed.robot
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
        IF    '${key}'=='credentialsKey' and '${value}' != '${EMPTY}'    Type Text    ${pbc_payone_credentials_key_input}    ${value}
        IF    '${key}'=='merchantId' and '${value}' != '${EMPTY}'    Type Text    ${pbc_payone_merchant_id_input}    ${value}
        IF    '${key}'=='subAccountId' and '${value}' != '${EMPTY}'    Type Text    ${pbc_payone_sub_account_id_input}    ${value}
        IF    '${key}'=='paymentPortalId' and '${value}' != '${EMPTY}'    Type Text    ${pbc_payone_payment_portal_id_input}    ${value}
        IF    '${key}'=='mode' and '${value}' != '${EMPTY}'    Click    //spy-radio-group[@id='isLiveMode']//label//span[contains(text(),'${value}')]/ancestor::label
        IF    '${key}'=='methods' and '${value}' != '${EMPTY}'
            Run Keywords
                Convert string to List by separator:    ${value}
                Log    ${covertedList}
                Check payone configuration checkbox:    ${covertedList}
        END
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

Payone: submit credit card with data:
    [Documentation]    Possible argument names: cardType (V, M), cardNumber, nameOnCard, expireYear, expireMonth, cvc
    [Arguments]    @{args}
    ${cardData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{cardData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='cardType' and '${value}' != '${EMPTY}'    Select From List By Value When Element Is Visible    ${apps_payone_payment_cc_card_type}    ${value}
        IF    '${key}'=='cardNumber' and '${value}' != '${EMPTY}'    Type Text When Element Is Visible    ${apps_payone_payment_cc_card_number}    ${value}
        IF    '${key}'=='nameOnCard' and '${value}' != '${EMPTY}'    Type Text When Element Is Visible    ${apps_payone_payment_cc_name_on_card}    ${value}
        IF    '${key}'=='expireMonth' and '${value}' != '${EMPTY}'    Select From List By Value When Element Is Visible    ${apps_payone_payment_cc_expire_month}    ${value}
        IF    '${key}'=='expireYear' and '${value}' != '${EMPTY}'    Select From List By Value When Element Is Visible    ${apps_payone_payment_cc_expire_year}    ${value}
        IF    '${key}'=='cvc' and '${value}' != '${EMPTY}'    Type Text When Element Is Visible    ${apps_payone_payment_cc_cvc}    ${value}
    END
    Click    ${apps_payone_payment_pay_btn}

Payone: create Beeceptor relay
    [Documentation]    Create separate tab, open Beeceptor and start listening and forwarding notifications from Payone to PBC
    ${oldPage}=    Switch Page    CURRENT
    ${beeceptorPage}=    New Page    ${aop_payone_beeceptor}
    Set Suite Variable    ${beeceptorPage}    ${beeceptorPage}
    injectRequestApiIntoPage
    Evaluate JavaScript    id=app
    ...    (app, args) => {
    ...        let data = JSON.parse(args);
    ...        window.sent = {}
    ...        new MutationObserver(() => {
    ...            document.querySelectorAll('.event-row').forEach((request) => {
    ...                if (window.sent[request.id]) return;
    ...
    ...                let url = request.querySelector('code')?.innerText
    ...                let body = request.querySelector('textarea')?.innerText
    ...
    ...                if (url && body) {
    ...                    console.log(window.sent[request.id] = {url, body});
    ...                    _request({
    ...                        method: 'post',
    ...                        url: data.aop_url + data.payone_url,
    ...                        options: {
    ...                            data: body,
    ...                            headers: {
    ...                                'X-Store-Reference': data.reference,
    ...                                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
    ...                            }
    ...                        }
    ...                    }).then(console.log).catch(console.error)
    ...                }
    ...            })
    ...        }).observe(app, {childList: true, subtree: true})
    ...    }
    ...    arg={"aop_url": "${apps_url}", "reference": "${aop_store_reference}", "payone_url": "${aop_payone_notifications_url}"}
    Switch Page    ${oldPage}
