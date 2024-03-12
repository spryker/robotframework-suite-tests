*** Variables ***
${zed_store_add_name_input}     xpath=//input[@id="store_name"]
${zed_store_save_button}    xpath=//input[@type="submit"]
${zed_store_locale_tab}    xpath=//ul[contains(@class, 'nav')]/li[contains(@data-tab-content-id, 'locale_store_relation')]
${zed_store_default_locale_iso_code}    xpath=//select[contains(@id,"defaultLocaleIsoCode")]
${zed_store_currency_tab}    xpath=//ul[contains(@class, 'nav')]/li[contains(@data-tab-content-id, 'locale_currency_relation')]
${zed_store_default_currency_iso_code}    xpath=//select[contains(@id,"defaultCurrencyIsoCode")]
${zed_store_delivery_region_tab}    xpath=//ul[contains(@class, 'nav')]/li[contains(@data-tab-content-id, 'country_store_relation')]
${zed_store_search_field}    xpath=//form[@name='store']/div/div[@class='tab-content']/div[contains(@id,'tab-content')][contains(@class,'active')]//*[contains(@id,'available')]//input[@type='search']