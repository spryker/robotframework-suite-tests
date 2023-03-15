*** Variables ***
${checkout_summary_main_content_locator}    xpath=//div[@data-qa='component summary-overview']
${checkout_summary_submit_order_button}    xpath=//form[@name='summaryForm']//button[contains(@class,'submit-button')]
${checkout_summary_approver_dropdown}    id=quote_approve_request_form_approverCompanyUserId
${checkout_summary_send_request_button}    xpath=//form[@name='quote_approve_request_form']//button[contains(@class,'button--success')]
${checkout_summary_cancel_request_button}    xpath=//div[@data-qa='component quote-approve-request']//form[contains(@action,'remove')]//button
${checkout_summary_alert_warning}    xpath=//*[@class="form form--checkout-form"]//ul[contains(@class,'alert')]
${checkout_summary_quote_status}    xpath=//div[contains(@data-qa,'component quote-status')]
${checkout_summary_approve_request_button}    xpath=//main[contains(@class,'page-layout-main--checkout-page')]//form[contains(@action,'approve')]//button
${checkout_summary_decline_request_button}    xpath=//main[contains(@class,'page-layout-main--checkout-page')]//form[contains(@action,'decline')]//button
&{submit_checkout_form_button}    ui_b2b=xpath=//div[contains(@class,'form--checkout-form')]//button[@data-qa='submit-button']    ui_b2c=xpath=//div[contains(@class,'form--checkout-form')]//button[@data-qa='submit-button']    ui_suite=xpath=//button[@data-qa='submit-button']    ui_mp_b2b=xpath=//div[contains(@class,'form--checkout-form')]//button[@data-qa='submit-button']    ui_mp_b2c=xpath=//div[contains(@class,'form--checkout-form')]//button[@data-qa='submit-button']
&{checkout_summary_surcharge_amount}    ui_b2c=xpath=//ul[@data-qa='component summary-overview']//li[contains(text(),'Surcharge')]//span    ui_b2b=xpath=//div[@data-qa='component summary-overview']//li//div[contains(text(),'Surcharge')]/following-sibling::div    ui_mp_b2b=xpath=//div[@data-qa='component summary-overview']//li//div[contains(text(),'Surcharge')]/following-sibling::div    ui_mp_b2c=xpath=//ul[@data-qa='component summary-overview']//li[contains(text(),'Surcharge')]//span
&{checkout_summary_alert_message}    ui_b2c=xpath=//div[contains(@class,'checkout-actions')]//ul[contains(@class,'alert')]/li    ui_b2b=xpath=//div[@data-qa='component form']//ul[contains(@class,'alert')]/li    ui_mp_b2b=xpath=//div[@data-qa='component form']//ul[contains(@class,'alert')]/li    ui_mp_b2c=xpath=//div[contains(@class,'checkout-actions')]//ul[contains(@class,'alert')]/li
