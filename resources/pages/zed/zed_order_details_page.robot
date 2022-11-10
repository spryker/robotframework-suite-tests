*** Variables ***
${zed_order_details_page_comments}    xpath=//p[@class="comment-title"]//following-sibling::p
${order_details_page_add_comments_textbox}    xpath=//form[contains(@action,"/comment/add")]/textarea
${add_button_order_details_page}    xpath=//form[contains(@action,"/comment/add")]/button
