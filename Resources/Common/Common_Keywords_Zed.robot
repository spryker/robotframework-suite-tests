*** Settings ***
Resource                  Common.robot
Resource                  Common_Variables_Zed.robot
Resource                  ../Pages/Zed/Zed_Login_Page.robot

*** Keywords ***
Zed: Login on Zed with Provided Credentials:
    [Arguments]    ${email}    ${password}=${default_password}
    delete all cookies
    go to    ${zed_url}
    Wait Until Element Is Visible    ${zed_user_name_field}
    input text    ${zed_user_name_field}    ${email}
    input text    ${zed_password_field}    ${password}
    click element    ${zed_login_button}
    Wait Until Element Is Visible    ${zed_log_out_button}    ${loading_time}    Zed:Dashboard page is not displayed

Zed: Go to First Navigation Item Level:
    [Documentation]     example: "Zed: Go to First Navigation Item Level  Customers"
    [Arguments]     ${navigation_item}
    click element  xpath=//span[contains(@class,'nav-label')][contains(text(),'${navigation_item}')]/../../a

Zed: Go to Second Navigation Item Level:
    [Documentation]     example: "Zed: Go to Second Navigation Item Level    Customers    Customer Access"
    [Arguments]     ${navigation_item_level1}   ${navigation_item_level2}
    Sleep    5s
    ${node_state}=  Get Element Attribute  xpath=(//span[contains(@class,'nav-label')][contains(text(),'${navigation_item_level1}')]/ancestor::li)[1]    class
    log  ${node_state}
    Run Keyword If    'active' in '${node_state}'   run keywords  wait until element is visible  xpath=//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}']
    ...    AND      click element  xpath=//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}']
    ...    ELSE     run keywords    click element  xpath=//span[contains(@class,'nav-label')][contains(text(),'${navigation_item_level1}')]/../../a
    ...    AND      wait until element is visible  xpath=//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}']
    ...    AND      click element  xpath=//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}']

Zed: Click Button in Header
    [Arguments]  ${button_name}
    wait until element is visible  xpath=//div[@class='title-action']/a[contains(.,'${button_name}')]
    click element  xpath=//div[@class='title-action']/a[contains(.,'${button_name}')]

Zed: Click Action Button in a Table For Row That Contains
    [Arguments]  ${row_content}     ${zed_table_action_button_locator}
    Zed: Perform Search By:  ${row_content}
    wait until element is visible  xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[position()=last()]/*[contains(.,'${zed_table_action_button_locator}')]
    click element  xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[position()=last()]/*[contains(.,'${zed_table_action_button_locator}')]

Zed: Select Checkbox by Lable
    [Arguments]  ${checkbox_label}
    wait until element is visible  xpath=//input[@type='checkbox']/../../label[contains(text(),'${checkbox_label}')]//input
    select checkbox     xpath=//input[@type='checkbox']/../../label[contains(text(),'${checkbox_label}')]//input

Zed: Unselect Checkbox by Lable
    [Arguments]  ${checkbox_label}
    wait until element is visible  xpath=//input[@type='checkbox']/../../label[contains(text(),'${checkbox_label}')]//input
    unselect checkbox     xpath=//input[@type='checkbox']/../../label[contains(text(),'${checkbox_label}')]//input

Zed: Submit the Form
    wait until element is visible    ${zed_save_button}
    click element   ${zed_save_button}

Zed: Perform Search By:
    [Arguments]  ${search_key}
    input text  ${zed_search_field_locator}     ${search_key}
    sleep  2s
    wait until page contains element    ${zed_processing_block_locator}

Zed: Table should contain:
    [Arguments]    ${search_key}
    Zed: Perform Search By:  ${search_key}
    table should contain  ${zed_table_locator}  ${search_key}
