*** Settings ***
Resource    ../Common/Common.robot
Resource    ../Common/Common_Yves.robot 
Resource    ../Pages/Yves/Yves_Quick_Order_page.robot

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