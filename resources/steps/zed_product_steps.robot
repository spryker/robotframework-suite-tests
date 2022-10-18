*** Settings ***
Resource    ../common/common.robot
Resource    ../../resources/common/common_zed.robot
Resource    ../../resources/pages/zed/zed_product_page.robot


*** Keywords ***
Zed: navigate to edit page of product from product listing page
    Click    ${zed_product_edit_button}

Zed: edit product details
     Click    ${zed_product_edit_button}

Zed: update stock quantity of product for created warehouse
    Clear Text    ${zed_product_stock_quantity_field}
    Input Text    ${zed_product_stock_quantity_field}   5

Zed: update stock quantity of product for selected warehouse to null
     Zed: login on Zed with provided credentials:    ${zed_admin_email}
     Zed: go to second navigation item level:    Catalog    Products
    Zed: perform search by:    009
    Zed: navigate to edit page of product from product listing page
    Zed: go to tab:    Variants
    Zed: edit product details
    Zed: go to tab:    Price & Stock
    Clear Text     ${zed_product_stock_quantity_field}
    Zed: submit the form