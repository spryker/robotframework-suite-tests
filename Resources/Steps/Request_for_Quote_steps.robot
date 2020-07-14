*** Settings ***
Library    BuiltIn
Library    DateTime
Resource    ../Pages/Yves/Yves_Quote_Request_page.robot
Resource    ../Common/Common_Yves.robot
Resource    ../Steps/Header_steps.robot
Resource    ../Common/Common.robot

*** Keywords ***
Go to 'Quote Requests' page
    Click Element    ${agent_quote_requests_header_item}
    Wait For Document Ready    

Yves: quote request with reference xxx should have status:
    [Arguments]    ${quoteReference}    ${expectedStatus}
    Page Should Contain Element    xpath=//div[contains(@data-qa,'component quote-request')]//td[contains(.,'${quoteReference}')]
    ${actualStatus}=    Get Text    xpath=//div[contains(@data-qa,'component quote-request')]//td[contains(.,'${quoteReference}')]/..//*[contains(@class,'request-status')]
    Should Be Equal    ${expectedStatus}    ${actualStatus}

Yves: view quote request with reference:
    [Arguments]    ${quoteReference}
    Click Element    xpath=//div[contains(@data-qa,'component quote-request')]//td[contains(.,'${quoteReference}')]/..//*[text()='View']/ancestor::a[contains(@class,'table-action-link')]

Yves: click '${buttonName}' button on the 'Quote Request Details' page
    Wait For Document Ready    
    Run Keyword If    '${buttonName}' == 'Back to List'    Click Element    ${quote_request_back_to_list_button}
    ...    ELSE IF    '${buttonName}' == 'Cancel'    Click Element    ${quote_request_cancel_button}
    ...    ELSE IF    '${buttonName}' == 'Revise'    Click Element    ${quote_request_revise_button}
    ...    ELSE IF    '${buttonName}' == 'Convert to Cart'    Click Element    ${quote_request_convert_to_cart_button}
    ...    ELSE IF    '${buttonName}' == 'Send to Customer'    Click Element    ${quote_request_send_to_customer_button}
    ...    ELSE IF    '${buttonName}' == 'Edit'    Click Element    ${quote_request_edit_button}
    ...    ELSE IF    '${buttonName}' == 'Edit Items'    Click Element    ${quote_request_edit_items_button}
    ...    ELSE IF    '${buttonName}' == 'Save and Back to Edit'    Click Element    ${quote_request_save_and_back_to_edit_button}
    ...    ELSE IF    '${buttonName}' == 'Send to Agent'    Click Element    ${quote_request_send_to_agent_button}
    Wait For Document Ready  
    Yves: remove flash messages  

Yves: change price for the product in the quote request with sku xxx on:
    [Arguments]    ${sku}    ${priceToSet}
    ${use_default_price_state}=    Get Element Attribute    xpath=//article[@data-qa='component quote-request-cart-item']//div[contains(@class,'quote-request-cart-item__column--content')][contains(.,'${sku}')]/ancestor::article//*[contains(@class,'quote-request-cart-item__column--total')]//input[@type='checkbox']    checked
    Log    ${use_default_price_state}
    Run Keyword If    'true' in '${use_default_price_state}'    Click ELement    xpath=//article[@data-qa='component quote-request-cart-item']//div[contains(@class,'quote-request-cart-item__column--content')][contains(.,'${sku}')]/ancestor::article//*[contains(@class,'quote-request-cart-item__column--total')]//span[@name='use_default_price']
    Input Text    xpath=//article[@data-qa='component quote-request-cart-item']//div[contains(@class,'quote-request-cart-item__column--content')][contains(.,'${sku}')]/ancestor::article//*[contains(@class,'quote-request-cart-item__column--total')]//input[@type='text']    ${priceToSet}

Yves: add the following note to the quote request:
    [Arguments]    ${noteToSet}
    Input Text    ${quote_request_notes_text_area}    ${noteToSet}

Yves: go to the quote request through the header with reference:
    [Arguments]    ${quoteReference}
    Yves: move mouse over header menu item:    ${quoteRequestsWidget}
    Wait Until Element Is Visible    ${agent_quote_requests_widget}
    Click Element    xpath=//agent-control-bar//a[contains(@href,'quote-request')]/ancestor::li[contains(@class,'menu__item--has-children')]//a[contains(@class,'quote-request-detail')][contains(.,'${quoteReference}')]

Yves: 'Quote Request Details' page contains the following note:
    [Arguments]    ${noteToCheck}
    ${actualNote}=    Get Text    xpath=//div[@data-qa='component quote-request-main-content']//div/label[text()='Notes']/../*[@class='text-break']
    Should Be Equal    ${actualNote}    ${noteToCheck}

Yves: set 'Valid Till' date for the quote request, today +:
    [Arguments]    ${daysToAdd}
    ${currentDate}=    Get Current Date
    ${dateToSet}=    Add Time To Date    ${currentDate}    ${daysToAdd}
    Add/Edit element attribute with JavaScript:    //input[@id='quote_request_agent_form_validUntil']    value    ${dateToSet}

Yves: set 'Valid Till' date in the past for the quote request:
    Add/Edit element attribute with JavaScript:    //input[@id='quote_request_agent_form_validUntil']    value    2019-07-15 02:47:55.432

