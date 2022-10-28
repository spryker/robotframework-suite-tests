*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Variables ***
${all_product_checkbox}    id=check-all-orders
${create_reclamation_button_locator}    xpath=//input[@type="submit"]
*** Keywords ***
zed: create reclaimation
    Click    ${all_product_checkbox}
    Click    ${create_reclamation_button_locator}
    Zed: flash message should be shown:    success

Zed: select latest Reclamation
    Click    xpath=//th[@id="spy_sales_reclamation.id_sales_reclamation" and contains(text(),'#')]

