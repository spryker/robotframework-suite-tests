*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_yves.robot 
Resource    ../pages/yves/yves_quick_order_page.robot

*** Keywords ***
Yves: Go to 'Quick Order' page
    Click    ${quick_order_icon_header_menu_item}    

Yves: add the following articles into the form through quick order text area:
    [Arguments]    ${contentToUse}
    Clear Text    ${quick_order_add_articles_text_area}
    Type Text    ${quick_order_add_articles_text_area}    ${contentToUse}
    Click    ${quick_order_verify_button}  

Yves: add products to the shopping cart from quick order page
    Click    ${quick_order_add_to_cart_button}    
    Yves: remove flash messages 
    
Yves: add products to the shopping list from quick order page with name:
    [Arguments]    ${shoppingListName}
    Wait Until Element Is Visible    ${quick_order_shopping_list_selector}
    Yves: Select shopping list on 'Quick Order' page    ${shoppingListName}
    Click    ${quick_order_add_to_shopping_list_button}
    Yves: remove flash messages 

Yves: Select shopping list on 'Quick Order' page
    [Arguments]    ${shoppingListName}
    Scroll Element Into View    ${quick_order_shopping_list_selector}
    Select From List By Label    ${quick_order_shopping_list_selector}    ${shoppingListName}

Yves: find and add new item in the quick order form:
    [Arguments]    @{args}
    ${quickOrderData}=    Set Up Keyword Arguments    @{args}
    Clear Text    ${quick_order_add_articles_text_area}
    Type Text    ${quick_order_add_articles_text_area}    ${EMPTY}
    Sleep    3s
    Click    ${quick_order_verify_button}
    ${emptyRowAvailable}=    Run Keyword And Return Status    Page Should Contain Element    ${quick_order_first_empty_row}
    IF    '${emptyRowAvailable}'=='False'    
        Click    ${quick_order_add_more_rows}
        Wait Until Element Is Visible    ${quick_order_first_empty_row}
    END
    Type Text    ${quick_order_first_empty_row}    ${searchQuery}
    Wait Until Element Is Visible    ${quick_order_row_search_results}
    Wait Until Page Contains Element    xpath=//div[contains(@data-qa,'component quick-order-rows')]//input[contains(@class,'autocomplete')][@value='']/ancestor::quick-order-row//product-search-autocomplete-form//ul[@data-qa='component products-list']/li[@data-value='${searchQuery}']
    Click    xpath=//div[contains(@data-qa,'component quick-order-rows')]//input[contains(@class,'autocomplete')][@value='']/ancestor::quick-order-row//product-search-autocomplete-form//ul[@data-qa='component products-list']/li[@data-value='${searchQuery}']
    Sleep    10s
    Wait Until Element Is Visible    ${quick_order_row_merchant_selector}
    Select From List By Label    ${quick_order_row_merchant_selector}    ${merchant}
    Clear Text    ${quick_order_add_articles_text_area}
    Type Text    ${quick_order_add_articles_text_area}    ${EMPTY}
    Sleep    3s
    Click    ${quick_order_verify_button}