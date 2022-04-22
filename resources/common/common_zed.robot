*** Settings ***
Library    BuiltIn
Resource                  common.robot
Resource                  ../pages/zed/zed_login_page.robot
Resource    ../pages/zed/zed_edit_product_page.robot

*** Variable ***
${zed_log_out_button}   xpath=//ul[@class='nav navbar-top-links navbar-right']//a[contains(@href,'logout')]
${zed_save_button}      xpath=//input[contains(@class,'safe-submit')]
${zed_success_flash_message}    xpath=//div[@class='flash-messages']/div[@class='alert alert-success']
${zed_table_locator}    xpath=//table[contains(@class,'dataTable')]/tbody
${zed_search_field_locator}     xpath=//input[@type='search']
${zed_variant_search_field_locator}     xpath=//*[@id='product-variant-table_filter']//input[@type='search']
${zed_processing_block_locator}     xpath=//div[contains(@id,'processing')][contains(@class,'dataTables_processing')]


*** Keywords ***
Zed: login on Zed with credentials:
    [Arguments]    ${email}    ${password}=${default_password}
    go to    ${zed_url}
    delete all cookies
    Reload
    Wait Until Element Is Visible    ${zed_user_name_field}
    Type Text    ${zed_user_name_field}    ${email}
    Type Text    ${zed_password_field}    ${password}
    Click    ${zed_login_button}
    Wait Until Element Is Visible    ${zed_log_out_button}    Zed:Dashboard page is not displayed

Zed: go to first navigation item level:
    [Documentation]     example: "Zed: Go to First Navigation Item Level  Customers"
    [Arguments]     ${navigation_item}
    Wait Until Page Contains Element    xpath=//ul[@id='side-menu']/li/a/span[@class='nav-label'][contains(text(),'${navigation_item}')]/../../a
    Click Element by xpath with JavaScript    //ul[@id='side-menu']/li/a/span[@class='nav-label'][contains(text(),'${navigation_item}')]/../../a

Zed: go to second navigation item level:
    [Documentation]     example: "Zed: Go to Second Navigation Item Level    Customers    Customer Access"
    [Arguments]     ${navigation_item_level1}   ${navigation_item_level2}
    ${node_state}=    Get Element Attribute  xpath=(//span[contains(@class,'nav-label')][text()='${navigation_item_level1}']/ancestor::li)[1]    class
    log    ${node_state}
    Run Keyword If    'active' in '${node_state}'   run keywords  wait until element is visible  xpath=//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}']
    ...    AND      Click  xpath=//span[contains(@class,'nav-label')][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}']
    ...    ELSE     run keywords    Click    //ul[@id='side-menu']/li/a/span[@class='nav-label'][contains(text(),'${navigation_item_level1}')]/../../a
    ...    AND      wait until element is visible  xpath=//span[contains(@class,'nav-label')][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}']
    ...    AND      Click  xpath=//span[contains(@class,'nav-label')][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}']

Zed: click button in Header:
    [Arguments]    ${button_name}
    wait until element is visible    xpath=//div[@class='title-action']/a[contains(.,'${button_name}')]
    Click    xpath=//div[@class='title-action']/a[contains(.,'${button_name}')]

Zed: click Action Button in a table for row that contains:
    [Arguments]    ${row_content}    ${zed_table_action_button_locator}
    Zed: perform search by:    ${row_content}
    wait until element is visible    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')]
    Click    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')]

Zed: click Action Button in Variant table for row that contains:
    [Arguments]    ${row_content}    ${zed_table_action_button_locator}
    Zed: perform variant search by:    ${row_content}
    wait until element is visible    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')]
    Click    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')]

Zed: Check checkbox by Label:
    [Arguments]    ${checkbox_label}
    wait until element is visible    xpath=//input[@type='checkbox']/../../label[contains(text(),'${checkbox_label}')]//input
    Check checkbox    xpath=//input[@type='checkbox']/../../label[contains(text(),'${checkbox_label}')]//input

Zed: Uncheck Checkbox by Label:
    [Arguments]    ${checkbox_label}
    wait until element is visible    xpath=//input[@type='checkbox']/../../label[contains(text(),'${checkbox_label}')]//input
    Uncheck Checkbox    xpath=//input[@type='checkbox']/../../label[contains(text(),'${checkbox_label}')]//input

Zed: submit the form
    wait until element is visible    ${zed_save_button}
    Click   ${zed_save_button}

Zed: perform search by:
    [Arguments]    ${search_key}
    Type Text    ${zed_search_field_locator}    ${search_key}
    Keyboard Key    press    Enter
    Wait Until Element Is Visible    ${zed_processing_block_locator}
    Wait Until Element Is Not Visible    ${zed_processing_block_locator}
    Sleep    3s

Zed: perform variant search by:
    [Arguments]    ${search_key}
    Type Text    ${zed_variant_search_field_locator}    ${search_key}
    Wait Until Element Is Visible    ${zed_product_variant_table_processing_locator}
    Wait Until Element Is Not Visible    ${zed_product_variant_table_processing_locator}
    Sleep    3s

Zed: table should contain:
    [Arguments]    ${search_key}
    Zed: perform search by:    ${search_key}
    Table Should Contain    ${zed_table_locator}  ${search_key}

Zed: go to tab:
    [Arguments]    ${tabName}
    Click    xpath=//*[contains(@data-toggle,'tab') and contains(text(),'${tabName}')]

Zed: message should be shown:
    [Arguments]    ${text}
    Wait Until Element Is Visible    xpath=//div[contains(@class,'alert alert-success')]//*[contains(text(),'${text}')]    message=Success message is not shown

Zed: flash message should be shown:
    [Documentation]    Possible values: 'success', 'info' and 'danger'
    [Arguments]    ${type}=success
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'flash-messages')]//div[contains(@class,'alert-${type}')]    message=Flash message is not shown

Zed: click Action Button(without search) in a table for row that contains:
    [Arguments]    ${row_content}    ${zed_table_action_button_locator}
    wait until element is visible    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')]
    Click    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')]

