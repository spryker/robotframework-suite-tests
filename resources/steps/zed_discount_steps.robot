*** Settings ***
Resource    ../pages/zed/zed_discount_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Keywords ***
Zed: create a discount and activate it:
    [Arguments]    ${discountType}    ${valueType}    ${discountValue}    ${applyToQuery}=    ${voucherCode}=    ${promotionalProductDiscount}=False    ${promotionalProductAbstractSku}=    ${promotionalProductQuantity}=    ${applyWhenQuery}=    ${discountName}=Test Discount    ${discountDescription}='Test Description'
    ${currentURL}=    Get Location
# General information
    Click    ${zed_discount_add_new_discount_button}
    Wait Until Element Is Visible    ${zed_discount_create_discount_page}
    IF    '${discountType}'=='voucher'
        Select From List By Label    ${zed_discount_type_dropdown}    Voucher codes
    ELSE IF    '${discountType}'=='cart rule'
        Select From List By Label    ${zed_discount_type_dropdown}    Cart rule
    END
    Type Text    ${zed_discount_name_field}     ${discountName}
    Type Text    ${zed_discount_description_field}     ${discountDescription}
    Evaluate Javascript    ${None}  document.getElementById("discount_discountGeneral_valid_from").setAttribute("value", "2021-01-01")
    Evaluate JavaScript    ${None}   document.getElementById("discount_discountGeneral_valid_to").setAttribute("value", "2050-01-01")
# Discount calculation
    Zed: go to tab:    Discount calculation
    Wait For Elements State    ${zed_discount_query_builder_first_calculation_group}    visible    15s
    IF    '${valueType}'=='Percentage'    Run Keywords    Select From List By Label    ${zed_discount_calculator_type_drop_down}    Percentage
    ...    AND    Type Text    ${zed_discount_percentage_value_field}     ${discountValue}
    ...    ELSE   Run keywords    '${valueType}'=='Fixed amount'    Select From List By Label    ${zed_discount_calculator_type_drop_down}    Fixed amount
    ...    AND    Type Text    ${zed_discount_euro_gross_field}    ${discountValue}
    IF    '${promotionalProductDiscount}'=='False'
        Run keywords
    ...    Click    ${zed_discount_plain_query_apply_to__button}
    ...    AND    Wait Until Element Is Visible    ${zed_discount_plain_query_apply_to_field}
    ...    AND    Type Text    ${zed_discount_plain_query_apply_to_field}     ${applyToQuery}
    ELSE IF    '${promotionalProductDiscount}'=='True'
        Run keywords
    ...    Click    ${zed_discount_promotional_product_radio}
    ...    AND    Wait Until Element Is Visible    ${zed_discount_promotional_product_abstract_sku_field}
    ...    AND    Type Text    ${zed_discount_promotional_product_abstract_sku_field}     ${promotionalProductAbstractSku}
    ...    AND    Type Text    ${zed_discount_promotional_product_abstract_quantity_field}     ${promotionalProductQuantity}
    END
    # Discount condition
    Zed: go to tab:    Conditions
    Wait For Elements State    ${zed_discount_query_builder_first_condition_group}    visible    15s
    Click    ${zed_discount_plain_query_apply_when__button}
    Wait Until Element Is Visible    ${zed_discount_plain_query_apply_when_field}
    Type Text    ${zed_discount_plain_query_apply_when_field}     ${applyWhenQuery}
    Click    ${zed_discount_save_button}
    Click    ${zed_discount_activate_button}
    # Voucher codes
    IF    '${discountType}'=='voucher'    Zed: generate vouchers:    1    ${voucherCode}
    # Check discount in Zed
    Zed: go to second navigation item level:    Merchandising    Discount
    Zed: perform search by:    ${discountName}
    Element Should Be Visible    xpath=//td[contains(@class,'name') and contains(text(),'${discountName}')]/ancestor::tr//span[contains(@class,'label') and contains(text(),'Active')]    message=None

Zed: generate vouchers:
    [Arguments]    ${quantity}    ${customCode}    ${addRandomLength}=    ${maxNumberOfUsages}=0
    ${currentURL}=    Get Location
    IF    'tab-content-general' not in '${currentURL}'  Zed: go to tab:    Voucher codes
    Type Text    ${zed_discount_voucher_quantity_field}     ${quantity}
    Type Text    ${zed_discount_voucher_custom_code_field}     ${customCode}
    Type Text    ${zed_discount_voucher_max_usages_field}     ${maxNumberOfUsages}
    Click    ${zed_discount_voucher_code_generate_button}

Zed: deactivate following discounts from Overview page:
    [Arguments]    @{discountNames}
    ${items_list_count}=   get length  ${discountNames}
    Zed: go to second navigation item level:    Merchandising    Discount
    FOR    ${name}    IN    @{discountNames}
        Zed: perform search by:    ${name}
        ${isDiscountActive}=    Set Variable    ${EMPTY}
        ${isDiscountActive}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//td[contains(text(),'${name}')]/following-sibling::td[contains(@class,'Action')]//button[contains(.,'Deactivate')]
        IF    '${isDiscountActive}'=='True'    Click    xpath=//td[contains(text(),'${name}')]/following-sibling::td[contains(@class,'Action')]//button[contains(.,'Deactivate')]
    END

Zed: activate following discounts from Overview page:
    [Arguments]    @{discountNames}
    ${items_list_count}=   get length  ${discountNames}
    Zed: go to second navigation item level:    Merchandising    Discount
    FOR    ${name}    IN    @{discountNames}
        Zed: perform search by:    ${name}
        ${isDiscountInactive}=    Set Variable    ${EMPTY}
        ${isDiscountInactive}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//td[contains(text(),'${name}')]/following-sibling::td[contains(@class,'Action')]//button[contains(.,'Activate')]
        IF    '${isDiscountInactive}'=='True'    Click    xpath=//td[contains(text(),'${name}')]/following-sibling::td[contains(@class,'Action')]//button[contains(.,'Activate')]
    END
