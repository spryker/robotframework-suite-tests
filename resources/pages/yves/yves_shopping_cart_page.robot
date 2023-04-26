*** Variables ***
&{shopping_cart_main_content_locator}    ui_b2b=xpath=//*[@data-qa='component cart-sidebar']    ui_b2c=xpath=//*[@class='page-layout-cart']    ui_mp_b2b=xpath=//*[@data-qa='component cart-sidebar']    ui_mp_b2c=xpath=//*[@class='page-layout-cart']
${shopping_cart_checkout_button}    xpath=//main//a[@data-qa='cart-go-to-checkout']
${shopping_cart_request_quote_button}    xpath=//a[contains(@href,'/quote-request/create')]
&{shopping_cart_upp-sell_products_section}    ui_b2b=xpath=//main[contains(@class,'cart')]//slick-carousel[@data-qa='component slick-carousel']    ui_b2c=xpath=//div[contains(@data-qa,'component extra-product')]    ui_mp_b2b=xpath=//main[contains(@class,'cart')]//slick-carousel[@data-qa='component slick-carousel']    ui_mp_b2c=xpath=//main[contains(@class,'cart')]//slick-carousel[@data-qa='component slick-carousel']
${shopping_cart_locked_cart_form}    xpath=//form[@class='cart-locking__form']
${shopping_cart_cart_title}    xpath=//*[contains(@class,'cart-title__text')]
${request_a_quote_button}    xpath=//a[contains(@class,'button')][contains(text(),'Request a Quote')]
${shopping_cart_voucher_code_section_toggler}    xpath=//input[@id='cartCodeForm_code']//ancestor::div[@data-qa='component toggler-item']
${shopping_cart_voucher_code_field}    id=cartCodeForm_code
${shopping_cart_voucher_code_redeem_button}    xpath=//button[contains(text(),'Redeem') and contains(@data-qa,'submit')]
${shopping_cart_promotional_product_section}    xpath=//product-item[contains(@data-qa,'component product-item')]
${shopping_cart_promotional_product_add_to_cart_button}    xpath=//product-item[contains(@data-qa,'component product-item')]//form[contains(@name,'addToCartForm')]//button[@data-init-single-click]
&{shopping_cart_promotional_product_increase_quantity_button}    ui_b2c=xpath=//product-item[contains(@data-qa,'component product-item')]//quantity-counter//div[contains(@class,'button button--quantity js-quantity-counter__incr')]    ui_b2b=xpath=//product-item[contains(@data-qa,'component product-item')]//quantity-counter/button[contains(@class,'increment')]    ui_mp_b2b=xpath=//product-item[contains(@data-qa,'component product-item')]//quantity-counter/button[contains(@class,'increment')]    ui_mp_b2c=xpath=//product-item[contains(@data-qa,'component product-item')]//quantity-counter//div[contains(@class,'js-quantity-counter__incr')]
&{shopping_cart_promotional_product_decrease_quantity_button}    ui_b2c=xpath=//product-item[contains(@data-qa,'component product-item')]//quantity-counter//div[contains(@class,'button button--quantity js-quantity-counter__decr')]    ui_b2b=xpath=//product-item[contains(@data-qa,'component product-item')]//quantity-counter/button[contains(@class,'decrement')]    ui_mp_b2b=xpath=//product-item[contains(@data-qa,'component product-item')]//quantity-counter/button[contains(@class,'decrement')]    ui_mp_b2c=xpath=//product-item[contains(@data-qa,'component product-item')]//quantity-counter//div[contains(@class,'js-quantity-counter__decr')]
&{shopping_cart_surcharge_amount}    ui_b2c=xpath=//div[@data-qa='component cart-summary']//li[contains(text(),'Surcharge')]//span    ui_b2b=xpath=//div[@data-qa='component cart-summary']//li//div[contains(text(),'Surcharge')]/following-sibling::div    ui_mp_b2b=xpath=//div[@data-qa='component cart-summary']//li//div[contains(text(),'Surcharge')]/following-sibling::div    ui_mp_b2c=xpath=//div[@data-qa='component cart-summary']//li[contains(text(),'Surcharge')]//span
${shopping_cart_write_comment_placeholder}    xpath=//div[@data-qa='component add-comment-form']//form[@method='POST']/textarea
${shopping_cart_add_comment_button}    xpath=//button[contains(@class,"js-add-comment-form__button")]
${shopping_cart_edit_comment_button}    xpath=//button[contains(@class,"button--hollow-icon-small") and not (contains(@class,"js-comment-form__remove-button"))]
${shopping_cart_edit_comment_placeholder}    xpath=//comment-form[@data-qa='component comment-form']//form[@method='POST']//textarea
${shopping_cart_update_comment_button}    xpath=//button[contains(@action,"/comment/update")]
${shopping_cart_remove_comment_button}    xpath=//button[contains(@action,"/comment/remove")]
${shopping_cart_checkout_error_message_locator}    xpath=//div[@data-qa='component cart-summary']//div[@class='spacing-top']