*** Settings ***
Resource    common_ui.robot
Resource    ../pages/zed/zed_login_page.robot
Resource    ../pages/zed/zed_edit_product_page.robot

*** Variables ***
${zed_log_out_button}   xpath=//ul[@class='nav navbar-top-links navbar-right']//a[contains(@href,'logout')]
${zed_save_button}      xpath=//input[contains(@class,'safe-submit')]
${zed_success_flash_message}    xpath=//div[@class='flash-messages']/div[@class='alert alert-success']
${zed_error_flash_message}    xpath=//div[@class='flash-messages']/div[@class='alert alert-danger']
${zed_info_flash_message}    xpath=//div[@class='flash-messages']/../div[@class='alert alert-info']
${zed_error_message}    xpath=//div[@class='alert alert-danger']
${zed_table_locator}    xpath=//table[contains(@class,'dataTable')]/tbody
${zed_search_field_locator}     xpath=//div[@class='dataTables_filter']//input[@type='search']
${zed_variant_search_field_locator}     xpath=//*[@id='product-variant-table_filter']//input[@type='search']
${zed_processing_block_locator}     xpath=//div[contains(@id,'processing')][contains(@class,'dataTables_processing')]
${zed_merchants_dropdown_locator}    xpath=//select[@name='id-merchant']
${zed_attribute_access_denied_header}    xpath=//div[@class='wrapper wrapper-content']//div[@class='flash-messages']//following-sibling::h1
${zed_sweet_alert_js_error_popup}    xpath=//*[contains(@class,'sweet-alert')]


*** Keywords ***
Zed: login on Zed with provided credentials:
    [Arguments]    ${email}    ${password}=${default_password}
    Go To    ${zed_url}
    Delete All Cookies
    Reload
    Wait Until Element Is Visible    ${zed_user_name_field}
    Type Text    ${zed_user_name_field}    ${email}
    Type Text    ${zed_password_field}    ${password}
    Click    ${zed_login_button}
    Wait Until Element Is Visible    ${zed_log_out_button}    Zed: Login failed!

Zed: login with deactivated user/invalid data:
   [Arguments]    ${email}    ${password}=${default_password}
    Go To    ${zed_url}
    Delete All Cookies
    Reload
    Wait Until Element Is Visible    ${zed_user_name_field}
    Type Text    ${zed_user_name_field}    ${email}
    Type Text    ${zed_password_field}    ${password}
    Click    ${zed_login_button}
    Wait Until Page Contains Element    ${zed_error_flash_message}

Zed: go to first navigation item level:
    [Documentation]     example: "Zed: Go to First Navigation Item Level  Customers"
    [Arguments]     ${navigation_item}
    Wait Until Page Contains Element    xpath=//ul[@id='side-menu']/li/a/span[@class='nav-label'][contains(text(),'${navigation_item}')]/../../a
    Click Element by xpath with JavaScript    //ul[@id='side-menu']/li/a/span[@class='nav-label'][contains(text(),'${navigation_item}')]/../../a
    Repeat Keyword    3    Wait For Load State

Zed: go to second navigation item level:
    [Documentation]     example: "Zed: Go to Second Navigation Item Level    Customers    Customer Access"
    [Arguments]     ${navigation_item_level1}   ${navigation_item_level2}
    ${node_state}=    Get Element Attribute  xpath=(//span[contains(@class,'nav-label')][text()='${navigation_item_level1}']/ancestor::li)[1]    class
    IF    'active' in '${node_state}'
        wait until element is visible  xpath=(//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}'])[1]
        Click Element by xpath with JavaScript    (//span[contains(@class,'nav-label')][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}'])[1]
        Repeat Keyword    3    Wait For Load State    timeout=${browser_timeout}
    ELSE
        Scroll Element Into View    xpath=//ul[@id='side-menu']/li/a/span[@class='nav-label'][contains(text(),'${navigation_item_level1}')]/../../a
        Click Element by xpath with JavaScript    //ul[@id='side-menu']/li/a/span[@class='nav-label'][contains(text(),'${navigation_item_level1}')]/../../a
        Repeat Keyword    3    Wait For Load State
        ${node_expanded}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//span[contains(@class,'nav-label')][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}']    timeout=1s
        IF    '${node_expanded}'=='False'    
            Reload
            Click    xpath=//ul[@id='side-menu']/li/a/span[@class='nav-label'][contains(text(),'${navigation_item_level1}')]/../../a
            Repeat Keyword    3    Wait For Load State    timeout=${browser_timeout}
        END
        wait until element is visible  xpath=(//span[contains(@class,'nav-label')][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}'])[1]
        Click Element by xpath with JavaScript    (//span[contains(@class,'nav-label')][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}'])[1]
        Repeat Keyword    3    Wait For Load State    timeout=${browser_timeout}
    END
    
Zed: click button in Header:
    [Arguments]    ${button_name}
    wait until element is visible    xpath=//div[@class='title-action']/a[contains(.,'${button_name}')]
    Click    xpath=//div[@class='title-action']/a[contains(.,'${button_name}')]

Zed: wait for button in Header to be visible:
    [Arguments]    ${button_name}    ${timeout}
    Wait until element is visible    xpath=//div[@class='title-action']/a[contains(.,'${button_name}')]

Zed: click Action Button in a table for row that contains:
    [Arguments]    ${row_content}    ${zed_table_action_button_locator}
    Zed: perform search by:    ${row_content}
    # all services are not supported due to demodata collision
    Wait until element is visible    xpath=(//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}') and not(contains(text(),'service'))]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')])[1]
    Click    xpath=(//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}') and not(contains(text(),'service'))]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')])[1]
    Repeat Keyword    3    Wait For Load State

Zed: save abstract product:  
    [Arguments]    ${productAbstract}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     ${productAbstract}     Edit
    Wait until element is visible    ${zed_save_button}
    Zed: submit the form

Zed: click Action Button in Variant table for row that contains:
    [Arguments]    ${row_content}    ${zed_table_action_button_locator}
    Zed: perform variant search by:    ${row_content}
    wait until element is visible    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')]
    Click    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')]
    Repeat Keyword    2    Wait For Load State

Zed: Check checkbox by Label:
    [Arguments]    ${checkbox_label}
    wait until element is visible    xpath=//input[@type='checkbox']/../../label[contains(text(),'${checkbox_label}')]//input
    Check checkbox    xpath=//input[@type='checkbox']/../../label[contains(text(),'${checkbox_label}')]//input

Zed: Check checkbox by Value:
    [Arguments]    ${checkbox_value}
    wait until element is visible    xpath=//input[@type='checkbox' and contains(@value, '${checkbox_value}')]
    Check checkbox    xpath=//input[@type='checkbox' and contains(@value, '${checkbox_value}')]

Zed: Uncheck Checkbox by Label:
    [Arguments]    ${checkbox_label}
    wait until element is visible    xpath=//input[@type='checkbox']/../../label[contains(text(),'${checkbox_label}')]//input
    Uncheck Checkbox    xpath=//input[@type='checkbox']/../../label[contains(text(),'${checkbox_label}')]//input

Zed: submit the form
    Wait until element is visible    ${zed_save_button}
    Click    ${zed_save_button}
    Repeat Keyword    2    Wait For Load State
    Wait Until Element Is Visible    ${zed_log_out_button}
    ${error_flash_message}=    Run Keyword And Ignore Error    Page Should Not Contain Element    ${zed_error_flash_message}    1s
    IF    'FAIL' in ${error_flash_message}
        Click    ${zed_save_button}
        Repeat Keyword    2    Wait For Load State
        Wait Until Element Is Visible    ${zed_log_out_button}
    END
    ${error_message}=    Run Keyword And Ignore Error    Page Should Not Contain Element    ${zed_error_message}    1s
    IF    'FAIL' in ${error_message}
        Click    ${zed_save_button}
        Repeat Keyword    2    Wait For Load State
        Wait Until Element Is Visible    ${zed_log_out_button}
    END
    Page Should Not Contain Element    ${zed_error_message}    1s
    Page Should Not Contain Element    ${zed_error_flash_message}    1s

Zed: perform search by:
    [Arguments]    ${search_key}
    Zed: clear search field
    Type Text    ${zed_search_field_locator}    ${search_key}
    TRY
        Wait For Response    timeout=10s
    EXCEPT    
        Log    Search event is not fired
    END
    Repeat Keyword    3    Wait For Load State
    Wait For Load State    networkidle

Zed: clear search field
    Clear Text    ${zed_search_field_locator}
    Repeat Keyword    3    Wait For Load State
    Wait For Load State    networkidle

Zed: perform variant search by:
    [Arguments]    ${search_key}
    Clear Text    ${zed_variant_search_field_locator}
    Repeat Keyword    3    Wait For Load State
    Wait For Load State    networkidle
    Type Text    ${zed_variant_search_field_locator}    ${search_key}
    TRY
        Wait For Response    timeout=10s
    EXCEPT    
        Log    Search event is not fired
    END
    Repeat Keyword    3    Wait For Load State
    Wait For Load State    networkidle

Zed: table should contain:
    [Arguments]    ${search_key}    ${error_message}=Table doesn't contain expected '${search_key}' record
    Zed: perform search by:    ${search_key}
    Table Should Contain    locator=${zed_table_locator}    expected=${search_key}    message=${error_message}

Zed: table should contain non-searchable value:
    [Arguments]    ${search_key}
    Wait Until Element Is Visible    ${zed_table_locator}
    Table Should Contain    ${zed_table_locator}  ${search_key}  

Zed: table should contain xxx N times:
    [Arguments]    ${search_key}    ${expected_count}
    Wait Until Element Is Visible    ${zed_table_locator}
    Zed: perform search by:    ${search_key}
    ${actual_count}=    Get Element Count    xpath=//table[contains(@class,'dataTable')]/tbody//*[contains(text(),'${search_key}')]
    Should Be Equal    '${actual_count}'    '${expected_count}'

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
    Wait For Load State

Zed: filter by merchant:
    [Arguments]    ${merchant}
    Wait Until Element Is Visible    ${zed_merchants_dropdown_locator}
    Select From List By Label    ${zed_merchants_dropdown_locator}    ${merchant}

Zed: go to URL:
    [Arguments]    ${url}    ${expected_response_code}=${EMPTY}
    ${url}=    Get URL Without Starting Slash    ${url}
    Set Browser Timeout    ${browser_timeout}
    ${response_code}=    Go To    ${zed_url}${url}
    ${response_code}=    Convert To Integer    ${response_code}
    ${is_5xx}=    Evaluate    500 <= ${response_code} < 600
    ${page_title}=    Get Title
    ${page_title}=    Convert To Lower Case    ${page_title}
    ${no_exception}=    Run Keyword And Return Status    Should Not Contain    ${page_title}    error
    IF    ${is_5xx} or not ${no_exception}
        LocalStorage Clear
        ${response_code}=    Go To    ${zed_url}${url}
        ${response_code}=    Convert To Integer    ${response_code}
        ${is_5xx}=    Evaluate    500 <= ${response_code} < 600
        IF    ${is_5xx}    Fail    '${response_code}' error occurred on go to '${zed_url}${url}'
        ${page_title}=    Get Title
        ${page_title}=    Convert To Lower Case    ${page_title}
        Should Not Contain    ${page_title}    error    msg='${response_code}' error occurred on go to '${zed_url}${url}'
    END
    IF    '${expected_response_code}' != '${EMPTY}'
        ${expected_response_code}=    Convert To Integer    ${expected_response_code}
        Should Be Equal    ${response_code}    ${expected_response_code}    msg=Expected response code (${expected_response_code}) is not equal to the actual response code (${response_code}) on Go to: ${zed_url}${url}
    END
    ${no_js_error}=    Run Keyword And Return Status    Page Should Not Contain Element    ${zed_sweet_alert_js_error_popup}    timeout=500ms
    IF    not ${no_js_error}
        LocalStorage Clear
        ${response_code}=    Go To    ${zed_url}${url}
        ${response_code}=    Convert To Integer    ${response_code}
        ${is_5xx}=    Evaluate    500 <= ${response_code} < 600
        IF    ${is_5xx}    Fail    '${response_code}' error occurred on go to '${zed_url}${url}'
        ${no_js_error}=    Run Keyword And Return Status    Page Should Not Contain Element    ${zed_sweet_alert_js_error_popup}    timeout=500ms
        IF    not ${no_js_error}    
            Take Screenshot    EMBED    fullPage=True
            Fail    ''sweet-alert' js error popup on the page '${zed_url}${url}'
        END
    END
    RETURN    ${response_code}