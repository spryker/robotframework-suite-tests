*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True

*** Variable ***
&{catalog_main_page_locator}    b2b=xpath=//main[contains(@class,'page-layout-main--catalog-page')]    b2c=xpath=//div[contains(@class,'catalog-right')]
${catalog_product_card_locator}    xpath=//product-item[@data-qa='component product-item'][1]
&{catalog_products_counter_locator}    b2b=xpath=//*[contains(@class,'col--counter')]    b2c=xpath=//*[contains(@class,'sort__results col')]
${catalog_filter_apply_button}    xpath=//button[contains(text(),'Apply')]
${catalog_add_to_cart_button}    xpath=//button[contains(@title,'Add to Cart')]



