*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_edit_product_page.robot

*** Keywords ***
Zed: discontinue the following product:
    [Arguments]    ${productAbstract}    ${productConcrete}
    Wait Until Element Is Visible    ${zed_log_out_button}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: perform search by:    ${productAbstract}
    Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    Zed: switch to the tab on 'Edit product' page:    Variants
    Zed: click Action Button in Variant table for row that contains:    ${productConcrete}    Edit
    Wait Until Element Is Visible    ${zed_pdp_concrete_main_content_locator}
    Zed: switch to the tab on 'Edit product' page:    Discontinue
    ${can_be_discontinued}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_pdp_discontinue_button}
    IF    '${can_be_discontinued}'=='True'    Click    ${zed_pdp_discontinue_button}

Zed: undo discontinue the following product:
    [Arguments]    ${productAbstract}    ${productConcrete}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: perform search by:    ${productAbstract}
    Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    Zed: switch to the tab on 'Edit product' page:    Variants
    Zed: click Action Button in Variant table for row that contains:    ${productConcrete}    Edit
    Wait Until Element Is Visible    ${zed_pdp_concrete_main_content_locator}
    Zed: switch to the tab on 'Edit product' page:    Discontinue
    ${can_be_restored}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_pdp_restore_button}
    IF    '${can_be_restored}'=='True'    Click    ${zed_pdp_restore_button}

Zed: check if at least one price exists for concrete and add if doesn't:
    [Arguments]    ${price}
    ${currentURL}=    Get Location
    IF    'content-price' not in '${currentURL}'    Zed: switch to the tab on 'Edit product' page:    Price & Stock
    ${exists}=    BuiltIn.Run Keyword And Return Status    Element Should Exist    xpath=///table[@id='price-table-collection']//input[@id='product_concrete_form_edit_prices_1-93-DEFAULT-BOTH_moneyValue_gross_amount']
    IF        '${exists}'=='False'    Type Text    xpath=//table[@id='price-table-collection']//input[@id='product_concrete_form_edit_prices_1-93-DEFAULT-BOTH_moneyValue_gross_amount']    ${price}
    Click    ${zed_dpd_save_button}

Zed: add following alternative products to the concrete:
    [Arguments]    @{alternative_products_list}
    ${currentURL}=    Get Location
    IF    'content-alternatives' not in '${currentURL}'    Zed: switch to the tab on 'Edit product' page:    Product Alternatives
    ${alternative_products_list_count}=   get length  ${alternative_products_list}
    FOR    ${index}    IN RANGE    0    ${alternative_products_list_count}
        ${alternative_product_to_assign}=    Get From List    ${alternative_products_list}    ${index}
        Type Text    ${zed_pdp_add_products_alternative_input}    ${alternative_product_to_assign}
        Wait Until Element Is Visible    ${zed_pdp_alternative_products_suggestion}
        Click    xpath=//ul[@id='select2-product_concrete_form_edit_alternative_products-results']/li[contains(@class,'select2-results__option') and contains(text(),'(sku: ${alternative_product_to_assign})')]
    END
    Zed: submit the form

Zed: switch to the tab on 'Edit product' page:
    [Arguments]    ${tabToUse}
    Click    xpath=//form[contains(@name,'form_edit')]/div[@class='tabs-container']/ul[contains(@class,'nav-tabs')]//a[@data-toggle='tab'][text()='${tabToUse}']

Zed: product is successfully discontinued
    ${currentURL}=    Get Location
    IF    'discontinue' not in '${currentURL}'    Zed: switch to the tab on 'Edit product' page:    Discontinue
    Page Should Contain Element    ${zed_pdp_restore_button}

Zed: update stock quantity of product for selected warehouse:
    [Arguments]    ${warehouse}    ${abstract_sku}    ${concrete_sku}     ${quantity}    ${never_out_of_stock}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: click Action Button in a table for row that contains:    ${abstract_sku}    Edit
    Zed: go to tab:    Variants
    Zed: click Action Button in Variant table for row that contains:    ${concrete_sku}    Edit
    Zed: go to tab:    Price & Stock
    Zed: make product out of stock for all warehouses
    Type Text    xpath=//input[@value='${warehouse}']//parent::div/following-sibling::div[1]//child::input    ${quantity}
    Zed: check/uncheck never out of stock checkbox for particular warehouse:    ${warehouse}    ${never_out_of_stock}
    
Zed: check/uncheck never out of stock checkbox for particular warehouse:
    [Arguments]    ${warehouse}    ${never_out_of_stock}
    ${checkboxState}=    Set Variable    ${EMPTY}
    ${checkboxState}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//input[@value='${warehouse}']//parent::div/following-sibling::div[2]//input[@checked='1']
    IF    '${checkboxState}'=='False' and '${never_out_of_stock}' == 'true'    Click     xpath=//input[@value='${warehouse}']//parent::div/following-sibling::div[2]//input
    IF    '${checkboxState}'=='True' and '${never_out_of_stock}' == 'false'    Click     xpath=//input[@value='${warehouse}']//parent::div/following-sibling::div[2]//input
    Zed: submit the form

Zed: make product out of stock for all warehouses
    ${never_out_of_stock_count}=    Get Element Count    //input[@type='checkbox']/../../label[contains(@for,'product_concrete_form_edit_price')]//input
    ${counter}=    Set Variable    1
    WHILE    ${counter} <= ${never_out_of_stock_count}
        Type Text    (//input[@class="form-control" and not (contains(@readonly,'readonly'))] )[${counter}]   0
        Log    ${counter}
        ${state}=    Get Checkbox State    (//input[@type='checkbox']/../../label[contains(@for,'product_concrete_form_edit_price')]//input)[${counter}]
        Log    ${state}
        IF    '${state}' == 'True'
            Uncheck Checkbox    (//input[@type='checkbox']/../../label[contains(@for,'product_concrete_form_edit_price')]//input)[${counter}]
        END
        ${counter}=    Evaluate    ${counter} + 1
    END   