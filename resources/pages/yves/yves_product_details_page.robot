*** Variables ***
&{pdp_main_container_locator}    ui_b2b=xpath=//main[contains(@class,'page-layout-main--pdp')]    ui_b2c=xpath=//*[@itemtype='https://schema.org/Product']//main[contains(@class,'page-layout')]    ui_suite=xpath=//section[@itemtype="https://schema.org/Product"]    ui_mp_b2b=xpath=//main[contains(@class,'page-layout-main--pdp')]    ui_mp_b2c=xpath=//*[@itemtype='https://schema.org/Product']//main[contains(@class,'page-layout')]
${pdp_price_element_locator}    xpath=//volume-price[@class='custom-element volume-price']//span[contains(@class,'volume-price__price')][not(ancestor::form[contains(@action,'cart/add')])]
${pdp_original_price_element_locator}    xpath=//volume-price[@class='custom-element volume-price']//span[contains(@class,'volume-price')][contains(@class,'original')][not(ancestor::form[contains(@action,'cart/add')])]
${pdp_add_to_cart_button}    xpath=//button[contains(@class,'button') and @data-qa='add-to-cart-button']
&{pdp_add_to_cart_disabled_button}    ui_b2c=xpath=//button[@disabled and contains(text(),'Add to Cart')]    ui_b2b=xpath=//button[@disabled and contains(@data-qa,'add-to-cart-button')]    ui_mp_b2b=xpath=//button[@disabled and contains(@data-qa,'add-to-cart-button')]    ui_mp_b2c=xpath=//button[@disabled and contains(text(),'Add to Cart')]    ui_mp_b2c=xpath=//button[@disabled and contains(text(),'Add to Cart')]    ui_suite=xpath=//button[contains(@class,'add-to-cart')][@disabled]
${pdp_add_to_wishlist_button}    xpath=//button[@type='submit'][contains(.,'Wishlist')]
&{pdp_quantity_input_filed}    ui_b2b=xpath=//div[@class='product-configurator__add-to-cart']//input[contains(@class,'number-input')][contains(@class,'quantity-counter')]    ui_b2c=//*[@data-qa='quantity-input']    ui_mp_b2b=xpath=//div[@class='product-configurator__add-to-cart']//input[contains(@class,'number-input')][contains(@class,'quantity-counter')]    ui_mp_b2c=//*[@data-qa='quantity-input']    ui_suite=xpath=//form[contains(@action,'cart/add')]//select[@name='quantity']
&{pdp_alternative_products_slider}    ui_b2b=xpath=//*[@data-qa='component product-alternative-slider']    ui_b2c=xpath=//*[contains(@class,'product-slider')][contains(.,'Alternative products')]/../slick-carousel    ui_mp_b2b=xpath=//*[@data-qa='component product-alternative-slider']    ui_mp_b2c=xpath=//*[contains(@class,'product-slider')][contains(.,'Alternative products')]/../slick-carousel    ui_suite=xpath=(//*[contains(text(),'Alternative products')]/following-sibling::simple-carousel)[1]
${pdp_measurement_sales_unit_selector}    css=*[name=id-product-measurement-sales-unit]
${pdp_measurement_unit_notification}    xpath=//packaging-unit-quantity-selector/div[contains(@class,'measurement-unit-choice')]
&{pdp_increase_quantity_button}    ui_b2b=xpath=//div[@class='product-configurator__add-to-cart']//button[contains(@class,'quantity-counter__button--increment')]    ui_mp_b2b=xpath=//div[@class='product-configurator__add-to-cart']//button[contains(@class,'quantity-counter__button--increment')]    ui_b2c=xpath=//quantity-counter[@data-qa='component quantity-counter']//*[contains(@class,'quantity-counter__incr')]    ui_mp_b2c=xpath=//quantity-counter[@data-qa='component quantity-counter']//*[contains(@class,'quantity-counter__incr')]
&{pdp_decrease_quantity_button}    ui_b2b=xpath=//div[@class='product-configurator__add-to-cart']//button[contains(@class,'quantity-counter__button--decrement')]    ui_mp_b2b=xpath=//div[@class='product-configurator__add-to-cart']//button[contains(@class,'quantity-counter__button--decrement')]    ui_b2c=xpath=//quantity-counter[@data-qa='component quantity-counter']//*[contains(@class,'quantity-counter__decr')]    ui_mp_b2c=xpath=//quantity-counter[@data-qa='component quantity-counter']//*[contains(@class,'quantity-counter__decr')]
${pdp_variant_selector}    xpath=//*[@data-qa='component variant']//select
${pdp_variant_custom_selector}    xpath=//section[@data-qa='component variant-configurator']//span[contains(@id,'select2-attribute')]
${pdp_variant_custom_selector_results}    xpath=//ul[contains(@id,'select2-attribute')][contains(@id,'results')]
${pdp_amount_input_filed}    xpath=//formatted-number-input/input[contains(@class,'user-amount')]
${pdp_packaging_unit_notification}    xpath=//div[contains(@class,'packaging-unit-quantity-selector')][contains(@class,'packaging-unit-choice')]/div[contains(@class,'packaging-unit')]//button
&{pdp_product_bundle_include_small}    ui_b2b=xpath=//div[contains(@data-qa,'component bundle-items')]    ui_b2c=xpath=//div[contains(@data-qa,'component bundle-items')]    ui_mp_b2b=xpath=//div[contains(@data-qa,'component bundle-items')]    ui_mp_b2c=xpath=//div[contains(@data-qa,'component bundle-items')]    ui_suite=xpath=//div[contains(@data-qa,'component bundle-items')]
${pdp_product_bundle_include_large}    xpath=//div[@data-qa='component product-bundle']
&{pdp_related_products}    ui_b2b=xpath=//*[contains(@class,'title--product-slider')][contains(.,'Similar products')]/../slick-carousel    ui_b2c=xpath=//*[contains(@class,'product-slider')][contains(.,'You might also like')]/../slick-carousel    ui_mp_b2b=xpath=//*[contains(@class,'title--product-slider')][contains(.,'Similar products')]/../slick-carousel    ui_mp_b2c=xpath=//*[contains(@class,'product-slider')][contains(.,'You might also like')]/../slick-carousel    ui_suite=xpath=(//main//simple-carousel[@data-qa='component simple-carousel'])[1]
${pdp_add_to_shopping_list_button}    xpath=//button[@data-qa='add-to-shopping-list-button']
&{pdp_product_sku}    ui_b2b=xpath=//section[@class='product-configurator']//div[@class='product-configurator__sku']    ui_b2c=//section[@class='product-detail']//div[@class='spacing-top spacing-top--bigger']    ui_mp_b2b=xpath=//section[@class='product-configurator']//div[@class='product-configurator__sku']    ui_mp_b2c=//section[@class='product-detail']//div[@class='spacing-top spacing-top--bigger']    ui_suite=xpath=//*[contains(@data-qa,'product-configurator')]//*[@itemprop='sku']
${pdp_shopping_list_selector}    xpath=//form[contains(@action,'shopping-list')]//select[@name='idShoppingList']
&{pdp_sales_label}    ui_b2b=xpath=//*[@class='page-info']//*[@data-qa='component label-group']//span[contains(text(),'SALE')]    ui_b2c=xpath=//*[contains(@data-qa,'product-carousel')]//*[@data-qa='component label-group']//span[contains(text(),'SALE')]    ui_mp_b2b=xpath=//*[@class='page-info']//*[@data-qa='component label-group']//span[contains(text(),'SALE')]    ui_mp_b2c=xpath=//*[contains(@data-qa,'product-carousel')]//*[@data-qa='component label-group']//span[contains(text(),'SALE')]    ui_suite=xpath=(//*[contains(@data-qa,'product-carousel')]//*[contains(@data-qa,'label')]//span[contains(.,'SALE')])[1]
&{pdp_new_label}    ui_b2b=xpath=//*[@class='page-info']//*[@data-qa='component label-group']//span[contains(text(),'New')]    ui_b2c=xpath=//*[contains(@data-qa,'product-carousel')]//*[@data-qa='component label-group']//span[contains(text(),'New')]    ui_mp_b2b=xpath=//*[@class='page-info']//*[@data-qa='component label-group']//span[contains(text(),'New')]    ui_mp_b2c=xpath=//*[contains(@data-qa,'product-carousel')]//*[@data-qa='component label-group']//span[contains(text(),'New')]    ui_suite=xpath=(//*[contains(@data-qa,'product-carousel')]//*[contains(@data-qa,'label')]//span[contains(.,'New')])[1]
${pdp_warranty_option}    xpath=//*[contains(@class,'option')]//*[contains(@class,'title')][contains(text(),'Warranty')]
${pdp_insurance_option}    xpath=//*[contains(@class,'option')]//*[contains(@class,'title')][contains(text(),'Insurance')]
&{pdp_limited_warranty_option}    ui_b2b=xpath=//*[contains(@class,'option')]//*[contains(@class,'title')][contains(text(),'limited warranty')]    ui_b2c=xpath=//*[contains(@class,'option')]//*[contains(@class,'title')][contains(text(),'limited warranty')]    ui_mp_b2b=xpath=//*[contains(@class,'option')]//*[contains(@class,'title')][contains(text(),'limited warranty')]    ui_mp_b2c=xpath=//*[contains(@class,'option')]//*[contains(@class,'title')][contains(text(),'limited warranty')]    ui_suite=xpath=//*[contains(@data-qa,'product-option')][contains(@data-qa,'warranty')]
${pdp_insurance_coverage_option}    xpath=//*[contains(@class,'option')]//*[contains(@class,'title')][contains(text(),'insurance coverage')]
&{pdp_gift_wrapping_option}    ui_b2b=xpath=//*[contains(@class,'option')]//*[contains(@class,'title')][contains(text(),'Gift wrapping')]    ui_b2c=xpath=//*[contains(@class,'option')]//*[contains(@class,'title')][contains(text(),'Gift wrapping')]    ui_mp_b2b=xpath=//*[contains(@class,'option')]//*[contains(@class,'title')][contains(text(),'Gift wrapping')]    ui_mp_b2c=xpath=//*[contains(@class,'option')]//*[contains(@class,'title')][contains(text(),'Gift wrapping')]    ui_suite=xpath=//*[contains(@data-qa,'product-option')][contains(@data-qa,'gift')]
${pdp_product_reviews_list}    xpath=//*[contains(text(),'Product Reviews')]/following-sibling::div/article[@class='review']
${pdp_product_not_available_text}    xpath=//form[@class='js-product-configurator__form-add-to-cart']//*[contains(@class,'text')][contains(text(),'This product is currently not available.')]
${pdp_availability_notification_email_field}    xpath=//input[@id='availabilityNotificationSubscriptionForm_email']
${pdp_wishlist_dropdown}    xpath=//select[contains(@name,'wishlist-name')]
${pdp_reset_selected_variant_locator}    xpath=(//div[@class='variant']//button | //div[@class='variant']//a)[1]
${pdp_back_in_stock_subscribe_button}    xpath=//form[@id='availability_notification_subscription']//button[@data-qa='submit-button']
${pdp_back_in_stock_unsubscribe_button}    xpath=//form[@id='availability_unsubscribe']//button[@type='submit']
${pdp_bazaarvoice_write_review_button}    xpath=//button[contains(@class,'bv-write-review')]
${pdp_bazaarvoice_questions_locator}    xpath=//div[@data-bv-show='questions']
${pdp_bazaarvoice_intine_rating_locator}    xpath=//section[@data-bv-show='inline_rating']
${referrer_url}    xpath=//header//form[contains(@action,'currency/switch')]//input[@name='referrer-url']
${pdp_product_name}    xpath=//h1[contains(@class,'title')]
${pdp_configure_button}    xpath=(//*[contains(@action,'product-configurator-gateway') or contains(@form-action,'product-configurator-gateway')]//button)[1]
${pdp_configuration_status}    xpath=(//span[@data-qa='component status'])[1]
&{pdp_configuration_date_time}    ui_b2b=xpath=(//*[contains(@data-qa,'collapsible-list')]//div[contains(@class,'item')][1]/*[contains(@class,'value')])[1]    ui_mp_b2b=xpath=(//*[contains(@data-qa,'collapsible-list')]//div[contains(@class,'item')][1]/*[contains(@class,'value')])[1]    ui_b2c=xpath=(//*[contains(@data-qa,'collapsible-list')]//*[contains(@class,'value')])[1]    ui_mp_b2c=xpath=(//*[contains(@data-qa,'collapsible-list')]//*[contains(@class,'value')])[1]    ui_suite=xpath=((//*[contains(@data-qa,'collapsible-list')])[1]//div)[2]
&{pdp_configuration_date}    ui_b2b=xpath=(//*[contains(@data-qa,'collapsible-list')]//div[contains(@class,'item')][2]/*[contains(@class,'value')])[1]    ui_mp_b2b=xpath=(//*[contains(@data-qa,'collapsible-list')]//div[contains(@class,'item')][2]/*[contains(@class,'value')])[1]    ui_b2c=xpath=(//*[contains(@data-qa,'collapsible-list')]//*[contains(@class,'value')])[2]    ui_mp_b2c=xpath=(//*[contains(@data-qa,'collapsible-list')]//*[contains(@class,'value')])[2]    ui_suite=xpath=((//*[contains(@data-qa,'collapsible-list')])[1]//div)[last()]