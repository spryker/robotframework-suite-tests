*** Variables ***
${shipment_method_dropdown}    id=shipment_group_form_shipment_method_idShipmentMethod
${view_order_last_placed}    xpath=(//a[starts-with(@href,'/sales/detail')])[1]
${country_create_new_shipment_page}    id=shipment_group_form_shipment_shippingAddress_iso2Code