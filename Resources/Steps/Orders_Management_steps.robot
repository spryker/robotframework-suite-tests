*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True
Resource    ../Pages/Yves/Yves_Return_Slip_page.robot
Resource    ../Pages/Zed/Zed_Create_Return_page.robot
Resource    ../Pages/Zed/Zed_Return_Details_page.robot

*** Keywords ***
Zed: trigger all matching states inside xxx order:
    [Arguments]    ${orderID}    ${status}
    Zed: go to second navigation item level:    Sales    Orders
    Zed: perform search by:    ${orderID}
    Zed: click Action Button in a table for row that contains:    ${orderID}    View
    Zed: trigger all matching states inside this order:    ${status}
    Wait For Document Ready    

Zed: trigger all matching states inside this order:
    [Arguments]    ${status}
    Reload Page    
    Wait Until Page Contains Element    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']
    Scroll and Click Element    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']
    Wait For Document Ready    
    ${order_changed_status}=    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']
    Run Keyword If    'FAIL' in ${order_changed_status}    Run Keywords
    ...    Reload Page    
    ...    AND    Scroll and Click Element    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']
    ...    AND    Wait For Document Ready    

Yves: create return for the following products:
    [Arguments]    @{sku_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        Scroll and Click Element    xpath=(//form[@name='return_create_form']//div[@data-qa='component return-product-item']//*[contains(text(),'${sku_to_check}')]/ancestor::div[@data-qa='component return-product-item']/../div[contains(@class,'col')]//span[contains(@class,'checkbox')])[1]
    END
    Scroll and Click Element    ${create_return_button}[${env}]

Yves: check that 'Print Slip' contains the following products:
    [Arguments]    @{sku_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    Scroll and Click Element    ${return_details_print_slip_button}
    Wait For Document Ready   
    Select Window    NEW
    Wait Until Page Contains Element    ${return_slip_products_table}
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        Table Should Contain    ${return_slip_products_table}    ${sku_to_check}
    END   

Zed: create a return for the following order and product in it:
    [Arguments]    ${orderID}    @{sku_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    Zed: go to second navigation item level:    Sales    Orders
    Zed: perform search by:    ${orderID}
    Zed: click Action Button in a table for row that contains:    ${orderID}    View
    Click Element by xpath with JavaScript    //div[@class='title-action']/a[contains(.,'Return')]
    Wait Until Page Contains Element    ${zed_create_return_main_content_locator}
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        Scroll and Click Element    xpath=//table[@data-qa='order-item-list']//td/div[contains(text(),'SKU: ${sku_to_check}')]/ancestor::tr//div[@class='checkbox']//input
    END
    Scroll and Click Element    ${zed_create_return_button}  
    Wait Until Page Contains Element    ${zed_return_details_main_content_locator}
