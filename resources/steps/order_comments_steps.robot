*** Settings ***
Resource    ../common/common_yves.robot
Resource    ../common/common.robot
Resource    ../steps/customer_account_steps.robot
Resource    ../pages/zed/zed_order_details_page.robot
Resource    ../pages/yves/yves_order_details_page.robot
Resource    ../pages/yves/yves_shopping_cart_page.robot
Resource    ../common/common_zed.robot
Resource    order_history_steps.robot

*** Keywords ***
Yves: add comment on cart:
    [Arguments]    ${comment}
    Click    ${shopping_cart_write_comment_placeholder}
    Type Text    ${shopping_cart_write_comment_placeholder}    ${comment}
    Click    ${shopping_cart_add_comment_button}

Yves: check comments are visible or not in cart:
    [Arguments]    ${condition}    @{comments}    
    FOR    ${element}    IN    @{comments}
        IF    '${condition}' == 'true'    Element Should Be Visible    xpath=(//comment-form[@data-qa='component comment-form']//p[contains(text(),'${element}')])[1]    message=Comment '${element}' is not visible in the shopping cart but should
        IF    '${condition}' == 'false'    Element Should Not Be Visible    xpath=(//comment-form[@data-qa='component comment-form']//p[contains(text(),'${element}')])[1]    message=Comment '${element}' is visible in the shopping cart but should not
    END

Yves: check comments is visible or not in order:
    [Arguments]    ${condition}    @{comments}    
    FOR    ${element}    IN    @{comments}
        IF    '${condition}' == 'true'    Element Should Be Visible    xpath=(//comment-form[@data-qa='component comment-form']//p[contains(text(),'${element}')])[1]    message=Comment '${element}' is not visible in BO:order details page but should
        IF    '${condition}' == 'false'    Element Should Not Be Visible    xpath=(//div[contains(@class,"comment-form__readonly")]/p[contains(text(),'${element}')])[1]   message=Comment '${element}' is visible in BO:order details page but should not
    END

Yves: go to order details page to check comment:
    [Arguments]    ${comment}    ${lastPlacedOrder}
    Yves: go to 'Order History' page
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    ${text_entered}    Get Text    ${yves_order_details_page_comments}
    IF    '${text_entered}' == '${comment}'
        Log    text entered in comments appers in order details page in Yves
    ELSE
        Fail    comments not added succesfully to order details page in Yves
    END    

Zed: check comment appears at order detailed page in zed:
    [Arguments]    ${comment}    ${lastPlacedOrder}
    Zed: go to second navigation item level:    Sales    Orders
    Zed: click Action Button in a table for row that contains:    ${lastPlacedOrder}    View 
    Wait Until Element Is Visible    ${zed_order_details_page_comments}
    ${text_entered}    Get Text    ${zed_order_details_page_comments}
       IF    '${text_entered}' == '${comment}'
            Log    comments added to cart appears in order details page in zed
       ELSE
            Fail    comments added to cart does not appears in order details page in zed
       END

Yves: edit comment on cart:
    [Arguments]    ${comment_to_set}
    Click    ${shopping_cart_edit_comment_button}
    Click    ${shopping_cart_edit_comment_placeholder}
    Clear Text    ${shopping_cart_edit_comment_placeholder}  
    Keyboard Key    press    Tab
    Input Text    ${shopping_cart_edit_comment_placeholder}    ${comment_to_set}
    Click    ${shopping_cart_update_comment_button}

Yves: delete comment on cart
    Click    ${shopping_cart_remove_comment_button} 
    Page Should Not Contain Element    ${shopping_cart_remove_comment_button}

Yves: add comment on order in order detail page:
    [Arguments]    ${comment}
    Click    ${order_details_page_add_comments_textbox}
    Type Text    ${order_details_page_add_comments_textbox}    ${comment}
    Click    ${add_comment_button_order_details_page}