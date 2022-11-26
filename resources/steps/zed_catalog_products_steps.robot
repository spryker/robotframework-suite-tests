*** Settings ***
Resource    ../pages/zed/zed_create_zed_user_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../common/common_yves.robot
Resource    ../pages/zed/zed_redirects_page.robot

*** Keywords ***
Zed: edit product name:
    [Arguments]    ${abstract_sku}    ${name}    @{locale}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: click Action Button in a table for row that contains:    ${abstract_sku}    Edit
    FOR    ${element}    IN    @{locale}
        IF    '${element}' == 'EN' and '${name}' != '${EMPTY}'    Input Text    ${zed_edit_product_en_name}    ${name}    
        IF    '${element}' == 'DE' and '${name}' != '${EMPTY}'    Input Text    ${zed_edit_product_de_name}    ${name}    
    END
    Zed: submit the form

Yves: get current product title
    ${productTitle}=    Get Title
    ${productTitle}=    Set Test Variable    ${productTitle}
    [Return]    ${productTitle}

Zed: verify product redirect is created or not:
    [Arguments]    ${name}
    Zed: go to second navigation item level:    Content    Redirects
    ${name}=    Replace String    ${name}    ${SPACE}    -
    ${name}=    Convert To Lower Case    ${name}
    Zed: click Action Button in a table for row that contains:    ${name}    Edit
    ${fromURL}=    Get Text    ${zed_redirect_from_url}
    ${toURL}=    Get Text    ${zed_redirect_to_url}
    ${fromURL}=    Set Test Variable    ${fromURL}
    ${toURL}=    Set Test Variable    ${toURL}
    sleep    5s
    [Return]    ${fromURL}    ${toURL}