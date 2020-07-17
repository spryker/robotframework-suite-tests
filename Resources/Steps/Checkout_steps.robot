*** Settings ***
Resource    ../Pages/Yves/Yves_Checkout_Address_Page.robot
Resource    ../Pages/Yves/Yves_Checkout_Summary_page.robot
Resource    ../Common/Common_Yves.robot

*** Variables ***
${cancelRequestButton}    ${checkout_summary_cancel_request_button}  
${alertWarning}    ${checkout_summary_alert_warning}
${quoteStatus}    ${checkout_summary_quote_status}
${submit_checkout_form_button}    xpath=//div[contains(@class,'form--checkout-form')]//button[@data-qa='submit-button']

*** Keywords ***
Yves: billing address same as shipping address:
    [Arguments]    ${state}
    Run Keyword If    '${state}' == 'true'    Select Checkbox    ${checkout_address_billing_same_as_shipping_checkbox}
    
Yves: select the following existing address on the checkout as 'shipping' address and go next:
    [Arguments]    ${addressToUse}
    Wait Until Element Is Visible    ${checkout_address_delivery_dropdown}
    Select From List By Label    ${checkout_address_delivery_dropdown}    ${addressToUse}
    Scroll and Click Element    ${submit_checkout_form_button}
    Wait For Document Ready    

Yves: select the following shipping method on the checkout and go next:
    [Arguments]    ${shippingMethod}
    Scroll and Click Element    xpath=//div[@data-qa='component shipment-sidebar']//*[contains(.,'Shipping Method')]/../ul//label[contains(.,'${shippingMethod}')]/span[contains(@class,'radio__box')]
    Scroll and Click Element    ${submit_checkout_form_button}
    Wait For Document Ready    

Yves: select the following payment method on the checkout and go next:
    [Arguments]    ${paymentMethod}
    Scroll and Click Element    //form[@id='payment-form']//li[@class='checkout-list__item'][contains(.,'${paymentMethod}')]//span[contains(@class,'toggler-radio__box')]
    Scroll and Click Element    ${submit_checkout_form_button}
    Wait For Document Ready    

Yves: '${checkoutAction}' on the summary page
    Run Keyword If    '${checkoutAction}' == 'submit the order'    Scroll and Click Element    ${checkout_summary_submit_order_button}
    ...    ELSE IF    '${checkoutAction}' == 'send the request'    Scroll and Click Element    ${checkout_summary_send_request_button}
    ...    ELSE IF    '${checkoutAction}' == 'approve the cart'    Scroll and Click Element    ${checkout_summary_approve_request_button}
    Wait For Document Ready      

Yves: select approver on the 'Summary' page:
    [Arguments]    ${approver}
    Wait Until Element Is Visible    ${checkout_summary_approver_dropdown}
    Select From List By Label    ${checkout_summary_approver_dropdown}    ${approver} 

Yves: 'Summary' page contains/doesn't contain:
    [Arguments]    ${condition}    @{checkout_summary_elements_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${checkout_summary_elements_list_count}=   get length    ${checkout_summary_elements_list} 
    FOR    ${index}    IN RANGE    0    ${checkout_summary_elements_list_count}
        ${checkout_summary_element_to_check}=    Get From List    ${checkout_summary_elements_list}     ${index}
        Run Keyword If    '${condition}' == 'true'    
        ...    Run Keywords
        ...    Log    ${checkout_summary_element_to_check}    #Left as an example of multiple actions in Condition
        ...    AND    Page Should Contain Element    ${checkout_summary_element_to_check}    message=${checkout_summary_element_to_check} is not displayed
        Run Keyword If    '${condition}' == 'false'    
        ...    Run Keywords
        ...    Log    ${checkout_summary_element_to_check}    #Left as an example of multiple actions in Condition
        ...    AND    Page Should Not Contain Element    ${checkout_summary_element_to_check}    message=${checkout_summary_element_to_check} should not be displayed
    END
