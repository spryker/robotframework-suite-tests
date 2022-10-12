*** Settings ***
Library    BuiltIn
Suite Setup       SuiteSetup
Suite Teardown    SuiteTeardown
Test Setup        TestSetup
Test Teardown     TestTeardown
Resource    ../../resources/common/common.robot
Resource    ../../resources/steps/header_steps.robot
Resource    ../../resources/common/common_yves.robot
Resource    ../../resources/common/common_zed.robot
Resource    ../../resources/steps/pdp_steps.robot
Resource    ../../resources/steps/shopping_lists_steps.robot
Resource    ../../resources/steps/checkout_steps.robot
Resource    ../../resources/steps/customer_registration_steps.robot
Resource    ../../resources/steps/order_history_steps.robot
Resource    ../../resources/steps/product_set_steps.robot
Resource    ../../resources/steps/catalog_steps.robot
Resource    ../../resources/steps/agent_assist_steps.robot
Resource    ../../resources/steps/company_steps.robot
Resource    ../../resources/steps/customer_account_steps.robot
Resource    ../../resources/steps/configurable_bundle_steps.robot
Resource    ../../resources/steps/zed_users_steps.robot
Resource    ../../resources/steps/products_steps.robot
Resource    ../../resources/steps/orders_management_steps.robot
Resource    ../../resources/steps/wishlist_steps.robot
Resource    ../../resources/steps/zed_availability_steps.robot
Resource    ../../resources/steps/zed_discount_steps.robot
Resource    ../../resources/steps/zed_cms_page_steps.robot

Resource    ../../resources/steps/zed_customer_steps.robot

*** Test Cases ***
# New_Customer_Registration
#     [Documentation]    Check that a new user can be registered in the system
#     Register a new customer with data:
#     ...    || salutation | first name          | last name | e-mail                         | password           ||
#     ...    || Mr.        | Test${random}       | User      |  sonia+${random}@spryker.com | Change123!${random} ||
#     Yves: flash message should be shown:    success    Almost there! We send you an email to validate your email address. Please confirm it to be able to log in.
#     [Teardown]    Zed: delete customer:
#     ...    || email                          ||
#     ...    || sonia+${random}@spryker.com ||

# Guest_User_Access_Restrictions
#     [Documentation]    Checks that guest users see products info and cart but not profile
#     Yves: header contains/doesn't contain:    true    ${currencySwitcher}[${env}]   ${wishlistIcon}    ${accountIcon}    ${shoppingCartIcon}
#     Yves: go to PDP of the product with sku:    002
#     Yves: PDP contains/doesn't contain:     true    ${pdpPriceLocator}    ${addToCartButton}
#     Yves: add product to the shopping cart
#     Yves: go to b2c shopping cart
#     Yves: shopping cart contains product with unit price:   002    Canon IXUS 160    99.99
#     Yves: go to user menu item in header:    Overview
#     Yves: 'Login' page is displayed
#     Yves: go To 'Wishlist' Page
#     Yves: 'Login' page is displayed

# Authorized_User_Access
#     [Documentation]    Checks that authorized users see products info, cart and profile
#     Yves: login on Yves with provided credentials:    ${yves_second_user_email}
#     Yves: header contains/doesn't contain:    true    ${currencySwitcher}[${env}]    ${accountIcon}     ${wishlistIcon}    ${shoppingCartIcon}
#     Yves: go to PDP of the product with sku:    002
#     Yves: PDP contains/doesn't contain:     true    ${pdpPriceLocator}     ${addToCartButton}
#     Yves: add product to the shopping cart
#     Yves: go to b2c shopping cart
#     Yves: shopping cart contains product with unit price:    002    Canon IXUS 160    99.99
#     Yves: go to user menu item in header:    Overview
#     Yves: 'Overview' page is displayed
#     Yves: go to user menu item in header:    Orders History
#     Yves: 'Order History' page is displayed
#     Yves: go To 'Wishlist' Page
#     Yves: 'Wishlist' page is displayed
#     [Teardown]    Yves: check if cart is not empty and clear it

# User_Account
#     [Documentation]    Checks user account pages work
#     Yves: login on Yves with provided credentials:    ${yves_second_user_email}
#     Yves: go to user menu item in header:    Overview
#     Yves: 'Overview' page is displayed
#     Yves: go to user menu item in header:    Orders History
#     Yves: 'Order History' page is displayed
#     Yves: go to user menu item in header:    My Profile
#     Yves: 'My Profile' page is displayed
#     Yves: go To 'Wishlist' Page
#     Yves: 'Wishlist' page is displayed
#     Yves: go to user menu item in the left bar:    Addresses
#     Yves: 'Addresses' page is displayed
#     Yves: go to user menu item in the left bar:    Newsletter
#     Yves: 'Newsletter' page is displayed
#     Yves: go to user menu item in the left bar:    Returns
#     Yves: 'Returns' page is displayed
#     Yves: create a new customer address in profile:     Mr    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany
#     Yves: go to user menu item in the left bar:    Addresses
#     Yves: 'Addresses' page is displayed
#     Yves: check that user has address exists/doesn't exist:    true    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany
#     Yves: delete user address:    Kirncher Str. ${random}
#     Yves: go to user menu item in the left bar:    Addresses
#     Yves: 'Addresses' page is displayed
#     Yves: check that user has address exists/doesn't exist:    false    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany

# Catalog
#     [Documentation]    Checks that catalog options and search work
#     Yves: perform search by:    canon
#     Yves: 'Catalog' page should show products:    30
#     Yves: select filter value:    Color    blue
#     Yves: 'Catalog' page should show products:    2
#     Yves: go to first navigation item level:    Computers
#     Yves: 'Catalog' page should show products:    72
#     Yves: page contains CMS element:    Product Slider    Top Sellers
#     Yves: page contains CMS element:    Banner    Computers
#     Yves: change sorting order on catalog page:    Sort by price ascending
#     Yves: 1st product card in catalog (not)contains:     Price    €18.79
#     Yves: change sorting order on catalog page:    Sort by price descending
#     Yves: 1st product card in catalog (not)contains:      Price    €3,456.99
#     Yves: go to catalog page:    2
#     Yves: catalog page contains filter:    Price    Ratings     Label     Brand    Color
#     Yves: select filter value:    Color    blue
#     Yves: 'Catalog' page should show products:    2
#     [Teardown]    Yves: check if cart is not empty and clear it

# Catalog_Actions
#     [Documentation]    Checks quick add to cart and product groups
#     Yves: perform search by:    NEX-VG20EH
#     Yves: 1st product card in catalog (not)contains:      Add to Cart    true
#     Yves: quick add to cart for first item in catalog
#     Yves: perform search by:    115
#     Yves: 1st product card in catalog (not)contains:     Add to Cart    false
#     Yves: perform search by:    002
#     Yves: 1st product card in catalog (not)contains:      Add to Cart    true
#     Yves: 1st product card in catalog (not)contains:      Color selector   true
#     Yves: select product color:    black
#     Yves: quick add to cart for first item in catalog
#     Yves: go to b2c shopping cart
#     Yves: shopping cart contains the following products:    NEX-VG20EH    Canon IXUS 160
#     [Teardown]    Yves: check if cart is not empty and clear it

# Product_labels
#     [Documentation]    Checks that products have labels on PLP and PDP
#     Yves: go to first navigation item level:    Sale
#     Yves: 1st product card in catalog (not)contains:     Sale label    true
#     Yves: go to the PDP of the first available product on open catalog page
#     Yves: PDP contains/doesn't contain:    true    ${pdp_sales_label}[${env}]
#     Yves: go to first navigation item level:    New
#     Yves: 1st product card in catalog (not)contains:     New label    true
#     Yves: go to PDP of the product with sku:    666
#     Yves: PDP contains/doesn't contain:    true    ${pdp_new_label}[${env}]
#     [Teardown]    Yves: check if cart is not empty and clear it

# Product_PDP
#     [Documentation]    Checks that PDP contains required elements
#     Yves: go to PDP of the product with sku:    135
#     Yves: change variant of the product on PDP on:    Flash
#     Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}   ${addToCartButton}    ${pdp_warranty_option}    ${pdp_gift_wrapping_option}    ${relatedProducts}
#     Yves: PDP contains/doesn't contain:    false    ${pdp_add_to_wishlist_button}
#     Yves: login on Yves with provided credentials:    ${yves_user_email}
#     Yves: go to PDP of the product with sku:    135
#     Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}   ${pdp_add_to_cart_disabled_button}[${env}]    ${pdp_warranty_option}    ${pdp_gift_wrapping_option}     ${pdp_add_to_wishlist_button}    ${relatedProducts}
#     Yves: change variant of the product on PDP on:    Flash
#     Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}    ${addToCartButton}    ${pdp_warranty_option}    ${pdp_gift_wrapping_option}     ${pdp_add_to_wishlist_button}    ${relatedProducts}

# Volume_Prices
#     [Documentation]    Checks volume prices are applied
#     Yves: login on Yves with provided credentials:    ${yves_user_email}
#     Yves: go to PDP of the product with sku:    193
#     Yves: change quantity on PDP:    5
#     Yves: add product to the shopping cart
#     Yves: go to b2c shopping cart
#     Yves: shopping cart contains product with unit price:    193    Sony FDR-AX40    825.00
#     Yves: delete from b2c cart products with name:    Sony FDR-AX40
#     [Teardown]    Yves: check if cart is not empty and clear it

# Discontinued_Alternative_Products
#     [Documentation]    Checks discontinued and alternative products
#     Yves: go to PDP of the product with sku:    ${product_with_relations_alternative_products_sku}
#     Yves: change variant of the product on PDP on:    2.3 GHz - Discontinued
#     Yves: PDP contains/doesn't contain:    true    ${alternativeProducts}
#     Yves: login on Yves with provided credentials:    ${yves_user_email}
#     Yves: delete all wishlists
#     Yves: go to the PDP of the first available product
#     Yves: add product to wishlist:    My wishlist
#     Yves: get sku of the concrete product on PDP
#     Yves: get sku of the abstract product on PDP
#     Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     Zed: discontinue the following product:    ${got_abstract_product_sku}    ${got_concrete_product_sku}
#     Zed: product is successfully discontinued
#     Zed: check if at least one price exists for concrete and add if doesn't:    100
#     Zed: add following alternative products to the concrete:    012
#     Yves: login on Yves with provided credentials:    ${yves_user_email}
#     Yves: go To 'Wishlist' Page
#     Yves: go to wishlist with name:    My wishlist
#     Yves: product with sku is marked as discountinued in wishlist:    ${got_concrete_product_sku}
#     Yves: product with sku is marked as alternative in wishlist:    012
#     [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}    
#     ...    AND    Yves: check if cart is not empty and clear it
#     ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     ...    AND    Zed: undo discontinue the following product:    ${got_abstract_product_sku}    ${got_concrete_product_sku}

# Back_in_Stock_Notification
#     [Documentation]    Back in stock notification is sent and availability check
#     [Setup]    Run keywords    Yves: go to the 'Home' page
#     ...    AND    Yves: go to the PDP of the first available product
#     ...    AND    Yves: get sku of the concrete product on PDP
#     ...    AND    Yves: get sku of the abstract product on PDP
#     Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     Zed: go to second navigation item level:    Catalog    Availability
#     Zed: check if product is/not in stock:    ${got_abstract_product_sku}    true
#     Zed: change product stock:    ${got_abstract_product_sku}    ${got_concrete_product_sku}    false    0
#     Zed: go to second navigation item level:    Catalog    Availability
#     Zed: check if product is/not in stock:    ${got_abstract_product_sku}    false
#     Yves: login on Yves with provided credentials:    ${yves_second_user_email}
#     Yves: go to PDP of the product with sku:  ${got_abstract_product_sku}
#     Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
#     Yves: check if product is available on PDP:    ${got_abstract_product_sku}    false
#     Yves: submit back in stock notification request for email:    ${yves_second_user_email}
#     Yves: unsubscribe from availability notifications
#     Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     Zed: go to second navigation item level:    Catalog    Availability
#     Zed: change product stock:    ${got_abstract_product_sku}    ${got_concrete_product_sku}    true    0
#     Zed: go to second navigation item level:    Catalog    Availability
#     Zed: check if product is/not in stock:    ${got_abstract_product_sku}    true
#     Yves: login on Yves with provided credentials:    ${yves_second_user_email}
#     Yves: go to PDP of the product with sku:  ${got_abstract_product_sku}
#     Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
#     Yves: check if product is available on PDP:    ${got_abstract_product_sku}    true
#     [Teardown]    Zed: check and restore product availability in Zed:    ${got_abstract_product_sku}    Available    ${got_concrete_product_sku}

# Add_to_Wishlist
#     [Documentation]    Check creation of wishlist and adding to different wishlists
#     Yves: login on Yves with provided credentials:    ${yves_user_email}
#     Yves: delete all wishlists
#     Yves: go to PDP of the product with sku:  003
#     Yves: add product to wishlist:    My wishlist
#     Yves: go To 'Wishlist' Page
#     Yves: create wishlist with name:    Second wishlist
#     Yves: go to PDP of the product with sku:  004
#     Yves: add product to wishlist:    Second wishlist    select
#     Yves: go To 'Wishlist' Page
#     Yves: go to wishlist with name:    My wishlist
#     Yves: wishlist contains product with sku:    003_26138343
#     Yves: go to wishlist with name:    Second wishlist
#     Yves: wishlist contains product with sku:    004_30663302
#     [Teardown]    Run keywords    Yves: delete all wishlists    AND    Yves: check if cart is not empty and clear it

# Product_Sets
#     [Documentation]    Check the usage of product sets
#     Yves: login on Yves with provided credentials:    ${yves_user_email}
#     Yves: go to URL:    en/product-sets
#     Yves: 'Product Sets' page contains the following sets:    HP Product Set    Sony Product Set    Upgrade your running game
#     Yves: view the following Product Set:    Upgrade your running game
#     Yves: 'Product Set' page contains the following products:    TomTom Golf    Samsung Galaxy S6 edge
#     Yves: change variant of the product on CMS page on:    Samsung Galaxy S6 edge    128 GB
#     Yves: add all products to the shopping cart from Product Set
#     Yves: go to b2c shopping cart
#     Yves: shopping cart contains the following products:    TomTom Golf    Samsung Galaxy S6 edge
#     Yves: delete from b2c cart products with name:    TomTom Golf    Samsung Galaxy S6 edge
#     [Teardown]    Yves: check if cart is not empty and clear it

# Product_Bundles
#     [Documentation]    Checks checkout with Bundle product
#     [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     ...    AND    Zed: change product stock:    ${bundled_product_1_abstract_sku}    ${bundled_product_1_concrete_sku}    true    10
#     ...    AND    Zed: change product stock:    ${bundled_product_2_abstract_sku}    ${bundled_product_2_concrete_sku}    true    10
#     ...    AND    Zed: change product stock:    ${bundled_product_3_abstract_sku}    ${bundled_product_3_concrete_sku}    true    10
#     Yves: login on Yves with provided credentials:    ${yves_user_email}
#     Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
#     #Fails due to bug CC-16679
#     Yves: PDP contains/doesn't contain:    true    ${bundleItemsSmall}    ${bundleItemsLarge}
#     Yves: add product to the shopping cart
#     Yves: go to b2c shopping cart
#     Yves: shopping cart contains the following products:    ${bundle_product_product_name}
#     Yves: click on the 'Checkout' button in the shopping cart
#     Yves: billing address same as shipping address:    true
#     Yves: fill in the following new shipping address:
#     ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
#     ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
#     Yves: submit form on the checkout
#     Yves: select the following shipping method on the checkout and go next:    Express
#     Yves: select the following payment method on the checkout and go next:    Invoice
#     Yves: accept the terms and conditions:    true
#     Yves: 'submit the order' on the summary page
#     Yves: 'Thank you' page is displayed
#     [Teardown]    Yves: check if cart is not empty and clear it

# Configurable_Bundle
#     [Documentation]    Check the usage of configurable bundles (includes authorized checkout)
#     Yves: login on Yves with provided credentials:    ${yves_user_email}
#     Yves: check if cart is not empty and clear it
#     Yves: go to URL:    en/configurable-bundle/configurator/template-selection
#     Yves: 'Choose Bundle to configure' page is displayed
#     Yves: choose bundle template to configure:    Smartstation Kit
#     Yves: select product in the bundle slot:    Slot 5    Sony Cyber-shot DSC-W830
#     Yves: select product in the bundle slot:    Slot 6    Sony NEX-VG30E
#     Yves: go to 'Summary' step in the bundle configurator
#     Yves: add products to the shopping cart in the bundle configurator
#     Yves: go to URL:    en/configurable-bundle/configurator/template-selection
#     Yves: 'Choose Bundle to configure' page is displayed
#     Yves: choose bundle template to configure:    Smartstation Kit
#     Yves: select product in the bundle slot:    Slot 5    Canon IXUS 165
#     Yves: select product in the bundle slot:    Slot 6    Sony HDR-MV1
#     Yves: go to 'Summary' step in the bundle configurator
#     Yves: add products to the shopping cart in the bundle configurator
#     Yves: go to b2c shopping cart
#     Yves: change quantity of the configurable bundle in the shopping cart on:    Smartstation Kit    2
#     Yves: click on the 'Checkout' button in the shopping cart
#     Yves: billing address same as shipping address:    true
#     Yves: fill in the following new shipping address:
#     ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
#     ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
#     Yves: submit form on the checkout
#     Yves: select the following shipping method on the checkout and go next:    Express
#     Yves: select the following payment method on the checkout and go next:    Invoice
#     Yves: accept the terms and conditions:    true
#     Yves: 'submit the order' on the summary page
#     Yves: 'Thank you' page is displayed
#     Yves: go to user menu item in header:    Orders History
#     Yves: 'Order History' page is displayed
#     Yves: get the last placed order ID by current customer
#     Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
#     Yves: 'View Order' page is displayed
#     Yves: 'Order Details' page contains the following product title N times:    Smartstation Kit    3
#     [Teardown]    Yves: check if cart is not empty and clear it

# Discounts
#     [Documentation]    Discounts, Promo Products, and Coupon Codes (includes guest checkout)
#     [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     ...    AND    Zed: deactivate following discounts from Overview page:    Free Acer Notebook    Tu & Wed $5 off 5 or more    10% off $100+    Free smartphone    20% off cameras    Free Acer M2610    Free standard delivery    10% off Intel Core    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order
#     ...    AND    Zed: change product stock:    190    190_25111746    true    10
#     Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     Zed: go to second navigation item level:    Merchandising    Discount
#     Zed: create a discount and activate it:    voucher    Percentage    5    sku = '*'    test${random}    discountName=Voucher Code 5% ${random}
#     Zed: create a discount and activate it:    cart rule    Percentage    10    sku = '*'    discountName=Cart Rule 10% ${random}
#     Zed: create a discount and activate it:    cart rule    Percentage    100    discountName=Promotional Product 100% ${random}    promotionalProductDiscount=True    promotionalProductAbstractSku=002    promotionalProductQuantity=2
#     Yves: login on Yves with provided credentials:    ${yves_user_email}
#     Yves: check if cart is not empty and clear it
#     Yves: go to PDP of the product with sku:    190
#     Yves: add product to the shopping cart
#     Yves: go to b2c shopping cart
#     Yves: apply discount voucher to cart:    test${random}
#     Yves: discount is applied:    voucher    Voucher Code 5% ${random}    - €8.73
#     Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €17.46
#     Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
#     Yves: add product to the shopping cart
#     Yves: go to b2c shopping cart
#     Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €87.96
#     Yves: promotional product offer is/not shown in cart:    true
#     Yves: change quantity of promotional product and add to cart:    +    1
#     Yves: shopping cart contains the following products:    Kodak EasyShare M532    Canon IXUS 160
#     Yves: discount is applied:    cart rule    Promotional Product 100% ${random}    - €199.98
#     Yves: click on the 'Checkout' button in the shopping cart
#     Yves: billing address same as shipping address:    true
#     Yves: fill in the following new shipping address:
#     ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
#     ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
#     Yves: submit form on the checkout
#     Yves: select the following shipping method on the checkout and go next:    Express
#     Yves: select the following payment method on the checkout and go next:    Invoice
#     Yves: accept the terms and conditions:    true
#     Yves: 'submit the order' on the summary page
#     Yves: 'Thank you' page is displayed
#     Yves: get the last placed order ID by current customer
#     Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     Zed: grand total for the order equals:    ${lastPlacedOrder}    €753.55
#     [Teardown]    Run keywords    Yves: check if cart is not empty and clear it
#     ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     ...    AND    Zed: deactivate following discounts from Overview page:    Voucher Code 5% ${random}    Cart Rule 10% ${random}    Promotional Product 100% ${random}
#     ...    AND    Zed: activate following discounts from Overview page:    Free Acer Notebook    Tu & Wed $5 off 5 or more    10% off $100+    Free smartphone    20% off cameras    Free Acer M2610    Free standard delivery    10% off Intel Core    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order

# Split_Delivery
#     [Documentation]    Checks split delivery in checkout
#     Yves: login on Yves with provided credentials:    ${yves_user_email}
#     Yves: check if cart is not empty and clear it
#     Yves: go to PDP of the product with sku:    007
#     Yves: add product to the shopping cart
#     Yves: go to PDP of the product with sku:    005
#     Yves: add product to the shopping cart
#     Yves: go to PDP of the product with sku:    012
#     Yves: add product to the shopping cart
#     Yves: go to b2c shopping cart
#     Yves: click on the 'Checkout' button in the shopping cart
#     Yves: select delivery to multiple addresses
#     Yves: fill in new delivery address for a product:
#     ...    || product        | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
#     ...    || Canon IXUS 285 | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
#    Yves: fill in new delivery address for a product:
#     ...    || product        | salutation | firstName | lastName | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
#     ...    || Canon IXUS 175 | Dr.        | First     | Last     | Second Street | 2           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
#    Yves: fill in new delivery address for a product:
#     ...    || product        | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
#     ...    || Canon IXUS 165 | Dr.        | First     | Last     | Third Street | 3           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
#     Yves: fill in the following new billing address:
#     ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
#     ...    || Mr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
#     Yves: submit form on the checkout
#     Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
#     Yves: select the following shipping method for the shipment:    2    Hermes    Same Day
#     Yves: select the following shipping method for the shipment:    3    DHL    Express
#     Yves: submit form on the checkout
#     Yves: select the following payment method on the checkout and go next:    Invoice
#     Yves: accept the terms and conditions:    true
#     Yves: 'submit the order' on the summary page
#     Yves: 'Thank you' page is displayed
#     [Teardown]    Yves: check if cart is not empty and clear it

# Agent_Assist
#     [Documentation]    Checks that agent can be used
#     Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     Zed: create new Zed user with the following data:    agent+${random}@spryker.com    change${random}    Agent    Assist    Root group    This user is an agent    en_US
#     Yves: go to the 'Home' page
#     Yves: go to URL:    agent/login
#     Yves: login on Yves with provided credentials:    agent+${random}@spryker.com    change${random}
#     Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
#     Yves: perform search by customer:    ${yves_user_first_name}
#     Yves: agent widget contains:    ${yves_user_email}
#     Yves: As an Agent login under the customer:    ${yves_user_email}
#     Yves: perform search by:    031
#     Yves: product with name in the catalog should have price:    Canon PowerShot G9 X    €400.24
#     Yves: go to PDP of the product with sku:    031
#     Yves: product price on the PDP should be:    €400.24
#     [Teardown]    Run Keywords    Yves: check if cart is not empty and clear it
#     ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     ...    AND    Zed: delete Zed user with the following email:    agent+${random}@spryker.com

# Return_Management
#     [Documentation]    Checks that returns work and oms process is checked
#     Yves: login on Yves with provided credentials:    ${yves_user_email}
#     Yves: check if cart is not empty and clear it
#     Yves: go to PDP of the product with sku:    007
#     Yves: add product to the shopping cart
#     Yves: go to PDP of the product with sku:    008
#     Yves: add product to the shopping cart
#     Yves: go to PDP of the product with sku:    010
#     Yves: add product to the shopping cart
#     Yves: go to b2c shopping cart
#     Yves: click on the 'Checkout' button in the shopping cart
#     Yves: billing address same as shipping address:    true
#     Yves: fill in the following new shipping address:
#     ...    || salutation | firstName | lastName | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
#     ...    || Mr.        | Guest     | User     | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
#     Yves: submit form on the checkout
#     Yves: select the following shipping method on the checkout and go next:    Express
#     Yves: select the following payment method on the checkout and go next:    Invoice
#     Yves: accept the terms and conditions:    true
#     Yves: 'submit the order' on the summary page
#     Yves: 'Thank you' page is displayed
#     Yves: get the last placed order ID by current customer
#     Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
#     Zed: trigger all matching states inside this order:    Skip timeout
#     Zed: trigger all matching states inside this order:    Ship
#     Yves: login on Yves with provided credentials:    ${yves_user_email}
#     Yves: go to user menu item in header:    Orders History
#     Yves: 'Order History' page is displayed
#     Yves: get the last placed order ID by current customer
#     Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
#     Yves: 'Create Return' page is displayed
#     Yves: create return for the following products:    010_30692994
#     Yves: 'Return Details' page is displayed
#     Yves: check that 'Print Slip' contains the following products:    010_30692994
#     Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     Zed: create a return for the following order and product in it:    ${lastPlacedOrder}    007_30691822
#     Zed: create new Zed user with the following data:    returnagent+${random}@spryker.com    change123${random}    Agent    Assist    Root group    This user is an agent    en_US
#     Yves: go to the 'Home' page
#     Yves: logout on Yves as a customer
#     Yves: go to URL:    agent/login
#     Yves: login on Yves with provided credentials:    returnagent+${random}@spryker.com    change123${random}
#     Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
#     Yves: perform search by customer:    ${yves_user_email}
#     Yves: agent widget contains:    ${yves_user_email}
#     Yves: As an Agent login under the customer:    ${yves_user_email}
#     Yves: go to user menu item in header:    Orders History
#     Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
#     Yves: 'Create Return' page is displayed
#     Yves: create return for the following products:    008_30692992
#     Yves: 'Return Details' page is displayed
#     Yves: check that 'Print Slip' contains the following products:    008_30692992
#     Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Execute return
#     Yves: login on Yves with provided credentials:    ${yves_user_email}
#     Yves: go to user menu item in header:    Orders History
#     Yves: 'Order History' page is displayed
#     Yves: 'Order History' page contains the following order with a status:    ${lastPlacedOrder}    Returned
#     [Teardown]    Run Keywords    Yves: check if cart is not empty and clear it
#     ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     ...    AND    Zed: delete Zed user with the following email:    returnagent+${random}@spryker.com

# Content_Management
#     [Documentation]    Checks cms content can be edited in zed and that correct cms elements are present on homepage
#     Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     Zed: go to second navigation item level:    Content    Pages
#     Zed: create a cms page and publish it:    Test Page${random}    test-page${random}    Page Title    Page text
#     Yves: go to the 'Home' page
#     Yves: page contains CMS element:    Homepage Banners
#     Yves: page contains CMS element:    Product Slider    Top Sellers
#     Yves: page contains CMS element:    Homepage Inspirational block
#     Yves: page contains CMS element:    Homepage Banner Video
#     Yves: page contains CMS element:    Footer section
#     Yves: go to newly created page by URL:    en/test-page${random}
#     Yves: page contains CMS element:    CMS Page Title    Page Title
#     Yves: page contains CMS element:    CMS Page Content    Page text

# Product_Relations
#     [Documentation]    Checks related product on PDP and upsell products in cart
#     Yves: login on Yves with provided credentials:    ${yves_user_email}
#     Yves: go to PDP of the product with sku:    ${product_with_relations_related_products_sku}
#     Yves: PDP contains/doesn't contain:    true    ${relatedProducts}
#     Yves: go to PDP of the product with sku:    ${product_with_relations_upselling_sku}
#     Yves: PDP contains/doesn't contain:    false    ${relatedProducts}
#     Yves: add product to the shopping cart
#     Yves: go to b2c shopping cart
#     Yves: shopping cart contains/doesn't contain the following elements:    true    ${upSellProducts}
#     [Teardown]    Yves: check if cart is not empty and clear it

# Guest_Checkout
#     [Documentation]    Guest checkout with bundles, discounts and OMS
#     [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     ...    AND    Zed: change product stock:    ${bundled_product_1_abstract_sku}    ${bundled_product_1_concrete_sku}    true    10
#     ...    AND    Zed: change product stock:    ${bundled_product_2_abstract_sku}    ${bundled_product_2_concrete_sku}    true    10
#     ...    AND    Zed: change product stock:    ${bundled_product_3_abstract_sku}    ${bundled_product_3_concrete_sku}    true    10
#     ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     ...    AND    Zed: go to second navigation item level:    Merchandising    Discount
#     ...    AND    Zed: create a discount and activate it:    voucher    Percentage    5    sku = '*'    guestTest${random}    discountName=Guest Voucher Code 5% ${random}
#     ...    AND    Zed: create a discount and activate it:    cart rule    Percentage    10    sku = '*'    discountName=Guest Cart Rule 10% ${random}
#     Yves: go to the 'Home' page
#     Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
#     #Fails due to bug CC-16679
#     Yves: PDP contains/doesn't contain:    true    ${bundleItemsSmall}    ${bundleItemsLarge}
#     Yves: add product to the shopping cart
#     Yves: go to URL:    en/configurable-bundle/configurator/template-selection
#     Yves: 'Choose Bundle to configure' page is displayed
#     Yves: choose bundle template to configure:    Smartstation Kit
#     Yves: select product in the bundle slot:    Slot 5    Sony Cyber-shot DSC-W830
#     Yves: select product in the bundle slot:    Slot 6    Sony NEX-VG30E
#     Yves: go to 'Summary' step in the bundle configurator
#     Yves: add products to the shopping cart in the bundle configurator
#     Yves: go to PDP of the product with sku:    007
#     Yves: add product to the shopping cart
#     Yves: go to PDP of the product with sku:    008
#     Yves: add product to the shopping cart
#     Yves: go to b2c shopping cart
#     Yves: apply discount voucher to cart:    guestTest${random}
#     Yves: shopping cart contains the following products:    ${bundle_product_product_name}
#     Yves: click on the 'Checkout' button in the shopping cart
#     Yves: proceed with checkout as guest:    Mr    Guest    user    guest+${random}@user.com
#     Yves: billing address same as shipping address:    true
#     Yves: fill in the following new shipping address:
#     ...    || salutation | firstName | lastName | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
#     ...    || Mr.        | Guest     | User     | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
#     Yves: submit form on the checkout
#     Yves: select the following shipping method on the checkout and go next:    Express
#     Yves: select the following payment method on the checkout and go next:    Invoice
#     Yves: accept the terms and conditions:    true
#     Yves: 'submit the order' on the summary page
#     Yves: 'Thank you' page is displayed
#     Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     Zed: get the last placed order ID of the customer by email:    guest+${random}@user.com
#     Zed: trigger all matching states inside xxx order:    ${zedLastPlacedOrder}    Pay
#     Zed: trigger all matching states inside this order:    Skip timeout
#     Zed: trigger all matching states inside this order:    Ship
#     Zed: trigger all matching states inside this order:    Stock update
#     Zed: trigger all matching states inside this order:    Close
#     [Teardown]    Run keywords    Yves: check if cart is not empty and clear it
#     ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     ...    AND    Zed: deactivate following discounts from Overview page:    Guest Voucher Code 5% ${random}    Guest Cart Rule 10% ${random}

# Refunds
#     [Documentation]    Checks that refund can be created for one item and the whole order
#     [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     ...    AND    Zed: deactivate following discounts from Overview page:    Tu & Wed $5 off 5 or more    10% off $100+    20% off cameras    Tu & Wed €5 off 5 or more    10% off minimum order
#     Yves: login on Yves with provided credentials:    ${yves_user_email}
#     Yves: check if cart is not empty and clear it
#     Yves: go to PDP of the product with sku:    007
#     Yves: add product to the shopping cart
#     Yves: go to PDP of the product with sku:    008
#     Yves: add product to the shopping cart
#     Yves: go to PDP of the product with sku:    010
#     Yves: add product to the shopping cart
#     Yves: go to b2c shopping cart
#     Yves: click on the 'Checkout' button in the shopping cart
#     Yves: billing address same as shipping address:    true
#     Yves: fill in the following new shipping address:
#     ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
#     ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
#     Yves: submit form on the checkout
#     Yves: select the following shipping method on the checkout and go next:    Express
#     Yves: select the following payment method on the checkout and go next:    Invoice
#     Yves: accept the terms and conditions:    true
#     Yves: 'submit the order' on the summary page
#     Yves: 'Thank you' page is displayed
#     Yves: get the last placed order ID by current customer
#     Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,041.90
#     Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
#     Zed: trigger all matching states inside this order:    Skip timeout
#     Zed: trigger matching state of order item inside xxx shipment:    008_30692992    Ship
#     Zed: trigger matching state of order item inside xxx shipment:    008_30692992    Stock update
#     Zed: trigger matching state of order item inside xxx shipment:    008_30692992    Refund
#     Zed: grand total for the order equals:    ${lastPlacedOrder}    €696.90
#     Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Ship
#     Zed: trigger all matching states inside this order:    Stock update
#     Zed: trigger all matching states inside this order:    Refund
#     Zed: grand total for the order equals:    ${lastPlacedOrder}    €0.00
#     [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     ...    AND    Zed: activate following discounts from Overview page:    Tu & Wed $5 off 5 or more    10% off $100+    20% off cameras    Tu & Wed €5 off 5 or more    10% off minimum order

Add_to_cart_products_as_a_guest_user_and_login_during_checkout
    Yves: go to the 'Home' page
    Yves: go to PDP of the product with sku:    ${bundled_product_3_concrete_sku}
    Yves: add a product to cart on clicking add to cart button on PDP
    Yves: go to b2c shopping cart  
    Yves: click on the 'Checkout' button in the shopping cart
     Yves: proceed as a guest user and login during checkout:   ${yves_second_user_email}
     Yves: fill in the following new shipping address:
     ...    || salutation     | firstName                    | lastName                    | street        | houseNumber       | postCode     | city       | country     | company    | phone           | additionalAddress     ||
    ...    || ${Salutation}  | ${Guest_user_first_name}     | ${Guest_user_last_name}     | ${random}     | ${random}         | ${random}    | ${city}    | ${country}  | ${company} | ${random} | ${additional_address} ||
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Add_to_cart_products_as_a_guest_user_and_register_during_checkout
    Yves: go to the 'Home' page
    Yves: go to PDP of the product with sku:    ${bundled_product_3_concrete_sku}
    Yves: add a product to cart on clicking add to cart button on PDP
    Page Should Not Contain Element    ${pdp_add_to_wishlist_button}
    Yves: go to b2c shopping cart  
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: signup guest user during checkout:    ${Guest_user_first_name}    ${Guest_user_last_name}    abc${random}@gmail.com    Abc#${random}    Abc#${random}
    Save the result of a SELECT DB query to a variable:    select registration_key from spy_customer where email = 'abc${random}@gmail.com'    confirmation_key
    I send a POST request:     /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"${confirmation_key}"}}}
    Yves: login after signup during checkout:    abc${random}@gmail.com    Abc#${random}
    Yves: fill in the following new shipping address:
    ...    || salutation     | firstName                    | lastName                    | street        | houseNumber       | postCode     | city       | country     | company    | phone           | additionalAddress     ||
    ...    || ${Salutation}  | ${Guest_user_first_name}     | ${Guest_user_last_name}     | ${random}     | ${random}         | ${random}    | ${city}    | ${country}  | ${company} | ${random} | ${additional_address} ||
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:    ${bundled_product_3_concrete_sku}
    Delete All Cookies
    Yves: Add product to wishlist as guest user
     [Teardown]    Zed: delete customer:
    ...    || email                          ||
    ...    || abc${random}@gmail.com ||