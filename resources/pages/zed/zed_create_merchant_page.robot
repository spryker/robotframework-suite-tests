*** Variables ***
${zed_create_merchant_name_field}    id=merchant_name
${zed_create_merchant_reference_field}    id=merchant_merchant_reference
${zed_create_merchant_email_field}    id=merchant_email
${zed_create_merchant_url_en_locale_field}    id=merchant_urlCollection_0_url
${zed_create_merchant_url_de_locale_field}    id=merchant_urlCollection_1_url
${zed_create_merchant_registration_number_filed}    id=merchant_registration_number
${merchant_is_active_checkbox_locator}    id=merchant_is_active
${merchant_checkbox_en_locator}    id=merchant_storeRelation_id_stores_0
${merchant_checkbox_de_locator}    id=merchant_storeRelation_id_stores_1
${zed_create_merchant_user_email_field}    id=merchant-user_username
${zed_create_merchant_user_first_name_field}    id=merchant-user_firstName
${zed_create_merchant_user_last_name_field}    id=merchant-user_lastName
${zed_add_merchant_user_button}    xpath=//a[contains(@class,'btn-create')][contains(text(),'User')]
${zed_merchant_user_search_field_locator}     xpath=//div[@class='dataTables_filter']//input[@type='search']