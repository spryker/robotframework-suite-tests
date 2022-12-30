*** Variables ***
${new_product_sku_field}    id=create_product_abstract_form_sku
${new_product_name_field}    id=create_product_abstract_form_name
${new_product_multiple_concretes_option}    xpath=//span[contains(text(),'multiple concrete products')]/../span[@class='ant-radio']
${new_product_super_attribute_first_row_name_selector}    xpath=//div[@class='mp-product-attributes-selector__content']/div[1]/div[1]//spy-select
${new_product_super_attribute_first_row_values_selector}    xpath=//div[@class='mp-product-attributes-selector__content']/div[1]/div[2]//spy-select
${new_product_super_attribute_second_row_name_selector}    xpath=//div[@class='mp-product-attributes-selector__content']/div[2]/div[1]//spy-select
${new_product_super_attribute_second_row_values_selector}    xpath=//div[@class='mp-product-attributes-selector__content']/div[2]/div[2]//spy-select
${new_product_add_super_attribute_button}    xpath=//div[contains(@class,'mp-product-attributes-selector__button')]//span[contains(text(),'Add')]
${new_product_created_popup}    xpath=//span[contains(@class,'ant-alert')]//span[contains(text(),'Product successfully created')]
${new_concrete_product_created_popup}    xpath=//span[contains(@class,'ant-alert')]//span[contains(text(),'Success! 1 Concrete Product is saved.')]
${new_product_concretes_preview_count}    xpath=//mp-concrete-products-preview//spy-chips
${new_product_submit_next_button}    xpath=//button[@type='submit'][contains(text(),'Next')]
${new_product_submit_create_button}    xpath=//button[@type='submit'][contains(text(),'Create')]
${product_concrete_submit_button}    xpath=//div[@class='mp-edit-concrete-product__header']//button[@type='submit']
${product_updated_popup}    xpath=//span[contains(@class,'ant-alert')]//span[contains(text(),'The Product is saved')]
${product_name_de_field}    id=productAbstract_localizedAttributes_0_name
${product_store_selector}    xpath=//web-spy-card[@spy-title='Stores']//web-spy-select
${product_tax_selector}    xpath=//web-spy-card[contains(@spy-title,'Tax Set')]//web-spy-select
${product_drawer_concretes_tab}    xpath=//div[contains(text(),'Concrete Products')]
${product_concrete_active_checkbox}    xpath=//span[contains(text(),'Concrete Product is active')]
${product_concrete_stock_input}    xpath=//web-spy-input[@spy-id='productConcreteEdit_productConcrete_stocks_quantity']//input
${product_concrete_use_abstract_name_checkbox}    xpath=//span[contains(text(),'Use Abstract Product name')]
${product_concrete_searchability_selector}    xpath=//web-spy-select[@spy-id='productConcreteEdit_searchability']
${mp_add_price_button}    xpath=//web-spy-card[@spy-title='Price']//button[contains(text(),'Add')]
${mp_add_concrete_price_button}    xpath=//web-mp-edit-concrete-product//web-spy-card[@spy-title='Price']//button[contains(text(),'Add')]
${product_delete_price_row_button}    xpath=//li[contains(@class,'ant-dropdown-menu-item')]
${product_price_deleted_popup}    xpath=//span[contains(@class,'ant-alert')]//span[contains(text(),'The Price is deleted')]
${mp_use_abstract_price_checkbox}    xpath=//web-mp-content-toggle[@name='productConcreteEdit[useAbstractProductPrices]']//input[@type='checkbox'][contains(@class,'checkbox')]/parent::span
${mp_add_concrete_products_button}    xpath=//web-mp-edit-abstract-product-variants//web-spy-button-action[@type='button']//button

