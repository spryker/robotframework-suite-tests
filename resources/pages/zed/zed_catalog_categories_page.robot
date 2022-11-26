*** Variables ***
${zed_categories_table_actions_button}    xpath=//button[@aria-expanded='true']
${zed_categories_table_action_edit}     xpath=(//a[contains(@href,'/category-gui/edit?id-category')])[1]
${zed_edit_category_en_name}    id=category_localized_attributes_1_name
${zed_edit_category_de_name}    id=category_localized_attributes_0_name
${zed_edit_category_save_button}    xpath=//button[contains(@class,'safe-submit')]

${zed_categories_table_action_edit}