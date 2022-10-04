*** Variables ***
${create_shipment_button}    //a[normalize-space()='Create Shipment']
${edit_shipment_button}    (//a[contains(text(),'Edit Shipment')])[1]
${shipment_method_dropdown}    id=shipment_group_form_shipment_method_idShipmentMethod
${save_button_edit_shipment_page}    xpath=//input[@value='Save']
${view_order_last_placed}    xpath=(//a[starts-with(@href,'/sales/detail')])[1]
${delivery_address_edit_shipment_page}    id=shipment_group_form_shipment_shippingAddress_idCustomerAddress
${salutation_create_new_shipment_page}    xpath=//select[@id='shipment_group_form_shipment_shippingAddress_salutation']
${country_create_new_shipment_page}    xpath=(//select[@id='shipment_group_form_shipment_shippingAddress_iso2Code'])[1]
${save_button_new_shipment_page}    xpath=//input[@value='Save']
${shipment_method_dropdown_new_shipment_page}    xpath=//select[@id='shipment_group_form_shipment_method_idShipmentMethod']
${shipment_address_first_name}    xpath=//input[@id='shipment_group_form_shipment_shippingAddress_firstName']
${shipment_address_last_name}    xpath=//input[@id='shipment_group_form_shipment_shippingAddress_lastName']
${shipment_address_email}    xpath=//input[@id='shipment_group_form_shipment_shippingAddress_email']
${shipment_address_address1}    xpath= (//input[@id="shipment_group_form_shipment_shippingAddress_address1"])[1]
${shipment_address_address2}    xpath=(//input[@id='shipment_group_form_shipment_shippingAddress_address2'])[1]
${shipment_address_city}    xpath=//input[@id='shipment_group_form_shipment_shippingAddress_city']
${shipment_address_zipcode}    xpath=//input[@id='shipment_group_form_shipment_shippingAddress_zipCode']