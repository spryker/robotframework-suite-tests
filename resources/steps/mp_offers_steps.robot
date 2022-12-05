*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_mp.robot
Resource    ../pages/mp/mp_offer_drawer.robot
Resource    ../pages/mp/mp_product_drawer.robot
Resource    ../pages/zed/zed_view_offer_page.robot

*** Keywords ***    
MP: fill offer fields:
    [Arguments]    @{args}
    ${productData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${offer_active_checkbox}
    FOR    ${key}    ${value}    IN    &{productData}
        Log    Key is '${key}' and value is '${value}'.
        IF    '${key}'=='is active' and '${value}' != '${EMPTY}'    
            ${checkbox_state}=    Get Element Attribute    xpath=//web-spy-checkbox[@spy-id='productOffer_isActive']//span[@class='ant-checkbox-inner']/../../span[contains(@class,'checkbox')]    class
            Log    ${checkbox_state}
            IF    'checked' in '${checkbox_state}' and '${value}' == 'false'
                Click    ${offer_active_checkbox}
            ELSE IF    'checked' not in '${checkbox_state}' and '${value}' == 'true'
                Click    ${offer_active_checkbox}
            END
        END
        IF    '${key}'=='merchant sku' and '${value}' != '${EMPTY}'
            Type Text    ${offer_merchant_sku}    ${value}
        END
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'
            Click    ${stores_list_selector}
            MP: select option in expanded dropdown:    ${value}
            Click    ${stores_list_selector}
        END
        IF    '${key}'=='store 2' and '${value}' != '${EMPTY}'
            Click    ${stores_list_selector}
            MP: select option in expanded dropdown:    ${value}
            Click    ${stores_list_selector}
        END
        IF    '${key}'=='stock quantity' and '${value}' != '${EMPTY}'
            Type Text    ${offer_stock_input}    ${value}
        END
        IF    '${key}'=='unselect store' and '${value}' != '${EMPTY}'
            Click    ${stores_list_selector}
            MP: select option in expanded dropdown:    ${value}
            Click    ${stores_list_selector}
        END
    END
            
MP: add offer price:
    [Arguments]    @{args}
    Wait Until Element Is Visible    ${mp_add_price_button}
    Click    ${mp_add_price_button}
    ${priceData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{priceData}
        IF    '${key}'=='row number' and '${value}' != '${EMPTY}'    
            Set Test Variable    ${rowNumber}    ${value}
        ELSE    
            Set Test Variable    ${rowNumber}    1
        END
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'    
            Click    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[1]//spy-select
            MP: select option in expanded dropdown:    ${value}
        END
        IF    '${key}'=='currency' and '${value}' != '${EMPTY}'    
            Click    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[2]//spy-select
            MP: select option in expanded dropdown:    ${value}
        END
        IF    '${key}'=='gross default' and '${value}' != '${EMPTY}'    
            Type Text    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[4]//input    ${value}
        END
        IF    '${key}'=='quantity' and '${value}' != '${EMPTY}'    
            Type Text    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[7]//input    ${value}
        END
    END

MP: save offer    
    MP: click submit button
    Wait Until Element Is Visible    ${offer_saved_popup}
    Wait Until Element Is Not Visible    ${offer_saved_popup}

MP: change offer stock:
    [Arguments]    @{args}
    MP: open navigation menu tab:    Offers
    ${stockData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{stockData}
        IF    '${key}'=='offer' and '${value}' != '${EMPTY}'
                MP: perform search by:    ${value}
                MP: click on a table row that contains:    ${value}
                Wait Until Element Is Visible    ${offer_active_checkbox}
        END
        IF    '${key}'=='stock quantity' and '${value}' != '${EMPTY}'
            Type Text    ${offer_stock_input}    ${value}
        END
        IF    '${key}'=='is never out of stock' and '${value}' != '${EMPTY}'    
            ${checkbox_state}=    Get Element Attribute    ${offer_always_in_stock_checkbox}    class
            Log    ${checkbox_state}
            IF    'checked' in '${checkbox_state}' and '${value}' == 'false'
                Click    ${offer_always_in_stock_checkbox}
            ELSE IF    'checked' not in '${checkbox_state}' and '${value}' == 'true'
                Click    ${offer_always_in_stock_checkbox}
            END
        END
    END
    MP: save offer

MP: delete offer price row that contains quantity:
    [Arguments]    ${quantity}
    Scroll Element Into View    xpath=//web-spy-card[@spy-title='Price']//tbody/tr/td[7][contains(.,'${quantity}')]/ancestor::tr//td[@class='ng-star-inserted']/div
    Hover    xpath=//web-spy-card[@spy-title='Price']//tbody/tr/td[7][contains(.,'${quantity}')]/ancestor::tr//td[@class='ng-star-inserted']/div
    Click    ${product_delete_price_row_button}
    Wait Until Element Is Visible    ${product_price_deleted_popup}
    Wait Until Element Is Not Visible    ${product_price_deleted_popup}

Zed: view offer page is displayed
    Wait Until Element Is Visible    ${zed_view_offer_page_main_content_locator}

Zed: view offer product page contains:
    [Arguments]    @{args}
    ${offertData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{offertData}
        IF    '${key}'=='approval status' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_offer_approval_status}    ${value}
        END
        IF    '${key}'=='status' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_offer_status}    ${value}
        END
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_offer_store}    ${value}
        END
        IF    '${key}'=='sku' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_offer_sku}    ${value}
        END
        IF    '${key}'=='name' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_offer_name}    ${value}
        END
        IF    '${key}'=='merchant' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_offer_merchant}    ${value}
        END
        IF    '${key}'=='merchant sku' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_offer_merchant_sku}    ${value}
        END
    END