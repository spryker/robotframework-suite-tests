*** Variables ***
${zed_category_edit_button}     xpath=//body/ul[@class='dropdown-menu']/li/a[contains(.,'Edit')]
${zed_category_store_select}      xpath=//select[@id="category_store_relation_id_stores"]
${zed_category_store_select_search_field}      xpath=//select[@id="category_store_relation_id_stores"]/following-sibling::*//input[contains(@class,'select2-search')]
${zed_category_save_button}     xpath=//button[contains(@class,'safe-submit')]
