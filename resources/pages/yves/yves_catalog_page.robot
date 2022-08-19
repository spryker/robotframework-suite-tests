*** Variable ***
&{catalog_main_page_locator}    b2b=xpath=//main[contains(@class,'page-layout-main--catalog-page')]    b2c=xpath=//div[contains(@class,'catalog-right')]    suite-nonsplit=xpath=//form[contains(@class,'catalog__form')]    mp_b2b=xpath=//main[contains(@class,'page-layout-main--catalog-page')]
${catalog_product_card_locator}    xpath=//product-item[@data-qa='component product-item'][1]//a[contains(@class,'link-detail-page') and (contains(@class,'info')) or (contains(@class,'name'))]
&{catalog_products_counter_locator}    b2b=xpath=//*[contains(@class,'col--counter')]    b2c=xpath=//*[contains(@class,'sort__results col')]    mp_b2b=xpath=//*[contains(@class,'col--counter')]
${catalog_filter_apply_button}    xpath=//section[@data-qa='component filter-section']//button[contains(@class,'button')]
${catalog_add_to_cart_button}    xpath=//button[contains(@title,'Add to Cart')]