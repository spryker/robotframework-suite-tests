*** Settings ***
Resource    ../Pages/Zed/Zed_Discount_page.robot
Resource    ../Common/Common_Zed.robot
Resource    ../Common/Common.robot

*** Keywords ***
Zed: create a discount and activate it:
    [Arguments]    ${discountType}    ${valueType}    ${discountValue}    ${applyToQuery}=    ${voucherCode}=    ${promotionalProductDiscount}=False    ${promotionalProductAbstractSku}=    ${promotionalProductQuantity}=    ${applyWhenQuery}=    ${discountName}=Test Discount    ${discountDescription}='Test Description'
    ${currentURL}=    Get Location
# General information   
    Scroll and Click Element    ${zed_discount_add_new_discount_button}
    Wait Until Element Is Visible    ${zed_discount_create_discount_page}
    Run Keyword Unless    'tab-content-general' in '${currentURL}'
    ...    Zed: go to tab:    General Information
    Run keyword if    '${discountType}'=='voucher'    Select From List By Label    ${zed_discount_type_dropdown}    Voucher codes
    ...    ELSE    Run keyword if    '${discountType}'=='cart rule'    Select From List By Label    ${zed_discount_type_dropdown}    Cart rule
    Input text into field    ${zed_discount_name_field}     ${discountName}
    Input text into field    ${zed_discount_description_field}     ${discountDescription}
    Execute Javascript    document.getElementById("discount_discountGeneral_valid_from").setAttribute("value", "2021-01-01")
    Execute Javascript    document.getElementById("discount_discountGeneral_valid_to").setAttribute("value", "2050-01-01")
# Discount calculation 
    Zed: go to tab:    Discount calculation
    Wait For Document Ready    
    Run keyword if    '${valueType}'=='Percentage'    Run Keywords    Select From List By Label    ${zed_discount_calculator_type_drop_down}    Percentage    
    ...    AND    Input text into field    ${zed_discount_percentage_value_field}     ${discountValue}
    ...    ELSE    Run keyword if    Run keywords    '${valueType}'=='Fixed amount'    Select From List By Label    ${zed_discount_calculator_type_drop_down}    Fixed amount
    ...    AND    Input text into field    ${zed_discount_euro_gross_field}    ${discountValue}
    Run Keyword If    '${promotionalProductDiscount}'=='False'    Run keywords
    ...    Scroll and Click Element    ${zed_discount_plain_query_apply_to__button}
    ...    AND    Wait Until Element Is Visible    ${zed_discount_plain_query_apply_to_field}
    ...    AND    Input text into field    ${zed_discount_plain_query_apply_to_field}     ${applyToQuery}
    ...    ELSE    Run Keyword If    '${promotionalProductDiscount}'=='True'    Run keywords
    ...    Scroll and Click Element    ${zed_discount_promotional_product_radio}
    ...    AND    Wait Until Element Is Visible    ${zed_discount_promotional_product_abstract_sku_field}
    ...    AND    Input text into field    ${zed_discount_promotional_product_abstract_sku_field}     ${promotionalProductAbstractSku}
    ...    AND    Input text into field    ${zed_discount_promotional_product_abstract_quantity_field}     ${promotionalProductQuantity}
# Discount condition 
    Zed: go to tab:    Conditions
    Wait For Document Ready    
    Scroll and Click Element    ${zed_discount_plain_query_apply_when__button}
    Wait Until Element Is Visible    ${zed_discount_plain_query_apply_when_field}
    Input text into field    ${zed_discount_plain_query_apply_when_field}     ${applyWhenQuery}
    Scroll and Click Element    ${zed_discount_save_button}
    Wait For Document Ready    
    Scroll and Click Element    ${zed_discount_activate_button}
    Wait For Document Ready
# Voucher codes 
    Run keyword if    '${discountType}'=='voucher'    Zed: Generate Vouchers:    1    ${voucherCode}
# Check discount in Zed 
    Zed: go to second navigation item level:    Merchandising    Discount
    Zed: perform search by:    ${discountName}    
    Element Should Be Visible    xpath=//td[contains(@class,'name') and contains(text(),'${discountName}')]/ancestor::tr[@role='row']//span[contains(@class,'label') and contains(text(),'Active')]    message=None



Zed: Generate Vouchers:
    [Arguments]    ${quantity}    ${customCode}    ${addRandomLength}=    ${maxNumberOfUsages}=0
    ${currentURL}=    Get Location
    Run Keyword Unless    'tab-content-general' in '${currentURL}'
    ...    Zed: go to tab:    Voucher codes
    Input text into field    ${zed_discount_voucher_quantity_field}     ${quantity}
    Input text into field    ${zed_discount_voucher_custom_code_field}     ${customCode}
    Input text into field    ${zed_discount_voucher_max_usages_field}     ${maxNumberOfUsages}
    Scroll and Click Element    ${zed_discount_voucher_code_generate_button}
    Wait For Document Ready

Zed: Deactivate Following Discounts From Overview Page:
    [Arguments]    @{discountNames}
    ${items_list_count}=   get length  ${discountNames}
    Zed: go to second navigation item level:    Merchandising    Discount
    FOR    ${name}    IN    @{discountNames}
        Zed: perform search by:    ${name}    
        ${activated}=    Run Keyword And Return Status    Element Should Be Visible    xpath=Element Should Be Visible    xpath=//td[contains(@class,'name') and contains(text(),'${name}')]/ancestor::tr[@role='row']//span[contains(@class,'label') and contains(text(),'Active')]
        Run keyword if    '${activated}'=='True'    Scroll and Click Element    xpath=//button[contains(.,'Deactivate')]/ancestor::td[contains(@class,'column-Actions')]/preceding-sibling::td[contains(@class,'name') and contains(text(),'${name}')]
        Wait For Document Ready    
    END    

    