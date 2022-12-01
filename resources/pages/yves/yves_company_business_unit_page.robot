*** Variables ***
${create_business_unit_button}    xpath=//a[contains(@class,'action-bar__action')]
${business_unit_street_locator}    id=company_unit_address_form_address1
${business_unit_number_locator}    id=company_unit_address_form_address2
${business_unit_address_locator}    id=company_unit_address_form_address3
${business_unit_zipcode_locator}    id=company_unit_address_form_zip_code
${business_unit_city_locator}    id=company_unit_address_form_city
${business_unit_country_locator}    id=company_unit_address_form_iso2_code
${business_unit_phone_number_locator}    id=company_unit_address_form_phone
${business_unit_submit_button}    xpath=//button[contains(@class,'form__action--sm-md-first button')]
${business_unit_external_url_locator}    id=company_business_unit_form_external_url
${create_business_unit_phone_number_locator}    id=company_business_unit_form_phone
${create_business_unit_email_locator}    id=company_business_unit_form_email
${create_business_parent_bu_locator}    id=company_business_unit_form_fk_parent_company_business_unit
${create_business_name_locator}    id=company_business_unit_form_name