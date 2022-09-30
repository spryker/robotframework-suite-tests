*** Variables ***
${shopping_list_main_content_locator}    xpath=//*[@data-qa='component shopping-list-info']
${add_all_available_products_to_cart_locator}    xpath=//form[contains(@name,'shopping_list_add_item_to_cart_form')]//button[contains(text(),'Add all available products to cart')]

${shoppingList_dropdown}    //span[contains(text(),'Newcomers')]
${add_to_shopinglist_button}     xpath=//button[normalize-space()='Add to Shopping list']
${shoppinglist_dropdown_value}    //li[contains(text(),'Monthly office')]
${product_213103}    //a[contains(text(),'Visitor chair, stackable - backrest upholstered, s')]
${searchbox_input_field_locator}    //input[@placeholder='Search']
${shopping_list_header}    //a[@class="user-navigation__link js-user-navigation__trigger"]
${Quick_order_header}    //span[text()='Quick Order']
${all_shoppinglist_button}    //a[normalize-space()='All Shopping Lists']