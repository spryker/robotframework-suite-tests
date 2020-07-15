*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Library    BuiltIn
Resource    ../Common/Common_Yves.robot
Resource    ../Pages/Yves/Yves_Bundle_Configurator_page.robot

*** Keywords ***
Yves: choose bundle template to configure:
    [Arguments]    ${bundleTemplate}
    Click Element    xpath=//div[@data-qa='component template-list']//*[@class='template-list__item-name'][text()='${bundleTemplate}']/ancestor::a
    Wait Until Element Is Visible    ${bundle_configurator_main_content_locator}

Yves: select product in the bundle slot:
    [Arguments]    ${slot}    ${sku}
    Click Element    xpath=//form[@name='configurator_state_form']//button[contains(.,'${slot}')]
    Wait For Document Ready    
    Click Element    xpath=//article[@data-qa='component configurator-product']//div[contains(@class,'description')]//span[text()='Sku: ${sku}']/ancestor::article//button
    Wait For Document Ready    

Yves: go to 'Summary' step in the bundle configurator
    Click Element    ${bundle_configurator_summary_step}
    Wait For Document Ready 
    Wait For Document Ready

Yves: add products to the shopping cart in the bundle configurator
    Wait Until Element Is Visible    ${bundle_configurator_add_to_cart_button}
    Click Element    ${bundle_configurator_add_to_cart_button}
    Wait For Document Ready    
    Yves: remove flash messages