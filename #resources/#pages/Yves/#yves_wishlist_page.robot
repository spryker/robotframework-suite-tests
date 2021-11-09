*** Variables ***
${wishlist_name_input_field}    id=wishlist_form_name
${wishlist_add_new_button}    xpath=//button[@type='submit' and contains(text(),'Add new wishlist')]
${wishlist_delete_button}    xpath=(//table//button[contains(@title,'Delete')])