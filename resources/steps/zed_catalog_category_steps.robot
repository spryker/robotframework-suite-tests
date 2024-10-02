*** Settings ***
Resource    ../pages/zed/zed_cms_page_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Keywords ***

Zed: assign store to category:
    [Arguments]    ${store}     ${category}
    Zed: go to second navigation item level:    Catalog    Category
    Zed: click Action Button in a table for row that contains:     ${category}     Edit
    Click    ${zed_category_edit_button}
    Set Browser Timeout    ${browser_timeout}
    Wait Until Element Is Visible   ${zed_category_store_select}
    Type Text    ${zed_category_store_select_search_field}     ${store}    delay=50ms
    Wait Until Element Is Visible    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${store}')]
    Click    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${store}')]
    Sleep    1s

    ${iterations}=    Get Element Count    xpath=//input[contains(concat(' ',@id,' '), 'category_localized_attributes_') and contains(@id,'_name') and @type='text' and @required='required']
            FOR    ${index}    IN RANGE    0    ${iterations}
                ${currentInput}=    Set Variable     xpath=//input[@id='category_localized_attributes_${index}_name']
                ${value}=   Get Text     ${currentInput}
                IF    '${value}' == '${EMPTY}'
                    Click    ${currentInput}//ancestor::div[contains(@class, 'ibox') and contains(@class, 'collapsed')]//a[@class='collapse-link']
                    Type Text    ${currentInput}    'test'    delay=50ms
                END
            END

    Wait Until Element Is Visible    ${zed_category_save_button}
    Click   ${zed_category_save_button}
    Wait until element is visible    ${zed_success_flash_message}
    Trigger Multistore P&S
    Trigger P&S    3    ${store}


