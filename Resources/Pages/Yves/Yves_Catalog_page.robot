*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True

*** Variable ***
&{catalog_main_page_locator}    b2b=xpath=//main[contains(@class,'page-layout-main--catalog-page')]    b2c=xpath=//div[contains(@class,'catalog-right')]
${catalog_product_card_locator}    xpath=//product-item[@data-qa='component product-item'][1]
${catalog_products_counter_locator}    xpath=//*[contains(@class,'col--counter')]


