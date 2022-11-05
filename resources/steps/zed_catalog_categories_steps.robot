*** Settings ***
Resource    ../pages/zed/zed_create_zed_user_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_catalog_categories_page.robot

** Keywords ***
Zed: Edit the category name:
    [Arguments]    ${name}
    click   ${categories_product_actions_button}
    Click   ${categories_product_actions_edit}
    Input Text    ${categories_product_name}    ${name}
    Click    ${categories_product_save_button}