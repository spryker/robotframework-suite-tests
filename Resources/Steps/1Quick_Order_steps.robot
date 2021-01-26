*** Settings ***
Resource    ../Pages/Yves/Yves_Quick_Order_page.robot

*** Keywords ***
Go to 'Quick Order' page
    Scroll and Click Element    ${quick_order_icon_header_menu_item}
    Wait For Document Ready    

Yves: add the following articles into the form through quick order text area:
    [Arguments]    ${contentToUse}
    Clear Element Text    ${quick_order_add_articles_text_area}
    Input text into field    ${quick_order_add_articles_text_area}    ${contentToUse}
    Scroll and Click Element    ${quick_order_verify_button}
    Wait For Document Ready    

Yves: add products to the shopping cart from quick order page
    Scroll and Click Element    ${quick_order_add_to_cart_button}
    Wait For Document Ready   
    Yves: remove flash messages 
    
Yves: add products to the shopping list from quick order page with name:
    [Arguments]    ${shoppingListName}
    Wait Until Element Is Visible    ${quick_order_shopping_list_selector}
    Select shopping list on 'Quick Order' page    ${shoppingListName}
    Scroll and Click Element    ${quick_order_add_to_shopping_list_button}
    Wait For Document Ready   
    Yves: remove flash messages 
 