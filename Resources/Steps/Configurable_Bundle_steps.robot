*** Settings ***
Resource    ../Common/Common.robot
Resource    ../Common/Common_Yves.robot
Resource    ../Pages/Yves/Yves_Bundle_Configurator_page.robot

*** Keywords ***
Yves: choose bundle template to configure:
    [Arguments]    ${bundleTemplate}
    Click    xpath=//div[@data-qa='component template-list']//*[@class='template-list__item-name'][text()='${bundleTemplate}']/ancestor::a
    Wait Until Element Is Visible    ${bundle_configurator_main_content_locator}

Yves: select product in the bundle slot:
    [Arguments]    ${slot}    ${sku}
    Click    xpath=//form[@name='configurator_state_form']//button[contains(.,'${slot}')]
        
    Run keyword if    '${env}'=='b2b'    Click    xpath=//product-item-list[@data-qa='component configurator-product']//span[@class='configurator-product__sku'][text()='Sku: ${sku}']/ancestor::product-item-list//button
    ...    ELSE    Run keyword if    '${env}'=='b2c'    Click    xpath=(//product-item-list[@data-qa='component configurator-product']//span[contains(text(),'${sku}')]/ancestor::product-item-list//button)[1]
        

Yves: go to 'Summary' step in the bundle configurator
    Click    ${bundle_configurator_summary_step}
     
    

Yves: add products to the shopping cart in the bundle configurator
    Wait Until Element Is Visible    ${bundle_configurator_add_to_cart_button}
    Click    ${bundle_configurator_add_to_cart_button}
        
    Yves: remove flash messages