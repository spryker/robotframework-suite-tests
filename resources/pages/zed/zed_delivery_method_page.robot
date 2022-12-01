*** Variables ***
${create_carrier_company_button_locator}    xpath=//a[contains(@href,"/shipment-gui/create-carrier/index")]
${create_delivery_method_button_locator}    xpath=//a[contains(@href,"/shipment-gui/create-shipment-method")]
${shipment_carrier_name_input_field_locator}    id=shipment_carrier_name
${delivery_method_key_locator}    id=shipment_method_shipmentMethodKey
${shipment_method_name_locator}    id=shipment_method_name
${delivery_method_carrier_dropdown_locator}    id=shipment_method_fkShipmentCarrier
${zed_delivery_method_de_store_checkbox}    xpath=//input[@type='checkbox']/../../label[contains(text(),'DE')]//input
${zed_delivery_method_at_store_checkbox}    xpath=//input[@type='checkbox']/../../label[contains(text(),'AT')]//input
${delivery_method_gross_price_de_chf}    id=shipment_method_prices_0_gross_amount
${delivery_method_gross_price_de_euro}    id=shipment_method_prices_1_gross_amount
${delivery_method_gross_price_at_chf}    id=shipment_method_prices_2_gross_amount
${delivery_method_gross_price_at_euro}    id=shipment_method_prices_3_gross_amount
${delivery_method_net_price_de_chf}    id=shipment_method_prices_0_net_amount
${delivery_method_net_price_de_euro}    id=shipment_method_prices_1_net_amount
${delivery_method_net_price_at_chf}    id=shipment_method_prices_2_net_amount
${delivery_method_net_price_at_euro}    id=shipment_method_prices_3_net_amount
${delivery_method_tax_set_dropdown_locator}    id=shipment_method_fkTaxSet
${confirm_delete_shipment_method_button_locator}    id=shipment_method_delete_form_submit
${delivery_method_availability_plugin_dropdown_locator}    id=shipment_method_availabilityPlugin
${delivery_method_price_plugin_dropdown_locator}    id=shipment_method_pricePlugin
${delivery_method_delivery_time_plugin}    id=shipment_method_deliveryTimePlugin
${delivery_method_view_mode_header}    xpath=//div[contains(@class,'white-bg page-heading')]//div/h2