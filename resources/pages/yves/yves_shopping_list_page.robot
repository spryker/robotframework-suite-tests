*** Variables ***
${shopping_list_main_content_locator}    xpath=//*[@data-qa='component shopping-list-info']
${add_all_available_products_to_cart_locator}    xpath=//form[contains(@name,'shopping_list_add_item_to_cart_form')]//button[contains(text(),'Add all available products to cart')]

${shoppingList_dropdown}     xpath=//span[contains(@id,'select2-idShoppingList')]
${add_to_shopinglist_button}     xpath=//button[@data-qa="add-to-shopping-list-button"]
${searched_product}    xpath=//a[@class="product-item__overlay product-item__overlay--catalog product-item__overlay--category js-product-item__name js-product-item__link-detail-page"]
${searchbox_input_field_locator}    xpath=//input[contains(@class,'suggest-search__input--transparent')]
${shopping_list_header}    //a[@class="user-navigation__link js-user-navigation__trigger"]
${Quick_order_header}    xpath=//a[contains(@href,'/quick-order')]
${add_product_to_cart}    xpath=//div[@class="col col--sm-12 col--lg-auto text-right spacing-bottom"]//button
${add_button_shoppinglist_page}    xpath=//div[@class="col col--sm-12 col--md-2"]
${quantity_input_field}    //input[@id='quantity']
${shoppinglist_page_searchbox_input_field_locator}    //input[@placeholder='Search by SKU or Name']
${currently_not_available_text_locator}    //span[normalize-space()='Currently not available']