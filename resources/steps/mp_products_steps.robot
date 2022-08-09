*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_mp.robot
Resource    ../pages/mp/mp_product_drawer.robot

*** Keywords ***
MP: fill product price values:
    [Arguments]    ${rowNumber}    ${priceCustomer}    ${priceStore}    ${priceCurrency}    ${grossDefault}    ${isConcrete}=false
    IF    "${isConcrete}" == "true"
        Wait Until Element Is Visible    ${mp_add_concrete_price_button}
        Click    ${mp_add_concrete_price_button}
    ELSE   
        Wait Until Element Is Visible    ${mp_add_price_button}
        Click    ${mp_add_price_button}
    END
    Click    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[1]//spy-select
    MP: select option in expanded dropdown:    ${priceCustomer}
    Click    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[2]//spy-select
    MP: select option in expanded dropdown:    ${priceStore}
    Click    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[3]//spy-select
    MP: select option in expanded dropdown:    ${priceCurrency}
    Type Text    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[5]//input    ${grossDefault}
    
MP: create multi sku product with following data:
    [Documentation]    Creates new abstract product with 2 variants    
    [Arguments]    @{args}
    ${productData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${mp_submit_button}
    FOR    ${key}    ${value}    IN    &{productData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='product sku'    Type Text    ${new_product_sku_field}    ${value}
        IF    '${key}'=='product name'    
        Run keywords    
            Type Text    ${new_product_name_field}    ${value}
            Click    ${new_product_multiple_concretes_option}
            MP: click submit button
            Wait Until Element Is Visible    ${spinner_loader}
            Wait Until Element Is Not Visible    ${spinner_loader}
            Click    ${new_product_super_attribute_first_row_name_selector}
        END
        IF    '${key}'=='first attribute name'    
        Run keywords    
            MP: select option in expanded dropdown:    ${value}
            Click    ${new_product_super_attribute_first_row_values_selector}
        END
        IF    '${key}'=='first attribute first value'    MP: select option in expanded dropdown:    ${value}
        IF    '${key}'=='first attribute second value'    
        Run Keywords
            MP: select option in expanded dropdown:    ${value}
            Click    ${new_product_add_super_attribute_button}  
            Click    ${new_product_super_attribute_second_row_name_selector}
        END
        IF    '${key}'=='second attribute name'    
        Run Keywords
            MP: select option in expanded dropdown:    ${value}
            Click    ${new_product_super_attribute_second_row_values_selector}
        END
        IF    '${key}'=='second attribute value'    MP: select option in expanded dropdown:    ${value}
    END  
    Element Should Contain    ${new_product_concretes_preview_count}    2
    Click    ${new_product_submit_create_button}
    Wait Until Element Is Visible    ${new_product_created_popup}
    Wait Until Element Is Not Visible    ${new_product_created_popup}

MP: fill abstract product required fields:
    [Arguments]    ${productNameDE}    ${productStore}    ${taxSet}    
    Wait Until Element Is Visible    ${product_name_de_field}
    Type Text    ${product_name_de_field}    ${productNameDE}
    Click    ${product_store_selector}
    MP: select option in expanded dropdown:    ${productStore}
    Wait Until Element Is Visible    ${product_tax_selector}
    Click    ${product_tax_selector}
    MP: select option in expanded dropdown:    ${taxSet}

MP: save abstract product    
    MP: click submit button
    Wait Until Element Is Visible    ${product_updated_popup}
    Wait Until Element Is Not Visible    ${product_updated_popup}

MP: fill concrete product fields
    Click    ${product_concrete_active_checkbox}
    Type Text    ${product_concrete_stock_input}    100
    Click    ${product_concrete_use_abstract_name_checkbox} 
    Click    ${product_concrete_searchability_selector}
    MP: select option in expanded dropdown:    en_US
    MP: save concrete product

MP: save concrete product
    Click    ${product_concrete_submit_button}
    Wait Until Element Is Visible    ${product_updated_popup}
    Wait Until Element Is Not Visible    ${product_updated_popup}

MP: delete price row that contains text:
    [Arguments]    ${rowContent}
    Scroll Element Into View    xpath=//spy-chips[contains(text(),'${rowContent}')]/ancestor::tr//td[@class='ng-star-inserted']/div
    Hover    xpath=//spy-chips[contains(text(),'${rowContent}')]/ancestor::tr//td[@class='ng-star-inserted']/div
    Click    ${product_delete_price_row_button}
    Wait Until Element Is Visible    ${product_price_deleted_popup}
    Wait Until Element Is Not Visible    ${product_price_deleted_popup}

MP: open concrete drawer by SKU:
    [Arguments]    ${concreteSKU}
    Click    ${product_drawer_concretes_tab}    
    MP: click on a table row that contains:    ${concreteSKU}
    Wait Until Element Is Visible    ${spinner_loader}
    Wait Until Element Is Not Visible    ${spinner_loader}



