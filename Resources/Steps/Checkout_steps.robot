*** Settings ***
Resource    ../Pages/Yves/Yves_Checkout_Address_page.robot
Resource    ../Pages/Yves/Yves_Checkout_Login_page.robot
Resource    ../Pages/Yves/Yves_Checkout_Payment_page.robot
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
    Run Keyword If    '${state}' == 'true' and '${env}'=='b2b'    Add/Edit element attribute with JavaScript:    //input[@id='addressesForm_billingSameAsShipping']    checked    checked
    ...    ELSE    Run Keyword If    '${state}' == 'true' and '${env}'=='b2c'    Click Element by id with JavaScript    addressesForm_billingSameAsShipping   
   
Yves: accept the terms and conditions:
    [Documentation]    ${state} can be true or false
    [Arguments]    ${state}    ${isGuest}=false
    Run Keyword If    '${state}' == 'true' and '${isGuest}'=='false'    Run keywords    Wait Until Page Contains Element    xpath=//input[@name='acceptTermsAndConditions']    AND    Run Keyword And Ignore Error    Click Element by xpath with JavaScript    //input[@name='acceptTermsAndConditions']
    ...    ELSE    Run Keyword If    '${state}'=='true' and '${isGuest}'=='true'    Run keywords    Wait Until Page Contains Element    id=guestForm_customer_accept_terms    AND    Click Element by id with JavaScript    guestForm_customer_accept_terms
    
Yves: select the following existing address on the checkout as 'shipping' address and go next:
    [Arguments]    ${addressToUse}
    Wait Until Element Is Visible    ${checkout_address_delivery_dropdown}
    Select From List By Label    ${checkout_address_delivery_dropdown}    ${addressToUse}
    Scroll and Click Element    ${submit_checkout_form_button}
    Wait For Document Ready    

Yves: fill in the following shipping address:
    [Documentation]
    [Arguments]    ${salutation}    ${firstName}    ${lastName}    ${street}    ${houseNumber}    ${postCode}    ${city}    ${country}    ${isDefaultShipping}=True     ${isDefaultBilling}=True      ${company}=    ${phone}=    ${additionalAddress}=    ${addressesForm_billingSameAsShipping}=true
    Click Element    xpath=//span[@aria-labelledby='select2-addressesForm_shippingAddress_id_customer_address-container']    modifier=False    action_chain=False
    Click Element    xpath=//li[contains(text(),'Define new address')]    modifier=False    action_chain=False
#    Click Element    ${checkout_shipping_address_salutation_dropdown}
#    Click Element    xpath=//li[@class='select2-results__option' and contains(text(),'${salutation}')]
    Input text into field    ${checkout_shipping_address_first_name_field}     ${firstName}
    Input text into field    ${checkout_shipping_address_last_name_field}     ${lastName}
    Input text into field    ${checkout_shipping_address_company_name_field}     ${company}
    Input text into field    ${checkout_shipping_address_street_field}     ${street}
    Input text into field    ${checkout_shipping_address_house_number_field}     ${houseNumber}
    Input text into field    ${checkout_shipping_address_additional_address_field}     ${additionalAddress}
    Input text into field    ${checkout_shipping_address_zip_code_field}     ${postCode}
    Input text into field    ${checkout_shipping_address_city_field}     ${city}
#     Click Element    ${checkout_shipping_address_country_drop_down_field}
#     Click Element    xpath=//li[contains(@class,'select2-results__option') and contains(text(),'${country}')]
    Input text into field    ${checkout_shipping_address_phone_field}     ${phone}
    Scroll Element Into View    ${checkout_address_submit_button}
    Wait Until Element Is Enabled    ${checkout_address_submit_button}
    Wait Until Element Is Visible    ${checkout_address_submit_button}
    Click Element    ${checkout_address_submit_button}
    Scroll and Click Element    ${submit_checkout_form_button}   
    Wait For Document Ready 

Yves: select the following shipping method on the checkout and go next:
    [Arguments]    ${shippingMethod}
    Scroll and Click Element    xpath=//div[@data-qa='component shipment-sidebar']//*[contains(.,'Shipping Method')]/../ul//label[contains(.,'${shippingMethod}')]/span[contains(@class,'radio__box')]
    Scroll and Click Element    ${submit_checkout_form_button}
    Wait For Document Ready    

Yves: select the following payment method on the checkout and go next:
    [Arguments]    ${paymentMethod}
    BuiltIn.Run Keyword If    '${env}'=='b2b'    Run keywords
    ...    Scroll and Click Element    //form[@id='payment-form']//li[@class='checkout-list__item'][contains(.,'${paymentMethod}')]//span[contains(@class,'toggler-radio__box')]
    ...    AND    Scroll and Click Element    ${submit_checkout_form_button}
    ...    ELSE    Run keywords
    ...    Scroll and CLick Element    //form[@name='paymentForm']//span[contains(@class,'toggler') and contains(text(),'${paymentMethod}')]/preceding-sibling::span[@class='toggler-radio__box']
    ...    AND    Input text into field    ${checkout_payment_invoice_date_of_birth_field}    11.11.1111    
    ...    AND    Scroll and Click Element    ${submit_checkout_form_button}
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

Yves: proceed with checkout as guest:
    [Arguments]    ${salutation}    ${firstName}    ${lastName}    ${email}
    Click Element by xpath with JavaScript    //span[contains(text(),'Buy as Guest')]/ancestor::label[@class='toggler-radio__container']/input
    Wait Until Element Is Visible    ${yves_checkout_login_guest_firstName_field}
    Input text into field    ${yves_checkout_login_guest_firstName_field}     ${firstName}
    Input text into field    ${yves_checkout_login_guest_lastName_field}     ${lastName}
    Input text into field    ${yves_checkout_login_guest_email_field}     ${email}
    Yves: accept the terms and conditions:    true    true
    Scroll and Click Element    ${yves_checkout_login_buy_as_guest_submit_button} 
    Wait For Document Ready    

