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
${selected address}

*** Keywords ***
Yves: billing address same as shipping address:
    [Arguments]    ${state}
    IF    '${env}' in ['b2b','mp_b2b']    Wait Until Page Contains Element    ${manage_your_addresses_link}
    ${checkboxState}=    Set Variable    ${EMPTY}
    ${checkboxState}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//input[@id='addressesForm_billingSameAsShipping'][@checked]
    IF    '${checkboxState}'=='False' and '${state}' == 'true'    Click Element by xpath with JavaScript    //input[@id='addressesForm_billingSameAsShipping']
    IF    '${checkboxState}'=='True' and '${state}' == 'false'    Click Element by xpath with JavaScript    //input[@id='addressesForm_billingSameAsShipping']
    Wait Until Element Is Not Visible    ${billing_address_section}[${env}]

Yves: accept the terms and conditions:
    [Documentation]    ${state} can be true or false
    [Arguments]    ${state}    ${isGuest}=false
    IF    '${state}' == 'true' and '${isGuest}'=='false'
        Run keywords
            Wait Until Page Contains Element    xpath=//input[@name='acceptTermsAndConditions']
            Run Keyword And Ignore Error    Click Element by xpath with JavaScript    //input[@name='acceptTermsAndConditions']
    ELSE IF    '${state}'=='true' and '${isGuest}'=='true'
        Run keywords
            Wait Until Page Contains Element    id=guestForm_customer_accept_terms
            Click Element by id with JavaScript    guestForm_customer_accept_terms
    END

Yves: select the following existing address on the checkout as 'shipping' address and go next:
    [Arguments]    ${addressToUse}
    Wait Until Element Is Visible    ${checkout_address_delivery_selector}[${env}] 
    WHILE  '${selected address}' != '${addressToUse}'
        Run Keywords         
            Select From List By Label    ${checkout_address_delivery_selector}[${env}]    ${addressToUse}
            ${selected address}=    Get Text    xpath=//div[contains(@class,'shippingAddress')]//select[@name='checkout-full-addresses'][contains(@class,'address__form')]/..//span[contains(@id,'checkout-full-address')]
    END
    Click    ${submit_checkout_form_button}[${env}]

Yves: fill in the following new shipping address:
    [Documentation]    Possible argument names: salutation, firstName, lastName, street, houseNumber, postCode, city, country, company, phone, additionalAddress
    [Arguments]    @{args}
    ${newAddressData}=    Set Up Keyword Arguments    @{args}
    Select From List By Label    ${checkout_address_delivery_selector}[${env}]    Define new address
    Wait Until Element Is Visible    ${checkout_new_shipping_address_form}
    FOR    ${key}    ${value}    IN    &{newAddressData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    ${checkout_shipping_address_salutation_selector}    ${value}
        IF    '${key}'=='firstName' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_first_name_field}[${env}]    ${value}
        IF    '${key}'=='lastName' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_last_name_field}    ${value}
        IF    '${key}'=='street' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_street_field}    ${value}
        IF    '${key}'=='houseNumber' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_house_number_field}    ${value}
        IF    '${key}'=='postCode' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_zip_code_field}    ${value}
        IF    '${key}'=='city' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_city_field}    ${value}
        IF    '${key}'=='country' and '${value}' != '${EMPTY}'    Select From List By Label    ${checkout_shipping_address_country_selector}    ${value}
        IF    '${key}'=='company' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_company_name_field}    ${value}
        IF    '${key}'=='phone' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_phone_field}    ${value}
        IF    '${key}'=='additionalAddress' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_additional_address_field}    ${value}
    END

Yves: fill in the following new billing address:
    [Documentation]    Possible argument names: salutation, firstName, lastName, street, houseNumber, postCode, city, country, company, phone, additionalAddress
    [Arguments]    @{args}
    ${newAddressData}=    Set Up Keyword Arguments    @{args}
    Select From List By Label    ${checkout_address_billing_selector}[${env}]    Define new address
    Wait Until Element Is Visible    ${checkout_new_billing_address_form}
    FOR    ${key}    ${value}    IN    &{newAddressData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    ${checkout_billing_address_salutation_selector}    ${value}
        IF    '${key}'=='firstName' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_first_name_field}    ${value}
        IF    '${key}'=='lastName' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_last_name_field}    ${value}
        IF    '${key}'=='street' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_street_field}    ${value}
        IF    '${key}'=='houseNumber' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_house_number_field}    ${value}
        IF    '${key}'=='postCode' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_zip_code_field}    ${value}
        IF    '${key}'=='city' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_city_field}    ${value}
        IF    '${key}'=='country' and '${value}' != '${EMPTY}'    Select From List By Label    ${checkout_billing_address_country_select}    ${value}
        IF    '${key}'=='company' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_company_name_field}    ${value}
        IF    '${key}'=='phone' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_phone_field}    ${value}
        IF    '${key}'=='additionalAddress' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_additional_address_field}    ${value}
    END

Yves: select delivery to multiple addresses
    Select From List By Label    ${checkout_address_delivery_selector}[${env}]    Deliver to multiple addresses

Yves: click checkout button:
    [Arguments]    ${buttonName}
    Click    xpath=//button[@type='submit' and contains(text(),'${buttonName}')]

Yves: fill in new delivery address for a product:
    [Documentation]    Possible argument names: product (SKU or Name), salutation, firstName, lastName, street, houseNumber, postCode, city, country, company, phone, additionalAddress
    [Arguments]    @{args}
    ${newAddressData}=    Set Up Keyword Arguments    @{args}
    # Wait Until Element Is Visible    ${checkout_shipping_address_item_form}
    FOR    ${key}    ${value}    IN    &{newAddressData}
        Log    Key is '${key}' and value is '${value}'.
        ${item}=    Set Variable If    '${key}'=='product'    ${value}    ${item}
        Select From List By Label    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]//select    Define new address
        IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//select[contains(@name,'[salutation]')]    ${value}
        IF    '${key}'=='firstName' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[first_name]')]    ${value}
        IF    '${key}'=='lastName' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[last_name]')]    ${value}
        IF    '${key}'=='street' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[address1]')]    ${value}
        IF    '${key}'=='houseNumber' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[address2]')]    ${value}
        IF    '${key}'=='postCode' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[zip_code]')]    ${value}
        IF    '${key}'=='city' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[city]')]    ${value}
        IF    '${key}'=='country' and '${value}' != '${EMPTY}'    Select From List By Label    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//select[contains(@name,'[iso2_code]')]    ${value}
        IF    '${key}'=='company' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[company]')]    ${value}
        IF    '${key}'=='phone' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[phone]')]    ${value}
        IF    '${key}'=='additionalAddress' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[address3]')]    ${value}
    END

Yves: select the following shipping method on the checkout and go next:
    [Arguments]    ${shippingMethod}
    IF    '${env}'=='suite-nonsplit'
        Click    xpath=//input[contains(@id,'shipmentSelection')]/following-sibling::span[contains(@class,'label')][contains(text(),'${shippingMethod}')]/../span[contains(@class,'radio__box')]
    ELSE
        Click    xpath=//div[@data-qa='component shipment-sidebar']//*[contains(.,'Shipping Method')]/../ul//label[contains(.,'${shippingMethod}')]/span[contains(@class,'radio__box')]
    END
    Click    ${submit_checkout_form_button}[${env}]

Yves: submit form on the checkout
    Click    ${submit_checkout_form_button}[${env}]

Yves: select the following shipping method for the shipment:
    [Arguments]    ${shipment}    ${shippingProvider}    ${shippingMethod}
        Click    xpath=//form[@name='shipmentCollectionForm']/descendant::article[contains(@class,'grid')][${shipment}]//div[@data-qa='component shipment-sidebar']//*[contains(@class,'title')]/*[contains(text(),'${shippingProvider}')]/..//following-sibling::ul[1]//label[contains(.,'${shippingMethod}')]/span[contains(@class,'radio__box')]

Yves: select the following payment method on the checkout and go next:
    [Arguments]    ${paymentMethod}    ${paymentProvider}=${EMPTY}
    IF    '${env}'=='b2b'
        Run keywords
            Click    //form[@id='payment-form']//li[@class='checkout-list__item'][contains(.,'${paymentMethod}')]//span[contains(@class,'toggler-radio__box')]
            Type Text    ${checkout_payment_invoice_date_of_birth_field}    11.11.1111
            Click    ${submit_checkout_form_button}[${env}]
    ELSE IF    '${env}' in ['mp_b2b','mp_b2c']
        Run Keywords
            Click    //form[@id='payment-form']//li[@class='checkout-list__item'][contains(.,'${paymentMethod}')]//span[contains(@class,'toggler-radio__box')]
            Type Text    ${checkout_payment_marketplace_invoice_date_field}    11.11.1111
            Click    ${submit_checkout_form_button}[${env}]
    ELSE IF    ('${env}'=='suite-nonsplit' and '${paymentProvider}'!='${EMPTY}')
        Run Keywords
            Click    //form[@name='paymentForm']//h5[contains(text(), '${paymentProvider}')]/following-sibling::ul//label/span[contains(text(), '${paymentMethod}')]
            Click    ${submit_checkout_form_button}[${env}]
    ELSE
        Run keywords
        Click    //form[@name='paymentForm']//span[contains(@class,'toggler') and contains(text(),'${paymentMethod}')]/preceding-sibling::span[@class='toggler-radio__box']
            Type Text    ${checkout_payment_invoice_date_of_birth_field}    11.11.1111
            Click    ${submit_checkout_form_button}[${env}]
    END

Yves: '${checkoutAction}' on the summary page
    [Documentation]    Possible supported actions: 'submit the order', 'send the request' and 'approve the cart'
    IF    '${checkoutAction}' == 'submit the order'
        Click    ${checkout_summary_submit_order_button}
    ELSE IF    '${checkoutAction}' == 'send the request'
        Click    ${checkout_summary_send_request_button}
    ELSE IF    '${checkoutAction}' == 'approve the cart'
        Click    ${checkout_summary_approve_request_button}
    END

Yves: select approver on the 'Summary' page:
    [Arguments]    ${approver}
    Wait Until Element Is Visible    ${checkout_summary_approver_dropdown}
    Select From List By Label    ${checkout_summary_approver_dropdown}    ${approver}

Yves: 'Summary' page contains/doesn't contain:
    [Arguments]    ${condition}    @{checkout_summary_elements_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${checkout_summary_elements_list_count}=   get length    ${checkout_summary_elements_list}
    FOR    ${index}    IN RANGE    0    ${checkout_summary_elements_list_count}
        ${checkout_summary_element_to_check}=    Get From List    ${checkout_summary_elements_list}     ${index}
        IF    '${condition}' == 'true'
            Run Keywords
                Log    ${checkout_summary_element_to_check}    #Left as an example of multiple actions in Condition
                Page Should Contain Element    ${checkout_summary_element_to_check}    message=${checkout_summary_element_to_check} is not displayed
        END
        IF    '${condition}' == 'false'
                Run Keywords
                    Log    ${checkout_summary_element_to_check}    #Left as an example of multiple actions in Condition
                    Page Should Not Contain Element    ${checkout_summary_element_to_check}    message=${checkout_summary_element_to_check} should not be displayed
        END
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

Yves: assert merchant of product in cart or list:
    [Documentation]    Method for MP which asserts value in 'Sold by' label of item in cart or list. Requires concrete SKU
    [Arguments]    ${sku}    ${merchant_name_expected}
    Page Should Contain Element    xpath=//span[@itemprop='sku'][text()='${sku}']/../../following-sibling::p/a[text()='${merchant_name_expected}']

Yves: check payment method presence in checkout process:
    [Arguments]    ${payment_method_locator}    ${condition}
    IF    '${condition}' == 'True'
        Page Should Contain Element    ${payment_method_locator}
    ELSE IF    '${condition}' == 'False'
        Page Should not Contain Element    ${payment_method_locator}   
    END