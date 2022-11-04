*** Variables ***
${all_product_checkbox}    id=check-all-orders
${create_reclamation_button_locator}    xpath=//input[@type="submit"]
${first_view_reclaimation}    (//a[contains(@href,"/sales-reclamation-gui/detail?id-reclamation")])[1]
${close_button_reclaimation}    (//button[@type="submit"])[1]
${state_reclaimation_locator}    (//span[contains(@class,"label-danger")])[1]