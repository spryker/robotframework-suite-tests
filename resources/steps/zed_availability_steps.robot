*** Settings ***
Resource    ../pages/zed/zed_availability_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Keywords ***
Zed: check if product is/not in stock:
    [Arguments]    ${sku}    ${isInStock}
    ${isInStock}=    Convert To Lower Case    ${isInStock}
    ${currentURL}=    Get Location
    IF    '/availability-gui' not in '${currentURL}'    Zed: go to URL:    /availability-gui
    IF    '/availability-gui/index' in '${currentURL}'    Zed: go to URL:    /availability-gui
    Zed: perform search by:    ${sku}
    IF    '${isInStock}'=='true'
        Element Text Should Be    ${zed_availability_product_availability_label}     Available    Message='Expected product availability is not found'
    ELSE
        Element Text Should Be    ${zed_availability_product_availability_label}     Not available    Message='Expected product availability is not found'
    END

Zed: change product stock:
    [Arguments]    ${skuORnameAbstract}    ${skuConcrete}    ${isNeverOutOfStock}    ${quantityWarehouse1}    ${quantityWarehouse2}=0
    ${isNeverOutOfStock}=    Convert To Lower Case    ${isNeverOutOfStock}
    ${currentURL}=    Get Location
    IF    '/availability-gui' not in '${currentURL}'    Zed: go to URL:    /availability-gui
    IF    '/availability-gui/index' in '${currentURL}'    Zed: go to URL:    /availability-gui
    Zed: perform search by:    ${skuORnameAbstract}
    TRY
        Set Browser Timeout    5s
        Click    xpath=//a[contains(text(),'${skuORnameAbstract}')]/ancestor::tr//following-sibling::td//*[contains(.,'View')]
    EXCEPT    
        Set Browser Timeout    5s
        Click    xpath=//td[contains(text(), '${skuORnameAbstract}')]/ancestor::tr//following-sibling::td//*[contains(.,'View')]
    END
    Set Browser Timeout    ${browser_timeout}
    Element Should Be Visible    xpath=//div[@class='ibox float-e-margins']/*[contains(.,'Variant availability')]
    Click    xpath=//*[contains(text(),'${skuConcrete}')]/ancestor::tr//following-sibling::td//*[contains(.,'Edit Stock')]
    Element Should Be Visible    xpath=//div[@class='ibox float-e-margins']/*[contains(.,'Edit Stock')]
    Wait Until Element Is Visible    ${zed_save_button}
    ${checkBoxes}=    Get Element Count    ${zed_availability_never_out_of_stock_checkbox}
    FOR    ${index}    IN RANGE    1    ${checkBoxes}+1
        Log    ${zed_availability_never_out_of_stock_checkbox}
        Log    ${index}
        Log    ${zed_availability_never_out_of_stock_checkbox}\[${index}\]
        IF    '${isNeverOutOfStock}'=='true'
            Check checkbox    \(//*[@type='checkbox' and contains(@id,'is_never_out_of_stock')]\)\[${index}\]
        ELSE
            Uncheck Checkbox    \(//*[@type='checkbox' and contains(@id,'is_never_out_of_stock')]\)\[${index}\]
        END
    END
    Type Text    xpath=//input[contains(@id,'AvailabilityGui_stock_stocks_0_quantity')]    ${quantityWarehouse1}
    Type Text    xpath=//input[contains(@id,'AvailabilityGui_stock_stocks_1_quantity')]    ${quantityWarehouse2}
    Click    ${zed_save_button}
    #Resave to apply changes
    Set Browser Timeout    1s
    TRY
        Click    ${zed_save_button}
    EXCEPT    
        Log    Form is already submitted
    END
    Set Browser Timeout    ${browser_timeout}
    Trigger multistore p&s

Zed: check and restore product availability in Zed:
    [Arguments]    ${skuAbstract}    ${expectedStatus}    ${skuConcrete}
    ${expectedStatus}=    Convert To Lower Case    ${expectedStatus}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to URL:    /availability-gui
    Zed: perform search by:    ${skuAbstract}
    ${isProductAvailable}=    Run Keyword And Return Status    Element Text Should Be    ${zed_availability_product_availability_label}     Available
    IF    '${expectedStatus}'=='available' and '${isProductAvailable}'=='False'
        Zed: change product stock:    ${skuAbstract}    ${skuConcrete}    true    10    0
    ELSE
        IF   '${expectedStatus}'=='not available' and '${isProductAvailable}'=='True'
        Zed: change product stock:    ${skuAbstract}    ${skuConcrete}    false    0    0
        END
    END