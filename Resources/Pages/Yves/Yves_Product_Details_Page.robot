*** Settings ***
Library    SeleniumLibrary    plugins=SeleniumTestability;True;30 Seconds;True

*** Variable ***
&{pdp_main_container_locator}    b2b=xpath=//main[contains(@class,'page-layout-main--pdp')]//div[@class='container']    b2c=xpath=//main[contains(@class,'page-layout-main')]//div[contains(@class,'pdp')]
${pdp_price_element_locator}    xpath=//span[contains(@class,'volume-price__price')]
${pdp_add_to_cart_button}    xpath=//button[contains(@class,'button') and @data-qa='add-to-cart-button']
${pdp_add_to_cart_disabled_button}    xpath=//button[@disabled and contains(text(),'Add to Cart')]
${pdp_add_to_wishlist_button}    xpath=//button[@type='submit' and contains(text(),'Add to Wishlist')]
&{pdp_quantity_input_filed}    b2b=xpath=//div[@class='product-configurator__add-to-cart']//input[@name='quantity']    b2c=//*[@data-qa='quantity-input']
${pdp_alternative_products_slider}    xpath=//*[@data-qa='component product-alternative-slider']
${pdp_measurement_sales_unit_selector}    name=id-product-measurement-sales-unit
${pdp_measurement_unit_notification}    id=measurement-unit-choices
${pdp_increase_quantity_button}    xpath=//div[@class='product-configurator__add-to-cart']//button[contains(@class,'quantity-counter__button--increment')]
${pdp_decrease_quantity_button}    xpath=//div[@class='product-configurator__add-to-cart']//button[contains(@class,'quantity-counter__button--decrement')]
${pdp_variant_selector}    xpath=//*[@data-qa='component variant']//select
${pdp_amount_input_filed}    id=user-amount
${pdp_packaging_unit_notification}    xpath=//*[@class='packaging-unit-notifications']
${pdp_product_bundle_include_small}    xpath=//div[@class='js-product-options-bundle__target']
${pdp_product_bundle_include_large}    xpath=//div[@data-qa='component product-bundle']
&{pdp_related_products}    b2b=xpath=//*[contains(@class,'title--product-slider')][contains(.,'Similar products')]/../slick-carousel    b2c=xpath=//*[contains(@class,'product-slider')][contains(.,'You might also like')]/../slick-carousel
${pdp_add_to_shopping_list_button}    xpath=//button[@data-qa='add-to-shopping-list-button']
${pdp_product_sku}    xpath=//section[@class='product-configurator']//div[@class='product-configurator__sku']
${pdp_shopping_list_selector}    xpath=//form[contains(@action,'shopping-list')]//select
${pdp_sales_label}    xpath=//*[@data-qa='component label-group']//span[contains(text(),'SALE')]
${pdp_new_label}    xpath=//*[@data-qa='component label-group']//span[contains(text(),'NEW')]
${pdp_warranty_option}    xpath=//*[contains(@class,'item--option')]//*[contains(text(),'Warranty')]
${pdp_insurance_option}    xpath=//*[contains(@class,'item--option')]//*[contains(text(),'Insurance')]
${pdp_gift_wrapping_option}    xpath=//*[contains(@class,'item--option')]//*[contains(text(),'Gift wrapping')]
${pdp_product_reviews_list}    xpath=//*[contains(text(),'Product Reviews')]/following-sibling::div/article[@class='review']
${pdp_add_to_wishlist_button}    xpath=//button[@type='submit' and contains(text(),'Add to Wishlist')]