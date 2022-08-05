*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_mp.robot
Resource    ../pages/mp/mp_offer_drawer.robot

*** Keywords ***    
MP: fill offer fields:
    [Arguments]    ${merchantSku}    ${offerStore}    ${priceStore}    ${priceCurrency}    ${priceGrossValue}
    Wait Until Element Is Visible    ${offer_active_checkbox}
    Click    ${offer_active_checkbox}
    Type Text    ${offer_merchant_sku}    ${merchantSku}
    Click    ${stores_list_selector}
    Keyboard Input    type    ${offerStore}
    Keyboard Key    press    Enter
    Type Text    ${offer_stock_input}    100
    MP: fill offer price values:    1    ${priceStore}    ${priceCurrency}    ${priceGrossValue}
    MP: click submit button
    Wait Until Element Is Visible    ${offer_saved_popup}
    Wait Until Element Is Not Visible    ${offer_saved_popup}

MP: fill offer price values:
    [Arguments]    ${rowNumber}    ${priceStore}    ${priceCurrency}    ${grossDefault}
    Wait Until Element Is Visible    ${mp_add_price_button}
    Click    ${mp_add_price_button}
    Click    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[1]//spy-select
    MP: select option in expanded dropdown:    ${priceStore}
    Click    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[2]//spy-select
    MP: select option in expanded dropdown:    ${priceCurrency}
    Type Text    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[4]//input    ${grossDefault}
