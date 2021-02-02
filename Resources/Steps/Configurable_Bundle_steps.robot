*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Library    BuiltIn
Resource    ../Common/Common_Yves.robot
Resource    ../Pages/Yves/Yves_Bundle_Configurator_page.robot

*** Keywords ***
Yves: choose bundle template to configure:
    [Arguments]    ${bundleTemplate}
    Scroll and Click Element    xpath=//div[@data-qa='component template-list']//*[@class='template-list__item-name'][text()='${bundleTemplate}']/ancestor::a
    Wait Until Element Is Visible    ${bundle_configurator_main_content_locator}

Yves: select product in the bundle slot:
    [Arguments]    ${slot}    ${sku}
    Scroll and Click Element    xpath=//form[@name='configurator_state_form']//button[contains(.,'${slot}')]
    Wait For Document Ready    
    Run keyword if    '${env}'=='b2b'    Scroll and Click Element    xpath=//product-item-list[@data-qa='component configurator-product']//span[@class='configurator-product__sku'][text()='Sku: ${sku}']/ancestor::product-item-list//button
    ...    ELSE    Run keyword if    '${env}'=='b2c'    Scroll and Click Element    xpath=//product-item-list[@data-qa='component configurator-product']//span[contains(text(),'${sku}')]/ancestor::product-item-list//button
    Wait For Document Ready    

Yves: go to 'Summary' step in the bundle configurator
    Scroll and Click Element    ${bundle_configurator_summary_step}
    Wait For Document Ready 
    Wait For Document Ready

Yves: add products to the shopping cart in the bundle configurator
    Wait Until Element Is Visible    ${bundle_configurator_add_to_cart_button}
    Scroll and Click Element    ${bundle_configurator_add_to_cart_button}
    Wait For Document Ready    
    Yves: remove flash messages