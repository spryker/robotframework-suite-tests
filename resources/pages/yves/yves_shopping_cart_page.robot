*** Variables ***
&{shopping_cart_main_content_locator}    b2b=xpath=//*[@data-qa='component cart-sidebar']    b2c=xpath=//*[@class='page-layout-cart']
${shopping_cart_checkout_button}    xpath=//div[contains(@class,'sidebar')]//a[@data-qa='cart-go-to-checkout']
${shopping_cart_request_quote_button}    xpath=//a[contains(@href,'/quote-request/create')]
${shopping_cart_upp-sell_products_section}    xpath=//main[contains(@class,'page-layout-main--cart-page')]//slick-carousel[@data-qa='component slick-carousel']
${shopping_cart_locked_cart_form}    xpath=//form[@class='cart-locking__form']
${shopping_cart_cart_title}    xpath=//*[contains(@class,'cart-title__text')]
${request_a_quote_button}    xpath=//a[contains(@class,'button')][contains(text(),'Request a Quote')]
&{shopping_cart_voucher_code_section_toggler}    b2c=//input[@id='cartCodeForm_code']//ancestor::div[@data-qa='component toggler-item']
${shopping_cart_voucher_code_field}    id=cartCodeForm_code
${shopping_cart_voucher_code_redeem_button}    xpath=//button[contains(text(),'Redeem') and contains(@data-qa,'submit')]
${shopping_cart_promotional_product_section}    xpath=(//*[contains(text(),'Promotional products')]/following-sibling::product-item)\[2\]
${shopping_cart_promotional_product_add_to_cart_button}    xpath=(//button[contains(@class,'button--promotion-item') and contains(text(),'Add to Cart')])\[2\]
${shopping_cart_promotional_product_increase_quantity_button}    xpath=//product-item[preceding-sibling::h4][2]//div[contains(@class,'button button--quantity js-quantity-counter__incr')]
${shopping_cart_promotional_product_decrease_quantity_button}    xpath=//product-item[preceding-sibling::h4][2]//div[contains(@class,'button button--quantity js-quantity-counter__decr')]

