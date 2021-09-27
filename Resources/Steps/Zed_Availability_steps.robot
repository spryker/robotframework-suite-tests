*** Settings ***
Resource    ../Pages/Zed/Zed_Availability_page.robot
Resource    ../Common/Common_Zed.robot

*** Keywords ***

Zed: check if product is/not in stock:
    [Arguments]    ${sku}    ${isInStock}
    Zed: perform search by:    ${sku}
    Run Keyword If    '${isInStock}'=='true'    Element Text Should Be    ${zed_availability_product_availability_label}     Available    Message='Expected product availability is not found'
    ...    ELSE    Element Text Should Be    ${zed_availability_product_availability_label}     Not available    Message='Expected product availability is not found'

Zed: change product stock:
    [Arguments]    ${skuAbstract}    ${skuConcrete}    ${isNeverOutOfStock}    ${quantityWarehouse1}    ${quantityWarehouse2}=0
    Zed: perform search by:    ${skuAbstract}
    Click    xpath=//a[contains(text(),'${skuAbstract}')]/ancestor::tr//following-sibling::td//*[contains(.,'View')]
        
    Element Should Be Visible    xpath=//div[@class='ibox float-e-margins']/*[contains(.,'Variant availability')]
    Click    xpath=//*[contains(text(),'${skuConcrete}')]/ancestor::tr//following-sibling::td//*[contains(.,'Edit Stock')]
        
    Element Should Be Visible    xpath=//div[@class='ibox float-e-margins']/*[contains(.,'Edit Stock')]
    ${checkBoxes}=    Get Element Count    ${zed_availability_never_out_of_stock_checkbox}
    FOR    ${index}    IN RANGE    1    ${checkBoxes}
        Log    ${zed_availability_never_out_of_stock_checkbox}
        Log    ${index}
        Log    ${zed_availability_never_out_of_stock_checkbox}\[${index}\]
        Run Keyword If    '${isNeverOutOfStock}'=='true'    Select Checkbox    \(//*[@type='checkbox' and contains(@id,'is_never_out_of_stock')]\)\[${index}\]
        ...    ELSE    Unselect Checkbox    \(//*[@type='checkbox' and contains(@id,'is_never_out_of_stock')]\)\[${index}\]
    END
    Type Text    xpath=//input[contains(@id,'AvailabilityGui_stock_stocks_0_quantity')]    ${quantityWarehouse1}
    Type Text    xpath=//input[contains(@id,'AvailabilityGui_stock_stocks_1_quantity')]    ${quantityWarehouse2}   
    Click    ${zed_save_button}

Zed: check and restore product availability in Zed:    
    [Arguments]    ${skuAbstract}    ${expectedStatus}    ${skuConcrete}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: perform search by:    ${skuAbstract}
    ${isProductAvailable}=    Run Keyword And Return Status    Element Text Should Be    ${zed_availability_product_availability_label}     Available
    Run Keyword If    '${expectedStatus}'=='Available' and '${isProductAvailable}'=='False'
    ...    Zed: change product stock:    ${skuAbstract}    ${skuConcrete}    true    0    0
    ...    ELSE    Run Keyword If   '${expectedStatus}'=='Not Available' and '${isProductAvailable}'=='True'
    ...    Zed: change product stock:    ${skuAbstract}    ${skuConcrete}    false    0    0


