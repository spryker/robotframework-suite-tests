*** Variables ***
${zed_pdp_abstract_main_content_locator}    css=*[name=product_form_edit]
${zed_pdp_concrete_main_content_locator}    css=*[name=product_concrete_form_edit]
${zed_pdp_discontinue_button}    xpath=//form[@name='product_concrete_form_edit']//div[@id='tab-content-discontinue']//a[contains(@href,'discontinue')]
${zed_pdp_add_products_alternative_input}    xpath=//form[@name='product_concrete_form_edit']//div[@id='tab-content-alternatives']//input
${zed_pdp_alternative_products_suggestion}    xpath=//ul[@id='select2-product_concrete_form_edit_alternative_products-results']/li[contains(@class,'select2-results__option')]
${zed_pdp_restore_button}    xpath=//form[@name='product_concrete_form_edit']//div[@id='tab-content-discontinue']//a[contains(@href,'restore')]
${zed_dpd_save_button}    xpath=//input[@type='submit' and @value='Save']
${zed_product_variant_table_processing_locator}    xpath=//div[@id='product-variant-table_processing']
${zed_edit_product_en_name}    id=product_form_edit_general_en_US_name
${zed_edit_product_de_name}    id=product_form_edit_general_de_DE_name
