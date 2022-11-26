*** Settings ***
Resource    ../pages/zed/zed_create_zed_user_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_catalog_categories_page.robot
Resource    ../steps/zed_catalog_products_steps.robot

*** Keywords ***
Zed: verify categories redirect created or not:
    [Arguments]    ${redirect_name}
    Zed: go to second navigation item level:    Content    Redirects
    ${redirect_name}=    Replace String    ${redirect_name}    ${SPACE}    -
    ${redirect_name}=    Convert To Lower Case    ${redirect_name}
    Zed: table should contain non-searchable value:    ${redirect_name}
    ${redirect_name}=     Set Test Variable    ${redirect_name}
    [Return]    ${redirect_name}

Yves: get current category title
    ${categoryTitle}=    Get Title
    ${categoryTitle}=    Set Test Variable    ${categoryTitle}
    [Return]    ${categoryTitle}

Zed: change category name on:
    [Arguments]    ${name}    ${new_name}   @{locale} 
    Zed: go to second navigation item level:    Catalog    Categories
    Zed: perform search by:    ${name}
    Click   ${zed_categories_table_actions_button}
    Click   ${zed_categories_table_action_edit}
    FOR    ${element}    IN    @{locale}
        IF    '${element}' == 'EN' and '${new_name}' != '${EMPTY}'    Input Text    ${zed_edit_category_en_name}    ${new_name}    
        IF    '${element}' == 'DE' and '${new_name}' != '${EMPTY}'    Input Text    ${zed_edit_category_de_name}    ${new_name}
    END
    Click    ${zed_edit_category_save_button}

Yves: get current page URL
    ${currentURL}=    Get Url
    ${currentURL}=    Set Test Variable    ${currentURL}
    [Return]    ${currentURL}