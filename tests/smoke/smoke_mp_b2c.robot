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
Resource    ../../resources/steps/merchant_profile_steps.robot
Resource    ../../resources/steps/zed_marketplace_steps.robot
Resource    ../../resources/steps/mp_profile_steps.robot
Resource    ../../resources/steps/mp_orders_steps.robot
Resource    ../../resources/steps/mp_offers_steps.robot
Resource    ../../resources/steps/mp_products_steps.robot

*** Test Cases ***
New_Customer_Registration
    [Documentation]    Check that a new user can be registered in the system
    Register a new customer with data:
    ...    || salutation | first name          | last name | e-mail                        | password            ||
    ...    || Mr.        | Test${random}       | User      |  sonia+${random}@spryker.com  | Change123!${random} ||
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
    Yves: shopping cart contains product with unit price:   002    Canon IXUS 160    99.99
    Yves: go to user menu item in header:    Overview
    Yves: 'Login' page is displayed
    Yves: go To 'Wishlist' Page
    Yves: 'Login' page is displayed

Authorized_User_Access
    [Documentation]    Checks that authorized users see products info, cart and profile
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: header contains/doesn't contain:    true    ${currencySwitcher}[${env}]    ${accountIcon}     ${wishlistIcon}    ${shoppingCartIcon}
    Yves: go to PDP of the product with sku:    002
    Yves: PDP contains/doesn't contain:     true    ${pdpPriceLocator}     ${addToCartButton}
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: shopping cart contains product with unit price:    002    Canon IXUS 160    99.99
    Yves: go to user menu item in header:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu item in header:    Orders History
    Yves: 'Order History' page is displayed
    Yves: go To 'Wishlist' Page
    Yves: 'Wishlist' page is displayed
    [Teardown]    Yves: check if cart is not empty and clear it

User_Account
    [Documentation]    Checks user account pages work
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to user menu item in header:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu item in header:    Orders History
    Yves: 'Order History' page is displayed
    Yves: go to user menu item in header:    My Profile
    Yves: 'My Profile' page is displayed
    Yves: go To 'Wishlist' Page
    Yves: 'Wishlist' page is displayed
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: go to user menu item in the left bar:    Newsletter
    Yves: 'Newsletter' page is displayed
    Yves: go to user menu item in the left bar:    Returns
    Yves: 'Returns' page is displayed
    Yves: create a new customer address in profile:     Mr    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    true    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany
    Yves: delete user address:    Kirncher Str. ${random}
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    false    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany

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
    Yves: catalog page contains filter:    Price    Ratings     Label     Brand    Color
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
#     Yves: select product color:    black
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
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}   ${addToCartButton}    ${pdp_limited_warranty_option}    ${pdp_gift_wrapping_option}    ${relatedProducts}
    Yves: PDP contains/doesn't contain:    false    ${pdp_add_to_wishlist_button}
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    135
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}   ${pdp_add_to_cart_disabled_button}[${env}]    ${pdp_limited_warranty_option}    ${pdp_gift_wrapping_option}     ${pdp_add_to_wishlist_button}    ${relatedProducts}
    Yves: change variant of the product on PDP on:    Flash
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}    ${addToCartButton}    ${pdp_limited_warranty_option}    ${pdp_gift_wrapping_option}     ${pdp_add_to_wishlist_button}    ${relatedProducts}

Volume_Prices
    [Documentation]    Checks volume prices are applied
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    193
    Yves: change quantity on PDP:    5
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: shopping cart contains product with unit price:    193    Sony FDR-AX40    825.00
    Yves: delete from b2c cart products with name:    Sony FDR-AX40
    [Teardown]    Yves: check if cart is not empty and clear it

Discontinued_Alternative_Products
    [Documentation]    Checks discontinued and alternative products
    Yves: go to PDP of the product with sku:    ${product_with_relations_alternative_products_sku}
    Yves: change variant of the product on PDP on:    2.3 GHz - Discontinued
    Yves: PDP contains/doesn't contain:    true    ${alternativeProducts}
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: delete all wishlists
    Yves: go to the PDP of the first available product
    Yves: add product to wishlist:    My wishlist
    Yves: get sku of the concrete product on PDP
    Yves: get sku of the abstract product on PDP
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: discontinue the following product:    ${got_abstract_product_sku}    ${got_concrete_product_sku}
    Zed: product is successfully discontinued
    Zed: check if at least one price exists for concrete and add if doesn't:    100
    Zed: add following alternative products to the concrete:    012
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go To 'Wishlist' Page
    Yves: go to wishlist with name:    My wishlist
    Yves: product with sku is marked as discountinued in wishlist:    ${got_concrete_product_sku}
    Yves: product with sku is marked as alternative in wishlist:    012
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}    
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: undo discontinue the following product:    ${got_abstract_product_sku}    ${got_concrete_product_sku}

Back_in_Stock_Notification
    [Documentation]    Back in stock notification is sent and availability check
    [Setup]    Run keywords    Yves: go to the 'Home' page
    ...    AND    Yves: go to the PDP of the first available product
    ...    AND    Yves: get sku of the concrete product on PDP
    ...    AND    Yves: get sku of the abstract product on PDP
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: check if product is/not in stock:    ${got_abstract_product_sku}    true
    Zed: change product stock:    ${got_abstract_product_sku}    ${got_concrete_product_sku}    false    0
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: check if product is/not in stock:    ${got_abstract_product_sku}    false
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:  ${got_abstract_product_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
    Yves: check if product is available on PDP:    ${got_abstract_product_sku}    false
    Yves: submit back in stock notification request for email:    ${yves_second_user_email}
    Yves: unsubscribe from availability notifications
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: change product stock:    ${got_abstract_product_sku}    ${got_concrete_product_sku}    true    0
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: check if product is/not in stock:    ${got_abstract_product_sku}    true
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:  ${got_abstract_product_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: check if product is available on PDP:    ${got_abstract_product_sku}    true
    [Teardown]    Zed: check and restore product availability in Zed:    ${got_abstract_product_sku}    Available    ${got_concrete_product_sku}

Add_to_Wishlist
    [Documentation]    Check creation of wishlist and adding to different wishlists
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: delete all wishlists
    Yves: go to PDP of the product with sku:  003
    Yves: add product to wishlist:    My wishlist
    Yves: go To 'Wishlist' Page
    Yves: create wishlist with name:    Second wishlist
    Yves: go to PDP of the product with sku:  004
    Yves: add product to wishlist:    Second wishlist    select
    Yves: go To 'Wishlist' Page
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

# Product_Bundles
#     ### Product Bundles are not supported by Marketplace for now ###
#     [Documentation]    Checks checkout with Bundle product. Fails due to bug CC-16679
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

Discounts
    [Documentation]    Discounts, Promo Products, and Coupon Codes (includes guest checkout)
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate following discounts from Overview page:    Free Acer Notebook    Tu & Wed $5 off 5 or more    10% off $100+    Free smartphone    20% off cameras    Free Acer M2610    Free standard delivery    10% off Intel Core    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order
    ...    AND    Zed: change product stock:    190    190_25111746    true    10
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Merchandising    Discount
    Zed: create a discount and activate it:    voucher    Percentage    5    sku = '*'    test${random}    discountName=Voucher Code 5% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    10    sku = '*'    discountName=Cart Rule 10% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    100    discountName=Promotional Product 100% ${random}    promotionalProductDiscount=True    promotionalProductAbstractSku=002    promotionalProductQuantity=2
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
    Yves: discount is applied:    cart rule    Promotional Product 100% ${random}    - €199.98
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
    ...    AND    Yves: delete all user addresses
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate following discounts from Overview page:    Voucher Code 5% ${random}    Cart Rule 10% ${random}    Promotional Product 100% ${random}
    ...    AND    Zed: activate following discounts from Overview page:    Free Acer Notebook    Tu & Wed $5 off 5 or more    10% off $100+    Free smartphone    20% off cameras    Free Acer M2610    Free standard delivery    10% off Intel Core    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order

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
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Run Keywords    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses

Agent_Assist
    [Documentation]    Checks that agent can be used
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create new Zed user with the following data:    agent+${random}@spryker.com    change${random}    Agent    Assist    Root group    This user is an agent    en_US
    Yves: go to the 'Home' page
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent+${random}@spryker.com    change${random}
    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: perform search by customer:    ${yves_user_first_name}
    Yves: agent widget contains:    ${yves_user_email}
    Yves: As an Agent login under the customer:    ${yves_user_email}
    Yves: perform search by:    031
    Yves: product with name in the catalog should have price:    Canon PowerShot G9 X    €400.24
    Yves: go to PDP of the product with sku:    031
    Yves: product price on the PDP should be:    €400.24
    [Teardown]    Run Keywords    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    agent+${random}@spryker.com

Return_Management
    [Documentation]    Checks that returns work and oms process is checked. 
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
    ...    || salutation | firstName | lastName | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | Guest     | User     | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    send to distribution
    Zed: trigger matching state of xxx merchant's shipment:    1    confirm at center
    Zed: trigger matching state of xxx merchant's shipment:    1    Ship   
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to user menu item in header:    Orders History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    010_30692994
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    010_30692994
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create a return for the following order and product in it:    ${lastPlacedOrder}    007_30691822
    Zed: create new Zed user with the following data:    returnagent+${random}@spryker.com    change123${random}    Agent    Assist    Root group    This user is an agent    en_US
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    returnagent+${random}@spryker.com    change123${random}
    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: perform search by customer:    ${yves_user_email}
    Yves: agent widget contains:    ${yves_user_email}
    Yves: As an Agent login under the customer:    ${yves_user_email}
    Yves: go to user menu item in header:    Orders History
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    008_30692992
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    008_30692992
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    Execute return
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to user menu item in header:    Orders History
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

Guest_Checkout
    [Documentation]    Guest checkout with discounts and OMS
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    012
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: proceed with checkout as guest:    Mr    Guest    user    guest+${random}@user.com
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
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: get the last placed order ID of the customer by email:    guest+${random}@user.com
    Zed: trigger all matching states inside xxx order:    ${zedLastPlacedOrder}    Pay
    Zed: go to my order page:    ${zedLastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    send to distribution
    Zed: trigger matching state of xxx merchant's shipment:    1    confirm at center
    Zed: trigger matching state of xxx merchant's shipment:    1    Ship   
    [Teardown]    Run keywords    Yves: check if cart is not empty and clear it

Refunds
    [Documentation]    Checks that refund can be created for one item and the whole order. Fails due to bug CC-17232
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate following discounts from Overview page:    Tu & Wed $5 off 5 or more    10% off $100+    20% off cameras    Tu & Wed €5 off 5 or more    10% off minimum order
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
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,041.90
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay   
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    send to distribution
    Zed: trigger matching state of xxx merchant's shipment:    1    confirm at center
    Zed: trigger matching state of order item inside xxx shipment:    008_30692992    Ship
    Zed: trigger matching state of order item inside xxx shipment:    008_30692992    deliver
    Zed: trigger matching state of order item inside xxx shipment:    008_30692992    Refund
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €696.90
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    Ship
    Zed: trigger matching state of xxx merchant's shipment:    1    deliver
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
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: delete all user addresses
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: create a new customer address in profile:     Mr    ${yves_user_first_name}    ${yves_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
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
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    3

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
    Yves: go to URL:    en/merchant/video-king
    Yves: assert merchant profile fields:
    ...    || name | email                  | phone           | delivery time | data privacy              ||
    ...    ||      | updated@office-king.nl | +11 222 333 444 | 2-4 weeks     | Data privacy updated text ||
    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    MP: open navigation menu tab:    Profile
    MP: open profile tab:    Online Profile  
    MP: update profile fields with following data:
    ...    || email            | phone           | delivery time | data privacy                                         ||
    ...    || hi@video-king.nl | +31 123 345 777 | 2-4 days      | Video King values the privacy of your personal data. ||
    MP: click submit button

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
    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    MP: open navigation menu tab:    Profile
    MP: open profile tab:    Online Profile
    MP: change store status to:    online
    Yves: go to the 'Home' page
    Yves: go to PDP of the product with sku:    ${second_product_with_multiple_offers_abstract_sku}
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Yves: go to URL:    en/merchant/video-king
    Yves: try reloading page if element is/not appear:    ${merchant_profile_main_content_locator}    true

Merchant_Profile_Set_to_Inactive_from_Backoffice
    [Documentation]    Checks that backoffice admin is able to deactivate merchant and then it's profile, products and offers won't be displayed on Yves
    [Setup]    Run Keywords    
    ...    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    ...    AND    MP: change offer stock:
    ...    || offer   | stock quantity | is never out of stock ||
    ...    || offer30 | 10             | true                  ||
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
    Yves: go to newly created page by URL:    en/merchant/NewMerchantURL${random}
    Yves: assert merchant profile fields:
    ...    || name                         | email| phone | delivery time | data privacy ||
    ...    || NewMerchantUpdated${random}  |      |       |               |              ||
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Marketplace    Merchants  
    ...    AND    Zed: click Action Button in a table for row that contains:     NewMerchantUpdated${random}     Deactivate


Manage_Merchant_Users
    [Documentation]    Checks that backoffice admin is able to create, activate, edit and delete merchant users
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:     Video King     Edit
    Zed: create new Merchant User with the following data:
    ...    || e-mail                    | first name     | last name      ||
    ...    || m_user+${random}@test.com | FName${random} | LName${random} ||
    Zed: perform merchant user search by:     m_user+${random}@test.com
    Zed: table should contain non-searchable value:    Deactivated
    Zed: click Action Button in Merchant Users table for row that contains:    m_user+${random}@test.com    Activate
    Zed: table should contain non-searchable value:    Active
    Zed: click Action Button in Merchant Users table for row that contains:    m_user+${random}@test.com    Edit
    Zed: update Merchant User on edit page with the following data:
    ...    || e-mail | first name           | last name ||
    ...    ||        | UpdatedName${random} |           ||
    Zed: perform merchant user search by:    m_user+${random}@test.com
    Zed: table should contain non-searchable value:    UpdatedName${random}
    Zed: click Action Button in Merchant Users table for row that contains:    m_user+${random}@test.com    Deactivate
    Zed: table should contain non-searchable value:    Deactivated
    [Teardown]    Run Keywords    Zed: click Action Button in Merchant Users table for row that contains:    m_user+${random}@test.com    Delete
    ...    AND    Zed: submit the form

# Create_and_Approve_New_Merchant_Product
#     [Documentation]    Checks that merchant is able to create new multi-SKU product and marketplace operator is able to approve it in BO
#     MP: login on MP with provided credentials:    ${merchant_budget_cameras_email}
#     MP: open navigation menu tab:    Products    
#     MP: click on create new entity button:    Create Product
#     MP: create multi sku product with following data:
#     ...    || product sku  | product name        | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
#     ...    || SKU${random} | NewProduct${random} | packaging_unit       | Item                        | Box                          | material              | Aluminium              ||
#     MP: perform search by:    NewProduct${random}
#     MP: click on a table row that contains:     NewProduct${random}
#     MP: fill abstract product required fields:
#     ...    || product name DE     | store | tax set        ||
#     ...    || NewProduct${random} | DE    | Standard Taxes ||
#     MP: fill product price values:
#     ...    || product type | row number | customer | store | currency | gross default ||
#     ...    || abstract     | 1          | Default  | DE    | EUR      | 100           ||
#     MP: save abstract product 
#     MP: click on a table row that contains:    NewProduct${random}
#     MP: open concrete drawer by SKU:    SKU${random}-2
#     MP: fill concrete product fields:
#     ...    || is active | stock quantity | use abstract name | searchability ||
#     ...    || true      | 100            | true              | en_US         ||
#     Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     Zed: go to second navigation item level:    Catalog    Products 
#     Zed: click Action Button in a table for row that contains:     NewProduct${random}     Approve
#     Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}   
#     Yves: go to URL:    en/search?q=SKU${random}
#     Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    15    5s
#     Yves: go to PDP of the product with sku:     SKU${random}
#     Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    true
#     Yves: product price on the PDP should be:    €100.00

# Create_New_Offer
#     [Documentation]    Checks that merchant is able to create new offer and it will be displayed on Yves
#     MP: login on MP with provided credentials:    ${merchant_budget_cameras_email}
#     MP: open navigation menu tab:    Offers
#     MP: click on create new entity button:    Add Offer
#     MP: perform search by:    673327
#     MP: click on a table row that contains:    673327  
#     MP: fill offer fields:
#     ...    || is active | merchant sku         | store | stock quantity ||
#     ...    || true      | merchantSKU${random} | DE    | 100            ||
#     MP: add offer price:
#     ...    || row number | store | currency | gross default ||
#     ...    || 1          | DE    | CHF      | 100           ||
#     MP: save offer
#     MP: perform search by:    merchantSKU${random}
#     MP: click on a table row that contains:    merchantSKU${random} 
#     MP: add offer price:
#     ...    || row number | store | currency | gross default ||
#     ...    || 1          | DE    | EUR      | 200           ||
#     MP: save offer
#     Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
#     Yves: create new 'Shopping Cart' with name:    newOfferCart${random}
#     Yves: go to PDP of the product with sku:     673327
#     Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    true
#     Yves: merchant's offer/product price should be:    Office King    €200.00
#     Yves: select xxx merchant's offer:    Office King
#     Yves: add product to the shopping cart
#     Yves: go to the shopping cart through the header with name:    newOfferCart${random}
#     Yves: 'Shopping Cart' page is displayed
#     Yves: assert merchant of product in cart or list:    673327    Office King
#     Yves: shopping cart contains product with unit price:    673327    Estucado upholstered chair with armrests, leader, white - white    200
#     [Teardown]    Yves: delete 'Shopping Cart' with name:    newOfferCart${random}

# Approve_Offer
#     [Documentation]    Checks that marketplace operator is able to approve or deny merchant's offer and it will be available or not in store due to this status
#     Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     Zed: go to second navigation item level:    Marketplace    Offers
#     Zed: select merchant in filter:    Office King
#     Zed: click Action Button in a table for row that contains:     ${product_with_multiple_offers_concrete_sku}     Deny
#     Yves: go to the 'Home' page
#     Yves: go to PDP of the product with sku:     ${product_with_multiple_offers_abstract_sku}
#     Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    false
#     Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     Zed: go to second navigation item level:    Marketplace    Offers
#     Zed: select merchant in filter:    Office King
#     Zed: click Action Button in a table for row that contains:     ${product_with_multiple_offers_concrete_sku}    Approve
#     Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
#     Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
#     Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    true
#     Yves: merchant's offer/product price should be:    Office King    ${product_with_multiple_offers_video_king_price}
#     Yves: select xxx merchant's offer:    Office King
#     Yves: product price on the PDP should be:     ${product_with_multiple_offers_video_king_price}

# Fulfill_Order_from_Merchant_Portal
#     [Documentation]    Checks that merchant is able to process his order through OMS from merchant portal
#     [Setup]    Run Keywords    
#     ...    MP: login on MP with provided credentials:    ${merchant_video_king_email}
#     ...    AND    MP: change offer stock:
#     ...    || offer    | stock quantity | is never out of stock ||
#     ...    || offer395 | 10             | true                  ||
#     ...    AND    MP: login on MP with provided credentials:    ${merchant_budget_cameras_email}
#     ...    AND    MP: change offer stock:
#     ...    || offer    | stock quantity | is never out of stock ||
#     ...    || offer193 | 10             | true                  ||
#     ...    AND    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
#     ...    AND    Yves: delete all shopping carts
#     ...    AND    Yves: create new 'Shopping Cart' with name:    MerchantOrder${random}
#     Yves: go to PDP of the product with sku:     ${product_with_multiple_offers_abstract_sku}
#     Yves: add product to the shopping cart
#     Yves: select xxx merchant's offer:    Computer Experts
#     Yves: add product to the shopping cart
#     Yves: select xxx merchant's offer:    Office King
#     Yves: add product to the shopping cart
#     Yves: go to the shopping cart through the header with name:    MerchantOrder${random}
#     Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}     Office King
#     Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}     Computer Experts
#     Yves: click on the 'Checkout' button in the shopping cart
#     Yves: billing address same as shipping address:    true
#     Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
#     Yves: select the following shipping method for the shipment:    1    DHL    Standard    
#     Yves: select the following shipping method for the shipment:    2    Hermes    Same Day
#     Yves: select the following shipping method for the shipment:    3    Hermes    Next Day
#     Yves: submit form on the checkout
#     Yves: select the following payment method on the checkout and go next:    Invoice
#     Yves: accept the terms and conditions:    true
#     Yves: 'submit the order' on the summary page
#     Yves: 'Thank you' page is displayed
#     Yves: get the last placed order ID by current customer
#     Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay 
#     MP: login on MP with provided credentials:    ${merchant_budget_cameras_email}
#     MP: open navigation menu tab:    Orders    
#     MP: wait for order to appear:    ${lastPlacedOrder}--${merchant_budget_cameras_reference}
#     MP: click on a table row that contains:    ${lastPlacedOrder}--${merchant_budget_cameras_reference}
#     MP: order grand total should be:    €31.81
#     MP: update order state using header button:    Ship
#     MP: order state on drawer should be:    Shipped   
#     MP: update order state using header button:    deliver
#     MP: order state on drawer should be:    Delivered

# Shopping_List_Contains_Offers
#     [Documentation]    Checks that customer is able to add merchant products and offers to list and merchant relation won't be lost in list and afterwards in cart
#     [Setup]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
#     ...    AND    Yves: delete all shopping carts
#     Yves: create new 'Shopping List' with name:    shoppingListName${random}
#     Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
#     Yves: add product to the shopping list:    shoppingListName${random}
#     Yves: select xxx merchant's offer:    Computer Experts
#     Yves: add product to the shopping list:    shoppingListName${random}
#     Yves: view shopping list with name:    shoppingListName${random}
#     Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Spryker
#     Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Computer Experts
#     Yves: add all available products from list to cart  
#     Yves: 'Shopping Cart' page is displayed
#     Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Spryker
#     Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Computer Experts
#     [Teardown]    Yves: delete 'Shopping List' with name:    shoppingListName${random}

# Merchant_Portal_Customer_Specific_Prices
#     [Documentation]    Checks that customer will see product/offer prices specified by merchant for his business unit
#     MP: login on MP with provided credentials:    ${merchant_spryker_email}
#     MP: open navigation menu tab:    Products
#     MP: perform search by:    ${one_variant_product_of_main_merchant_abstract_sku}
#     MP: click on a table row that contains:    ${one_variant_product_of_main_merchant_abstract_sku}
#     MP: open concrete drawer by SKU:    ${one_variant_product_of_main_merchant_concrete_sku}
#     MP: fill product price values:
#     ...    || product type | row number | customer                  | store | currency | gross default ||
#     ...    || concrete     | 1          | 5 - Spryker Systems GmbH  | DE    | EUR      | 100           ||
#     MP: save concrete product
#     Yves: login on Yves with provided credentials:     ${yves_company_user_custom_merchant_prices_email}
#     Yves: go to PDP of the product with sku:    ${one_variant_product_of_main_merchant_abstract_sku}
#     Yves: merchant's offer/product price should be:    Spryker     €100.00
#     MP: login on MP with provided credentials:    ${merchant_spryker_email}
#     MP: open navigation menu tab:    Products
#     MP: perform search by:    ${one_variant_product_of_main_merchant_abstract_sku}
#     MP: click on a table row that contains:    ${one_variant_product_of_main_merchant_abstract_sku}
#     MP: open concrete drawer by SKU:    ${one_variant_product_of_main_merchant_concrete_sku}
#     MP: delete price row that contains text:    5 - Spryker Systems GmbH
#     MP: save concrete product
#     Yves: login on Yves with provided credentials:     ${yves_company_user_custom_merchant_prices_email}
#     Yves: go to PDP of the product with sku:    ${one_variant_product_of_main_merchant_abstract_sku}
#     Yves: merchant's offer/product price should be:    Spryker     €632.12

# Search_for_Merchant_Offers_and_Products
#     [Documentation]    Checks that through search customer is able to see the list of merchant's products and offers
#     Yves: go to the 'Home' page
#     Yves: perform search by:    Office King
#     Yves: go to the PDP of the first available product on open catalog page
#     Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    true
#     Yves: perform search by:    Office King
#     Yves: select filter value:    Merchant    Office King
#     Yves: change sorting order on catalog page:    Sort by name ascending
#     Yves: go to the PDP of the first available product on open catalog page
#     Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    true
#     Yves: perform search by:    Office King
#     Yves: select filter value:    Merchant    Office King
#     Yves: change sorting order on catalog page:    Sort by name descending
#     Yves: go to the PDP of the first available product on open catalog page
#     Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    true