*** Variable ***
&{catalog_main_page_locator}    ui_b2b=xpath=//main[contains(@class,'page-layout-main--catalog-page')]    ui_b2c=xpath=//div[contains(@class,'catalog-right')]    ui_suite=xpath=//form[contains(@class,'catalog__form')]    ui_mp_b2b=xpath=//main[contains(@class,'page-layout-main--catalog-page')]    ui_mp_b2c=xpath=//div[contains(@class,'catalog-right')]
${catalog_product_card_locator}    xpath=(//product-item[@data-qa='component product-item'][1]//a[contains(@class,'link-detail-page') and (contains(@class,'info')) or (contains(@class,'name'))])[1]
&{catalog_products_counter_locator}    ui_b2b=xpath=//*[contains(@class,'col--counter')]    ui_b2c=xpath=//*[contains(@class,'sort__results col')]    ui_mp_b2b=xpath=//*[contains(@class,'col--counter')]    ui_mp_b2c=xpath=//*[contains(@class,'sort__results col')]    ui_suite=xpath=//*[@data-qa='component sort']//strong
${catalog_filter_apply_button}    xpath=//section[@data-qa='component filter-section']//button[contains(@class,'button')]
${catalog_add_to_cart_button}    xpath=//button[contains(@title,'Add to Cart')]
${catalog_sorting_selector}    xpath=//select[@name='sort']
${catalog_apply_sorting_button}    xpath=//*[contains(@data-qa,"component sort")]//button