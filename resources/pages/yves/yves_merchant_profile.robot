*** Variables ***
${merchant_profile_main_content_locator}    xpath=//div[@data-qa='component merchant-profile']
${merchant_profile_name_header_locator}     xpath=//div[@class='page-info']//h3
${merchant_profile_email_locator}    xpath=//div[@class='merchant-profile']//h5[text()='Email Address']/../div
${merchant_profile_phone_locator}    xpath=//div[@class='merchant-profile']//h5[text()='Phone']/../div
${merchant_profile_delivery_time_locator}    xpath=//div[@class='merchant-profile']//h5[text()='Delivery Time']/../div
${merchant_profile_data_privacy_locator}    xpath=//div[@class='merchant-profile']//h3[text()='Data Privacy']/../div
