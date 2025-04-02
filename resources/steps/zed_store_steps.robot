*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_store_page.robot    


*** Keywords ***

Zed: create new Store:
    [Arguments]    @{args}
    Zed: go to URL:    /store-gui/list
    Zed: click button in Header:    Create Store
    Wait Until Element Is Visible    ${zed_store_add_name_input}
    ${storeData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{storeData}
        IF    '${key}'=='name' and '${value}' != '${EMPTY}'
            Type Text    ${zed_store_add_name_input}    ${value}
            Click    ${zed_store_locale_tab}
            Wait Until Element Is Visible    ${zed_store_default_locale_iso_code}
        END
        IF    '${key}'=='locale_iso_code' and '${value}' != '${EMPTY}'
            Wait Until Element Is Visible    ${zed_store_default_locale_iso_code}
            Select From List By Label    ${zed_store_default_locale_iso_code}    ${value}
            Zed: perform store search by:    ${value}   
            Zed: Check checkbox by Value:    ${value}
            Click    ${zed_store_currency_tab}    
        END   
        IF    '${key}'=='currency_iso_code' and '${value}' != '${EMPTY}'
            Wait Until Element Is Visible    ${zed_store_default_currency_iso_code}
            Select From List By Label    ${zed_store_default_currency_iso_code}    ${value}
        END    
        IF    '${key}'=='currency_code' and '${value}' != '${EMPTY}'
            ${currency code}=    Set Variable    ${value}
            Zed: perform store search by:    ${value}
            Zed: Check checkbox by Value:    ${value}
        END
        IF    '${key}'=='currency_iso_code2' and '${value}' != '${EMPTY}'
            Wait Until Element Is Visible    ${zed_store_default_currency_iso_code}
            Select From List By Label    ${zed_store_default_currency_iso_code}    ${value}
        END          
        IF    '${key}'=='currency_code2' and '${value}' != '${EMPTY}'
            ${currency code}=    Set Variable    ${value}
            Zed: perform store search by:    ${value}
            Zed: Check checkbox by Value:    ${value}
            Click    ${zed_store_delivery_region_tab}
        END   
        IF    '${key}'=='store_delivery_region' and '${value}' != '${EMPTY}'
            Zed: perform store search by:    ${value}    
            Zed: Check checkbox by Value:    ${value} 
        END   
        IF    '${key}'=='store_context_timezone' and '${value}' != '${EMPTY}'
            Click   ${zed_store_context_tab}
            Zed: store context add timezone:    ${value}
        END         
    END 
    Click    ${zed_store_save_button}

Zed: perform store search by:
    [Arguments]    ${search_key}
    Clear Text    ${zed_store_search_field}
    Type Text    ${zed_store_search_field}    ${search_key}
    Keyboard Key    press    Enter
    TRY
        Wait For Response    timeout=10s
    EXCEPT    
        Log    Search event is not fired
    END
    Repeat Keyword    2    Wait For Load State

Zed: store context add timezone:
    [Arguments]    ${timezone}
    Click    ${zed_store_context_add_button}
    Select From List By Label    ${zed_store_context_select}    ${timezone}
 