*** Variables ***
${order_details_main_content_locator}    xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']
${order_details_reorder_all_button}    xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']//button[contains(.,'Reorder all')]
${order_details_reorder_selected_items_button}    xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']//button[contains(.,'Reorder selected items')]
${order_details_shipping_address_locator}    xpath=//div[@class='summary-sidebar__item']//ul[@data-qa='component display-address']
${order_details_write_comment_placeholder}    xpath=//div[@data-qa='component add-comment-form']//form[@method='POST']/textarea
${order_details_edit_comment_placeholder}    xpath=//div[starts-with(@class,"comment-form__edit js-comment__target-all")]/textarea
${order_details_add_button}    xpath=//button[@class="button button--primary add-comment-form__button js-add-comment-form__button"]
${order_details_edit_comment_button}    xpath=//button[contains(@class,"col button button--hollow-icon-small js-comment__trigger-all")]
${order_details_update_button}    xpath=//button[contains(@action,"/en/comment/update")]
${order_details_remove_comment_button}    xpath=//button[contains(@action,"/en/comment/remove")]
${yves_order_details_page_comments}    xpath=//div[contains(@class,'comment-form__readonly')]//p
${comments_shopping_cart}    xpath=//div[contains(@class,"comment-form__readonly js-comment__target-all")]/p