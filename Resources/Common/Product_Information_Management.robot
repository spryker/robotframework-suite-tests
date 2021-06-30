*** Settings ***
Library     SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Resource    ./Common_Zed.robot


*** Variables ***
${abstract_product_edit_tab_3}         Variants
${concrete_product_edit_tab_2}         Price & Stock

*** Keywords ***
Zed: Edit an Abstract Product:
    [Documentation]                                 Enter the edit page of an abstract product. Expect to be in the Products list page.
    [Arguments]                                     ${abstract_product_sku}
    Zed: table should contain:                      ${abstract_product_sku}
    Scroll and Click Element                        xpath=/html/body/div[1]/div/div[3]/div[3]/div/div/div[2]/div/div[2]/div/div[1]/div[2]/table/tbody/tr/td[10]/a[2]
    Wait For Document Ready
    Element Should Be Visible                       xpath=//body//*[contains(text(),'Edit Product Abstract: ${abstract_product_sku}')]    message=Page for Abstract Product edition is not opened

Zed: Edit a Concrete Product:
    [Documentation]                                 Enter the edit page of a concrete product. Expect to be in the Products list page.
    [Arguments]                                     ${abstract_product_sku}    ${concrete_product_sku}
    Zed: Edit an Abstract Product:                  ${abstract_product_sku}
    Zed: go to tab:                                 ${abstract_product_edit_tab_3}
    Zed: table should contain:                      ${concrete_product_sku}
    Scroll and Click Element                        xpath=/html/body/div[2]/div/div[3]/form/div[1]/div[1]/div[3]/div/div[2]/div[2]/div/div[1]/div[2]/table/tbody/tr/td[6]/a[2]
    # Element Should Be Visible                       xpath=//body//*[contains(text(),'Edit Product Concrete: ${concrete_product_sku}')]    message=Page for Concrete Product edition is not opened

Zed: Go to the product list
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:        Catalog    Products