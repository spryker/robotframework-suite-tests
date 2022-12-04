*** Variables ***
${zed_pdp_abstract_main_content_locator}    css=*[name=product_form_edit]
${zed_pdp_concrete_main_content_locator}    css=*[name=product_concrete_form_edit]
${zed_pdp_discontinue_button}    xpath=//form[@name='product_concrete_form_edit']//div[@id='tab-content-discontinue']//a[contains(@href,'discontinue')]
${zed_pdp_add_products_alternative_input}    xpath=//form[@name='product_concrete_form_edit']//div[@id='tab-content-alternatives']//input
${zed_pdp_alternative_products_suggestion}    xpath=//ul[@id='select2-product_concrete_form_edit_alternative_products-results']/li[contains(@class,'select2-results__option')]
${zed_pdp_restore_button}    xpath=//form[@name='product_concrete_form_edit']//div[@id='tab-content-discontinue']//a[contains(@href,'restore')]
${zed_pdp_save_button}    xpath=//input[@type='submit' and @value='Save']
${zed_product_variant_table_processing_locator}    xpath=//div[@id='product-variant-table_processing']
${zed_product_name_en_input}    xpath=//input[@id='product_form_edit_general_en_US_name']
${zed_product_name_de_input}    xpath=//input[@id='product_form_edit_general_de_DE_name']
${zed_product_new_from}    xpath=//input[@id='product_form_edit_new_from']
${zed_product_new_to}    xpath=//input[@id='product_form_edit_new_to']
${zed_product_general_deDE_collapsed_section}    xpath=//div[@id='tab-content-general'][contains(@class,'active')]//*[contains(.,'de_DE')]/ancestor::div[contains(@class,'ibox nested collapsed')]//i[contains(@class,'plus')]
${zed_product_general_deDE_expanded_section}    xpath=//div[@id='tab-content-general'][contains(@class,'active')]//*[contains(.,'de_DE')]/ancestor::div[contains(@class,'ibox nested collapsed')]//i[contains(@class,'minus')]