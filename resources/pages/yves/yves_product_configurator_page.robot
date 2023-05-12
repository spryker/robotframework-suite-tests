*** Variables ***
${configurator_date_input}    id=date
${configurator_day_time_selector}    id=daytime
${configurator_save_button}    xpath=//button[@type='submit']
${configurator_cancel_button}    xpath=//a[contains(@class,'cancel')]
${configurator_store}    xpath=//app-information-list//li[contains(.,'Store')]/span
${configurator_locale}    xpath=//app-information-list//li[contains(.,'Locale')]/span
${configurator_price_mode}    xpath=//app-information-list//li[contains(.,'Price')]/span
${configurator_currency}    xpath=//app-information-list//li[contains(.,'Currency')]/span
${configurator_customer_id}    xpath=//app-information-list//li[contains(.,'Customer')]/span
${configurator_sku}    xpath=//app-product-details//div[contains(@class,'details')]/div