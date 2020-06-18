*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
# Library    String
# Library    BuiltIn
# Library    Collections
Resource    ../Pages/Yves/Yves_Catalog_page.robot

*** Keywords ***
Yves: 'Catalog' page should show products:
    [Arguments]    ${productsCount}
    Element Should Contain    ${catalog_products_counter_locator}    ${productsCount}