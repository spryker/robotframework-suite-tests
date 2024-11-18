*** Variables ***
${order_details_main_content_locator}    xpath=//main//form[contains(@name,'Reorder')][contains(@action,'reorder')]//*[contains(@data-qa,'reorder-form')]
&{order_details_reorder_all_button}    ui_b2b=xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']//button[contains(.,'Reorder all')]    ui_b2c=xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']//button[contains(.,'Reorder all')]    ui_mp_b2b=xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']//button[contains(.,'Reorder all')]    ui_mp_b2c=xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']//button[contains(.,'Reorder all')]    ui_suite=xpath=//form[contains(@action,'reorder')][input[contains(@id,'cartReorderForm')]]//button[@class="button"] | //form[@name='customerReorderWidgetForm']//button
${order_details_reorder_selected_items_button}    xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']//button[contains(.,'Reorder selected items')]
&{order_details_shipping_address_locator}    ui_b2b=xpath=//div[@class='summary-sidebar__item']//ul[@data-qa='component display-address']    ui_mp_b2b=xpath=//div[@class='summary-sidebar__item']//ul[@data-qa='component display-address']    ui_mp_b2c=xpath=//*[@data-qa="component order-detail-table"]//div[@class='summary-sidebar__item'][1]/div[contains(@class,'text')]    ui_b2c=xpath=//*[@data-qa="component order-detail-table"]//div[@class='summary-sidebar__item'][1]/div[contains(@class,'text')]    ui_suite=xpath=//div[@class='order-detail-table']//ul[@data-qa='component display-address']
${order_details_cancel_button_locator}    xpath=//remote-form-submit[contains(@form-action,'cancel')]//button | //*[contains(@name,'orderCancelForm')]//button
${order_details_write_comment_placeholder}    xpath=//div[@data-qa='component add-comment-form']//form[@method='POST']/textarea
${order_details_edit_comment_placeholder}    xpath=//comment-form[@data-qa='component comment-form']//form[@method='POST']//textarea
${order_details_add_comment_button}    xpath=//button[contains(@class,"js-add-comment-form__button")]
${order_details_edit_comment_button}    xpath=//button[contains(@class,"button--hollow-icon-small") and not (contains(@class,"js-comment-form__remove-button"))]
${order_details_update_comment_button}    xpath=//button[contains(@action,"/comment/update")]
${order_details_remove_comment_button}    xpath=//button[contains(@action,"/comment/remove")]
${yves_order_details_page_comments}    xpath=//comment-thread-list//comment-form//textarea
${add_comment_button_order_details_page}    xpath=//button[contains(@action,'comment/add')] | //button[contains(@class,'add-comment')]
${order_details_page_add_comments_textbox}    xpath=//textarea[ancestor::form[@method='POST'] and not(ancestor::comment-thread-list)]