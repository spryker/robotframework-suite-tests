*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True

*** Variable ***
${catalog_product_card_locator}    xpath=(//div[contains(@class,'product-card__container')])[1]


