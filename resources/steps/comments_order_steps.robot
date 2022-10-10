*** Settings ***
Resource    ../common/common_yves.robot
Resource    ../common/common.robot
Resource    ../steps/customer_account_steps.robot
Resource    ../pages/zed/zed_order_details_page.robot
Resource    ../pages/yves/yves_order_details_page.robot
Resource    ../common/common_zed.robot

*** Variables ***
${view_button_of_last_order}    xpath=(//a[contains(@href,'/customer/order/details')])[1]
${zed_view_button_of_last_order}    xpath=(//a[contains(@href,'/sales/detail')])[1]

*** Keywords ***
Yves: adding comments on cart before checkout
    Click    ${order_details_write_comment_placeholder}
    Type Text    ${order_details_write_comment_placeholder}    abc${random}
    Click    ${order_details_add_button}

Yves: go to 'Order History' page to check comments
    Yves: go to 'Customer Account' page
    Yves: go to user menu item in the left bar:    Order History
    Click    ${view_button_of_last_order}
    ${text_entered}    Get Text    ${yves_order_details_page_comments}
    IF    '${text_entered}' == 'abc${random}'
        Log    text entered in comments appers in order details page in Yves
    ELSE
        Log    comments not added succesfully to order details page in Yves
    END    

Zed: checking comments added in zed
    Click    ${zed_view_button_of_last_order}
    Wait Until Element Is Visible    ${zed_order_details_page_comments}
    ${text_entered}    Get Text    ${zed_order_details_page_comments}
       IF    '${text_entered}' == 'abc${random}'
            Log    comments added to cart appears in order details page in zed
       ELSE
            Log    comments added to cart does not appears in order details page in zed
       END

Yves: add edit delete comments on cart
    Type Text    ${order_details_write_comment_placeholder}    abc${random}
    Click    ${order_details_add_button}
    Click    ${order_details_edit_comment_button}
    Click    ${order_details_edit_comment_placeholder}
    Clear Text    ${order_details_edit_comment_placeholder}  
    Keyboard Key    press    Tab
    Input Text    ${order_details_edit_comment_placeholder}    xyz${random}
    Click    ${order_details_update_button}
    Click    ${order_details_remove_comment_button} 