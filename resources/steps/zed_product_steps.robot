*** Settings ***
Resource    ../common/common.robot
Resource    ../../resources/common/common_zed.robot


*** Keywords ***
Zed: update stock quantity of product for selected warehouse:
    [Arguments]    ${warehouse}    ${abstract_sku}    ${concrete_sku}    ${quantity}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: click Action Button in a table for row that contains:    ${abstract_sku}    Edit
    Zed: go to tab:    Variants
    Zed: click Action Button in Variant table for row that contains:    ${concrete_sku}    Edit
    Zed: go to tab:    Price & Stock
    Type Text    xpath=//input[@value='${warehouse}']//parent::div/following-sibling::div[1]//child::input    ${quantity}
    Zed: submit the form