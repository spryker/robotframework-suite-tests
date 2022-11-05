*** Variables ***
${categories_product_actions_button}    xpath= //button[@aria-expanded='true']
${categories_product_actions_edit}     xpath= (//a[contains(@href,'/category-gui/edit?id-category')])[1]
${categories_product_name}    id=category_localized_attributes_1_name
${categories_product_save_button}    xpath= //button[contains(@class,'safe-submit')]