*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True

*** Variable ***
${pdp_main_container_locator}    xpath=//main[contains(@class,'page-layout-main--pdp')]//div[@class='container']
${pdp_price_element_locator}    xpath=//span[contains(@class,'volume-price__price')]
${pdp_add_to_cart_button}    xpath=//button[@data-qa='add-to-cart-button']
${pdp_quantity_input_filed}    xpath=//form[@class='js-product-configurator__form']//input[@name='quantity']
${pdp_alternative_products_slider}    xpath=//*[@data-qa='component product-alternative-slider']
