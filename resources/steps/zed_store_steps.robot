*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_store_page.robot    


*** Keywords ***

Zed: create new Store:
    # [Arguments]    ${store_name}    ${locale_iso_code}    ${currency_iso_code}    ${currency_code}    ${store_delivery_region}
    # Zed: go to second navigation item level:    Administration    Stores
    # Zed: click button in Header:    Create Store
    # Wait Until Element Is Visible    ${zed_store_add_name_input}
    # Type Text    ${zed_store_add_name_input}    ${store_name}
    # Click    ${zed_store_locale_tab}
    # Wait Until Element Is Visible    ${zed_store_default_locale_iso_code}
    # Select From List By Label    ${zed_store_default_locale_iso_code}    ${locale_iso_code}
    # Zed: perform store search by:    ${zed_store_search_locale_field}    ${locale_iso_code}    
    # Zed: Check checkbox by Value:    ${locale_iso_code}
    # Click    ${zed_store_currency_tab}   
    # Wait Until Element Is Visible    ${zed_store_default_currency_iso_code}
    # Select From List By Label    ${zed_store_default_currency_iso_code}    ${currency_iso_code}
    # Zed: perform store search by:    ${zed_store_search_currency_field}     ${currency_code} 
    # Zed: Check checkbox by Value:    ${currency_code}
    # Click    ${zed_store_delivery_region_tab}
    # Zed: perform store search by:    ${zed_store_search_country_field}    ${store_delivery_region}    
    # Zed: Check checkbox by Value:    ${store_delivery_region}
    # Click    ${zed_store_save_button}
    # Zed: flash message should be shown:    success
    [Arguments]    @{args}
    Zed: go to second navigation item level:    Administration    Stores
    Zed: click button in Header:    Create Store
    Wait Until Element Is Visible    ${zed_store_add_name_input}
    ${storeData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{storeData}
        IF    '${key}'=='name' and '${value}' != '${EMPTY}'
            ${name}=    Set Variable    ${value}
            Type Text    ${zed_store_add_name_input}    ${value}
            Click    ${zed_store_locale_tab}
            Wait Until Element Is Visible    ${zed_store_default_locale_iso_code}
        END
        IF    '${key}'=='locale iso code' and '${value}' != '${EMPTY}'
            ${locale iso code}=    Set Variable    ${value}
            Wait Until Element Is Visible    ${zed_store_default_locale_iso_code}
            Select From List By Label    ${zed_store_default_locale_iso_code}    ${value}
            Zed: perform store search by:    ${zed_store_search_locale_field}    ${value}   
            Zed: Check checkbox by Value:    ${value}
            Click    ${zed_store_currency_tab}    
        END   
        IF    '${key}'=='currency iso code' and '${value}' != '${EMPTY}'
            ${currency iso code}=    Set Variable    ${value}
            Wait Until Element Is Visible    ${zed_store_default_currency_iso_code}
            Select From List By Label    ${zed_store_default_currency_iso_code}    ${value}
        END    
        IF    '${key}'=='currency code' and '${value}' != '${EMPTY}'
            ${currency code}=    Set Variable    ${value}
            Zed: perform store search by:    ${zed_store_search_currency_field}     ${value}
            Zed: Check checkbox by Value:    ${value}
            Click    ${zed_store_delivery_region_tab}
        END  
               IF    '${key}'=='store delivery region' and '${value}' != '${EMPTY}'
            ${store delivery region}=    Set Variable    ${value}
            Zed: perform store search by:    ${zed_store_search_country_field}    ${value}    
            Zed: Check checkbox by Value:    ${value} 
        END   
    END 
    Click    ${zed_store_save_button}

Zed: perform store search by:
    [Arguments]    ${search_field_xpath}    ${search_key}
    Clear Text    ${search_field_xpath}
    Type Text    ${search_field_xpath}    ${search_key}
    Keyboard Key    press    Enter
    TRY
        Wait For Response    timeout=10s
    EXCEPT    
        Log    Search event is not fired
    END
    Repeat Keyword    2    Wait Until Network Is Idle