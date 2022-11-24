*** Variables ***
${bob_remember_me_locator}    xpath=//form[@name='company_user_account_selector_form']//span[contains(@class,'checkbox__box')]
${bob_submit_locator}    xpath=//form[@name='company_user_account_selector_form']//button[@data-qa='submit-button']
${bob_business_unit_selector}    id=select2-company_user_account_selector_form_companyUserAccount-container