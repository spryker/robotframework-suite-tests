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
&{submit_checkout_form_button}    b2b=xpath=//div[contains(@class,'form--checkout-form')]//button[@data-qa='submit-button']    b2c=b2b=xpath=//div[contains(@class,'form--checkout-form')]//button[@data-qa='submit-button']    suite-nonsplit=xpath=//button[@data-qa='submit-button']

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

Yves: select an existing address on the checkout page as 'shipping' address and go next:
    [Arguments]    ${addressToUse}
    Wait Until Element Is Visible    ${checkout_address_delivery_selector}[${env}]
    Select From List By Label    ${checkout_address_delivery_selector}[${env}]    ${addressToUse}
    Click    ${submit_checkout_form_button}[${env}]

Yves: fill in a new shipping address:
    [Documentation]    Possible argument names: salutation, firstName, lastName, street, houseNumber, postCode, city, country, company, phone, additionalAddress
    [Arguments]    @{args}
    ${newAddressData}=    Set Up Keyword Arguments    @{args}
    Select From List By Label    ${checkout_address_delivery_selector}[${env}]    Define new address
    Wait Until Element Is Visible    ${checkout_new_shipping_address_form}
    FOR    ${key}    ${value}    IN    &{newAddressData}
        Log    Key is '${key}' and value is '${value}'.
        Run keyword if    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    ${checkout_shipping_address_salutation_selector}    ${value}
        Run keyword if    '${key}'=='firstName' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_first_name_field}[${env}]    ${value}
        Run keyword if    '${key}'=='lastName' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_last_name_field}    ${value}
        Run keyword if    '${key}'=='street' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_street_field}    ${value}
        Run keyword if    '${key}'=='houseNumber' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_house_number_field}    ${value}
        Run keyword if    '${key}'=='postCode' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_zip_code_field}    ${value}
        Run keyword if    '${key}'=='city' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_city_field}    ${value}
        Run keyword if    '${key}'=='country' and '${value}' != '${EMPTY}'    Select From List By Label    ${checkout_shipping_address_country_selector}    ${value}
        Run keyword if    '${key}'=='company' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_company_name_field}    ${value}
        Run keyword if    '${key}'=='phone' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_phone_field}    ${value}
        Run keyword if    '${key}'=='additionalAddress' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_additional_address_field}    ${value}
    END

Yves: fill in a new billing address:
    [Documentation]    Possible argument names: salutation, firstName, lastName, street, houseNumber, postCode, city, country, company, phone, additionalAddress
    [Arguments]    @{args}
    ${newAddressData}=    Set Up Keyword Arguments    @{args}
    Select From List By Label    ${checkout_address_billing_selector}[${env}]    Define new address
    Wait Until Element Is Visible    ${checkout_new_billing_address_form}
    FOR    ${key}    ${value}    IN    &{newAddressData}
        Log    Key is '${key}' and value is '${value}'.
        Run keyword if    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    ${checkout_billing_address_salutation_selector}    ${value}
        Run keyword if    '${key}'=='firstName' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_first_name_field}    ${value}
        Run keyword if    '${key}'=='lastName' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_last_name_field}    ${value}
        Run keyword if    '${key}'=='street' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_street_field}    ${value}
        Run keyword if    '${key}'=='houseNumber' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_house_number_field}    ${value}
        Run keyword if    '${key}'=='postCode' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_zip_code_field}    ${value}
        Run keyword if    '${key}'=='city' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_city_field}    ${value}
        Run keyword if    '${key}'=='country' and '${value}' != '${EMPTY}'    Select From List By Label    ${checkout_billing_address_country_select}    ${value}
        Run keyword if    '${key}'=='company' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_company_name_field}    ${value}
        Run keyword if    '${key}'=='phone' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_phone_field}    ${value}
        Run keyword if    '${key}'=='additionalAddress' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_additional_address_field}    ${value}
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
    FOR    ${key}    ${value}    IN    &{newAddressData}
        Log    Key is '${key}' and value is '${value}'.
        ${item}=    Set Variable If    '${key}'=='product'    ${value}    ${item}
        Select From List By Label    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]//select    Define new address
        Run keyword if    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//select[contains(@name,'[salutation]')]    ${value}
        Run keyword if    '${key}'=='firstName' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[first_name]')]    ${value}
        Run keyword if    '${key}'=='lastName' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[last_name]')]    ${value}
        Run keyword if    '${key}'=='street' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[address1]')]    ${value}
        Run keyword if    '${key}'=='houseNumber' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[address2]')]    ${value}
        Run keyword if    '${key}'=='postCode' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[zip_code]')]    ${value}
        Run keyword if    '${key}'=='city' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[city]')]    ${value}
        Run keyword if    '${key}'=='country' and '${value}' != '${EMPTY}'    Select From List By Label    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//select[contains(@name,'[iso2_code]')]    ${value}
        Run keyword if    '${key}'=='company' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[company]')]    ${value}
        Run keyword if    '${key}'=='phone' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[phone]')]    ${value}
        Run keyword if    '${key}'=='additionalAddress' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[address3]')]    ${value}
    END

Yves: select shipping method on the checkout page and go next:
    [Arguments]    ${shippingMethod}
    Run Keyword If    '${env}'=='suite-nonsplit'    Click    xpath=//input[contains(@id,'shipmentSelection')]/following-sibling::span[contains(@class,'label')][contains(text(),'${shippingMethod}')]/../span[contains(@class,'radio__box')]
    ...    ELSE    Click    xpath=//div[@data-qa='component shipment-sidebar']//*[contains(.,'Shipping Method')]/../ul//label[contains(.,'${shippingMethod}')]/span[contains(@class,'radio__box')]
    Click    ${submit_checkout_form_button}[${env}]

Yves: submit form on the checkout
    Click    ${submit_checkout_form_button}[${env}]

Yves: select shipping method for the shipment:
    [Arguments]    ${shipment}    ${shippingProvider}    ${shippingMethod}
        Click    xpath=//form[@name='shipmentCollectionForm']/descendant::article[contains(@class,'grid')][${shipment}]//div[@data-qa='component shipment-sidebar']//*[contains(@class,'title')]/*[contains(text(),'${shippingProvider}')]/..//following-sibling::ul[1]//label[contains(.,'${shippingMethod}')]/span[contains(@class,'radio__box')]

Yves: select payment method on the checkout page and go next:
    [Arguments]    ${paymentMethod}
    Run Keyword If    '${env}'=='b2b'    Run keywords
    ...    Click    //form[@id='payment-form']//li[@class='checkout-list__item'][contains(.,'${paymentMethod}')]//span[contains(@class,'toggler-radio__box')]
    ...    AND    Click    ${submit_checkout_form_button}[${env}]
    ...    ELSE    Run keywords
    ...    Click    //form[@name='paymentForm']//span[contains(@class,'toggler') and contains(text(),'${paymentMethod}')]/preceding-sibling::span[@class='toggler-radio__box']
    ...    AND    Type Text    ${checkout_payment_invoice_date_of_birth_field}    11.11.1111
    ...    AND    Click    ${submit_checkout_form_button}[${env}]

Yves: '${checkoutAction}' on the summary page
    [Documentation]    Possible supported actions: 'submit the order', 'send the request' and 'approve the cart'
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
