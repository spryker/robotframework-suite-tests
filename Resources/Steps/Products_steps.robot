*** Settings ***
Resource    ../Common/Common_Zed.robot
Resource    ../Common/Common.robot
Resource    ../Pages/Zed/Zed_Edit_Product_page.robot

*** Keywords ***
Zed: discontinue the following product:
    [Arguments]    ${productAbstract}    ${productConcrete}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: perform search by:    ${productAbstract}
    Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    Zed: switch to the tab on 'Edit product' page:    Variants
    Zed: click Action Button in a table for row that contains:    ${productConcrete}    Edit
    Wait Until Element Is Visible    ${zed_pdp_concrete_main_content_locator}
    Zed: switch to the tab on 'Edit product' page:    Discontinue
    Scroll and Click Element    ${zed_pdp_discontinue_button}

Zed: undo discontinue the following product:
    [Arguments]    ${productAbstract}    ${productConcrete}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: perform search by:    ${productAbstract}
    Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    Zed: switch to the tab on 'Edit product' page:    Variants
    Zed: click Action Button in a table for row that contains:    ${productConcrete}    Edit
    Wait Until Element Is Visible    ${zed_pdp_concrete_main_content_locator}
    Zed: switch to the tab on 'Edit product' page:    Discontinue
    Scroll and Click Element    ${zed_pdp_restore_button}

Zed: check if at least one price exists for concrete and add if doesn't:
    [Arguments]    ${price}
    ${currentURL}=    Get Location  
    Run Keyword Unless    'content-price' in '${currentURL}'    Zed: switch to the tab on 'Edit product' page:    Price & Stock
    ${exists}=    BuiltIn.Run Keyword And Return Status    Element Should Exist    xpath=//table[@id='price-table-collection']//input[@type='text' and @value]
    Run Keyword If        '${exists}'=='False'    Input text into field    xpath=//table[@id='price-table-collection']//input[1]    ${price}
    Scroll and Click Element    ${zed_dpd_save_button}

Zed: add following alternative products to the concrete:
    [Arguments]    @{alternative_products_list}
    ${currentURL}=    Get Location        
    Run Keyword Unless    'content-alternatives' in '${currentURL}'    Zed: switch to the tab on 'Edit product' page:    Product Alternatives
    ${alternative_products_list_count}=   get length  ${alternative_products_list}
    FOR    ${index}    IN RANGE    0    ${alternative_products_list_count}
        ${alternative_product_to_assign}=    Get From List    ${alternative_products_list}    ${index}
        Input text into field    ${zed_pdp_add_products_alternative_input}    ${alternative_product_to_assign}
        Wait Until Element Is Visible    ${zed_pdp_alternative_products_suggestion}
        Scroll and Click Element    xpath=//ul[@id='select2-product_concrete_form_edit_alternative_products-results']/li[contains(@class,'select2-results__option') and contains(text(),'(sku: ${alternative_product_to_assign})')]
    END


Zed: switch to the tab on 'Edit product' page:
    [Arguments]    ${tabToUse}
    Scroll and Click Element    xpath=//form[contains(@name,'form_edit')]/div[@class='tabs-container']/ul[contains(@class,'nav-tabs')]//a[@data-toggle='tab'][text()='${tabToUse}']

Zed: product is successfully discontinued
    ${currentURL}=    Get Location        
    Run Keyword Unless    'discontinue' in '${currentURL}'    Zed: switch to the tab on 'Edit product' page:    Discontinue
    Page Should Contain Element    ${zed_pdp_restore_button}
