*** Settings ***
Resource    ../pages/yves/yves_checkout_address_page.robot
Resource    ../pages/yves/yves_checkout_login_page.robot
Resource    ../pages/yves/yves_checkout_payment_page.robot
Resource    ../pages/yves/yves_checkout_summary_page.robot
Resource    ../common/common_yves.robot
Resource    ../common/common.robot


*** Variables ***
${cancelRequestButton}    ${checkout_summary_cancel_request_button}  
${alertWarning}    ${checkout_summary_alert_warning}
${quoteStatus}    ${checkout_summary_quote_status}
${submit_checkout_form_button}    xpath=//div[contains(@class,'form--checkout-form')]//button[@data-qa='submit-button']

*** Keywords ***
Yves: billing address same as shipping address:
    [Arguments]    ${state}
    Run keyword if    '${env}'=='b2b'    Wait Until Page Contains Element    ${manage_your_addresses_link}
    ${checkboxState}=    Set Variable    ${EMPTY} 
    ${checkboxState}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//input[@id='addressesForm_billingSameAsShipping'][@checked]
    Run Keyword If    '${checkboxState}'=='False' and '${state}' == 'true'    Click Element by xpath with JavaScript    //input[@id='addressesForm_billingSameAsShipping']
    Run Keyword If    '${checkboxState}'=='True' and '${state}' == 'false'    Click Element by xpath with JavaScript    //input[@id='addressesForm_billingSameAsShipping']
   
Yves: accept the terms and conditions:
    [Documentation]    ${state} can be true or false
    [Arguments]    ${state}    ${isGuest}=false
    Run Keyword If    '${state}' == 'true' and '${isGuest}'=='false'    Run keywords    Wait Until Page Contains Element    xpath=//input[@name='acceptTermsAndConditions']    AND    Run Keyword And Ignore Error    Click Element by xpath with JavaScript    //input[@name='acceptTermsAndConditions']
    ...    ELSE    Run Keyword If    '${state}'=='true' and '${isGuest}'=='true'    Run keywords    Wait Until Page Contains Element    id=guestForm_customer_accept_terms    AND    Click Element by id with JavaScript    guestForm_customer_accept_terms
    
Yves: select the following existing address on the checkout as 'shipping' address and go next:
    [Arguments]    ${addressToUse}
    Wait Until Element Is Visible    ${checkout_address_delivery_dropdown}
    Select From List By Label    ${checkout_address_delivery_dropdown}    ${addressToUse}
    Click    ${submit_checkout_form_button}
        

Yves: fill in the following shipping address:
    [Documentation]
    [Arguments]    ${salutation}    ${firstName}    ${lastName}    ${street}    ${houseNumber}    ${postCode}    ${city}    ${country}    ${isDefaultShipping}=True     ${isDefaultBilling}=True      ${company}=    ${phone}=    ${additionalAddress}=    ${addressesForm_billingSameAsShipping}=true
    Click    xpath=//span[@aria-labelledby='select2-addressesForm_shippingAddress_id_customer_address-container']
    Click    xpath=//li[contains(text(),'Define new address')]
#    Click    ${checkout_shipping_address_salutation_dropdown}
#    Click    xpath=//li[@class='select2-results__option' and contains(text(),'${salutation}')]
    Type Text    ${checkout_shipping_address_first_name_field}     ${firstName}
    Type Text    ${checkout_shipping_address_last_name_field}     ${lastName}
    Type Text    ${checkout_shipping_address_company_name_field}     ${company}
    Type Text    ${checkout_shipping_address_street_field}     ${street}
    Type Text    ${checkout_shipping_address_house_number_field}     ${houseNumber}
    Type Text    ${checkout_shipping_address_additional_address_field}     ${additionalAddress}
    Type Text    ${checkout_shipping_address_zip_code_field}     ${postCode}
    Type Text    ${checkout_shipping_address_city_field}     ${city}
#     Click    ${checkout_shipping_address_country_drop_down_field}
#     Click    xpath=//li[contains(@class,'select2-results__option') and contains(text(),'${country}')]
    Type Text    ${checkout_shipping_address_phone_field}     ${phone}
    Scroll Element Into View    ${checkout_address_submit_button}
    Wait Until Element Is Enabled    ${checkout_address_submit_button}
    Wait Until Element Is Visible    ${checkout_address_submit_button}
    Click    ${checkout_address_submit_button}
    Click    ${submit_checkout_form_button}   
     

Yves: fill in the following billing address:
    [Documentation]
    [Arguments]    ${salutation}    ${firstName}    ${lastName}    ${street}    ${houseNumber}    ${postCode}    ${city}    ${country}    ${company}=    ${phone}=    ${additionalAddress}=    
    Click    xpath=//span[@id='select2-addressesForm_billingAddress_id_customer_address-container']
    Click    xpath=//li[contains(text(),'Define new address')]
#    Click    ${checkout_shipping_address_salutation_dropdown}
#    Click    xpath=//li[@class='select2-results__option' and contains(text(),'${salutation}')]
    Type Text    ${checkout_billing_address_first_name_field}     ${firstName}
    Type Text    ${checkout_billing_address_last_name_field}     ${lastName}
    Type Text    ${checkout_billing_address_company_name_field}     ${company}
    Type Text    ${checkout_billing_address_street_field}     ${street}
    Type Text    ${checkout_billing_address_house_number_field}     ${houseNumber}
    Type Text    ${checkout_billing_address_additional_address_field}     ${additionalAddress}
    Type Text    ${checkout_billing_address_zip_code_field}     ${postCode}
    Type Text    ${checkout_billing_address_city_field}     ${city}
#     Click    ${checkout_shipping_address_country_drop_down_field}
#     Click    xpath=//li[contains(@class,'select2-results__option') and contains(text(),'${country}')]
    Type Text    ${checkout_billing_address_phone_field}     ${phone}

Yves: select delivery to multiple addresses
    Click    xpath=//span[@aria-labelledby='select2-addressesForm_shippingAddress_id_customer_address-container']
    Click    xpath=//li[contains(text(),'Deliver to multiple addresses')]
    Wait Until Element Is Visible    xpath=//*[contains(@class,'title') and contains(text(),'Assign each product to its own delivery address')]

Yves: click checkout button:
    [Arguments]    ${buttonName}
    Click    xpath=//button[@type='submit' and contains(text(),'${buttonName}')]

Yves: select new delivery address for a product:
    [Arguments]    ${productName}    ${newAddress}=false    ${existingAddress}=    ${salutation}=    ${firstName}=    ${lastName}=    ${street}=    
    ...    ${houseNumber}=    ${postCode}=    ${city}=    ${country}=    ${isDefaultShipping}=True     ${isDefaultBilling}=True      ${company}=    
    ...    ${phone}=    ${additionalAddress}=
    Run Keyword If    '${newAddress}'=='true'    Run keywords    Click    xpath=//*[contains(@class,'product-card-item')]//div[contains(text(),'${productName}')]/ancestor::article[contains(@data-qa,'component product-card-item')]//span[contains(@aria-labelledby,'id_customer_address-container')]
    ...    AND    Click    xpath=//li[contains(text(),'Define new address')]
    ...    AND    Type Text    xpath=//*[contains(@class,'product-card-item')]//div[contains(text(),'${productName}')]${checkout_shipping_multiple_address_first_name_field}     ${firstName}
    ...    AND    Type Text    xpath=//*[contains(@class,'product-card-item')]//div[contains(text(),'${productName}')]${checkout_shipping_multiple_address_last_name_field}     ${lastName}
    ...    AND    Type Text    xpath=//*[contains(@class,'product-card-item')]//div[contains(text(),'${productName}')]${checkout_shipping_multiple_address_company_name_field}     ${company}
    ...    AND    Type Text    xpath=//*[contains(@class,'product-card-item')]//div[contains(text(),'${productName}')]${checkout_shipping_multiple_address_street_field}     ${street}
    ...    AND    Type Text    xpath=//*[contains(@class,'product-card-item')]//div[contains(text(),'${productName}')]${checkout_shipping_multiple_address_house_number_field}     ${houseNumber}
    ...    AND    Type Text    xpath=//*[contains(@class,'product-card-item')]//div[contains(text(),'${productName}')]${checkout_shipping_multiple_address_additional_address_field}     ${additionalAddress}
    ...    AND    Type Text    xpath=//*[contains(@class,'product-card-item')]//div[contains(text(),'${productName}')]${checkout_shipping_multiple_address_zip_code_field}     ${postCode}
    ...    AND    Type Text    xpath=//*[contains(@class,'product-card-item')]//div[contains(text(),'${productName}')]${checkout_shipping_multiple_address_city_field}     ${city}
    ...    ELSE    Run Keyword If    '${newAddress}'=='false'    Run keywords    Click    xpath=//*[contains(@class,'product-card-item')]//div[contains(text(),'${productName}')]/ancestor::div[contains(@data-qa,'component address-item-form-field-list')]//span[@aria-labelledby='select2-addressesForm_multiShippingAddresses_0_shippingAddress_id_customer_address-container']
    ...    AND    Click    xpath=//li[contains(text(),'${existingAddress}')]    


Yves: select the following shipping method on the checkout and go next:
    [Arguments]    ${shippingMethod}
    Click    xpath=//div[@data-qa='component shipment-sidebar']//*[contains(.,'Shipping Method')]/../ul//label[contains(.,'${shippingMethod}')]/span[contains(@class,'radio__box')]
    Click    ${submit_checkout_form_button}

Yves: submit form on the checkout
    Click    ${submit_checkout_form_button}
        
Yves: select the following shipping method for product:
    [Arguments]    ${productName}    ${shippingMethod}
    Click    xpath=//div[contains(text(),'${productName}')]/ancestor::article[contains(@class,'checkout-block')]//div[contains(@data-qa,'component shipment-sidebar')]//ul//label[contains(.,'${shippingMethod}')]/span[contains(@class,'radio__box')]

Yves: select the following payment method on the checkout and go next:
    [Arguments]    ${paymentMethod}
    BuiltIn.Run Keyword If    '${env}'=='b2b'    Run keywords
    ...    Click    //form[@id='payment-form']//li[@class='checkout-list__item'][contains(.,'${paymentMethod}')]//span[contains(@class,'toggler-radio__box')]
    ...    AND    Click    ${submit_checkout_form_button}
    ...    ELSE    Run keywords
    ...    Click    //form[@name='paymentForm']//span[contains(@class,'toggler') and contains(text(),'${paymentMethod}')]/preceding-sibling::span[@class='toggler-radio__box']
    ...    AND    Type Text    ${checkout_payment_invoice_date_of_birth_field}    11.11.1111    
    ...    AND    Click    ${submit_checkout_form_button}
        

Yves: '${checkoutAction}' on the summary page
    Run Keyword If    '${checkoutAction}' == 'submit the order'    Click    ${checkout_summary_submit_order_button}
    ...    ELSE IF    '${checkoutAction}' == 'send the request'    Click    ${checkout_summary_send_request_button}
    ...    ELSE IF    '${checkoutAction}' == 'approve the cart'    Click    ${checkout_summary_approve_request_button}

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
    Wait Until Page Contains Element    xpath=//span[contains(text(),'Buy as Guest')]/ancestor::label[@class='toggler-radio__container']/input
    Click Element by xpath with JavaScript    //span[contains(text(),'Buy as Guest')]/ancestor::label[@class='toggler-radio__container']/input
    Wait Until Element Is Visible    ${yves_checkout_login_guest_firstName_field}
    Type Text    ${yves_checkout_login_guest_firstName_field}     ${firstName}
    Type Text    ${yves_checkout_login_guest_lastName_field}     ${lastName}
    Type Text    ${yves_checkout_login_guest_email_field}     ${email}
    Yves: accept the terms and conditions:    true    true
    Click    ${yves_checkout_login_buy_as_guest_submit_button} 
        

