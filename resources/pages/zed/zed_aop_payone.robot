*** Settings ***
Library    BuiltIn
Resource                  common.robot
Resource                  ../pages/zed/zed_login_page.robot
Resource    ../pages/zed/zed_edit_product_page.robot

*** Variable ***
${zed_log_out_button}   xpath=//ul[@class='nav navbar-top-links navbar-right']//a[contains(@href,'logout')]
${zed_save_button}      xpath=//input[contains(@class,'safe-submit')]
${zed_success_flash_message}    xpath=//div[@class='flash-messages']/div[@class='alert alert-success']
${zed_table_locator}    xpath=//table[contains(@class,'dataTable')]/tbody
${zed_search_field_locator}     xpath=//input[@type='search']
${zed_variant_search_field_locator}     xpath=//*[@id='product-variant-table_filter']//input[@type='search']
${zed_processing_block_locator}     xpath=//div[contains(@id,'processing')][contains(@class,'dataTables_processing')]

