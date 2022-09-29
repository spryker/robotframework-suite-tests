*** Variables ***
${login_page_url}    en/login
${host}    http://yves.de.spryker.local/
${adress}    en/customer/address
${checkout address}    en/checkout/address
# ${email_input_field_locator}    id=loginForm_email
# ${password_input_field_locator}    id=loginForm_password
# ${login_button_locator}    xpath=//button[normalize-space()='Login']


${add_new_address}    xpath=//a[normalize-space()='Add new address']
# ${street}    xpath=//input[@id='addressForm_address1']
# ${house_no}    xpath=//input[@id='addressForm_address2']
# ${post_code}    xpath=//input[@id='addressForm_zip_code']
# ${city}    xpath=//input[@id='addressForm_city']
# ${phone}    xpath=//input[@id='addressForm_phone']
# ${Is default shipping address}    xpath=//span[@class="checkbox__label " and text()='Is default shipping address']//parent::label//child::span[@class="checkbox__box"]
# ${Is default billing address}    xpath=//span[@class="checkbox__label " and text()='Is default billing address']//parent::label//child::span[@class="checkbox__box"]
# ${submit}    xpath=//button[normalize-space()='Submit']
${camera category}    xpath=//a[contains(@class,'navigation-multilevel-node__link navigation-multilevel-node__link--flyout navigation-multilevel-node__link--lvl-1 flyout-fullscreen')][normalize-space()='Cameras']
${digital camera}    xpath=//a[contains(@class,'navigation-multilevel-node__link navigation-multilevel-node__link--flyout navigation-multilevel-node__link--lvl-2')][normalize-space()='Digital Cameras']
${Add to cart}    xpath=//button[normalize-space()='Add to Cart']
${cart}    xpath=//cart-counter[@class='custom-element cart-counter js-navigation-top__trigger']//a//*[name()='svg']
${shipping_first_name}    xpath=//input[@id='addressesForm_shippingAddress_first_name']
${shipping_last_name}    xpath=//input[@id='addressesForm_shippingAddress_last_name']
${shipping_street}    xpath=//input[@id='addressesForm_shippingAddress_address1']
${shipping_house_no}    xpath=//input[@id='addressesForm_shippingAddress_address2']
${shipping_post_code}    xpath=//input[@id='addressesForm_shippingAddress_zip_code']
${shipping_city}    xpath=//input[@id='addressesForm_shippingAddress_city']
${shipping_phone}    xpath=//input[@id='addressesForm_shippingAddress_phone']
${Save new address to address book}    xpath=//span[@class="checkbox__label " and text()='Save new address to address book']//parent::label//child::span[@class="checkbox__box"]
${address_edit}    xpath=//a[normalize-space()='Edit']
${delete}    xpath=//button[normalize-space()='Delete']
${next}    xpath=//button[normalize-space()='Next']
${invoice}    xpath=(//span[@class='toggler-radio__box'])[2]
${Go to Summary}    xpath=//button[normalize-space()='Go to Summary']
${accept term checkbox}    xpath=(//span[@class='checkbox__box'])[1]
${submit your order}    xpath=//button[normalize-space()='Submit your order']