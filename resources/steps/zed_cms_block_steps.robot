*** Settings ***
Resource    ../pages/zed/zed_cms_page_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Keywords ***

Zed: assigned store to cms block:
    [Arguments]    ${store}    ${block_name}
    Zed: go to second navigation item level:    Content    Blocks
    Zed: perform search by:    ${block_name}
    Zed: click Action Button in a table for row that contains:     ${block_name}     Edit Block
    Set Browser Timeout    ${browser_timeout}
    Wait Until Element Is Visible    xpath=//div[@class='ibox-content']//div[@id='cms_block_storeRelation']//div[@class='checkbox']/label[contains(text(), '${store}')] 
    Zed: Check checkbox by Label:    ${store} 
    Click    ${zed_cms_block_save_button}
    Zed: message should be shown:    CMS Block was updated successfully.
    Trigger multistore p&s

    