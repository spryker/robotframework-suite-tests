*** Variables ***
${checkout_address_billing_same_as_shipping_checkbox}    xpath=//div[contains(@class,'col col--sm-12 js-address__form-handler-billingSameAsShipping')]//toggler-checkbox[@name='addressesForm[billingSameAsShipping]']
${checkout_address_delivery_dropdown}    xpath=//div[contains(@class,'js-address__form-handler-shippingAddress')]//select[@name='checkout-full-addresses'][contains(@class,'js-address__form-select-shippingAddress')]

