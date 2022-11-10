*** Settings ***
Resource    ../common/common_yves.robot
Resource    ../common/common.robot
Resource    ../steps/customer_account_steps.robot
Resource    ../pages/zed/zed_order_details_page.robot
Resource    ../pages/yves/yves_order_details_page.robot
Resource    ../common/common_zed.robot
Resource    order_history_steps.robot
*** Keywords ***
Yves: adding comments on cart before checkout:
    [Arguments]    ${comments}
    Click    ${order_details_write_comment_placeholder}
    Type Text    ${order_details_write_comment_placeholder}    ${comments}
    Click    ${order_details_add_button}
    ${text}    Get Text    ${comments_shopping_cart}
    Should Be Equal    ${comments}    ${text}

Yves: go to 'Order History' page to check comments:
    [Arguments]    ${comments}    ${lastPlacedOrder}
    Yves: go to 'Order History' page
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    ${text_entered}    Get Text    ${yves_order_details_page_comments}
    IF    '${text_entered}' == '${comments}'
        Log    text entered in comments appers in order details page in Yves
    ELSE
        Fail    comments not added succesfully to order details page in Yves
    END    

Zed: checking comments added in zed:
    [Arguments]    ${comments}    ${lastPlacedOrder}
    Zed: go to second navigation item level:    Sales    Orders
    Zed: click Action Button in a table for row that contains:    ${lastPlacedOrder}    View 
    Wait Until Element Is Visible    ${zed_order_details_page_comments}
    ${text_entered}    Get Text    ${zed_order_details_page_comments}
       IF    '${text_entered}' == '${comments}'
            Log    comments added to cart appears in order details page in zed
       ELSE
            Fail    comments added to cart does not appears in order details page in zed
       END

Yves: add comments on cart:
    [Arguments]    ${comment}
    Type Text    ${order_details_write_comment_placeholder}    ${comment}
    Click    ${order_details_add_button}
    ${text}    Get Text    ${comments_shopping_cart}
    Should Be Equal    ${comment}    ${text}

Yves:edit comments on cart:
    [Arguments]    ${comment}
    Click    ${order_details_edit_comment_button}
    Click    ${order_details_edit_comment_placeholder}
    Clear Text    ${order_details_edit_comment_placeholder}  
    Keyboard Key    press    Tab
    Input Text    ${order_details_edit_comment_placeholder}    ${comment}
    Click    ${order_details_update_button}
    ${text}    Get Text    ${comments_shopping_cart}
    Should Be Equal    ${comment}    ${text}

Yves: delete comments on cart
    Click    ${order_details_remove_comment_button} 
    Page Should Not Contain Element    ${order_details_remove_comment_button}

Yves: add comment on order:
    [Arguments]    ${comments}
    Click    ${order_details_page_add_comments_textbox}
    Type Text    ${order_details_page_add_comments_textbox}    ${comment}
    Click    ${add_button_order_details_page}
    ${text}    Get Text    ${comments_shopping_cart}
    Should Be Equal    ${comments}    ${text}