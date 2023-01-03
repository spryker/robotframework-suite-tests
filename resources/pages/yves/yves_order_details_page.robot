*** Variables ***
${order_details_main_content_locator}    xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']
${order_details_reorder_all_button}    xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']//button[contains(.,'Reorder all')]
${order_details_reorder_selected_items_button}    xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']//button[contains(.,'Reorder selected items')]
${order_details_shipping_address_locator}    xpath=//div[@class='summary-sidebar__item']//ul[@data-qa='component display-address']
${order_details_cancel_button_locator}    xpath=//remote-form-submit[contains(@form-action,'cancel')]//button
${order_details_write_comment_placeholder}    xpath=//div[@data-qa='component add-comment-form']//form[@method='POST']/textarea
${order_details_edit_comment_placeholder}    xpath=//comment-form[@data-qa='component comment-form']//form[@method='POST']//textarea
${order_details_add_comment_button}    xpath=//button[contains(@class,"js-add-comment-form__button")]
${order_details_edit_comment_button}    xpath=//button[contains(@class,"button--hollow-icon-small") and not (contains(@class,"js-comment-form__remove-button"))]
${order_details_update_comment_button}    xpath=//button[contains(@action,"/comment/update")]
${order_details_remove_comment_button}    xpath=//button[contains(@action,"/comment/remove")]
${yves_order_details_page_comments}    xpath=//div[contains(@class,'comment-form__readonly')]//p
${add_comment_button_order_details_page}    xpath=//form[contains(@action,"/comment/add")]/button
${order_details_page_add_comments_textbox}    xpath=//form[contains(@action,"/comment/add")]/textarea