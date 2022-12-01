*** Variables ***
${yves_company_role_delete_button}    id=company_role_delete_form_idCompanyRole
${yves_company_role_is_default_checkbox}    id=company_role_form_is_default
${yves_company_role_name_locator}    id=company_role_form_name
${yves_company_role_create_button}    xpath=//a[@class="button action-bar__action"]
${yves_company_role_submit_button}    xpath=//button[contains(@class,"form__action--sm-md-first button")]
${yves_company_role_permission_toggle_button}    xpath=//a[contains(@class,"switch") and not (contains(@class,'switch--active'))]