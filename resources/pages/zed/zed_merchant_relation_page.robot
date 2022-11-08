*** Variables ***
${merchant_dropdown_locator}    xpath=//label[@for="merchant-relationship_fk_merchant"]//following-sibling::span//span[@class="select2-selection__arrow"]
${company_dropdown_locator}    xpath=//label[@for="merchant-relationship_fk_company"]//following-sibling::span//span[@class="select2-selection__arrow"]
${confirm_button_locator}    xpath=//input[@name='submit-confirm']
${input_field_locator}    xpath=//input[@class="select2-search__field"]
${bussiness_unit_owner_locator}    xpath=//label[@for="merchant-relationship_fk_company_business_unit"]//following-sibling::span//span[@class="select2-selection__arrow"]
${assigned_bussiness_units_locator}    xpath=//span[@data-select2-id="7"] 
${bussiness_unit_owner_input_locator}    xpath=//input[@aria-controls="select2-merchant-relationship_fk_company_business_unit-results"]
${assigned_product_lists_input_locator}    xpath=//label[@for="merchant-relationship_assigneeCompanyBusinessUnits"]//parent::div//following-sibling::span//child::input
${assigned_product_lists_locator}    xpath=//span[@data-select2-id="8"]
${assigned_product_lists_input_locator}    xpath=//label[@for="merchant-relationship_productListIds"]//parent::div//following-sibling::span//child::input
${company_dropdown_merchant_relation_locator}    id=company-select