*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_marketplace_offers_page.robot
Resource    ../pages/zed/zed_create_merchant_page.robot

*** Keywords ***
Zed: select merchant in filter:
    [Arguments]    ${merchantName}
    Select From List By Label    ${zed_merchants_filter}    ${merchantName}

Zed: create new Merchant with the following data:
    [Arguments]    @{args}
    ${merchantData}=    Set Up Keyword Arguments    @{args}
    Zed: go to second navigation item level:    Marketplace    Merchants  
    Zed: click button in Header:    Add Merchant
    Wait Until Element Is Visible    ${zed_create_merchant_name_field}
    FOR    ${key}    ${value}    IN    &{merchantData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='merchant name' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_name_field}    ${value}
        IF    '${key}'=='merchant reference' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_reference_field}    ${value}
        IF    '${key}'=='e-mail' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_email_field}    ${value}
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'    Zed: Check checkbox by Label:    ${value}
        IF    '${key}'=='en url' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_url_en_locale_field}    ${value}
        IF    '${key}'=='de url' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_url_de_locale_field}    ${value}
    END  
    Zed: submit the form
    Zed: wait for button in Header to be visible:    Add Merchant    ${browser_timeout}
    Zed: table should contain:    ${MerchantName}

Zed: update Merchant on edit page with the following data:
    [Arguments]    @{args}
    ${merchantData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${zed_create_merchant_name_field}
    FOR    ${key}    ${value}    IN    &{merchantData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='merchant name' and '${value}' != '${EMPTY}'    Run Keywords    
        ...    Type Text    ${zed_create_merchant_name_field}    ${value}
        ...    AND    Set Test Variable    ${zedMerchantNewName}    ${value}
        IF    '${key}'=='merchant reference' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_reference_field}    ${value}
        IF    '${key}'=='e-mail' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_email_field}    ${value}
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'    Zed: Check checkbox by Label:    ${value}
        IF    '${key}'=='uncheck store' and '${value}' != '${EMPTY}'    Zed: Uncheck Checkbox by Label:    ${value}
        IF    '${key}'=='en url' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_url_en_locale_field}    ${value}
        IF    '${key}'=='de url' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_url_de_locale_field}    ${value}
    END  
    Zed: submit the form
    Zed: wait for button in Header to be visible:    Add Merchant    ${browser_timeout}
    Zed: table should contain:    ${zedMerchantNewName}
Zed: update Merchant name on edit page:
    [Arguments]    ${zedMerchantNewName}
    Wait Until Element Is Visible    ${zed_create_merchant_name_field}
    Type Text    ${zed_create_merchant_name_field}    ${zedMerchantNewName}
    Zed: submit the form
    Zed: wait for button in Header to be visible:    Add Merchant    ${browser_timeout}
    Zed: table should contain:    ${zedMerchantNewName}

Zed: create new Merchant User with the following data:
    [Arguments]    @{args}
    ${merchantUerData}=    Set Up Keyword Arguments    @{args}
    Zed: go to tab:     Users
    Click    ${zed_add_merchant_user_button}
    Wait Until Element Is Visible    ${zed_create_merchant_user_email_field}
    FOR    ${key}    ${value}    IN    &{merchantUerData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='e-mail' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_user_email_field}    ${value}
        IF    '${key}'=='first name' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_user_first_name_field}    ${value}
        IF    '${key}'=='last name' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_user_last_name_field}    ${value}
    END  
    Zed: submit the form
    Wait Until Element Is Visible    ${zed_table_locator}

Zed: update Merchant User on edit page with the following data:
    [Arguments]    @{args}
    ${merchantUerData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${zed_create_merchant_user_first_name_field}
    FOR    ${key}    ${value}    IN    &{merchantUerData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='e-mail' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_user_email_field}    ${value}
        IF    '${key}'=='first name' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_user_first_name_field}    ${value}
        IF    '${key}'=='last name' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_user_last_name_field}    ${value}
    END  
    Zed: submit the form
    Wait Until Element Is Visible    ${zed_table_locator}

Zed: perform Merchant User search by:
    [Arguments]    ${search_key}
    Wait Until Page Contains Element    ${zed_table_locator}
    Type Text    ${zed_merchant_user_search_field_locator}    ${search_key}
    TRY
        Wait Until Element Is Visible    ${zed_processing_block_locator}    3s
    EXCEPT    
        Log    processing locator is now shown
    END
    TRY
        Wait Until Element Is Not Visible    ${zed_processing_block_locator}    3s
    EXCEPT    
        Log    processing locator is now shown
    END
    Sleep    3s

Zed: click Action Button in Merchant Users table for row that contains:
    [Arguments]    ${row_content}    ${zed_table_action_button_locator}
    Zed: perform merchant user search by:    ${row_content}
    wait until element is visible    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')]
    Click    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')]
