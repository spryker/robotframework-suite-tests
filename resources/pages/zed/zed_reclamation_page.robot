*** Variables ***
${all_product_checkbox}    id=check-all-orders
${create_reclamation_button_locator}    xpath=//input[@type="submit"]
${first_view_reclamation}    xpath=(//a[contains(@href,"/sales-reclamation-gui/detail?id-reclamation")])[1]
${close_button_reclamation}    xpath= (//form[@name="close_reclamation_form"])[1]//button
${state_reclamation_locator}    xpath=(//td[@class=" column-spy_sales_reclamation.is_open"]//span[contains(@class,"label label-")])[1]