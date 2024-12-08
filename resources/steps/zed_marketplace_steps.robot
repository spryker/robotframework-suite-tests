*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_marketplace_offers_page.robot
Resource    ../pages/zed/zed_create_merchant_page.robot
Resource    zed_users_steps.robot

*** Keywords ***
Zed: select merchant in filter:
    [Arguments]    ${merchantName}
    Select From List By Label    ${zed_merchants_filter}    ${merchantName}

Zed: create new Merchant with the following data:
    [Arguments]    @{args}
    ${merchantData}=    Set Up Keyword Arguments    @{args}
    IF    '${env}' in ['ui_suite','ui_mp_b2b','ui_mp_b2c','ui_b2c']
        Zed: go to second navigation item level:    Marketplace    Merchants
    ELSE
        Zed: go to second navigation item level:    B2B Contracts    Merchants
    END    
    Zed: click button in Header:    Add Merchant
    Wait Until Element Is Visible    ${zed_create_merchant_name_field}
    FOR    ${key}    ${value}    IN    &{merchantData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='merchant name' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_name_field}    ${value}
        IF    '${key}'=='merchant reference' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_reference_field}    ${value}
        IF    '${key}'=='e-mail' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_email_field}    ${value}
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'    Zed: Check checkbox by Label:    ${value}
        IF    '${key}'=='store 2' and '${value}' != '${EMPTY}'    Zed: Check checkbox by Label:    ${value}
        IF    '${key}'=='store 3' and '${value}' != '${EMPTY}'    Zed: Check checkbox by Label:    ${value}
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
        IF    '${key}'=='store 2' and '${value}' != '${EMPTY}'    Zed: Check checkbox by Label:    ${value}
        IF    '${key}'=='store 3' and '${value}' != '${EMPTY}'    Zed: Check checkbox by Label:    ${value}
        IF    '${key}'=='uncheck store' and '${value}' != '${EMPTY}'    Zed: Uncheck Checkbox by Label:    ${value}
        IF    '${key}'=='uncheck store 2' and '${value}' != '${EMPTY}'    Zed: Uncheck Checkbox by Label:    ${value}
        IF    '${key}'=='uncheck store 3' and '${value}' != '${EMPTY}'    Zed: Uncheck Checkbox by Label:    ${value}
        IF    '${key}'=='en url' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_url_en_locale_field}    ${value}
        IF    '${key}'=='de url' and '${value}' != '${EMPTY}'    Type Text    ${zed_create_merchant_url_de_locale_field}    ${value}
    END
    Zed: submit the form
    ${form_submitted}=    Run Keyword And Ignore Error    Page Should Not Contain Element    ${zed_create_merchant_email_field}    1s
    IF    'FAIL' in ${form_submitted}
        Reload
        Zed: submit the form
    END
    Repeat Keyword    3    Wait For Load State
    Zed: table should contain:    search_key=${zedMerchantNewName}    error_message=Merchant Profile Update Failed! Form does not submit

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

Zed: create dynamic merchant user:
    [Arguments]    ${merchant}    ${merchant_user_email}=${EMPTY}    ${merchant_user_first_name}=FirstRobot    ${merchant_user_last_name}=LastRobot    ${merchant_user_password}=${default_secure_password}    ${merchant_user_group}=${EMPTY}    ${zed_admin_email}=${EMPTY}
    ${dynamic_admin_exists}=    Run Keyword And Return Status    Variable Should Exist    ${dynamic_admin_user}
    ${unique}=    Generate Random String    5    [NUMBERS]
    ${merchant_value}=    Convert To Lower Case   ${merchant}

    IF    'spryker' in '${merchant_value}'    
        VAR    ${merchant_key}    spryker
    ELSE IF    'king' in '${merchant_value}'
        VAR    ${merchant_key}    king
    ELSE IF    'budget' in '${merchant_value}'
        VAR    ${merchant_key}    budget
    ELSE IF    'expert' in '${merchant_value}'
        VAR    ${merchant_key}    expert
    END

    IF    '${zed_admin_email}' == '${EMPTY}'
        IF    ${dynamic_admin_exists}
            VAR    ${zed_admin_email}    ${dynamic_admin_user}
        ELSE
            Create dynamic admin user in DB
            VAR    ${zed_admin_email}    ${dynamic_admin_user}
        END
    END

    IF    '${merchant_user_email}' == '${EMPTY}'    
        VAR    ${merchant_user_email}    sonia+merchant+${merchant_key}+${unique}@spryker.com    
        VAR    ${dynamic_merchant_user}    ${merchant_user_email}    scope=TEST
    ELSE
        VAR    ${dynamic_merchant_user}    ${merchant_user_email}    scope=TEST
    END

    ${spryker_merchant_exists}=    Run Keyword And Return Status    Variable Should Exist    ${dynamic_spryker_merchant}
    ${king_merchant_exists}=    Run Keyword And Return Status    Variable Should Exist    ${dynamic_king_merchant}
    ${budget_merchant_exists}=    Run Keyword And Return Status    Variable Should Exist    ${dynamic_budget_merchant}
    ${expert_merchant_exists}=    Run Keyword And Return Status    Variable Should Exist    ${dynamic_expert_merchant}

    IF    'spryker' in '${merchant_value}'    
        IF    ${spryker_merchant_exists}
            VAR    ${dynamic_spryker_second_merchant}    ${merchant_user_email}    scope=TEST
        ELSE
            VAR    ${dynamic_spryker_merchant}    ${merchant_user_email}    scope=TEST
        END
    END
    IF    'king' in '${merchant_value}'
        IF    ${king_merchant_exists}
            VAR   ${dynamic_king_second_merchant}    ${merchant_user_email}    scope=TEST
        ELSE
            VAR   ${dynamic_king_merchant}    ${merchant_user_email}    scope=TEST
        END
    END
    IF    'budget' in '${merchant_value}'
        IF    ${budget_merchant_exists}
            VAR    ${dynamic_budget_second_merchant}    ${merchant_user_email}    scope=TEST
        ELSE
            VAR    ${dynamic_budget_merchant}    ${merchant_user_email}    scope=TEST
        END
    END
    IF    'expert' in '${merchant_value}'
        IF    ${expert_merchant_exists}
            VAR    ${dynamic_expert_second_merchant}    ${merchant_user_email}    scope=TEST
        ELSE
            VAR    ${dynamic_expert_merchant}    ${merchant_user_email}    scope=TEST
        END
    END

    ${currentURL}=    Get Location
    IF    '/list-merchant' not in '${currentURL}'    
        ${adminIsLoggedIn}=    Zed: is admin user is logged in
        IF    not ${adminIsLoggedIn}    Zed: login on Zed with provided credentials:    ${zed_admin_email}
        Go To    ${zed_url}merchant-gui/list-merchant
    END
    Wait For Load State
    Wait For Load State    networkidle
    Zed: click Action Button in a table for row that contains:     ${merchant}     Edit
    Zed: go to tab:     Users
    Click    ${zed_add_merchant_user_button}
    Wait Until Element Is Visible    ${zed_create_merchant_user_email_field}
    Type Text    ${zed_create_merchant_user_email_field}    ${merchant_user_email}
    Type Text    ${zed_create_merchant_user_first_name_field}    ${merchant_user_first_name}${unique}
    Type Text    ${zed_create_merchant_user_last_name_field}    ${merchant_user_last_name}${unique}
    Zed: submit the form
    Wait Until Element Is Visible    ${zed_table_locator}
    Zed: click Action Button in Merchant Users table for row that contains:    ${merchant_user_email}    Activate
    Zed: table should contain non-searchable value:    Active
    IF    '${merchant_user_group}' != '${EMPTY}'
        Zed: update Zed user:
        ...    || email                  | password                  | group                  ||
        ...    || ${merchant_user_email} | ${merchant_user_password} | ${merchant_user_group} ||
    ELSE
        Zed: update Zed user:
        ...    || email                  | password                  ||
        ...    || ${merchant_user_email} | ${merchant_user_password} ||
    END

Zed: delete merchant user:
    # TODO: get rid of merchant variable by b2c b2b mapping, like office kind -> video king
    [Arguments]    ${merchant_user}    ${merchant}=${EMPTY}    ${zed_admin_email}=${EMPTY}
    ${dynamic_admin_exists}=    Run Keyword And Return Status    Variable Should Exist    ${dynamic_admin_user}
    ${unique}=    Generate Random String    5    [NUMBERS]

    IF    '${zed_admin_email}' == '${EMPTY}'
        IF    ${dynamic_admin_exists}
            VAR    ${zed_admin_email}    ${dynamic_admin_user}
        ELSE
            VAR    ${zed_admin_email}    ${admin_email}
        END
    END

    IF    '${merchant}' == '${EMPTY}'
        IF    '+spryker+' in '${merchant_user}'    
            VAR    ${merchant}    Spryker
        ELSE IF    '+king+' in '${merchant_user}'    
            VAR    ${merchant}    King
        ELSE IF    '+budget+' in '${merchant_user}'    
            VAR    ${merchant}    Budget
        ELSE IF    '+expert+' in '${merchant_user}'    
            VAR    ${merchant}    Experts
        END
    END
            
    ${currentURL}=    Get Location
    
    IF    '/list-merchant' not in '${currentURL}'
        ${adminIsLoggedIn}=    Zed: is admin user is logged in
        IF    not ${adminIsLoggedIn}    Zed: login on Zed with provided credentials:    ${zed_admin_email}
        Go To    ${zed_url}merchant-gui/list-merchant
    END
    Wait For Load State
    Wait For Load State    networkidle
    Zed: click Action Button in a table for row that contains:     ${merchant}     Edit
    Zed: go to tab:     Users
    Zed: click Action Button in Merchant Users table for row that contains:    ${merchant_user}    Delete
    Zed: submit the form

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
    Clear Text    ${zed_merchant_user_search_field_locator}
    Type Text    ${zed_merchant_user_search_field_locator}    ${search_key}
    TRY
        Wait For Response    timeout=10s
    EXCEPT    
        Log    Search event is not fired
    END
    Repeat Keyword    3    Wait For Load State

Zed: click Action Button in Merchant Users table for row that contains:
    [Arguments]    ${row_content}    ${zed_table_action_button_locator}
    Zed: perform merchant user search by:    ${row_content}
    wait until element is visible    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')]
    Click    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')]
