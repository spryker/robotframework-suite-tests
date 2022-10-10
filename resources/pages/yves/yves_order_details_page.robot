*** Variables ***
${order_details_main_content_locator}    xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']
${order_details_reorder_all_button}    xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']//button[contains(.,'Reorder all')]
${order_details_reorder_selected_items_button}    xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']//button[contains(.,'Reorder selected items')]
${order_details_shipping_address_locator}    xpath=//div[@class='summary-sidebar__item']//ul[@data-qa='component display-address']
${order_details_write_comment_placeholder}    xpath=//textarea[@placeholder='Write a comment']
${order_details_edit_comment_placeholder}    xpath=//textarea[@required="required"]
${order_details_add_button}    xpath=//button[@title='Add']
${order_details_edit_comment_button}    xpath=(//div[@class="grid grid--center"]//button)[1]
${order_details_update_button}    xpath=//button[@class="button button--small js-comment-form__submit-button"]
${order_details_remove_comment_button}    xpath=//button[@action="/en/comment/remove"]
${yves_order_details_page_comments}    xpath=//div[contains(@class,'comment-form__readonly')]//p
${yves_comment_delete_button}    xpath=(//button[contains(@action,'/comment/remove')])[1]