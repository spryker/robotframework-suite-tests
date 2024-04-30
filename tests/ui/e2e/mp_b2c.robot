*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure
Resource    ../../../resources/common/common.robot
Resource    ../../../resources/steps/header_steps.robot
Resource    ../../../resources/common/common_yves.robot
Resource    ../../../resources/common/common_zed.robot
Resource    ../../../resources/steps/pdp_steps.robot
Resource    ../../../resources/steps/shopping_lists_steps.robot
Resource    ../../../resources/steps/checkout_steps.robot
Resource    ../../../resources/steps/customer_registration_steps.robot
Resource    ../../../resources/steps/order_history_steps.robot
Resource    ../../../resources/steps/product_set_steps.robot
Resource    ../../../resources/steps/catalog_steps.robot
Resource    ../../../resources/steps/agent_assist_steps.robot
Resource    ../../../resources/steps/company_steps.robot
Resource    ../../../resources/steps/customer_account_steps.robot
Resource    ../../../resources/steps/configurable_bundle_steps.robot
Resource    ../../../resources/steps/zed_users_steps.robot
Resource    ../../../resources/steps/products_steps.robot
Resource    ../../../resources/steps/orders_management_steps.robot
Resource    ../../../resources/steps/wishlist_steps.robot
Resource    ../../../resources/steps/zed_availability_steps.robot
Resource    ../../../resources/steps/zed_discount_steps.robot
Resource    ../../../resources/steps/zed_cms_page_steps.robot
Resource    ../../../resources/steps/zed_cms_block_steps.robot
Resource    ../../../resources/steps/zed_customer_steps.robot
Resource    ../../../resources/steps/merchant_profile_steps.robot
Resource    ../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../resources/steps/mp_profile_steps.robot
Resource    ../../../resources/steps/mp_orders_steps.robot
Resource    ../../../resources/steps/mp_offers_steps.robot
Resource    ../../../resources/steps/mp_products_steps.robot
Resource    ../../../resources/steps/mp_account_steps.robot
Resource    ../../../resources/steps/mp_dashboard_steps.robot
Resource    ../../../resources/steps/zed_root_menus_steps.robot
Resource    ../../../resources/steps/minimum_order_value_steps.robot
Resource    ../../../resources/steps/availability_steps.robot
Resource    ../../../resources/steps/glossary_steps.robot
Resource    ../../../resources/steps/configurable_product_steps.robot
Resource    ../../../resources/steps/dynamic_entity_steps.robot
Resource    ../../../resources/common/common_api.robot
Resource    ../../../resources/steps/service_point_steps.robot
Resource    ../../../resources/steps/warehouse_user_assigment_steps.robot
Resource    ../../../resources/steps/picking_list_steps.robot
Resource    ../../../resources/steps/zed_store_steps.robot    
Default Tags    bapi

*** Test Cases ***
New_Customer_Registration
    [Documentation]    Check that a new user can be registered in the system
    Register a new customer with data:
    ...    || salutation | first name | last name | e-mail                       | password                                        ||
    ...    || Mr.        | New        | User      | sonia+${random}@spryker.com  | Bv${random_str_password}!4${random_id_password} ||
    Yves: flash message should be shown:    success    Almost there! We send you an email to validate your email address. Please confirm it to be able to log in.
    [Teardown]    Zed: delete customer:
    ...    || email                       ||
    ...    || sonia+${random}@spryker.com ||
    
Guest_User_Access_Restrictions
    [Documentation]    Checks that guest users see products info and cart but not profile
    Yves: header contains/doesn't contain:    true    ${currencySwitcher}[${env}]   ${wishlistIcon}    ${accountIcon}    ${shoppingCartIcon}
    Yves: go to PDP of the product with sku:    002
    Yves: PDP contains/doesn't contain:     true    ${pdpPriceLocator}    ${addToCartButton}
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: shopping cart contains product with unit price:   002    Canon IXUS 160    37.50
    Yves: go to user menu:    Overview
    Yves: 'Login' page is displayed
    Yves: go to 'Wishlist' page
    Yves: 'Login' page is displayed

Authorized_User_Access
    [Documentation]    Checks that authorized users see products info, cart and profile
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: header contains/doesn't contain:    true    ${currencySwitcher}[${env}]    ${accountIcon}     ${wishlistIcon}    ${shoppingCartIcon}
    Yves: go to PDP of the product with sku:    002
    Yves: PDP contains/doesn't contain:     true    ${pdpPriceLocator}     ${addToCartButton}
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: shopping cart contains product with unit price:    002    Canon IXUS 160    37.50
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    Orders History
    Yves: 'Order History' page is displayed
    Yves: go to 'Wishlist' page
    Yves: 'Wishlist' page is displayed
    [Teardown]    Yves: check if cart is not empty and clear it

User_Account
    [Documentation]    Checks user account pages work + address management
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    Orders History
    Yves: 'Order History' page is displayed
    Yves: go to user menu:    My Profile
    Yves: 'Profile' page is displayed
    Yves: go to 'Wishlist' page
    Yves: 'Wishlist' page is displayed
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: go to user menu item in the left bar:    Newsletter
    Yves: 'Newsletter' page is displayed
    Yves: go to user menu item in the left bar:    Returns
    Yves: 'Returns' page is displayed
    Yves: delete all user addresses
    Yves: create a new customer address in profile:     Mr    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    true    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany
    Yves: delete user address:    Kirncher Str. ${random}
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    false    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create a new customer address in profile:
    ...    || email                     | salutation | first name                              | last name                              | address 1          | address 2           | address 3           | city            | zip code  | country | phone     | company          ||
    ...    || ${yves_second_user_email} | Mr         | ${yves_second_user_first_name}${random} | ${yves_second_user_last_name}${random} | address 1${random} | address 2 ${random} | address 3 ${random} | Berlin${random} | ${random} | Austria | 123456789 | Spryker${random} ||
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to user menu:    Overview
    Yves: go to user menu item in the left bar:    Addresses
    Yves: check that user has address exists/doesn't exist:    true    ${yves_second_user_first_name}${random}    ${yves_second_user_last_name}${random}    address 1${random}    address 2 ${random}    ${random}    Berlin${random}    Austria
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    ...    AND     Yves: delete all user addresses
    
Catalog
    [Documentation]    Checks that catalog options and search work
    Yves: perform search by:    canon
    Yves: 'Catalog' page should show products:    29
    Yves: select filter value:    Color    blue
    Yves: 'Catalog' page should show products:    2
    Yves: go to first navigation item level:    Computers
    Yves: 'Catalog' page should show products:    72
    Yves: page contains CMS element:    Product Slider    Top Sellers
    Yves: page contains CMS element:    Banner    Computers
    Yves: change sorting order on catalog page:    Sort by price ascending
    Yves: 1st product card in catalog (not)contains:     Price    €18.79
    Yves: change sorting order on catalog page:    Sort by price descending
    Yves: 1st product card in catalog (not)contains:      Price    €3,456.99
    Yves: go to catalog page:    2
    Yves: catalog page contains filter:    Price    Ratings     Label     Brand    Color    Merchant
    Yves: select filter value:    Color    blue
    Yves: 'Catalog' page should show products:    2
    [Teardown]    Yves: check if cart is not empty and clear it

# Catalog_Actions
#     ### Quick add to cart from catalog is not supported by Marketplace for now ###
#     [Documentation]    Checks quick add to cart and product groups.
#     Yves: perform search by:    NEX-VG20EH
#     Yves: 1st product card in catalog (not)contains:      Add to Cart    true
#     Yves: quick add to cart for first item in catalog
#     Yves: perform search by:    115
#     Yves: 1st product card in catalog (not)contains:     Add to Cart    false
#     Yves: perform search by:    002
#     Yves: 1st product card in catalog (not)contains:      Add to Cart    true
#     Yves: 1st product card in catalog (not)contains:      Color selector   true
#     Yves: mouse over color on product card:    black
#     Yves: quick add to cart for first item in catalog
#     Yves: go to b2c shopping cart
#     Yves: shopping cart contains the following products:    NEX-VG20EH    Canon IXUS 160
#     [Teardown]    Yves: check if cart is not empty and clear it

Product_labels
    [Documentation]    Checks that products have labels on PLP and PDP
    Yves: go to first navigation item level:    Sale
    Yves: 1st product card in catalog (not)contains:     Sale label    true
    Yves: go to the PDP of the first available product on open catalog page
    Yves: PDP contains/doesn't contain:    true    ${pdp_sales_label}[${env}]
    Yves: go to first navigation item level:    New
    Yves: 1st product card in catalog (not)contains:     New label    true
    Yves: go to the PDP of the first available product on open catalog page
    Yves: PDP contains/doesn't contain:    true    ${pdp_new_label}[${env}]
    [Teardown]    Yves: check if cart is not empty and clear it

Product_PDP
    [Documentation]    Checks that PDP contains required elements
    Yves: go to PDP of the product with sku:    135
    Yves: change variant of the product on PDP on:    Flash
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}   ${addToCartButton}    ${pdp_limited_warranty_option}[${env}]    ${pdp_gift_wrapping_option}[${env}]    ${relatedProducts}
    Yves: PDP contains/doesn't contain:    false    ${pdp_add_to_wishlist_button}
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    135
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}   ${pdp_add_to_cart_disabled_button}[${env}]    ${pdp_limited_warranty_option}[${env}]    ${pdp_gift_wrapping_option}[${env}]     ${pdp_add_to_wishlist_button}    ${relatedProducts}
    Yves: change variant of the product on PDP on:    Flash
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}    ${addToCartButton}    ${pdp_limited_warranty_option}[${env}]    ${pdp_gift_wrapping_option}[${env}]     ${pdp_add_to_wishlist_button}    ${relatedProducts}

Volume_Prices
    [Documentation]    Checks volume prices are applied
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    193
    Yves: change quantity using '+' or '-' button № times:    +    4
    Yves: product price on the PDP should be:    €165.00
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: shopping cart contains product with unit price:    193    Sony FDR-AX40    825.00
    Yves: delete from b2c cart products with name:    Sony FDR-AX40
    [Teardown]    Yves: check if cart is not empty and clear it

Discontinued_Alternative_Products
    [Documentation]    Checks discontinued and alternative products
    Yves: go to PDP of the product with sku:    ${product_with_relations_alternative_products_sku}
    Yves: change variant of the product on PDP on:    2.3 GHz
    Yves: PDP contains/doesn't contain:    true    ${alternativeProducts}
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: delete all wishlists
    Yves: go to PDP of the product with sku:    ${discontinued_product_concrete_sku}
    Yves: add product to wishlist:    My wishlist
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: discontinue the following product:    ${discontinued_product_abstract_sku}    ${discontinued_product_concrete_sku}
    Zed: product is successfully discontinued
    Zed: check if at least one price exists for concrete and add if doesn't:    100
    Zed: add following alternative products to the concrete:    012
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to 'Wishlist' page
    Yves: go to wishlist with name:    My wishlist
    Yves: product with sku is marked as discountinued in wishlist:    ${discontinued_product_concrete_sku}
    Yves: product with sku is marked as alternative in wishlist:    012
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}    
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: undo discontinue the following product:    ${discontinued_product_abstract_sku}    ${discontinued_product_concrete_sku}
    ...    AND    Trigger p&s

Back_in_Stock_Notification
    [Documentation]    Back in stock notification is sent and availability check
    [Setup]    Run keywords    Yves: go to the 'Home' page
    ...    AND    Yves: go to the PDP of the first available product
    ...    AND    Yves: get sku of the concrete product on PDP
    ...    AND    Yves: get sku of the abstract product on PDP
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: check if product is/not in stock:    ${stock_product_abstract_sku}    true
    Zed: change product stock:    ${stock_product_abstract_sku}    ${stock_product_concrete_sku}    false    0
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: check if product is/not in stock:    ${stock_product_abstract_sku}    false
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:  ${stock_product_abstract_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
    Yves: check if product is available on PDP:    ${stock_product_abstract_sku}    false
    Yves: submit back in stock notification request for email:    ${yves_second_user_email}
    Yves: unsubscribe from availability notifications
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: change product stock:    ${stock_product_abstract_sku}    ${stock_product_concrete_sku}    true    0
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: check if product is/not in stock:    ${stock_product_abstract_sku}    true
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:  ${stock_product_abstract_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: check if product is available on PDP:    ${stock_product_abstract_sku}    true
    [Teardown]    Zed: check and restore product availability in Zed:    ${stock_product_abstract_sku}    Available    ${stock_product_concrete_sku}

Add_to_Wishlist
    [Documentation]    Check creation of wishlist and adding to different wishlists
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: delete all wishlists
    Yves: create wishlist with name:    My wishlist
    Yves: go to PDP of the product with sku:  003
    Yves: add product to wishlist:    My wishlist
    Yves: go to 'Wishlist' page
    Yves: create wishlist with name:    Second wishlist
    Yves: go to PDP of the product with sku:  004
    Yves: add product to wishlist:    Second wishlist    select
    Yves: go to 'Wishlist' page
    Yves: go to wishlist with name:    My wishlist
    Yves: wishlist contains product with sku:    003_26138343
    Yves: go to wishlist with name:    Second wishlist
    Yves: wishlist contains product with sku:    004_30663302
    [Teardown]    Run keywords    Yves: delete all wishlists    AND    Yves: check if cart is not empty and clear it

# Product_Sets
#     ### Product Sets are not supported by Marketplace for now ###
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

Product_Bundles
    [Documentation]    Checks checkout with Bundle product. 
    [Setup]    Run keywords    Repeat Keyword    3    Trigger multistore p&s
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: change product stock:    ${bundled_product_1_abstract_sku}    ${bundled_product_1_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_2_abstract_sku}    ${bundled_product_2_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_3_abstract_sku}    ${bundled_product_3_concrete_sku}    true    10
    Repeat Keyword    3    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${bundleItemsSmall}
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to b2c shopping cart
    Yves: shopping cart contains the following products:    ${bundle_product_product_name}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Credit Card
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Yves: check if cart is not empty and clear it

# Configurable_Bundle
#     ### Configurable Bundles are not supported by Marketplace for now ###
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
#     Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
#     Yves: accept the terms and conditions:    true
#     Yves: 'submit the order' on the summary page
#     Yves: 'Thank you' page is displayed
#     Yves: go to user menu:    Orders History
#     Yves: 'Order History' page is displayed
#     Yves: get the last placed order ID by current customer
#     Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
#     Yves: 'View Order' page is displayed
#     Yves: 'Order Details' page contains the following product title N times:    Smartstation Kit    3
#     [Teardown]    Yves: check if cart is not empty and clear it

Discounts
    [Documentation]    Discounts, Promo Products, and Coupon Codes (includes guest checkout). DMS-ON: https://spryker.atlassian.net/browse/FRW-7476
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate all discounts from Overview page
    ...    AND    Zed: change product stock:    190    190_25111746    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_1_abstract_sku}    ${bundled_product_1_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_2_abstract_sku}    ${bundled_product_2_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_3_abstract_sku}    ${bundled_product_3_concrete_sku}    true    10
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Merchandising    Discount
    Zed: create a discount and activate it:    voucher    Percentage    5    sku = '*'    test${random}    discountName=Voucher Code 5% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    10    sku = '*'    discountName=Cart Rule 10% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    100    discountName=Promotional Product 100% ${random}    promotionalProductDiscount=True    promotionalProductAbstractSku=002    promotionalProductQuantity=2
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:    190
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: apply discount voucher to cart:    test${random}
    Yves: discount is applied:    voucher    Voucher Code 5% ${random}    - €8.73
    Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €17.46
    Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €87.96
    Yves: promotional product offer is/not shown in cart:    true
    Yves: change quantity of promotional product and add to cart:    +    1
    Yves: shopping cart contains the following products:    Kodak EasyShare M532    Canon IXUS 160
    Yves: discount is applied:    cart rule    Promotional Product 100% ${random}    - €75.00
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    DHL    Express
    Yves: select the following shipping method for the shipment:    2    DHL    Express
    Yves: select the following shipping method for the shipment:    3    DHL    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Credit Card
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €765.35
    [Teardown]    Run keywords    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate following discounts from Overview page:    Voucher Code 5% ${random}    Cart Rule 10% ${random}    Promotional Product 100% ${random}
    ...    AND    Zed: activate following discounts from Overview page:    Free Acer Notebook    Tu & Wed $5 off 5 or more    10% off $100+    Free smartphone    20% off cameras    Free Acer M2610    Free standard delivery    10% off Intel Core    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order
    ...    AND    Trigger p&s

Split_Delivery
    [Documentation]    Checks split delivery in checkout
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    012
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: select delivery to multiple addresses
    Yves: fill in new delivery address for a product:
    ...    || product        | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Canon IXUS 285 | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in new delivery address for a product:
    ...    || product        | salutation | firstName | lastName | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Canon IXUS 175 | Dr.        | First     | Last     | Second Street | 2           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in new delivery address for a product:
    ...    || product        | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Canon IXUS 165 | Dr.        | First     | Last     | Third Street | 3           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: select the following shipping method for the shipment:    2    Hermes    Same Day
    Yves: select the following shipping method for the shipment:    3    DHL    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    3
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses

Agent_Assist
    [Documentation]    Checks that agent can be used.
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create new Zed user with the following data:    agent+${random}@spryker.com    change${random}    Agent    Assist    Root group    This user is an agent in Storefront    en_US
    Yves: go to the 'Home' page
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent+${random}@spryker.com    change${random}
    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: perform search by customer:    ${yves_user_first_name}
    Yves: agent widget contains:    ${yves_user_email}
    Yves: as an agent login under the customer:    ${yves_user_email}
    Yves: perform search by:    031
    Yves: product with name in the catalog should have price:    Canon PowerShot G9 X    €400.24
    Yves: go to PDP of the product with sku:    031
    Yves: product price on the PDP should be:    €400.24
    [Teardown]    Run Keywords    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    agent+${random}@spryker.com

Return_Management
    [Documentation]    Checks that returns work and oms process is checked. DMS-ON: https://spryker.atlassian.net/browse/FRW-7477
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    008
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    010
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    012
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName | lastName | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | Guest     | User     | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: trigger all matching states inside this order:    skip picking
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    send to distribution
    Zed: trigger matching state of xxx merchant's shipment:    1    confirm at center
    Zed: trigger matching state of xxx merchant's shipment:    1    Ship   
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to user menu:    Orders History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    010_30692994    007_30691822
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    010_30692994    007_30691822
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Orders    
    MP: wait for order to appear:    ${lastPlacedOrder}--${merchant_spryker_reference}
    MP: click on a table row that contains:    ${lastPlacedOrder}--${merchant_spryker_reference}
    MP: update order state using header button:    Execute return
    MP: order states on drawer should contain:    Returned
    MP: order states on drawer should contain:    Shipped   
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create a return for the following order and product in it:    ${lastPlacedOrder}    012_25904598
    Zed: create new Zed user with the following data:    returnagent+${random}@spryker.com    change123${random}    Agent    Assist    Root group    This user is an agent in Storefront    en_US
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    returnagent+${random}@spryker.com    change123${random}
    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: perform search by customer:    ${yves_user_email}
    Yves: agent widget contains:    ${yves_user_email}
    Yves: as an agent login under the customer:    ${yves_user_email}
    Yves: go to user menu:    Orders History
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    008_30692992
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    008_30692992
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    Execute return
    Zed: go to second navigation item level:    Sales    My Returns
    Zed: table should contain xxx N times:    ${lastPlacedOrder}    3
    Zed: view the latest return from My Returns:    ${lastPlacedOrder}
    Zed: return details page contains the following items:    008_30692992
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to user menu:    Orders History
    Yves: 'Order History' page is displayed
    Yves: 'Order History' page contains the following order with a status:    ${lastPlacedOrder}    Returned
    [Teardown]    Run Keywords    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    returnagent+${random}@spryker.com

Content_Management
    [Documentation]    Checks cms content can be edited in zed and that correct cms elements are present on homepage
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Content    Pages
    Zed: create a cms page and publish it:    Test Page${random}    test-page${random}    Page Title    Page text
    Yves: go to the 'Home' page
    Yves: page contains CMS element:    Homepage Banners
    Yves: page contains CMS element:    Product Slider    Top Sellers
    Yves: page contains CMS element:    Homepage Inspirational block
    Yves: page contains CMS element:    Homepage Banner Video
    Yves: page contains CMS element:    Footer section
    Yves: go to newly created page by URL:    en/test-page${random}
    Yves: page contains CMS element:    CMS Page Title    Page Title
    Yves: page contains CMS element:    CMS Page Content    Page text
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Content    Pages
    ...    AND    Zed: click Action Button in a table for row that contains:    Test Page${random}    Deactivate
    ...    AND    Trigger multistore p&s

Product_Relations
    [Documentation]    Checks related product on PDP and upsell products in cart
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    ${product_with_relations_related_products_sku}
    Yves: PDP contains/doesn't contain:    true    ${relatedProducts}
    Yves: go to PDP of the product with sku:    ${product_with_relations_upselling_sku}
    Yves: PDP contains/doesn't contain:    false    ${relatedProducts}
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: shopping cart contains/doesn't contain the following elements:    true    ${upSellProducts}
    [Teardown]    Yves: check if cart is not empty and clear it

Guest_Checkout_and_Addresses
    [Documentation]    Guest checkout with discounts, OMS and different addresses. DMS-ON: https://spryker.atlassian.net/browse/FRW-7476
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Merchandising    Discount
    ...    AND    Zed: create a discount and activate it:    voucher    Percentage    5    sku = '*'    guestTest${random}    discountName=Guest Voucher Code 5% ${random}
    ...    AND    Zed: create a discount and activate it:    cart rule    Percentage    10    sku = '*'    discountName=Guest Cart Rule 10% ${random}
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    012
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: apply discount voucher to cart:    guestTest${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: proceed with checkout as guest:    Mr    Guest    user    sonia+guest${random}@spryker.com
    Yves: billing address same as shipping address:    true
    Yves: select delivery to multiple addresses
    Yves: fill in new delivery address for a product:
    ...    || product        | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Canon IXUS 285 | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in new delivery address for a product:
    ...    || product        | salutation | firstName | lastName | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Canon IXUS 175 | Dr.        | First     | Last     | Second Street | 2           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in new delivery address for a product:
    ...    || product        | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Canon IXUS 165 | Dr.        | First     | Last     | Third Street | 3           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: select the following shipping method for the shipment:    2    Hermes    Same Day
    Yves: select the following shipping method for the shipment:    3    DHL    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: get the last placed order ID of the customer by email:    sonia+guest${random}@spryker.com
    Zed: trigger all matching states inside xxx order:    ${zedLastPlacedOrder}    Pay
    Zed: go to my order page:    ${zedLastPlacedOrder}
    Zed: billing address for the order should be:    First Last, Billing Street 123, 10247 Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    1    Dr First, Last, First Street, 1, Additional street, Spryker, 10247, Berlin, Germany 
    Zed: shipping address inside xxx shipment should be:    2    Dr First, Last, Second Street, 2, Additional street, Spryker, 10247, Berlin, Germany 
    Zed: shipping address inside xxx shipment should be:    3    Dr First, Last, Third Street, 3, Additional street, Spryker, 10247, Berlin, Germany 
    Zed: trigger matching state of xxx merchant's shipment:    1    send to distribution
    Zed: trigger matching state of xxx merchant's shipment:    1    confirm at center
    Zed: trigger matching state of xxx merchant's shipment:    1    Ship   
    [Teardown]    Run keywords    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate following discounts from Overview page:    Guest Voucher Code 5% ${random}    Guest Cart Rule 10% ${random}

Refunds
    [Documentation]    Checks that refund can be created for one item and the whole order. DMS-ON: https://spryker.atlassian.net/browse/FRW-7476
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate all discounts from Overview page
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    008
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    010
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €394.41
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay   
    Zed: trigger all matching states inside this order:    skip picking
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    send to distribution
    Zed: trigger matching state of xxx merchant's shipment:    1    confirm at center
    Zed: trigger matching state of order item inside xxx shipment:    008_30692992    Ship
    Zed: trigger matching state of order item inside xxx shipment:    008_30692992    Deliver
    Zed: trigger matching state of order item inside xxx shipment:    008_30692992    Refund
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €265.03
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    Ship
    Zed: trigger matching state of xxx merchant's shipment:    1    Deliver
    Zed: trigger matching state of xxx merchant's shipment:    1    Refund
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €0.00
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: activate following discounts from Overview page:    Tu & Wed $5 off 5 or more    10% off $100+    20% off cameras    Tu & Wed €5 off 5 or more    10% off minimum order
    
Multiple_Merchants_Order
    [Documentation]    Checks that order with products and offers of multiple merchants could be placed and it will be splitted per merchant
    [Setup]    Run Keywords    
    ...    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    ...    AND    MP: change offer stock:
    ...    || offer   | stock quantity | is never out of stock ||
    ...    || offer30 | 10             | true                  ||
    ...    AND    MP: login on MP with provided credentials:    ${merchant_budget_cameras_email}
    ...    AND    MP: change offer stock:
    ...    || offer   | stock quantity | is never out of stock ||
    ...    || offer89 | 10             | true                  ||
    ...    AND    Trigger p&s
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: delete all user addresses
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: create a new customer address in profile:     Mr    ${yves_user_first_name}    ${yves_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: change product stock:    ${one_variant_product_of_main_merchant_abstract_sku}    ${one_variant_product_of_main_merchant_concrete_sku}    true    10    10
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    ${one_variant_product_of_main_merchant_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:     ${product_with_multiple_offers_abstract_sku}
    Yves: merchant's offer/product price should be:    Budget Cameras    ${product_with_multiple_offers_budget_cameras_price}
    Yves: merchant's offer/product price should be:    Video King    ${product_with_multiple_offers_video_king_price}
    Yves: select xxx merchant's offer:    Budget Cameras
    Yves: product price on the PDP should be:    ${product_with_multiple_offers_budget_cameras_price}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:     ${second_product_with_multiple_offers_abstract_sku}
    Yves: select xxx merchant's offer:    Video King
    Yves: product price on the PDP should be:    ${second_product_with_multiple_offers_video_king_price}
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: assert merchant of product in b2c cart:    ${one_variant_product_of_main_merchant_abstract_name}    Spryker
    Yves: assert merchant of product in b2c cart:    ${product_with_multiple_offers_abstract_name}    Budget Cameras
    Yves: assert merchant of product in b2c cart:    ${second_product_with_multiple_offers_abstract_name}    Video King
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_user_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: select the following shipping method for the shipment:    2    Hermes    Same Day
    Yves: select the following shipping method for the shipment:    3    DHL    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    3
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    ...    AND    Yves: delete all user addresses

Merchant_Profile_Update
    [Documentation]    Checks that merchant profile could be updated from merchant portal and that changes will be displayed on Yves
    Yves: go to URL:    en/merchant/Video-king
    Yves: assert merchant profile fields:
    ...    || name | email            | phone           | delivery time | data privacy                                         ||
    ...    ||      | hi@video-king.nl | +31 123 345 777 | 2-4 days      | Video King values the privacy of your personal data. ||
    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    MP: open navigation menu tab:    Profile  
    MP: open profile tab:    Online Profile
    MP: update profile fields with following data:
    ...    || email                  | phone           | delivery time | data privacy              ||
    ...    || updated@office-king.nl | +11 222 333 444 | 2-4 weeks     | Data privacy updated text ||
    MP: click submit button
    Trigger multistore p&s
    Yves: go to URL:    en/merchant/video-king
    Yves: assert merchant profile fields:
    ...    || name | email                  | phone           | delivery time | data privacy              ||
    ...    ||      | updated@office-king.nl | +11 222 333 444 | 2-4 weeks     | Data privacy updated text ||
    [Teardown]    Run Keywords    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    ...    AND    MP: open navigation menu tab:    Profile
    ...    AND    MP: open profile tab:    Online Profile  
    ...    AND    MP: update profile fields with following data:
    ...    || email            | phone           | delivery time | data privacy                                         ||
    ...    || hi@video-king.nl | +31 123 345 777 | 2-4 days      | Video King values the privacy of your personal data. ||
    ...    AND    MP: click submit button
    ...    AND    Trigger multistore p&s

Merchant_Profile_Set_to_Offline_from_MP
    [Documentation]    Checks that merchant is able to set store offline and then his profile, products and offers won't be displayed on Yves
    [Setup]    Run Keywords    
    ...    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    ...    AND    MP: change offer stock:
    ...    || offer   | stock quantity | is never out of stock ||
    ...    || offer30 | 10             | true                  ||
    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    MP: open navigation menu tab:    Profile
    MP: open profile tab:    Online Profile
    MP: change store status to:    offline
    Yves: go to URL:    en/merchant/video-king
    Yves: try reloading page if element is/not appear:    ${merchant_profile_main_content_locator}    false
    Yves: perform search by:    Video King
    Yves: go to the PDP of the first available product on open catalog page
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    false
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    false
    Yves: go to PDP of the product with sku:    ${second_product_with_multiple_offers_abstract_sku}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    false
    [Teardown]    Run Keywords    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    ...    AND    MP: open navigation menu tab:    Profile
    ...    AND    MP: open profile tab:    Online Profile
    ...    AND    MP: change store status to:    online
    ...    AND    Repeat Keyword    3    Trigger multistore p&s
    ...    AND    Yves: go to the 'Home' page
    ...    AND    Yves: go to PDP of the product with sku:    ${second_product_with_multiple_offers_abstract_sku}
    ...    AND    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    ...    AND    Yves: go to URL:    en/merchant/video-king
    ...    AND    Yves: go to newly created page by URL:    url=en/merchant/video-king    delay=5s    iterations=26

Merchant_Profile_Set_to_Inactive_from_Backoffice
    [Documentation]    Checks that backoffice admin is able to deactivate merchant and then it's profile, products and offers won't be displayed on Yves
    [Setup]    Run Keywords    
    ...    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    ...    AND    MP: change offer stock:
    ...    || offer   | stock quantity | is never out of stock ||
    ...    || offer30 | 10             | true                  ||
    ...    AND    Trigger oms
    Yves: go to the 'Home' page
    Yves: perform search by:    Video King
    Yves: go to the PDP of the first available product on open catalog page
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Yves: go to PDP of the product with sku:    ${second_product_with_multiple_offers_abstract_sku}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Merchants  
    Zed: click Action Button in a table for row that contains:     Video King     Deactivate
    Repeat Keyword    3    Trigger multistore p&s
    Yves: go to the 'Home' page
    Yves: go to URL:    en/merchant/video-king
    Yves: try reloading page if element is/not appear:    ${merchant_profile_main_content_locator}    false
    Yves: perform search by:    Video King
    Yves: go to the PDP of the first available product on open catalog page
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    false
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    false
    Yves: go to PDP of the product with sku:    ${second_product_with_multiple_offers_abstract_sku}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    false
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Marketplace    Merchants  
    ...    AND    Zed: click Action Button in a table for row that contains:     Video King     Activate
    ...    AND    Repeat Keyword    3    Trigger multistore p&s

Manage_Merchants_from_Backoffice
    [Documentation]    Checks that backoffice admin is able to create, approve, edit merchants
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create new Merchant with the following data:
    ...    || merchant name        | merchant reference            | e-mail                      | store | store | en url                  | de url                  ||
    ...    || NewMerchant${random} | NewMerchantReference${random} | merchant+${random}@test.com | DE    | DE    | NewMerchantURL${random} | NewMerchantURL${random} ||
    Zed: perform search by:    NewMerchant${random}
    Zed: table should contain non-searchable value:    Inactive
    Zed: table should contain non-searchable value:    Waiting for Approval
    Zed: table should contain non-searchable value:    DE
    Zed: click Action Button in a table for row that contains:    NewMerchant${random}    Activate
    Zed: click Action Button in a table for row that contains:    NewMerchant${random}    Approve Access
    Zed: perform search by:    NewMerchant${random}
    Zed: table should contain non-searchable value:    Active
    Zed: table should contain non-searchable value:    Approved
    Zed: click Action Button in a table for row that contains:    NewMerchant${random}    Edit
    Zed: update Merchant on edit page with the following data:
    ...    || merchant name               | merchant reference | e-mail  | store | store | en url | de url ||
    ...    || NewMerchantUpdated${random} |                    |         |       |       |        |        ||
    Trigger multistore p&s
    Yves: go to newly created page by URL:    en/merchant/NewMerchantURL${random}
    Yves: assert merchant profile fields:
    ...    || name                         | email| phone | delivery time | data privacy ||
    ...    || NewMerchantUpdated${random}  |      |       |               |              ||
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:    NewMerchantUpdated${random}    Edit
    Zed: update Merchant on edit page with the following data:
    ...    || merchant name | merchant reference | e-mail  | uncheck store | en url | de url ||
    ...    ||               |                    |         | DE            |        |        ||
    Trigger multistore p&s
    Yves: go to URL and refresh until 404 occurs:    ${yves_url}en/merchant/NewMerchantURL${random}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Marketplace    Merchants  
    ...    AND    Zed: click Action Button in a table for row that contains:     NewMerchantUpdated${random}     Deactivate
    ...    AND    Trigger multistore p&s

Manage_Merchant_Users
    [Documentation]    Checks that backoffice admin is able to create, activate, edit and delete merchant users
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:     Video King     Edit
    Zed: create new Merchant User with the following data:
    ...    || e-mail                         | first name     | last name      ||
    ...    || sonia+mu+${random}@spryker.com | FName${random} | LName${random} ||
    Zed: perform merchant user search by:     sonia+mu+${random}@spryker.com
    Zed: table should contain non-searchable value:    Deactivated
    Zed: click Action Button in Merchant Users table for row that contains:    sonia+mu+${random}@spryker.com    Activate
    Zed: table should contain non-searchable value:    Active
    Zed: click Action Button in Merchant Users table for row that contains:    sonia+mu+${random}@spryker.com    Edit
    Zed: update Merchant User on edit page with the following data:
    ...    || e-mail | first name           | last name ||
    ...    ||        | UpdatedName${random} |           ||
    Zed: perform merchant user search by:    sonia+mu+${random}@spryker.com
    Zed: table should contain non-searchable value:    UpdatedName${random}
    Zed: update Zed user:
    ...    || oldEmail                       | newEmail | password      | firstName | lastName ||
    ...    || sonia+mu+${random}@spryker.com |          | Change123!321 |           |          ||
    MP: login on MP with provided credentials:    sonia+mu+${random}@spryker.com    Change123!321
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:     Video King     Edit
    Zed: go to tab:     Users
    Zed: click Action Button in Merchant Users table for row that contains:    sonia+mu+${random}@spryker.com    Deactivate
    Zed: table should contain non-searchable value:    Deactivated
    MP: login on MP with provided credentials and expect error:    sonia+mu+${random}@spryker.com    Change123!321
    [Teardown]    Run Keywords     Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Marketplace    Merchants
    ...    AND    Zed: click Action Button in a table for row that contains:     Video King     Edit
    ...    AND    Zed: go to tab:     Users
    ...    AND    Zed: click Action Button in Merchant Users table for row that contains:    sonia+mu+${random}@spryker.com    Delete
    ...    AND    Zed: submit the form

Create_and_Approve_New_Merchant_Product
    [Documentation]    Checks that merchant is able to create new multi-SKU product and marketplace operator is able to approve it in BO
    MP: login on MP with provided credentials:    ${merchant_budget_cameras_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku  | product name        | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || SKU${random} | NewProduct${random} | packaging_unit       | Item                        | Box                          | series                | Ace Plus               ||
    MP: perform search by:    NewProduct${random}
    MP: click on a table row that contains:     NewProduct${random}
    MP: fill abstract product required fields:
    ...    || product name DE     | store | tax set           ||
    ...    || NewProduct${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default ||
    ...    || abstract     | 1           | DE    | EUR      | 100           ||
    MP: save abstract product 
    MP: click on a table row that contains:    NewProduct${random}
    MP: open concrete drawer by SKU:    SKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     NewProduct${random}     Approve
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}   
    Yves: go to PDP of the product with sku:     SKU${random}    wait_for_p&s=true
    Save current URL
    Yves: merchant is (not) displaying in Sold By section of PDP:    Budget Cameras    true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     NewProduct${random}     Deny
    Trigger p&s
    Yves: go to the 'Home' page
    Yves: go to URL and refresh until 404 occurs:    ${url}

Create_New_Offer
    [Documentation]    Checks that merchant is able to create new offer and it will be displayed on Yves
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku         | product name            | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || SprykerSKU${random} | SprykerProduct${random} | packaging_unit       | Item                        | Box                          | series                | Ace Plus               ||
    MP: perform search by:    SprykerProduct${random} 
    MP: click on a table row that contains:     SprykerSKU${random}
    MP: fill abstract product required fields:
    ...    || product name DE         | store | tax set           ||
    ...    || SprykerProduct${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || abstract     | 1          | DE    | EUR      | 100           ||
    MP: save abstract product
    MP: click on a table row that contains:    SprykerSKU${random}
    MP: open concrete drawer by SKU:    SprykerSKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     SprykerSKU${random}     Approve 
    Trigger p&s 
    MP: login on MP with provided credentials:    ${merchant_budget_cameras_email}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    SprykerSKU${random}-2
    MP: click on a table row that contains:    SprykerSKU${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku         | store | stock quantity ||
    ...    || true      | merchantSKU${random} | DE    | 100            ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | CHF      | 100           ||
    MP: save offer
    MP: perform search by:    merchantSKU${random}
    MP: click on a table row that contains:    merchantSKU${random} 
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | EUR      | 200           ||
    MP: save offer
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:     SprykerSKU${random}-2    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Budget Cameras    true
    Yves: merchant's offer/product price should be:    Budget Cameras    €200.00
    Yves: select xxx merchant's offer:    Budget Cameras
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: 'Shopping Cart' page is displayed
    Yves: assert merchant of product in b2c cart:    SprykerProduct${random}    Budget Cameras
    Yves: shopping cart contains product with unit price:    SprykerSKU${random}-2    SprykerProduct${random}    200
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     SprykerProduct${random}     Deny
    ...    AND    Trigger p&s

Approve_Offer
    [Documentation]    Checks that marketplace operator is able to approve or deny merchant's offer and it will be available or not in store due to this status
    [Setup]    Run Keywords    
    ...    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    ...    AND    MP: change offer stock:
    ...    || offer   | stock quantity | is never out of stock ||
    ...    || offer30 | 10             | true                  ||
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Offers
    Zed: select merchant in filter:    Video King
    Zed: click Action Button in a table for row that contains:     ${second_product_with_multiple_offers_concrete_sku}     Deny
    Trigger p&s
    Yves: go to the 'Home' page
    Yves: go to PDP of the product with sku:     ${second_product_with_multiple_offers_concrete_sku}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    false
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Offers
    Zed: select merchant in filter:    Video King
    Zed: click Action Button in a table for row that contains:     ${second_product_with_multiple_offers_concrete_sku}    Approve
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    ${second_product_with_multiple_offers_abstract_sku}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Yves: merchant's offer/product price should be:    Video King    ${second_product_with_multiple_offers_video_king_price}
    Yves: select xxx merchant's offer:    Video King
    Yves: product price on the PDP should be:     ${second_product_with_multiple_offers_video_king_price}

Fulfill_Order_from_Merchant_Portal
    [Documentation]    Checks that merchant is able to process his order through OMS from merchant portal
    [Setup]    Run Keywords    
    ...    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer30 | 10             | true                  ||
    ...    AND    MP: login on MP with provided credentials:    ${merchant_budget_cameras_email}
    ...    AND    MP: change offer stock:
    ...    || offer   | stock quantity | is never out of stock ||
    ...    || offer89 | 10             | true                  ||
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer410 | 10             | true                  ||
    ...    AND    Trigger p&s
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: change product stock:    ${one_variant_product_of_main_merchant_abstract_sku}    ${one_variant_product_of_main_merchant_concrete_sku}    true    10    10
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: delete all user addresses
    ...    AND    Yves: create a new customer address in profile:     Mr    ${yves_user_first_name}    ${yves_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    ...    AND    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:    ${one_variant_product_of_main_merchant_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:     ${product_with_multiple_offers_abstract_sku}
    Yves: merchant's offer/product price should be:    Budget Cameras    ${product_with_multiple_offers_budget_cameras_price}
    Yves: merchant's offer/product price should be:    Video King    ${product_with_multiple_offers_video_king_price}
    Yves: select xxx merchant's offer:    Budget Cameras
    Yves: product price on the PDP should be:    ${product_with_multiple_offers_budget_cameras_price}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:     ${second_product_with_multiple_offers_abstract_sku}
    Yves: select xxx merchant's offer:    Video King
    Yves: product price on the PDP should be:    ${second_product_with_multiple_offers_video_king_price}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    104
    Yves: select xxx merchant's offer:    Budget Cameras
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: assert merchant of product in b2c cart:    ${one_variant_product_of_main_merchant_abstract_name}    Spryker
    Yves: assert merchant of product in b2c cart:    ${product_with_multiple_offers_abstract_name}    Budget Cameras
    Yves: assert merchant of product in b2c cart:    ${second_product_with_multiple_offers_abstract_name}    Video King
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_user_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: select the following shipping method for the shipment:    2    Hermes    Same Day
    Yves: select the following shipping method for the shipment:    3    DHL    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: wait for order item to be in state:    ${product_with_multiple_offers_concrete_sku}    sent to merchant    2
    MP: login on MP with provided credentials:    ${merchant_budget_cameras_email}
    MP: open navigation menu tab:    Orders    
    MP: wait for order to appear:    ${lastPlacedOrder}--${merchant_budget_cameras_reference}
    MP: click on a table row that contains:    ${lastPlacedOrder}--${merchant_budget_cameras_reference}
    MP: order grand total should be:    €230.27
    MP: update order state using header button:    Ship
    MP: order states on drawer should contain:    Shipped 
    MP: switch to the tab:    Items
    MP: change order item state on:    041_25904691    Deliver
    MP: switch to the tab:    Items
    MP: order item state should be:    104_30727010    shipped
    MP: order item state should be:    041_25904691    delivered
    MP: update order state using header button:    Deliver
    MP: order states on drawer should contain:    Delivered
    MP: switch to the tab:    Items
    MP: order item state should be:    104_30727010    delivered
    MP: order item state should be:    041_25904691    delivered
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: delete all user addresses

Wishlist_List_Supports_Offers
    [Documentation]    Checks that customer is able to add merchant products and offers to list and merchant relation won't be lost in list and afterwards in cart
    [Setup]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: delete all wishlists
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: go to 'Wishlist' page
    ...    AND    Yves: create wishlist with name:    Offer wishlist
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: add product to wishlist:    Offer wishlist
    Yves: select xxx merchant's offer:    Budget Cameras
    Yves: add product to wishlist:    Offer wishlist
    Yves: go to 'Wishlist' page
    Yves: go to wishlist with name:    Offer wishlist
    Yves: assert merchant of product in wishlist:    ${product_with_multiple_offers_concrete_sku}    Spryker
    Yves: assert merchant of product in wishlist:    ${product_with_multiple_offers_concrete_sku}    Budget Cameras
    Yves: add all available products from wishlist to cart
    Yves: go to b2c shopping cart
    Yves: assert merchant of product in b2c cart:    ${product_with_multiple_offers_abstract_name}    Spryker
    Yves: assert merchant of product in b2c cart:    ${product_with_multiple_offers_abstract_name}    Budget Cameras
    [Teardown]    Run keywords    Yves: delete all wishlists    AND    Yves: check if cart is not empty and clear it

Search_for_Merchant_Offers_and_Products
    [Documentation]    Checks that through search customer is able to see the list of merchant's products and offers
    Yves: go to the 'Home' page
    Yves: perform search by:    Video King
    Yves: go to the PDP of the first available product on open catalog page
    Yves: select random varian if variant selector is available
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Yves: perform search by:    Spryker
    Yves: change sorting order on catalog page:    Sort by name ascending
    Yves: go to the PDP of the first available product on open catalog page
    Yves: select random varian if variant selector is available
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    Yves: perform search by:    ${EMPTY}
    Yves: select filter value:    Merchant    Budget Cameras
    Yves: go to the PDP of the first available product on open catalog page
    Yves: select random varian if variant selector is available
    Yves: merchant is (not) displaying in Sold By section of PDP:    Budget Cameras    true

Merchant_Portal_Product_Volume_Prices
    [Documentation]    Checks that merchant is able to create new multi-SKU product with volume prices. Falback to default price after delete
    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku    | product name          | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || VPSKU${random} | VPNewProduct${random} | packaging_unit       | Item                        | Box                          | series                | Ace Plus               ||
    MP: perform search by:    VPNewProduct${random}
    MP: click on a table row that contains:     VPNewProduct${random}
    MP: fill abstract product required fields:
    ...    || product name DE       | store | tax set           ||
    ...    || VPNewProduct${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || abstract     | 1          | DE    | EUR      | 100           ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default | quantity ||
    ...    || abstract     | 2          | DE    | EUR      | 10            | 2        ||
    MP: save abstract product 
    Trigger p&s
    MP: click on a table row that contains:    VPNewProduct${random}
    MP: open concrete drawer by SKU:    VPSKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     VPSKU${random}     Approve
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:     VPSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Reload
    Yves: change quantity using '+' or '-' button № times:    +    3
    Yves: product price on the PDP should be:    €10.00
    Yves: merchant's offer/product price should be:    Video King     €10.00
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to b2c shopping cart
    Yves: shopping cart contains product with unit price:    VPNewProduct${random}    VPNewProduct${random}    40.00
    Yves: assert merchant of product in b2c cart:    VPNewProduct${random}    Video King
    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    MP: open navigation menu tab:    Products
    MP: perform search by:    VPNewProduct${random}
    MP: click on a table row that contains:    VPNewProduct${random}
    MP: delete product price row that contains quantity:    2
    MP: save abstract product
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:     VPSKU${random}    wait_for_p&s=true
    Yves: change quantity using '+' or '-' button № times:    +    3
    Yves: product price on the PDP should be:    €100.00
    Yves: merchant's offer/product price should be:    Video King     €100.00
    Yves: go to b2c shopping cart
    Yves: shopping cart contains product with unit price:    VPNewProduct${random}    VPNewProduct${random}    400.00
    [Teardown]    Run Keywords    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     VPNewProduct${random}     Deny
    ...    AND    Trigger p&s

Merchant_Portal_Offer_Volume_Prices
    [Documentation]    Checks that merchant is able to create new offer with volume prices and it will be displayed on Yves. Falback to default price after delete.
    [Setup]    Repeat Keyword    3    Trigger multistore p&s
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku       | product name             | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || OfferSKU${random} | OfferNewProduct${random} | packaging_unit       | Item                        | Box                          | series                | Ace Plus               ||
    MP: perform search by:    OfferNewProduct${random}
    MP: click on a table row that contains:     OfferNewProduct${random}
    MP: fill abstract product required fields:
    ...    || product name DE          | store | tax set           ||
    ...    || OfferNewProduct${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || abstract     | 1          | DE    | EUR      | 100           ||
    MP: save abstract product 
    Trigger multistore p&s
    MP: click on a table row that contains:    OfferNewProduct${random}
    MP: open concrete drawer by SKU:    OfferSKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     OfferNewProduct${random}     Approve
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}  
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:     OfferSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    OfferSKU${random}-2
    MP: click on a table row that contains:    OfferSKU${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku               | store | stock quantity ||
    ...    || true      | volumeMerchantSKU${random} | DE    | 100            ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | CHF      | 100           ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 2          | DE    | EUR      | 200           | 1        ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 3          | DE    | EUR      | 10            | 2        ||
    MP: save offer
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:     OfferSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Yves: merchant's offer/product price should be:    Video King    €200.00
    Reload
    Yves: select xxx merchant's offer:    Video King
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity using '+' or '-' button № times:    +    3
    Yves: product price on the PDP should be:    €10.00
    Yves: merchant's offer/product price should be:    Video King     €10.00
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: assert merchant of product in b2c cart:    OfferNewProduct${random}    Video King
    Yves: shopping cart contains product with unit price:    OfferNewProduct${random}    OfferNewProduct${random}    40
    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    MP: open navigation menu tab:    Offers
    MP: perform search by:    OfferSKU${random}-2
    MP: click on a table row that contains:    volumeMerchantSKU${random}
    MP: delete offer price row that contains quantity:    2
    MP: save offer
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:     OfferSKU${random}    wait_for_p&s=true
    Reload
    Yves: select xxx merchant's offer:    Video King
    Yves: change quantity using '+' or '-' button № times:    +    3
    Yves: product price on the PDP should be:    €200.00
    Yves: merchant's offer/product price should be:    Video King     €200.00
    Yves: go to b2c shopping cart
    Yves: shopping cart contains product with unit price:    OfferNewProduct${random}    OfferNewProduct${random}    800
    [Teardown]    Run Keywords    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     OfferNewProduct${random}     Deny
    ...    AND    Trigger p&s

Merchant_Portal_My_Account
    [Documentation]    Checks that MU can edit personal data in MP
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:     Sony Experts     Edit
    Zed: create new Merchant User with the following data:
    ...    || e-mail                             | first name     | last name      ||
    ...    || sonia+editmu+${random}@spryker.com | FName${random} | LName${random} ||
    Zed: perform merchant user search by:     sonia+editmu+${random}@spryker.com
    Zed: table should contain non-searchable value:    Deactivated
    Zed: click Action Button in Merchant Users table for row that contains:    sonia+editmu+${random}@spryker.com    Activate
    Zed: table should contain non-searchable value:    Active
    Zed: update Zed user:
    ...    || oldEmail                           | newEmail | password      | firstName | lastName ||
    ...    || sonia+editmu+${random}@spryker.com |          | Change123!321 |           |          ||
    MP: login on MP with provided credentials:    sonia+editmu+${random}@spryker.com    Change123!321
    MP: update merchant personal details with data:
    ...    || firstName               | lastName                | email | currentPassword | newPassword          ||
    ...    || MPUpdatedFName${random} | MPUpdatedLName${random} |       | Change123!321   | UpdatedChange123!321 ||
    MP: click submit button
    MP: login on MP with provided credentials:    sonia+editmu+${random}@spryker.com    UpdatedChange123!321
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Users    Users
    Zed: table should contain:    MPUpdatedFName${random}
    Zed: table should contain:    MPUpdatedLName${random}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    sonia+editmu+${random}@spryker.com
    
Merchant_Portal_Dashboard
    [Documentation]    Checks that merchant user is able to access the dashboard page
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:     Sony Experts     Edit
    Zed: create new Merchant User with the following data:
    ...    || e-mail                               | first name      | last name       ||
    ...    || sonia+dahboard+${random}@spryker.com | DFName${random} | DLName${random} ||
    Zed: perform merchant user search by:     sonia+dahboard+${random}@spryker.com
    Zed: table should contain non-searchable value:    Deactivated
    Zed: click Action Button in Merchant Users table for row that contains:    sonia+dahboard+${random}@spryker.com    Activate
    Zed: table should contain non-searchable value:    Active
    Zed: update Zed user:
    ...    || oldEmail                             | newEmail | password      | firstName | lastName ||
    ...    || sonia+dahboard+${random}@spryker.com |          | Change123!321 |           |          ||
    Trigger multistore p&s
    MP: login on MP with provided credentials:    sonia+dahboard+${random}@spryker.com    Change123!321
    MP: click button on dashboard page and check url:    Manage Offers    /product-offers
    MP: click button on dashboard page and check url:    Add Offer    /product-list
    MP: click button on dashboard page and check url:    Manage Orders    /orders
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    sonia+dahboard+${random}@spryker.com

Merchant_Product_Offer_in_Backoffice
    [Documentation]    Check View action and filtration for Mproduct and Moffer in backoffice
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku      | product name         | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || ViewSKU${random} | ViewProduct${random} | packaging_unit       | Item                        | Box                          | series                | Ace Plus               ||
    MP: perform search by:    ViewProduct${random}
    MP: click on a table row that contains:     ViewProduct${random}
    MP: fill abstract product required fields:
    ...    || product name DE      | store | tax set           ||
    ...    || ViewProduct${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || abstract     | 1          | DE    | EUR      | 100           ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default | quantity ||
    ...    || abstract     | 2          | DE    | EUR      | 10            | 2        ||
    MP: save abstract product 
    MP: click on a table row that contains:    ViewProduct${random}
    MP: open concrete drawer by SKU:    ViewSKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     ViewProduct${random}     Approve
    Trigger p&s
    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    ViewSKU${random}-2
    MP: click on a table row that contains:    ViewSKU${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku             | store | stock quantity ||
    ...    || true      | viewMerchantSKU${random} | DE    | 100            ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | CHF      | 100           ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 2          | DE    | EUR      | 200           | 1        ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 3          | DE    | EUR      | 10            | 2        ||
    MP: save offer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: filter by merchant:    Spryker
    Zed: table should contain:    ViewSKU${random}
    Zed: click Action Button in a table for row that contains:     ViewProduct${random}     View
    Zed: view product page is displayed
    Zed: view abstract product page contains:
    ...    || merchant | status   | store | sku              | name                 ||
    ...    || Spryker  | Approved | DE    | ViewSKU${random} | ViewProduct${random} ||
    Zed: go to second navigation item level:    Marketplace    Offers
    Zed: filter by merchant:    Video King
    Zed: table should contain:    ViewSKU${random}-2
    Zed: click Action Button in a table for row that contains:     ViewSKU${random}-2     View
    Zed: view offer page is displayed
    Zed: view offer product page contains:
    ...    || approval status | status | store | sku                | name                 | merchant   | merchant sku             ||
    ...    || Approved        | Active | DE    | ViewSKU${random}-2 | ViewProduct${random} | Video King | viewMerchantSKU${random} ||
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     ViewProduct${random}     Deny
    ...    AND    Trigger p&s

Manage_Merchant_Product
    [Documentation]    Checks that MU and BO user can manage merchant abstract and concrete products + add new concrete product
    MP: login on MP with provided credentials:    ${merchant_budget_cameras_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku        | product name           | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || manageSKU${random} | manageProduct${random} | packaging_unit       | Item                        | Box                          | series                | Ace Plus               ||
    MP: perform search by:    manageProduct${random}
    MP: click on a table row that contains:     manageProduct${random}
    MP: fill abstract product required fields:
    ...    || product name DE        | store | tax set           ||
    ...    || manageProduct${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 1           | DE    | EUR      | 100           | 90             ||
    MP: save abstract product 
    Trigger multistore p&s
    MP: click on a table row that contains:    manageProduct${random}
    MP: open concrete drawer by SKU:    manageSKU${random}-1
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    MP: open concrete drawer by SKU:    manageSKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 3              | true              | en_US         ||
    MP: open concrete drawer by SKU:    manageSKU${random}-1
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 50            ||
    MP: save concrete product
    MP: open concrete drawer by SKU:    manageSKU${random}-2
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 20            ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default | quantity ||
    ...    || concrete     | 2          | DE    | EUR      | 10            | 2        ||
    MP: save concrete product
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     manageProduct${random}     Approve
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}   
    Yves: go to PDP of the product with sku:     manageSKU${random}    wait_for_p&s=true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: change variant of the product on PDP on:    Item
    Yves: product price on the PDP should be:    €50.00    wait_for_p&s=true
    Yves: merchant's offer/product price should be:    Budget Cameras    €50.00
    Yves: reset selected variant of the product on PDP
    Yves: change variant of the product on PDP on:    Box
    Reload
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: product price on the PDP should be:    €10.00
    Yves: merchant's offer/product price should be:    Budget Cameras     €10.00
    Yves: try add product to the cart from PDP and expect error:    Item manageSKU${random}-2 only has availability of 3.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: product price on the PDP should be:    €10.00
    Yves: merchant's offer/product price should be:    Budget Cameras     €10.00
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: shopping cart contains product with unit price:    manageProduct${random}    manageProduct${random}    30.00
    Yves: assert merchant of product in b2c cart:    manageProduct${random}    Budget Cameras
    MP: login on MP with provided credentials:    ${merchant_budget_cameras_email}
    MP: open navigation menu tab:    Products    
    MP: perform search by:    manageProduct${random}
    MP: click on a table row that contains:     manageProduct${random}
    MP: add new concrete product:
    ...    || first attribute | first attribute value | second attribute | second attribute value ||
    ...    || packaging_unit  | Giftbox               | series           | Ace Plus               ||
    MP: save abstract product
    MP: perform search by:    manageProduct${random}
    MP: click on a table row that contains:     manageProduct${random}
    MP: open concrete drawer by SKU:    manageSKU${random}-3
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 3              | true              | en_US         ||
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     manageProduct${random}     View
    Zed: view product page is displayed
    Zed: view abstract product page contains:
    ...    || merchant        | status   | store | sku                | name                   | variants count ||
    ...    || Budget Cameras  | Approved | DE    | manageSKU${random} | manageProduct${random} | 3              ||
    Zed: update abstract product price on:
    ...    || productAbstract    | store | mode  | type    | currency | amount ||
    ...    || manageSKU${random} | DE    | gross | default | €        | 110.00 ||
    Zed: update abstract product data:
    ...    || productAbstract    | store | name en                         | name de                         | new from   | new to     ||
    ...    || manageSKU${random} | AT    | ENUpdatedmanageProduct${random} | DEUpdatedmanageProduct${random} | 01.01.2020 | 01.01.2030 ||
    Trigger multistore p&s
    Zed: go to second navigation item level:    Catalog    Products
    Zed: table should contain:    ENUpdatedmanageProduct${random}
    Zed: change concrete product price on:
    ...    || productAbstract    | productConcrete      | store | mode  | type   | currency | amount ||
    ...    || manageSKU${random} | manageSKU${random}-3 | DE    | gross | default| €        | 15.00  ||
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:     manageSKU${random}    wait_for_p&s=true
    Yves: product name on PDP should be:    ENUpdatedmanageProduct${random}
    Yves: product price on the PDP should be:    €110.00    wait_for_p&s=true
    Yves: change variant of the product on PDP on:    Giftbox
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    [Teardown]    Run Keywords    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     manageSKU${random}     Deny
    ...    AND    Trigger multistore p&s

Merchant_Product_Original_Price
    [Documentation]    checks that Orignal price is displayed on the PDP and in Catalog
    MP: login on MP with provided credentials:    ${merchant_budget_cameras_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku          | product name             | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || originalSKU${random} | originalProduct${random} | packaging_unit       | Item                        | Box                          | series                | Ace Plus               ||
    MP: perform search by:    originalProduct${random}
    MP: click on a table row that contains:     originalProduct${random}
    MP: fill abstract product required fields:
    ...    || product name DE          | store | tax set           ||
    ...    || originalProduct${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original  ||
    ...    || abstract     | 1           | DE    | EUR      | 100           | 150             ||
    MP: save abstract product 
    MP: click on a table row that contains:    originalProduct${random}
    MP: open concrete drawer by SKU:    originalSKU${random}-1
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    MP: open concrete drawer by SKU:    originalSKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 3              | true              | en_US         ||
    MP: open concrete drawer by SKU:    originalSKU${random}-1
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 50            ||
    MP: save concrete product
    MP: open concrete drawer by SKU:    originalSKU${random}-2
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 20            ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default | quantity ||
    ...    || concrete     | 2          | DE    | EUR      | 10            | 2        ||
    MP: save concrete product
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     originalProduct${random}     Approve
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}   
    Yves: go to URL:    en/search?q=originalSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: 1st product card in catalog (not)contains:     Price    €100.00
    Yves: 1st product card in catalog (not)contains:     Original Price    €150.00
    Yves: go to PDP of the product with sku:     originalSKU${random}    wait_for_p&s=true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: product original price on the PDP should be:    €150.00
    [Teardown]    Run Keywords    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     originalSKU${random}     Deny
    ...    AND    Trigger p&s

Checkout_Address_Management
    [Documentation]    Bug: CC-30439. Checks that user can change address during the checkout and save new into the address book
    [Setup]    Run Keywords    
    ...    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: delete all user addresses
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: create a new customer address in profile:     Mr    ${yves_user_first_name}    ${yves_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    false
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: save new billing address to address book:    false
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_user_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: return to the previous checkout step:    Address
    Yves: billing address same as shipping address:    false
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | New       | Billing  | Changed Street | 098         | 09876    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: save new billing address to address book:    false
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName | lastName | street          | houseNumber | postCode | city   | country     | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Shipping Street | 7           | 10247    | Geneva | Switzerland | Spryker | 123456789 | Additional street ||
    Yves: save new deviery address to address book:    true
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: check that user has address exists/doesn't exist:    true    First    Last    Shipping Street    7    10247    Geneva    Switzerland
    Yves: check that user has address exists/doesn't exist:    false    New    Billing    Changed Street    098    09876    Berlin    Germany
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: billing address for the order should be:    New Billing, Changed Street 098, 09876 Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    1    Mr First, Last, Shipping Street, 7, Additional street, Spryker, 10247, Geneva, Switzerland
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: delete all user addresses

Manage_Shipments
    [Documentation]    Checks create/edit shipment functions from backoffice
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: delete all user addresses
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    012
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: select delivery to multiple addresses
    Yves: fill in new delivery address for a product:
    ...    || product        | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Canon IXUS 285 | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in new delivery address for a product:
    ...    || product        | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Canon IXUS 175 | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in new delivery address for a product:
    ...    || product        | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Canon IXUS 165 | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €225.87
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    1
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 1          | Hermes          | Next Day        | €15.00         | ASAP                    ||
    Zed: create new shipment inside the order:
    ...    || delivert address | salutation | first name | last name | email              | country | address 1     | address 2 | city   | zip code | shipment method | sku          ||
    ...    || New address      | Mr         | Evil       | Tester    | ${yves_user_email} | Austria | Hartmanngasse | 1         | Vienna | 1050     | DHL - Standard  | 012_25904598 ||
    Zed: billing address for the order should be:    First Last, Billing Street 123, 10247 Berlin, Germany
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    2
    Zed: shipping address inside xxx shipment should be:    1    Dr First, Last, First Street, 1, Additional street, Spryker, 10247, Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    2    Mr Evil, Tester, Hartmanngasse, 1, 1050, Vienna, Austria
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 2          | DHL             | Standard        | €0.00          | ASAP                    ||
    Zed: edit xxx shipment inside the order:
    ...    || shipmentN | delivert address | salutation | first name | last name | email              | country | address 1     | address 2 | city   | zip code | shipment method | requested delivery date | sku          ||
    ...    || 2         | New address      | Mr         | Edit       | Shipment  | ${yves_user_email} | Germany | Hartmanngasse | 9         | Vienna | 0987     | DHL - Express   | 2025-01-25              | 005_30663301 ||
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    3
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 2          | DHL             | Standard        |  €0.00         | ASAP                    ||
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 3          | DHL             | Express         |  €0.00         | 2025-01-25              ||
    Zed: xxx shipment should/not contain the following products:    1    true    007_30691822
    Zed: xxx shipment should/not contain the following products:    1    false    012_25904598
    Zed: xxx shipment should/not contain the following products:    2    true    012_25904598
    Zed: xxx shipment should/not contain the following products:    3    true    005_30663301
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €225.87
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses

Zed_navigation_ordering_and_naming
    [Documentation]    Verifies each left navigation node can be opened
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: verify first navigation root menus
    Zed: verify root menu icons
    Zed: verify second navigation root menus

Minimum_Order_Value
    [Documentation]    checks that global minimum and maximun order thresholds can be applied
    [Setup]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate following discounts from Overview page:    Free Acer Notebook    Tu & Wed $5 off 5 or more    10% off $100+    Free smartphone    20% off cameras    Free Acer M2610    Free standard delivery    10% off Intel Core    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses
    ...    AND    Yves: create a new customer address in profile:     Mr    ${yves_user_first_name}    ${yves_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: change global threshold settings:
    ...    || store & currency | minimum hard value | minimum hard en message  | minimum hard de message  | maximun hard value | maximun hard en message | maximun hard de message | soft threshold                | soft threshold value | soft threshold fixed fee | soft threshold en message | soft threshold de message ||
    ...    || DE - Euro [EUR]  | 5                  | EN minimum {{threshold}} | DE minimum {{threshold}} | 150                | EN max {{threshold}}    | DE max {{threshold}}    | Soft Threshold with fixed fee | 100000               | 9                        | EN fixed {{fee}} fee      | DE fixed {{fee}} fee      ||
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: soft threshold surcharge is added in the cart:    €9.00
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_user_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: soft threshold surcharge is added on summary page:    €9.00
    Yves: hard threshold is applied with the following message:    €150.00
    Yves: go to the 'Home' page
    Yves: go to b2c shopping cart
    Yves: delete product from the shopping cart with name:    Canon IXUS 175
    Yves: soft threshold surcharge is added in the cart:    €9.00
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: soft threshold surcharge is added on summary page:    €9.00
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €153.38
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: activate following discounts from Overview page:    Free Acer Notebook    Tu & Wed $5 off 5 or more    10% off $100+    Free smartphone    20% off cameras    Free Acer M2610    Free standard delivery    10% off Intel Core    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order
    ...    AND    Zed: change global threshold settings:
    ...    || store & currency | minimum hard value | minimum hard en message | minimum hard de message | maximun hard value | maximun hard en message                                                                                   | maximun hard de message                                                                                                              | soft threshold | soft threshold value | soft threshold en message | soft threshold de message ||
    ...    || DE - Euro [EUR]  | ${SPACE}           | ${SPACE}                | ${SPACE}                | 10000.00           | The cart value cannot be higher than {{threshold}}. Please remove some items to proceed with the order    | Der Warenkorbwert darf nicht höher als {{threshold}} sein. Bitte entfernen Sie einige Artikel, um mit der Bestellung fortzufahren    | None           | ${EMPTY}             | ${EMPTY}                  | ${EMPTY}                  ||
    ...    AND    Trigger p&s
    
Order_Cancelation
    [Documentation]    Check that customer is able to cancel order
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: check if cart is not empty and clear it
    Yves: delete all user addresses
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed    
    Trigger oms
    Yves: go to 'Order History' page
    Yves: get the last placed order ID by current customer
    Yves: cancel the order:    ${lastPlacedOrder}
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: wait for order item to be in state:    005_30663301    canceled
    ### NOT FINISHED AS NO REQUIREMENTS FOR MP CASE
    # Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    # Yves: go to PDP of the product with sku:    005_30663301
    # Yves: add product to the shopping cart
    # Yves: go to PDP of the product with sku:    007_30691822
    # Yves: add product to the shopping cart
    # Yves: go to b2c shopping cart
    # Yves: click on the 'Checkout' button in the shopping cart
    # Yves: billing address same as shipping address:    true
    # Yves: fill in the following new shipping address:
    # ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    # ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    # Yves: submit form on the checkout
    # Yves: select the following shipping method on the checkout and go next:    Express
    # Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    # Yves: 'submit the order' on the summary page
    # Yves: accept the terms and conditions:    true
    # Yves: 'Thank you' page is displayed    
    # Yves: go to 'Order History' page
    # Yves: get the last placed order ID by current customer
    # ### change the order state of one product ###
    # Zed: login on Zed with provided credentials:    ${zed_admin_email}
    # Zed: go to order page:    ${lastPlacedOrder}
    # Zed: trigger matching state of order item inside xxx shipment:    005_30663301    Pay
    # Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    # Yves: go to 'Order History' page
    # Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    # Yves: 'Order Details' page contains the cancel order button:    true
    # Zed: login on Zed with provided credentials:    ${zed_admin_email}
    # Zed: go to order page:    ${lastPlacedOrder}
    # Zed: trigger matching state of order item inside xxx shipment:    005_30663301    Skip timeout 
    # Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    # Yves: go to 'Order History' page
    # Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    # Yves: 'Order Details' page contains the cancel order button:    false
    # ### change state of state of all products ###
    # Zed: login on Zed with provided credentials:    ${zed_admin_email}
    # Zed: go to order page:    ${lastPlacedOrder}
    # Zed: trigger matching state of order item inside xxx shipment:    007_30691822    Pay
    # Zed: trigger matching state of order item inside xxx shipment:    007_30691822    Skip timeout
    # Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    # Yves: go to 'Order History' page
    # Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    # Yves: 'Order Details' page contains the cancel order button:    false
    # [Teardown]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    # ...    AND    Yves: check if cart is not empty and clear it
    # ...    AND    Yves: delete all user addresses

Multistore_Product_Offer
    [Documentation]    check product and offer multistore functionality
    [Setup]    Repeat Keyword    3    Trigger multistore p&s
    MP: login on MP with provided credentials:    ${merchant_budget_cameras_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku            | product name               | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || multistoreSKU${random} | multistoreProduct${random} | packaging_unit       | Item                        | Box                          | series                | Ace Plus               ||
    MP: perform search by:    multistoreProduct${random}
    MP: click on a table row that contains:     multistoreProduct${random}
    MP: fill abstract product required fields:
    ...    || product name DE            | store | store 2 |  tax set           ||
    ...    || multistoreProduct${random} | DE    | AT      | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 1           | DE    | EUR      | 100           | 90             ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 2           | AT    | EUR      | 300           | 90             ||
    MP: save abstract product 
    Trigger multistore p&s
    MP: click on a table row that contains:    multistoreProduct${random}
    MP: open concrete drawer by SKU:    multistoreSKU${random}-1
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    MP: open concrete drawer by SKU:    multistoreSKU${random}-1
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 50            ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 2          | AT    | EUR      | 55            ||
    MP: save concrete product
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     multistoreProduct${random}     Approve
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}  
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:     multistoreSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Budget Cameras    true
    Yves: product price on the PDP should be:    €50.00    wait_for_p&s=true
    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    multistoreSKU${random}-1
    MP: click on a table row that contains:    multistoreSKU${random}-1
    MP: fill offer fields:
    ...    || is active | merchant sku                   | store | store 2 | stock quantity ||
    ...    || true      | multistoreMerchantSKU${random} | DE    | AT      | 100            ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | CHF      | 100           ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 2          | DE    | EUR      | 200           | 1        ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 3          | AT    | EUR      | 10            | 1        ||
    MP: save offer
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:     multistoreSKU${random}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Yves: merchant's offer/product price should be:    Video King    €200.00
    Yves: go to AT store 'Home' page if other store not specified:
    Trigger multistore p&s
    Yves: go to PDP of the product with sku:     multistoreSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Budget Cameras    true
    Yves: product price on the PDP should be:    €55.00    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Yves: merchant's offer/product price should be:    Video King    €10.00
    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    MP: open navigation menu tab:    Offers
    MP: perform search by:    multistoreSKU${random}-1
    MP: click on a table row that contains:    multistoreSKU${random}-1
    MP: fill offer fields:
    ...    || is active | unselect store ||
    ...    || true      | AT             ||         
    MP: save offer
    Trigger multistore p&s
    Yves: go to AT store 'Home' page if other store not specified:
    Trigger multistore p&s
    Yves: go to PDP of the product with sku:     multistoreSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    false
    Save current URL
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: update abstract product data:
    ...    || productAbstract        | unselect store ||
    ...    || multistoreSKU${random} | AT             ||
    Trigger multistore p&s
    Yves: navigate to specified AT store URL if no other store is specified and refresh until 404 occurs:    ${url}
    [Teardown]    Run Keywords    Should Test Run
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     multistoreSKU${random}     Deny
    ...    AND    Trigger multistore p&s

Multistore_CMS
    [Documentation]    check CMS multistore functionality
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Content    Pages
    Zed: create a cms page and publish it:    Multistore Page${random}    multistore-page${random}    Multistore Page    Page text
    Trigger multistore p&s
    Yves: go to newly created page by URL on AT store if other store not specified:    en/multistore-page${random}
    Save current URL
    Yves: page contains CMS element:    CMS Page Title    Multistore Page
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: update cms page and publish it:
    ...    || cmsPage                  | unselect store ||
    ...    || Multistore Page${random} | AT             ||
    Yves: navigate to specified AT store URL if no other store is specified and refresh until 404 occurs:    ${url}
    [Teardown]    Run Keywords    Should Test Run
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Content    Pages
    ...    AND    Zed: click Action Button in a table for row that contains:    Multistore Page${random}    Deactivate
    ...    AND    Trigger multistore p&s

Product_Availability_Calculation
    [Documentation]    Check product availability + multistore. DMS-ON: https://spryker.atlassian.net/browse/FRW-7477
    Repeat Keyword    3    Trigger multistore p&s
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku              | product name                 | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || availabilitySKU${random} | availabilityProduct${random} | packaging_unit       | Item                        | Box                          | series                | Ace Plus               ||
    MP: perform search by:    availabilityProduct${random}
    MP: click on a table row that contains:     availabilityProduct${random}
    MP: fill abstract product required fields:
    ...    || product name DE              | store | store 2 | tax set           ||
    ...    || availabilityProduct${random} | DE    | AT      | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 1           | DE    | EUR      | 100           | 90             ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 2           | AT    | EUR      | 200           | 90             ||
    MP: save abstract product 
    Trigger multistore p&s
    MP: click on a table row that contains:    availabilityProduct${random}
    MP: open concrete drawer by SKU:    availabilitySKU${random}-1
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 5              | true              | en_US         ||
    MP: open concrete drawer by SKU:    availabilitySKU${random}-1
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 50            ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 2          | AT    | EUR      | 50            || 
    MP: save concrete product
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     availabilityProduct${random}     Approve
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}   
    Yves: go to PDP of the product with sku:     availabilitySKU${random}    wait_for_p&s=true
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-1 only has availability of 5.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: assert merchant of product in b2c cart:    availabilityProduct${random}    Spryker
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    DHL    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Yves: go to PDP of the product with sku:     availabilitySKU${random}
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-1 only has availability of 2.
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    Cancel
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:     availabilitySKU${random}
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-1 only has availability of 5.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: assert merchant of product in b2c cart:    availabilityProduct${random}    Spryker
    Yves: go to AT store 'Home' page if other store not specified:
    Trigger multistore p&s
    Yves: go to PDP of the product with sku:     availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: update warehouse:    
    ...    || warehouse                                         | unselect store || 
    ...    || Spryker ${merchant_spryker_reference} Warehouse 1 | AT             ||
    Trigger multistore p&s
    Yves: go to AT store 'Home' page if other store not specified:
    Yves: go to PDP of the product with sku:     availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
    [Teardown]    Run Keywords    Should Test Run
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:      availabilitySKU${random}     Deny
    ...    AND    Zed: update warehouse:    
    ...    || warehouse                                         | store || 
    ...    || Spryker ${merchant_spryker_reference} Warehouse 1 | AT    ||
    ...    AND    Trigger multistore p&s

Offer_Availability_Calculation
    [Documentation]    check offer availability
    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku      | product name          | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || offAvKU${random} | offAvProduct${random} | packaging_unit       | Item                        | Box                          | series                | Ace Plus               ||
    MP: perform search by:    offAvProduct${random}
    MP: click on a table row that contains:     offAvProduct${random}
    MP: fill abstract product required fields:
    ...    || product name DE       | store | store 2 | tax set           ||
    ...    || offAvProduct${random} | DE    | AT      | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 1           | DE    | EUR      | 100           | 90             ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 2           | AT    | EUR      | 200           | 90             ||
    MP: save abstract product 
    Trigger multistore p&s
    MP: click on a table row that contains:    offAvProduct${random}
    MP: open concrete drawer by SKU:    offAvKU${random}-1
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 5              | true              | en_US         ||
    MP: open concrete drawer by SKU:    offAvKU${random}-1
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 50            ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 2          | AT    | EUR      | 50            || 
    MP: save concrete product
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     offAvProduct${random}     Approve
    Trigger multistore p&s
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    offAvKU${random}-1
    MP: click on a table row that contains:    offAvKU${random}-1
    MP: fill offer fields:
    ...    || is active | merchant sku      | store | stock quantity ||
    ...    || true      | offAvMKU${random} | DE    | 5              ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | CHF      | 100           ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 2          | DE    | EUR      | 200           | 1        ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 3          | AT    | EUR      | 10            | 1        ||
    MP: save offer
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:     offAvKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    Yves: merchant's offer/product price should be:    Spryker    €200.00
    Yves: select xxx merchant's offer:    Spryker
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item offAvKU${random}-1 only has availability of 5.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: assert merchant of product in b2c cart:    offAvProduct${random}    Spryker
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    DHL    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Yves: go to PDP of the product with sku:     offAvKU${random}
    Yves: select xxx merchant's offer:    Spryker
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item offAvKU${random}-1 only has availability of 2.
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    Cancel
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:     offAvKU${random}
    Yves: select xxx merchant's offer:    Spryker
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item offAvKU${random}-1 only has availability of 5.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: assert merchant of product in b2c cart:    offAvProduct${random}    Spryker
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:      offAvProduct${random}     Deny
    ...    AND    Trigger p&s

User_Control
    [Documentation]    Create a user with limited access
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create new role with name:    controlRole${random}
    Zed: apply access permissions for user role:    ${full_access}    ${full_access}    ${full_access}   ${permission_allow}
    Zed: apply access permissions for user role:    ${bundle_access}    ${controller_access}    ${action_access}    ${permission_deny}
    Zed: create new group with role assigned:   controlGroup${random}    controlRole${random}
    Zed: create new Zed user with the following data:    sonia+control${random}@spryker.com   change${random}    First Control    Last Control    ControlGroup${random}    This user is an agent in Storefront    en_US    
    Zed: login on Zed with provided credentials:   sonia+control${random}@spryker.com    change${random}
    Zed: go to second navigation item level:    Catalog    Attributes
    Zed: click button in Header:    Create Product Attribute
    Zed: validate the message when permission is restricted:    Access denied
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: deactivate the created user:    sonia+control${random}@spryker.com
    Zed: login with deactivated user/invalid data:    sonia+control${random}@spryker.com    change${random}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Users    User Roles
    ...    AND    Zed: click Action Button in a table for row that contains:    controlRole${random}    Delete

Reorder
    [Documentation]    Checks that merchant relation is saved with reorder
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: assert merchant of product in b2c cart:    Canon IXUS 285    Spryker
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName | lastName | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | Guest     | User     | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:    Reorder    ${lastPlacedOrder}
    Yves: assert merchant of product in b2c cart:    Canon IXUS 285    Spryker
    [Teardown]    Run Keywords    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses

Update_Customer_Data
    [Documentation]    Checks customer data can be updated from Yves and Zed
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    My Profile
    Yves: 'Profile' page is displayed
    Yves: assert customer profile data:
    ...    || salutation | first name                     | last name                     | email                     ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | ${yves_second_user_email} ||
    Yves: update customer profile data:
    ...    || salutation | first name                            | last name                            ||
    ...    || Dr.        | updated${yves_second_user_first_name} | updated${yves_second_user_last_name} ||
    Yves: assert customer profile data:
    ...    || salutation | first name                            | last name                            ||
    ...    || Dr.        | updated${yves_second_user_first_name} | updated${yves_second_user_last_name} ||
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: assert customer profile data:
    ...    || email                     | salutation | first name                            | last name                            ||
    ...    || ${yves_second_user_email} | Dr         | updated${yves_second_user_first_name} | updated${yves_second_user_last_name} ||
    Zed: update customer profile data:
    ...    || email                     | salutation | first name                     | last name                     ||
    ...    || ${yves_second_user_email} | Mr         | ${yves_second_user_first_name} | ${yves_second_user_last_name} ||
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    My Profile
    Yves: 'Profile' page is displayed
    Yves: assert customer profile data:
    ...    || salutation | first name                     | last name                     | email                     ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | ${yves_second_user_email} ||
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: update customer profile data:
    ...    || email                     | salutation | first name                     | last name                     ||
    ...    || ${yves_second_user_email} | Mr         | ${yves_second_user_first_name} | ${yves_second_user_last_name} ||

Glossary
    [Documentation]    Create + edit glossary translation in BO
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Administration    Glossary  
    Zed: click button in Header:    Create Translation
    Zed: fill glossary form:
    ...    || Name                     | EN_US                        | DE_DE                             ||
    ...    || cart.price.test${random} | This is a sample translation | Dies ist eine Beispielübersetzung ||
    Zed: submit the form
    Zed: table should contain:    cart.price.test${random}
    Zed: go to second navigation item level:    Administration    Glossary 
    Zed: click Action Button in a table for row that contains:    ${glossary_name}    Edit
    Zed: fill glossary form:
    ...    || DE_DE                    | EN_US                              ||
    ...    || ${original_DE_text}-Test | ${original_EN_text}-Test-${random} ||
    Zed: submit the form
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: validate the page title:    ${original_EN_text}-Test-${random}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: undo the changes in glossary translation:    ${glossary_name}     ${original_DE_text}    ${original_EN_text}
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: validate the page title:    ${original_EN_text}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: undo the changes in glossary translation:    ${glossary_name}     ${original_DE_text}    ${original_EN_text}
    ...    AND    Trigger p&s

Configurable_Product_PDP_Wishlist
    [Documentation]    Configure product from PDP and Wishlist. DMS-ON: https://spryker.atlassian.net/browse/FRW-6380
    [Tags]    robot:skip    
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: create new 'Whistist' with name:    configProduct${random}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses
    ...    AND    Yves: create a new customer address in profile:     Mr    ${yves_user_first_name}    ${yves_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: change variant of the product on PDP on:    ${configurable_product_concrete_one_attribute}
    Yves: PDP contains/doesn't contain:    true    ${configureButton}
    Yves: check and go back that configuration page contains:
    ...    || store | locale | price_mode | currency | customer_id            | sku                                      ||
    ...    || DE    | en_US  | GROSS_MODE | EUR      | ${yves_user_reference} | ${configurable_product_concrete_one_sku} ||
    Yves: change the product configuration to:
    ...    || date       | date_time ||
    ...    || 12.12.2030 | Evening   ||
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: configuration should be equal:
    ...    || date       | date_time ||
    ...    || 12.12.2030 | Evening   ||
    Yves: change the product configuration to:
    ...    || date  | date_time ||
    ...    ||       | Afternoon ||
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: change the product configuration to:    
    ...    || date       | date_time ||
    ...    || 05.05.2035 | Afternoon ||
    Yves: configuration should be equal:
    ...    || date       | date_time ||
    ...    || 05.05.2035 | Afternoon ||
    Yves: change the product configuration to:
    ...    || date  | date_time ||
    ...    ||       | Afternoon ||
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: checkout is blocked with the following message:    This cart can't be processed. Please configure items inside the cart.
    Yves: go to the 'Home' page
    Yves: go to b2c shopping cart
    Yves: delete product from the shopping cart with name:    ${configurable_product_name}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: change variant of the product on PDP on:    ${configurable_product_concrete_two_attribute}
    Yves: change the product configuration to:
    ...    || date       | date_time ||
    ...    || 01.01.2055 | Morning   ||
    Yves: add product to wishlist:    configProduct${random}    select
    Yves: go to wishlist with name:    configProduct${random}
    Yves: wishlist contains product with sku:    ${configurable_product_concrete_two_sku}
    Yves: configuration should be equal:
    ...    || date       | date_time ||
    ...    || 01.01.2055 | Morning   ||
    Yves: change the product configuration to:
    ...    || date       | date_time ||
    ...    || 01.01.2055 | Afternoon ||
    Yves: configuration should be equal:
    ...    || date       | date_time ||
    ...    || 01.01.2055 | Afternoon ||
    Yves: add all available products from wishlist to cart
    Yves: go to b2c shopping cart
    Yves: configuration should be equal:
    ...    || date       | date_time ||
    ...    || 01.01.2055 | Afternoon ||
    Yves: shopping cart contains product with unit price:    ${configurable_product_concrete_two_sku}    ${configurable_product_name}    ${configurable_product_concrete_two_price}
    [Teardown]    Run Keywords    Yves: delete all wishlists
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses

Configurable_Product_OMS
    [Documentation]    Conf Product OMS check and reorder. DMS-ON: https://spryker.atlassian.net/browse/FRW-6380
    [Tags]    robot:skip
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses
    ...    AND    Yves: create a new customer address in profile:     Mr    ${yves_user_first_name}    ${yves_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: change variant of the product on PDP on:    ${configurable_product_concrete_one_attribute}
    Yves: change the product configuration to:
    ...    || date       | date_time ||
    ...    || 12.12.2030 | Evening   ||
    Yves: add product to the shopping cart
    Yves: reset selected variant of the product on PDP
    Yves: change variant of the product on PDP on:    ${configurable_product_concrete_two_attribute}
    Yves: change the product configuration to:
    ...    || date       | date_time ||
    ...    || 01.01.2055 | Afternoon ||
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: configuration should be equal:
    ...    || date       | date_time ||
    ...    || 12.12.2030 | Evening   ||
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_user_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €316.67
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: product configuration should be equal:
    ...    || shipment | position | sku                                      | date       | date_time ||
    ...    || 1        | 1        | ${configurable_product_concrete_one_sku} | 12.12.2030 | Evening   ||
    Zed: product configuration should be equal:
    ...    || shipment | position | sku                                      | date       | date_time ||
    ...    || 1        | 2        | ${configurable_product_concrete_two_sku} | 01.01.2055 | Afternoon ||
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay   
    Zed: trigger all matching states inside this order:    skip picking
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    send to distribution
    Zed: trigger matching state of xxx merchant's shipment:    1    confirm at center
    Zed: trigger matching state of xxx order item inside xxx shipment:    Ship    2
    Zed: trigger matching state of xxx order item inside xxx shipment:    Deliver    2
    Zed: trigger matching state of xxx order item inside xxx shipment:    Refund    2
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €37.50
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx order item inside xxx shipment:    Ship    1
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to user menu:    Orders History
    Yves: 'Order History' page is displayed
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    ${configurable_product_concrete_one_sku}
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    ${configurable_product_concrete_one_sku}
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Orders    
    MP: wait for order to appear:    ${lastPlacedOrder}--${merchant_spryker_reference}
    MP: click on a table row that contains:    ${lastPlacedOrder}--${merchant_spryker_reference}
    MP: update order state using header button:    Execute return
    MP: order states on drawer should contain:    Returned
    MP: order states on drawer should contain:    Refunded  
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to user menu:    Orders History
    ### Reorder ###
    Yves: 'View Order/Reorder/Return' on the order history page:    Reorder    ${lastPlacedOrder}
    Yves: go to b2c shopping cart
    Yves: shopping cart contains the following products:     ${configurable_product_name}
    Yves: configuration should be equal:
    ...    || date       | date_time ||
    ...    || 12.12.2030 | Evening   ||
    [Teardown]    Yves: check if cart is not empty and clear it
    
Data_exchange_API_download_specification
    [Documentation]    DMS-ON: https://spryker.atlassian.net/browse/FRW-7396
    [Setup]    Trigger API specification update
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: download data exchange api specification should be active:    true
    Zed: download data exchange api specification
    Zed: check that downloaded api specification contains:    /dynamic-entity/product-abstracts
    Zed: check that downloaded api specification does not contain:    /dynamic-entity/mime-types
    Zed: delete dowloaded api specification
    Zed: start creation of new data exchange api configuration for db table:    spy_mime_type
    Zed: edit data exchange api configuration:
    ...    || table_name  | is_enabled ||
    ...    || mime-types  | true       ||
    Zed: edit data exchange api configuration:
    ...    || field_name   | enabled | visible_name | type    | creatable | editable | required ||
    ...    || id_mime_type | true    | id_mime_type | integer | true      | false    | false    ||
    Zed: edit data exchange api configuration:
    ...    || field_name  | enabled | visible_name | type    | creatable | editable | required ||
    ...    || comment     | true    | comment      | string  | true      | true     | false    ||
    Zed: edit data exchange api configuration:
    ...    || field_name  | enabled | visible_name | type    | creatable | editable | required ||
    ...    || extensions  | true    | extensions   | string  | true      | true     | false    ||
    Zed: edit data exchange api configuration:
    ...    || field_name  | enabled | visible_name | type    | creatable | editable | required ||
    ...    || is_allowed  | true    | is_allowed   | boolean | true      | true     | true     ||
    Zed: edit data exchange api configuration:
    ...    || field_name | enabled | visible_name | type   | creatable | editable | required ||
    ...    || name       | true    | name         | string | true      | true     | true     ||
    Zed: save data exchange api configuration
    Zed: download data exchange api specification should be active:    false
    Trigger API specification update
    Zed: wait until info box is not displayed
    Zed: download data exchange api specification
    Zed: check that downloaded api specification contains:    /mime-types
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: edit data exchange api configuration:
    ...    || table_name  | is_enabled ||
    ...    || mime-types  | false      ||
    ...    AND    Zed: save data exchange api configuration
    ...    AND    Trigger API specification update
    ...    AND    Zed: wait until info box is not displayed
    ...    AND    Zed: delete dowloaded api specification
    ...    AND    Delete dynamic entity configuration in Database:    mime-types
    ...    AND    Trigger API specification update

Data_exchange_API_Configuration_in_Zed
    [Documentation]    DMS-ON: https://spryker.atlassian.net/browse/FRW-7396
    [Tags]    bapi
    [Setup]    Trigger API specification update
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: start creation of new data exchange api configuration for db table:    spy_mime_type
    Zed: edit data exchange api configuration:
    ...    || table_name  | is_enabled ||
    ...    || mime-types  | true       ||
    Zed: edit data exchange api configuration:
    ...    || field_name   | enabled | visible_name | type    | creatable | editable | required ||
    ...    || id_mime_type | true    | id_mime_type | integer | true      | false    | false    ||
    Zed: edit data exchange api configuration:
    ...    || field_name  | enabled | visible_name | type    | creatable | editable | required ||
    ...    || comment     | true    | comment      | string  | true      | true     | false    ||
    Zed: edit data exchange api configuration:
    ...    || field_name  | enabled | visible_name | type    | creatable | editable | required ||
    ...    || extensions  | true    | extensions   | string  | true      | true     | false    ||
    Zed: edit data exchange api configuration:
    ...    || field_name  | enabled | visible_name | type    | creatable | editable | required ||
    ...    || is_allowed  | true    | is_allowed   | boolean | true      | true     | true     ||
    Zed: edit data exchange api configuration:
    ...    || field_name | enabled | visible_name | type   | creatable | editable | required ||
    ...    || name       | true    | name         | string | true      | true     | true     ||
    Zed: save data exchange api configuration
    Trigger API specification update
    Trigger multistore p&s
    Zed: wait until info box is not displayed
    API_test_setup
    I get access token by user credentials:   ${zed_admin_email}
    ### CREATE TEST MIME TYPE USING DATA EXCHANGE API ###
    I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    I send a POST request:    /dynamic-entity/mime-types    {"data":[{"name":"POST ${random}","is_allowed":${false},"extensions":"[\\"fake\\"]"}]}
    Response status code should be:    201
    Response header parameter should be:    Content-Type    application/json
    Response body parameter should be:    [data][0][name]    POST ${random}
    Response body parameter should be:    [data][0][is_allowed]    False
    Response body parameter should be:    [data][0][extensions]    "fake"
    Response body parameter should be:    [data][0][comment]    None
    Save value to a variable:    [data][0][id_mime_type]    id_mime_type
    ### UPDATE TEST MIME TYPE USING DATA EXCHANGE API ###
    I send a PATCH request:    /dynamic-entity/mime-types/${id_mime_type}    {"data":{"comment":${null},"extensions":"[\\"dummy\\"]","is_allowed":${true},"name":"PATCH ${random}"}}
    Response status code should be:    200
    ### GET UPDATE TEST MIME TYPE BY ID ###
    I send a GET request:    /dynamic-entity/mime-types/${id_mime_type}
    Response status code should be:    200
    Response header parameter should be:    Content-Type    application/json
    Response body parameter should be:    [data][name]    PATCH ${random}
    Response body parameter should be:    [data][is_allowed]    True
    Response body parameter should be:    [data][extensions]    "dummy"
    Response body parameter should be:    [data][comment]    None
    ### DELETE TEST CONFIGURATION AND TEST MIME TYPE FROM DB ###
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: edit data exchange api configuration:
    ...    || table_name  | is_enabled ||
    ...    || mime-types  | false      ||
    ...    AND    Zed: save data exchange api configuration
    ...    AND    Trigger API specification update
    ...    AND    Zed: wait until info box is not displayed
    ...    AND    Delete dynamic entity configuration in Database:    mime-types
    ...    AND    Delete mime_type by id_mime_type in Database:    ${id_mime_type}
    ...    AND    Trigger API specification update  

Fulfilment_app_e2e
    [Documentation]    DMS-ON: https://spryker.atlassian.net/browse/FRW-7463
    # #LOGGED IN TO BO and SET CHECKBOX is a warehouse user = true FOR admin_de USER. UI TEST
    Make user a warehouse user/ not a warehouse user:    ${warehous_user[0].de_admin_user_uuid}    0
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: update Zed user:
    ...    || oldEmail             | user_is_warehouse_user ||
    ...    || admin_de@spryker.com | true                   ||
    Remove Tags    *
    Set Tags   bapi
    API_test_setup
    # #ASSIGN admin_de user TO WAREHOUSE [Spryker Mer 000001 Warehouse 1] MAKE WAREHOUSE ACTIVE BY BAPI
    And I get access token by user credentials:   ${zed_admin_email}
    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehous_user[0].de_admin_user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"true"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assigment_id  
    # #CREATE AN ORDER BY GLUE
    I set Headers:    Content-Type=${default_header_content_type}
    Remove Tags    *
    Set Tags    glue
    API_test_setup
    When I get access token for the customer:    ${yves_user_email}    
    Then I set Headers:    Authorization=${token}
    When Find or create customer cart
    Then Cleanup all items in the cart:    ${cart_id}
    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "091_25873091","quantity": 1}}}
    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "093_24495843","quantity": 1}}}
    I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": True,"isDefaultShipping": True},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": True,"isDefaultShipping": True},"payments": [{"paymentProviderName": "${payment_provider_name_1}","paymentMethodName": "${payment_method_name_1}"}],"shipment": {"idShipmentMethod": 1},"items": ["091_25873091","093_24495843"]}}}
    Then Response status code should be:    200
    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": False,"isDefaultShipping": False},"payments": [{"paymentProviderName": "${payment_provider_name_1}","paymentMethodName": "${payment_method_name_1}"}],"shipment": {"idShipmentMethod": 1},"items": ["091_25873091","093_24495843"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    And Save value to a variable:    [included][0][attributes][items][1][uuid]    uuid1
    # #MOVE ORDER ITEMS INTO WAITING STATE
    UI_test_setup
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: get the last placed order ID by current customer
    Trigger oms
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay 
    Zed: wait for order item to be in state:    091_25873091    confirmed
    Zed: wait for order item to be in state:    093_24495843    confirmed
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: wait for order item to be in state:    091_25873091    waiting
    Zed: wait for order item to be in state:    093_24495843    waiting
    # #MOVE ORDER ITEMS TO PROPER STATE USING BO, PICKING LIST GENERATED AUTOMATICALLY. UI TEST
    Zed: trigger all matching states inside this order:    picking list generation schedule
    Zed: wait for order item to be in state:    091_25873091    picking list generation started
    Zed: wait for order item to be in state:    093_24495843    picking list generation started
    # #ORDER READY FOR PICKING
    Zed: wait for order item to be in state:    091_25873091    ready for picking
    Zed: wait for order item to be in state:    093_24495843    ready for picking
    # #START PICKING PROCESS AND PICKING ITEMS BY BAPI
    Remove Tags    *
    Set Tags   bapi
    API_test_setup
    I set Headers:    Content-Type=${default_header_content_type}
    Then I get access token by user credentials:   ${zed_admin_email_de}
    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    I send a GET request:    /picking-lists/?include=picking-list-items,concrete-products,sales-shipments,sales-orders,warehouses
    Then Response status code should be:    200
    Then Save value to a variable:    [data][0][id]    picklist_id
    And Response body parameter should be:    [data][0][type]    picking-lists
    Then Save value to a variable:    [data][0][relationships][picking-list-items][data][0][id]    item_id_1
    Then Save value to a variable:    [data][0][relationships][picking-list-items][data][1][id]    item_id_2
    And Response body parameter should be:    [data][0][attributes][status]    ready-for-picking
    And Response body parameter should be in:    [included][0][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
    And Response body parameter should be in:    [included][1][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
    And Response body parameter should be in:    [included][2][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
    And Response body parameter should be in:    [included][3][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
    And Response body parameter should be in:    [included][4][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
    And Response body parameter should be in:    [included][5][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
    And Response body parameter should be in:    [included][6][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
    And Each array in response should contain property with NOT EMPTY value:    [included]    id
    # #START PICKING
    I send a POST request:   /picking-lists/${picklist_id}/start-picking    {"data": [{"type": "picking-lists","attributes": {"action": "startPicking"}}]}
    Then Response status code should be:    201
    And Response body parameter should be:    [data][attributes][status]    picking-started
    And Response body parameter should be:    [data][type]    picking-lists
    And Response body parameter should not be EMPTY:    [data][id]
    # #PICKING ONE ITEM, ANOTHER ITEM STILL NOT PICKED
    Then I send a PATCH request:    /picking-lists/${picklist_id}/picking-list-items    {"data":[{"id":"${item_id_1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item_id_2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":0}}]}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][attributes][status]    picking-started
    And Response body parameter should be in:    [data][0][relationships][picking-list-items][data][0][id]    ${item_id_1}    ${item_id_2}
    And Response body parameter should be in:    [data][0][relationships][picking-list-items][data][1][id]    ${item_id_1}    ${item_id_2}
    # #PICKING SECOND ITEM, PICKING FINISHED
    Then I send a PATCH request:    /picking-lists/${picklist_id}/picking-list-items    {"data":[{"id":"${item_id_1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item_id_2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":1}}]}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][attributes][status]    picking-finished
    # #CLEAN SYSTEM, REMOVE CREATED RELATIONS IN DB
    [Teardown]     Run Keywords    Remove picking list item by uuid in DB:    ${item_id_1}
    ...  AND    Remove picking list item by uuid in DB:    ${item_id_2} 
    ...  AND    Remove picking list by uuid in DB:    ${picklist_id}
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehous_user[0].de_admin_user_uuid}    0
    ...  AND    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assigment_id}     

Click_and_collect
    [Documentation]    checks that product offer is successfully replaced with a target product offer
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate all discounts from Overview page
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku              | product name                 | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || clickCollectSku${random} | clickCollectProduct${random} | packaging_unit       | Item                        | Box                          | series                | Ace Plus               ||
    MP: perform search by:    clickCollectProduct${random} 
    MP: click on a table row that contains:     clickCollectSku${random}
    MP: fill abstract product required fields:
    ...    || product name DE              | store | tax set           ||
    ...    || clickCollectProduct${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || abstract     | 1          | DE    | EUR      | 50            ||
    MP: save abstract product
    MP: click on a table row that contains:    clickCollectSku${random}
    MP: open concrete drawer by SKU:    clickCollectSku${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     clickCollectSku${random}     Approve 
    Trigger p&s 
    MP: login on MP with provided credentials:    ${merchant_budget_cameras_email}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    clickCollectSku${random}-2
    MP: click on a table row that contains:    clickCollectSku${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku                           | store | stock quantity | service point      | services | shipment types  ||
    ...    || true      | clickCollectFirstSku${random}${random} | DE    | 100            | Spryker Main Store | Pickup   | pickup - Pickup ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | EUR      | 100           ||
    MP: save offer
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    clickCollectSku${random}-2
    MP: click on a table row that contains:    clickCollectSku${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku                            | store | stock quantity | shipment types      ||
    ...    || true      | clickCollectSecondSku${random}${random} | DE    | 100            | delivery - Delivery ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | EUR      | 150           ||
    MP: save offer
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    clickCollectSku${random}-2
    MP: click on a table row that contains:    clickCollectSku${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku                  | store | stock quantity | service point        | services | shipment types  ||
    ...    || true      | clickCollectThirdSku${random} | DE    | 100            | Spryker Berlin Store | Pickup   | pickup - Pickup ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | EUR      | 200           ||
    MP: save offer
    Trigger p&s
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Offers
    Zed: filter by merchant:    Budget Cameras
    Zed: table should contain:    clickCollectSku${random}-2
    Zed: click Action Button in a table for row that contains:     clickCollectSku${random}-2     View
    Zed: view offer page is displayed
    Zed: view offer product page contains:
    ...    || approval status | status | store | sku                        | merchant       | merchant sku                  | services                      | shipment types  ||
    ...    || Approved        | Active | DE    | clickCollectSku${random}-2 | Budget Cameras | clickCollectThirdSku${random} | Spryker Berlin Store - Pickup | pickup - Pickup ||
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:     clickCollectSku${random}    wait_for_p&s=true
    Yves: select xxx merchant's offer with price:    Budget Cameras    €100.00
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: select xxx merchant's offer with price:    Budget Cameras    €150.00
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: select multiple addresses from toggler
    Yves: select xxx shipment type for item number xxx:    shipment_type=Pickup    item_number=1
    Yves: select xxx shipment type for item number xxx:    shipment_type=Pickup    item_number=2
    Yves: check store availabiity for item number xxx:
    ...    || item_number | store              | availability ||
    ...    || 1           | Spryker Main Store | green        ||
    Yves: check store availabiity for item number xxx:
    ...    || item_number | store                | availability ||
    ...    || 1           | Spryker Berlin Store | green        ||
    Yves: check store availabiity for item number xxx:
    ...    || item_number | store              | availability ||
    ...    || 2           | Spryker Main Store | green        ||
    Yves: check store availabiity for item number xxx:
    ...    || item_number | store                | availability ||
    ...    || 2           | Spryker Berlin Store | green        ||
    Yves: select pickup service point store for item number xxx:
    ...    || item_number | store                ||
    ...    || 1           | Spryker Berlin Store ||
    Yves: select pickup service point store for item number xxx:
    ...    || item_number | store                ||
    ...    || 2           | Spryker Berlin Store ||
    Yves: 'billing same as shipping' checkbox should be displayed:    false
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Pickup    Free Pickup
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: checkout summary page contains product with unit price:   sku=clickCollectSku${random}    productName=clickCollectProduct${random}    productPrice=400.00
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €400.00
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    1
    Zed: billing address for the order should be:    First Last, Billing Street 123, 10247 Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    1    Spryker Berlin Store, Mr ${yves_user_first_name}, ${yves_user_last_name}, Julie-Wolfthorn-Straße, 1, 10115, Berlin, Germany
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 1          | Pickup          | Free Pickup     | €0.00          | ASAP                    ||
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: activate following discounts from Overview page:    Free Acer Notebook    Tu & Wed $5 off 5 or more    10% off $100+    Free smartphone    20% off cameras    Free Acer M2610    Free standard delivery    10% off Intel Core    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     clickCollectSku${random}     Deny
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: delete all user addresses
    ...    AND    Trigger p&s

Configurable_Product_Checkout
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses
    ...    AND    Yves: create a new customer address in profile:     Mr    ${yves_user_first_name}    ${yves_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: change variant of the product on PDP on:    ${configurable_product_concrete_one_attribute}
    Yves: PDP contains/doesn't contain:    true    ${configureButton}
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: change the product options in configurator to:
    ...    || option one | option two | option three |option four | option five | option six | option seven | option eight | option nine | option ten       ||
    ...    || 517        | 473        | 100          | 0.00       |  51         | 19         | 367          | 46           | 72          | English Keyboard ||
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: shopping cart contains product with unit price:    sku=${configurable_product_concrete_one_attribute}   productName=${configurable_product_name}    productPrice=1,599.00
    Yves: change the product options in configurator to:
    ...    || option one | option two | option three |option four | option five | option six | option seven | option eight | option nine | option ten      ||
    ...    || 905        | 249        | 100          | 36         |  15         | 0.00       | 48           | 57           | 36          | German Keyboard ||
    Yves: shopping cart contains product with unit price:    sku=${configurable_product_concrete_one_attribute}    productName=${configurable_product_name}    productPrice=1,346.00 
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:   ${yves_user_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)  
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,226.40
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: trigger all matching states inside this order:    skip picking
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    send to distribution
    Zed: trigger matching state of xxx merchant's shipment:    1    confirm at center
    Zed: trigger matching state of xxx order item inside xxx shipment:    Ship    1
    Zed: trigger matching state of xxx order item inside xxx shipment:    Deliver    1
    Zed: trigger matching state of xxx order item inside xxx shipment:    Refund    1
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €0.00

Dynamic-multistore
    [Documentation]  Bug: https://spryker.atlassian.net/browse/FRW-8141  This test should exclusively run for dynamic multi-store scenarios. The test verifies that the user can successfully create a new store, assign a product and CMS page, and register a customer within the new store.
    [Tags]    dms-on
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create new Store:
    ...    || name                                    | locale_iso_code | currency_iso_code | currency_code | currency_iso_code2 | currency_code2 |store_delivery_region ||
    ...    || ${random_str_store}_${random_str_store} | en_US           | Euro              | EUR           | Swiss Franc        | CHF            | AT                   ||
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to AT store 'Home' page if other store not specified:     ${random_str_store}_${random_str_store}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: update abstract product data:
    ...    || store                                    | productAbstract                     ||
    ...    ||  ${random_str_store}_${random_str_store} | ${one_variant_product_abstract_sku} ||
    Zed: update abstract product price on:
    ...    || productAbstract                      | store                                   | mode  | type    | currency | amount | tax set            ||
    ...    || ${one_variant_product_abstract_sku}  | ${random_str_store}_${random_str_store} | gross | default | €        | 160.00 | Smart Electronics  ||   
    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract                     | productConcrete                     | active | searchable en | searchable de ||
    ...    || ${one_variant_product_abstract_sku} | ${one_variant_product_concrete_sku} | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract                     | productConcrete                     | store                                   | mode  | type    | currency | amount ||
    ...    || ${one_variant_product_abstract_sku} | ${one_variant_product_concrete_sku} | ${random_str_store}_${random_str_store} | gross | default | €        | 15.00  ||
    Zed: update warehouse:
    ...    || warehouse  | store                                   || 
    ...    || Warehouse1 | ${random_str_store}_${random_str_store} ||
    Zed: change concrete product stock:
    ...    || productAbstract                     | productConcrete                     | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || ${one_variant_product_abstract_sku} | ${one_variant_product_concrete_sku} | Warehouse1   | 100              | true                            ||
    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract                     | name de                        ||
    ...    || ${one_variant_product_abstract_sku} | DEmanageProduct${random} force ||
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to AT store 'Home' page if other store not specified:    ${random_str_store}_${random_str_store}
    Yves: select currency Euro if other currency not specified
    Yves: create new 'Shopping Cart' with name:    storeCart+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_concrete_sku}
    Yves: product price on the PDP should be:    €15.00
    ### create new cms page and check it in new store on YVES
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Content    Pages
    Zed: create a cms page and publish it:    New Page Store${random}    store-page${random}    Page Title    Page text
    Trigger multistore p&s
    Yves: go to newly created page by URL:    en/store-page${random}
    Yves: page contains CMS element:    CMS Page Title    Page Title
    Yves: page contains CMS element:    CMS Page Content    Page text
    Yves: go to AT store 'Home' page if other store not specified:    ${random_str_store}_${random_str_store}
    Yves: go to newly created page by URL:   en/store-page${random}
    Yves: page contains CMS element:    CMS Page Content    Page text
    ## assigned CMS BLocks to new store
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: assigned store to cms block:    ${random_str_store}_${random_str_store}    customer-registration_token--html
    Zed: assigned store to cms block:    ${random_str_store}_${random_str_store}    customer-registration_token--text
    ## register new customer in the new store on YVES
    Yves: go to AT store 'Home' page if other store not specified:    ${random_str_store}_${random_str_store}
    Register a new customer with data:
    ...    || salutation | first name | last name | e-mail                       | password                      ||
    ...    || Mr.        | New        | User      | sonia+dms${random}@spryker.com  | P${random_str}s#!#${random_id} ||
    Yves: flash message should be shown:    success    Almost there! We send you an email to validate your email address. Please confirm it to be able to log in.
    [Teardown]    Run Keywords    Should Test Run
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Content    Pages
    ...    AND    Zed: click Action Button in a table for row that contains:    New Page Store${random}   Deactivate
    ...    AND    Trigger multistore p&s
    Zed: delete customer:
    ...    || email                       ||
    ...    || sonia+dms${random}@spryker.com ||    
