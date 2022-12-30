*** Variables ***
${order_details_billng_address}    xpath=//div[@id='customer']//div[contains(@class,'content')]//dd[last()]
${create_shipment_button}    xpath=//a[contains(@href,'/shipment-gui/create')]
${create_shipment_delivery_address_dropdown}    id=shipment_group_form_shipment_shippingAddress_idCustomerAddress
${create_shipment_salutation_dropdown}    id=shipment_group_form_shipment_shippingAddress_salutation
${create_shipment_first_name_field}    id=shipment_group_form_shipment_shippingAddress_firstName
${create_shipment_last_name_field}    id=shipment_group_form_shipment_shippingAddress_lastName
${create_shipment_email_field}    id=shipment_group_form_shipment_shippingAddress_email
${create_shipment_country_dropdown}    id=shipment_group_form_shipment_shippingAddress_iso2Code
${create_shipment_address_1_field}    id=shipment_group_form_shipment_shippingAddress_address1    
${create_shipment_address_2_field}    id=shipment_group_form_shipment_shippingAddress_address2
${create_shipment_city_field}    id=shipment_group_form_shipment_shippingAddress_city
${create_shipment_zip_code_field}    id=shipment_group_form_shipment_shippingAddress_zipCode
${create_shipment_shipment_method}    id=shipment_group_form_shipment_method_idShipmentMethod
${create_shipment_requested_delivery_date}    id=shipment_group_form_shipment_requestedDeliveryDate
${zed_order_details_page_comments}    xpath=//p[@class="comment-title"]//following-sibling::p
${create_shipment_button}    xpath=//a[contains(@href,'shipment-gui/create?')]
${edit_shipment_button}    xpath=//a[contains(@href,'shipment-gui/edit?')]
