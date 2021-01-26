*** Settings ***
Resource    ../Pages/Zed/Zed_Availability_page.robot

*** Keywords ***

Zed: check if product is/not in stock:
    [Arguments]    ${sku}    ${isInStock}
    Zed: perform search by:    ${sku}
    Run Keyword If    '${isInStock}'=='true'    Element Text Should Be    ${zed_availability_product_availability_label}     Available    Message='Expected product availability is not found'
    ...    ELSE    Element Text Should Be    ${zed_availability_product_availability_label}     Not available    Message='Expected product availability is not found'

Zed: change product stock:
    [Arguments]    ${skuAbstract}    ${skuConcrete}    ${isNeverOutOfStock}    ${quantityWarehouse1}    ${quantityWarehouse2}=0
    Zed: perform search by:    ${skuAbstract}
    Scroll and Click Element    xpath=//a[contains(text(),'${skuAbstract}')]/ancestor::tr//following-sibling::td//*[contains(.,'View')]
    Wait For Document Ready    
    Element Should Be Visible    xpath=//div[@class='ibox float-e-margins']/*[contains(.,'Variant availability')]
    Scroll and Click Element    xpath=//*[contains(text(),'${skuConcrete}')]/ancestor::tr//following-sibling::td//*[contains(.,'Edit Stock')]
    Wait For Document Ready    
    Element Should Be Visible    xpath=//div[@class='ibox float-e-margins']/*[contains(.,'Edit Stock')]
    ${checkBoxes}=    Get Element Count    ${zed_availability_never_out_of_stock_checkbox}
    FOR    ${index}    IN RANGE    1    ${checkBoxes}
        Log    ${zed_availability_never_out_of_stock_checkbox}
        Log    ${index}
        Log    ${zed_availability_never_out_of_stock_checkbox}\[${index}\]
        Run Keyword If    '${isNeverOutOfStock}'=='true'    Select Checkbox    \(//*[@type='checkbox' and contains(@id,'is_never_out_of_stock')]\)\[${index}\]
        ...    ELSE    Unselect Checkbox    \(//*[@type='checkbox' and contains(@id,'is_never_out_of_stock')]\)\[${index}\]
    END
    Input text into field    xpath=//input[contains(@id,'AvailabilityGui_stock_stocks_0_quantity')]    ${quantityWarehouse1}
    Input text into field    xpath=//input[contains(@id,'AvailabilityGui_stock_stocks_1_quantity')]    ${quantityWarehouse2}   
    Scroll and Click Element    ${zed_save_button}


