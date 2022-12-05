*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_edit_product_page.robot
Resource    ../pages/zed/zed_view_abstract_product_page.robot
Resource    ../pages/zed/zed_view_concrete_product_page.robot

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
    Click    ${zed_pdp_save_button}

Zed: change concrete product price on:
    [Arguments]    @{args}
    ${priceData}=    Set Up Keyword Arguments    @{args}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    Zed: switch to the tab on 'Edit product' page:    Variants
    Zed: click Action Button in Variant table for row that contains:    ${productConcrete}    Edit
    Wait Until Element Is Visible    ${zed_pdp_concrete_main_content_locator}
    Zed: switch to the tab on 'Edit product' page:    Price & Stock
    FOR    ${key}    ${value}    IN    &{priceData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'
            ${store}=    Set Variable    ${value}
        END
        IF    '${key}'=='mode' and '${value}' != '${EMPTY}'
            ${mode}=    Set Variable    ${value}_amount
        END
        IF    '${key}'=='type' and '${value}' == 'default'
            ${type}=    Set Variable    DEFAULT
        END
        IF    '${key}'=='type' and '${value}' == 'original'
            ${type}=    Set Variable    ORIGINAL
        END
        IF    '${key}'=='currency' and '${value}' == '€'
        ${inputField}=    Set Variable    xpath=//table[@id='price-table-collection']//td[1][contains(text(),'${store}')]/../following-sibling::tr[1]//input[contains(@id,'${mode}')][contains(@id,'${type}')]
        END
        IF    '${key}'=='currency' and '${value}' == 'CHF'
        ${inputField}=    Set Variable    xpath=//table[@id='price-table-collection']//td[1][contains(text(),'${store}')]/ancestor::tr//input[contains(@id,'${mode}')][contains(@id,'${type}')]
        END
        IF    '${key}'=='amount' and '${value}' != '${EMPTY}'
            Type Text    ${inputField}    ${value}
        END
    END
    Click    ${zed_pdp_save_button}

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

Zed: view product page is displayed
     Wait Until Element Is Visible    ${zed_view_abstract_product_main_content_locator}

Zed: view abstract product page contains:
    [Arguments]    @{args}
    ${abstractProductData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{abstractProductData}
        IF    '${key}'=='merchant' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_abstract_product_merchant}    ${value}
        END
        IF    '${key}'=='status' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_abstract_product_status}    ${value}
        END
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_abstract_product_store}    ${value}
        END
        IF    '${key}'=='sku' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_abstract_product_sku}    ${value}
        END
        IF    '${key}'=='name' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_abstract_product_name}    ${value}
        END
        IF    '${key}'=='variants count' and '${value}' != '${EMPTY}'    
            ${actualVariantsCount}=    Get Element Count    xpath=//table[@id='product-variant-table']//tbody/tr
            Should Be Equal    '${actualVariantsCount}'    '${value}'
        END
    END

Zed: update abstract product data:
    [Arguments]    @{args}
    ${abstractProductData}=    Set Up Keyword Arguments    @{args}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     ${productAbstract}     Edit
    FOR    ${key}    ${value}    IN    &{abstractProductData}
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'    
            Zed: Check checkbox by Label:    ${value}
        END
        IF    '${key}'=='unselect store' and '${value}' != '${EMPTY}'    
            Zed: Uncheck Checkbox by Label:    ${value}
        END
        IF    '${key}'=='name en' and '${value}' != '${EMPTY}'  
            Wait Until Element Is Visible    ${zed_product_name_en_input}
            Type Text    ${zed_product_name_en_input}    ${value}
        END
        IF    '${key}'=='name de' and '${value}' != '${EMPTY}'  
            ${de_section_expanded}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${zed_product_name_de_input}    timeout=3s
            IF    '${de_section_expanded}'=='False'
                Scroll Element Into View    ${zed_product_general_deDE_collapsed_section}
                Click    ${zed_product_general_deDE_collapsed_section}
                Type Text    ${zed_product_name_de_input}    ${value}
            END
        END
        IF    '${key}'=='new from' and '${value}' != '${EMPTY}'    
            Type Text    ${zed_product_new_from}    ${value}
            Keyboard Key    press    Enter
        END
        IF    '${key}'=='new to' and '${value}' != '${EMPTY}'    
            Type Text    ${zed_product_new_to}    ${value}
            Keyboard Key    press    Enter
        END
    END
    Click    ${zed_pdp_save_button}

Zed: update abstract product price on:
    [Arguments]    @{args}
    ${priceData}=    Set Up Keyword Arguments    @{args}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    Zed: switch to the tab on 'Edit product' page:    Price & Tax
    FOR    ${key}    ${value}    IN    &{priceData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'
            ${store}=    Set Variable    ${value}
        END
        IF    '${key}'=='mode' and '${value}' != '${EMPTY}'
            ${mode}=    Set Variable    ${value}_amount
        END
        IF    '${key}'=='type' and '${value}' == 'default'
            ${type}=    Set Variable    DEFAULT
        END
        IF    '${key}'=='type' and '${value}' == 'original'
            ${type}=    Set Variable    ORIGINAL
        END
        IF    '${key}'=='currency' and '${value}' == '€'
        ${inputField}=    Set Variable    xpath=//table[@id='price-table-collection']//td[1][contains(text(),'${store}')]/../following-sibling::tr[1]//input[contains(@id,'${mode}')][contains(@id,'${type}')]
        END
        IF    '${key}'=='currency' and '${value}' == 'CHF'
        ${inputField}=    Set Variable    xpath=//table[@id='price-table-collection']//td[1][contains(text(),'${store}')]/ancestor::tr//input[contains(@id,'${mode}')][contains(@id,'${type}')]
        END
        IF    '${key}'=='amount' and '${value}' != '${EMPTY}'
            Type Text    ${inputField}    ${value}
        END
    END
    Click    ${zed_pdp_save_button}
