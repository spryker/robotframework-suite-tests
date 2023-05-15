*** Variables ***
${wishlist_main_content_locator}    xpath=//h1[contains(@class,'account-main')][contains(text(),'Wishlist')]
${wishlist_name_input_field}    id=wishlist_form_name
${wishlist_add_new_button}    xpath=//button[@type='submit' and contains(text(),'Add new wishlist')]
${wishlist_delete_button}    xpath=(//table//button[contains(@title,'Delete')])
${wishlist_add_all_to_cart_button}    xpath=//form[@name='add_all_available_products_to_cart_form']/button