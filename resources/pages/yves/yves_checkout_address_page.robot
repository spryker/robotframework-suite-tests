*** Variables ***
${checkout_address_billing_same_as_shipping_checkbox}    id=addressesForm_billingSameAsShipping
${checkout_address_delivery_dropdown}    xpath=//div[contains(@class,'js-address__form-handler-shippingAddress')]//select[@name='checkout-full-addresses'][contains(@class,'js-address__form-select-shippingAddress')]
${checkout_shipping_address_first_name_field}    id=addressesForm_shippingAddress_first_name
${checkout_shipping_address_last_name_field}    id=addressesForm_shippingAddress_last_name
${checkout_shipping_address_company_name_field}    id=addressesForm_shippingAddress_company
${checkout_shipping_address_street_field}    id=addressesForm_shippingAddress_address1
${checkout_shipping_address_house_number_field}    id=addressesForm_shippingAddress_address2
${checkout_shipping_address_additional_address_field}    id=addressesForm_shippingAddress_address3
${checkout_shipping_address_zip_code_field}    id=addressesForm_shippingAddress_zip_code
${checkout_shipping_address_city_field}    id=addressesForm_shippingAddress_city
${checkout_shipping_address_phone_field}    id=addressesForm_shippingAddress_phone
${checkout_shipping_address_salutation_dropdown}    id=select2-addressesForm_shippingAddress_id_customer_address-container
${checkout_shipping_address_country_dropdown}    id=select2-addressesForm_shippingAddress_iso2_code-container 
${checkout_address_submit_button}    xpath=//button[@data-qa='submit-button']
${checkout_shipping_multiple_address_first_name_field}    /ancestor::div[contains(@class,'grid js-address-item-form-field-list__item-shipping')]//input[contains(@id,'shippingAddress_first_name')]
${checkout_shipping_multiple_address_last_name_field}    /ancestor::div[contains(@class,'grid js-address-item-form-field-list__item-shipping')]//input[contains(@id,'shippingAddress_last_name')]
${checkout_shipping_multiple_address_company_name_field}    /ancestor::div[contains(@class,'grid js-address-item-form-field-list__item-shipping')]//input[contains(@id,'shippingAddress_company')]
${checkout_shipping_multiple_address_street_field}    /ancestor::div[contains(@class,'grid js-address-item-form-field-list__item-shipping')]//input[contains(@id,'shippingAddress_address1')]
${checkout_shipping_multiple_address_house_number_field}    /ancestor::div[contains(@class,'grid js-address-item-form-field-list__item-shipping')]//input[contains(@id,'shippingAddress_address2')]
${checkout_shipping_multiple_address_additional_address_field}    /ancestor::div[contains(@class,'grid js-address-item-form-field-list__item-shipping')]//input[contains(@id,'shippingAddress_address3')]
${checkout_shipping_multiple_address_zip_code_field}    /ancestor::div[contains(@class,'grid js-address-item-form-field-list__item-shipping')]//input[contains(@id,'shippingAddress_zip_code')]
${checkout_shipping_multiple_address_city_field}    /ancestor::div[contains(@class,'grid js-address-item-form-field-list__item-shipping')]//input[contains(@id,'shippingAddress_city')]
${checkout_shipping_multiple_address_phone_field}    /ancestor::div[contains(@class,'grid js-address-item-form-field-list__item-shipping')]//input[contains(@id,'shippingAddress_phone')]
${checkout_billing_address_first_name_field}    id=addressesForm_billingAddress_first_name
${checkout_billing_address_last_name_field}    id=addressesForm_billingAddress_last_name
${checkout_billing_address_company_name_field}    id=addressesForm_billingAddress_company
${checkout_billing_address_street_field}    id=addressesForm_billingAddress_address1
${checkout_billing_address_house_number_field}    id=addressesForm_billingAddress_address2
${checkout_billing_address_additional_address_field}    id=addressesForm_billingAddress_address3
${checkout_billing_address_zip_code_field}    id=addressesForm_billingAddress_zip_code
${checkout_billing_address_city_field}    id=addressesForm_billingAddress_city
${checkout_billing_address_phone_field}    id=addressesForm_billingAddress_phone
${manage_your_addresses_link}    xpath=//a[contains(@href,'customer/address')]
