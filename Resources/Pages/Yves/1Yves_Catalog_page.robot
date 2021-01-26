*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True

*** Variable ***
${catalog_main_page_locator}    xpath=//main[contains(@class,'page-layout-main--catalog-page')]
${catalog_product_card_locator}    xpath=//product-item[@data-qa='component product-item'][1]
${catalog_products_counter_locator}    xpath=//*[contains(@class,'col--counter')]

