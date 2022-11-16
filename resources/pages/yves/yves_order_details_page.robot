*** Variables ***
${order_details_main_content_locator}    xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']
${order_details_reorder_all_button}    xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']//button[contains(.,'Reorder all')]
${order_details_reorder_selected_items_button}    xpath=//customer-reorder-form[@data-qa='component customer-reorder-form']//button[contains(.,'Reorder selected items')]
${order_details_shipping_address_locator}    xpath=//div[@class='summary-sidebar__item']//ul[@data-qa='component display-address']
${order_details_grand_total_locator}    xpath=//li[contains(@class,'order-summary__item--total')]//strong[@class='float-right']
${order_details_invoice_ammount_locator}    xpath=//ul[contains(@class,'gift-card-order-summary')]//li[2]//span
${order_details_gift_card_ammount_locator}    xpath=//ul[contains(@class,'gift-card-order-summary')]//li[1]//span
