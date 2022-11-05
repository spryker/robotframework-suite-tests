*** Settings ***
Resource    ../pages/zed/zed_create_zed_user_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../common/common_yves.robot

*** Keywords ***
Zed: edit product description:
    [Arguments]    ${product_title}
    Input Text    id=product_concrete_form_edit_general_en_US_name   ${product_title}
    Zed: submit the form
    Zed: flash message should be shown:    success

yves: verify redirect category url:
    [Arguments]    ${url}
    Yves: go to URL:    ${url}
    ${abc}    Get Url    
    Should Contain    ${abc}    pens-twoss    message=redirect url not found

Yves: check the edited product title:
    [Arguments]    ${title}
    Element Should Contain    //h1[@class='page-info__title title title--h3']    ${title}