*** Settings ***
Library    BuiltIn
Suite Setup       SuiteSetup
Suite Teardown    SuiteTeardown
Test Setup        TestSetup
Test Teardown     TestTeardown
Resource    ../../Resources/Common/Common.robot
Resource    ../../Resources/Steps/Header_steps.robot
Resource    ../../Resources/Common/Common_Yves.robot
Resource    ../../Resources/Common/Common_Zed.robot
Resource    ../../Resources/Steps/PDP_steps.robot
Resource    ../../Resources/Steps/Shopping_Lists_steps.robot
Resource    ../../Resources/Steps/Checkout_steps.robot
Resource    ../../Resources/Steps/Order_History_steps.robot
Resource    ../../Resources/Steps/Product_Set_steps.robot
Resource    ../../Resources/Steps/Catalog_steps.robot
Resource    ../../Resources/Steps/Agent_Assist_steps.robot
Resource    ../../Resources/Steps/Company_steps.robot
Resource    ../../Resources/Steps/Customer_Account_steps.robot
Resource    ../../Resources/Steps/Configurable_Bundle_steps.robot
Resource    ../../Resources/Steps/Zed_Users_steps.robot
Resource    ../../Resources/Steps/Products_steps.robot
Resource    ../../Resources/Steps/Orders_Management_steps.robot
Resource    ../../Resources/Steps/Wishlist_steps.robot

*** Test Cases ***
Guest_User_Access
    [Documentation]    Checks that guest users see products info and cart but not profile
    Yves: header contains/doesn't contain:    true    ${currencySwitcher}    ${accountIcon}[${env}]    ${wishlistIcon}    ${shoppingCartIcon}[${env}]
    Yves: go to PDP of the product with sku:    002
    Yves: PDP contains/doesn't contain:     true    ${price}    ${addToCartButton} 
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: shopping cart contains product with unit price:   002    Canon IXUS 160    99.99
    Yves: go to user menu item in header:    Overview
    Yves: 'Login' page is displayed
    Yves: go To 'Wishlist' Page
    Yves: 'Login' page is displayed
    

Authorized_User_Access
    [Documentation]    Checks that authorized users see products info, cart and profile
    Yves: login on Yves with provided credentials:    spencor.hopkin@spryker.com
    Yves: header contains/doesn't contain:    true    ${currencySwitcher}    ${accountIcon}[${env}]     ${wishlistIcon}    ${shoppingCartIcon}[${env}] 
    Yves: go to PDP of the product with sku:    002
    Yves: PDP contains/doesn't contain:     true    ${price}    ${addToCartButton}
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: shopping cart contains product with unit price:    002    Canon IXUS 160    99.99
    Yves: go to user menu item in header:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu item in header:    Orders History
    Yves: 'Order History' page is displayed
    Yves: go To 'Wishlist' Page
    Yves: 'Wishlist' page is displayed

UserAccount
    [Documentation]    Checks user account pages work
    Yves: login on Yves with provided credentials:    spencor.hopkin@spryker.com
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
    Yves: create a new customer address in profile:     Mr    Spencor    Hopkin    Kirncher Str.    7    10247    Berlin    Germany
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    true    Mr    Spencor    Hopkin    Kirncher Str.    7    10247    Berlin    Germany
    Yves: delete user address:    Mr    Spencor    Hopkin    Kirncher Str.    7    10247    Berlin    Germany
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    false    Mr    Spencor    Hopkin    Kirncher Str.    7    10247    Berlin    Germany
    
    
Catalog
    [Documentation]    Checks that catalog options and search work
    Yves: perform search by:    canon
    Yves: 'Catalog' page should show products:    30
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
    Yves: select filter value:    Color    Yellow
    Yves: 'Catalog' page should show products:    1

Catalog_Actions
    [Documentation]    Checks quick add to cart and product groups
    Yves: perform search by:    NEX-VG20EH
    Yves: 1st product card in catalog (not)contains:      Add to Cart    true
    Yves: quick add to cart for first item in catalog
    Yves: perform search by:    HP Z 440
    Yves: 1st product card in catalog (not)contains:     Add to Cart    false
    Yves: perform search by:    002
    Yves: 1st product card in catalog (not)contains:      Add to Cart    true
    Yves: 1st product card in catalog (not)contains:      Color selector   true
    Yves: select product color:    Black
    Yves: quick add to cart for first item in catalog
    Yves: go to b2c shopping cart
    Yves: shopping cart contains the following products:    NEX-VG20EH    Canon IXUS 160

Product_labels
    [Documentation]    Checks that products have labels on PLP and PDP
    Yves: go to first navigation item level:    Sale
    Yves: 1st product card in catalog (not)contains:     SaleLabel    true
    Yves: go to PDP of the product with sku:    020
    Yves: PDP contains/doesn't contain:    true    ${pdp_sales_label}
    Yves: go to first navigation item level:    New
    Yves: 1st product card in catalog (not)contains:     NewLabel    true
    Yves: go to PDP of the product with sku:    666
    Yves: PDP contains/doesn't contain:    true    ${pdp_new_label}

Product_PDP
    [Documentation]    Checks that PDP contains required elements
    Yves: go to PDP of the product with sku:    135
    Yves: change variant of the product on PDP on:    Flash
    Yves: PDP contains/doesn't contain:    true    ${price}    ${addToCartButton}    ${pdp_warranty_option}    ${pdp_gift_wrapping_option}    ${relatedProducts} 
    Yves: PDP contains/doesn't contain:    false    ${pdp_add_to_wishlist_button}
    Yves: login on Yves with provided credentials:    sonia@spryker.com
    Yves: go to PDP of the product with sku:    135
    Yves: PDP contains/doesn't contain:    true    ${price}    ${pdp_add_to_cart_disabled_button}    ${pdp_warranty_option}    ${pdp_gift_wrapping_option}     ${pdp_add_to_wishlist_button}    ${relatedProducts} 
    Yves: change variant of the product on PDP on:    Flash
    Yves: PDP contains/doesn't contain:    true    ${price}    ${addToCartButton}    ${pdp_warranty_option}    ${pdp_gift_wrapping_option}     ${pdp_add_to_wishlist_button}    ${relatedProducts} 


Volume_Prices
    [Documentation]    Checks volume prices are applied
    Yves: login on Yves with provided credentials:    sonia@spryker.com
    Yves: go to PDP of the product with sku:    193
    Yves: change quantity on PDP:    5
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: shopping cart contains product with unit price:    Sony FDR-AX40    8.25
    Yves: delete from b2c cart products with name:    Sony FDR-AX40

Discontinued_Alternative_Products
    [Documentation]    Checks discontinued and alternative products
    Yves: go to PDP of the product with sku:  145
    Yves: change variant of the product on PDP on:    2.3 GHz
    Yves: PDP contains/doesn't contain:    true    ${alternativeProducts}
    Yves: login on Yves with provided credentials:    sonia@spryker.com
    Yves: go to PDP of the product with sku:  010
    Yves: add product to wishlist:    default
    Yves: get sku of the concrete product on PDP
    Yves: get sku of the abstract product on PDP
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: discontinue the following product:    ${got_abstract_product_sku}    ${got_concrete_product_sku}
    Zed: product is successfully discontinued
    Zed: add alternative products to the following abstract:    011
    Zed: submit the form
    Yves: login on Yves with provided credentials:    sonia@spryker.com
    Yves: go to user menu item in header:    Wishlist
    Yves: go to wishlist with name:    My wishlist
    Yves: product with sku is marked as discountinued in wishlist:    010
    Yves: product with sku is marked as alternative in wishlist:    011
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: undo discontinue the following product:    ${got_abstract_product_sku}    ${got_concrete_product_sku}

Back_in_Stock_Notification
    [Documentation]    Back in stock notification is sent and availability check
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: check if product is in stock:    009    true
    Zed: change product in stock status:    009    false
    Zed: check if product is in stock:    009    false
    Yves: login on Yves with provided credentials:    sonia@spryker.com
    Yves: go to PDP of the product with sku:  009
    Yves: check if product is in stock on PDP:    009    false
    Yves: submit back in stock notification request
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: change product in stock status:    009    true
    Zed: check if product is in stock:    009    true
    Yves: login on Yves with provided credentials:    sonia@spryker.com
    Yves: go to PDP of the product with sku:  009
    Yves: check if product is in stock on PDP:    009    true

Add_to_Wishlist
    [Documentation]    Check creation of wishlist and adding to different wishlists
    Yves: login on Yves with provided credentials:    sonia@spryker.com
    Yves: go to PDP of the product with sku:  003
    Yves: add product to wishlist:    My Wishlist
    Yves: go to user menu item in header:    Wishlist
    Yves: create wishlist with name:    Second Wishlist
    Yves: go to PDP of the product with sku:  004
    Yves: add product to wishlist:    Second Wishlist
    Yves: go to user menu item in header:    Wishlist
    Yves: go to wishlist with name:    My Wishlist
    Yves: wishlist contains product with sku:    003_26138343
    Yves: go to wishlist with name:    Second Wishlist
    Yves: wishlist contains product with sku:    004_30663302

Product_Sets
    [Documentation]    Check the usage of product sets
    Yves: login on Yves with provided credentials:    sonia@spryker.com
    Yves: go to URL:    en/product-sets
    Yves: 'Product Sets' page contains the following sets:    HP Product Set    Sony Product Set    Upgrade your running game
    Yves: view the following Product Set:    Upgrade your running game
    Yves: 'Product Set' page contains the following products:    TomTom Golf    Samsung Galaxy S6 edge
    Yves: change variant of the product on CMS page on:    Samsung Galaxy S6 edge    128 GB
    Yves: add all products to the shopping cart from Product Set
    Yves: go to b2c shopping cart
    Yves: shopping cart contains the following products:    TomTom Golf    Samsung Galaxy S6 edge
    Yves: delete from b2c cart products with name:    TomTom Golf    Samsung Galaxy S6 edge 

Product_Bundles
    [Documentation]    Check the usage of product bundles
    Yves: login on Yves with provided credentials:    sonia@spryker.com
    Yves: go to PDP of the product with sku:    212
    Yves: PDP contains/doesn't contain:    true    ${bundleItemsSmall}    ${bundleItemsLarge}
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: shopping cart contains the following products:    ASUS Bundle
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following shipping address:    Ms Sonia Wagner    Kirncher Str.    7    10247    Berlin
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Configurable_Bundle
    [Documentation]    Check the usage of configurable bundles (includes authorized checkout)
    Yves: login on Yves with provided credentials:    sonia@spryker.com
    Yves: go to second navigation item level:    More    Configurable Bundle
    Yves: 'Choose Bundle to configure' page is displayed
    Yves: choose bundle template to configure:    Smartstation Kit
    Yves: select product in the bundle slot:    Slot 5    Canon IXUS 160
    Yves: select product in the bundle slot:    Slot 6    Sony NEX-VG30E
    Yves: go to 'Summary' step in the bundle configurator
    Yves: add products to the shopping cart in the bundle configurator
    Yves: go to second navigation item level:    More    Configurable Bundle
    Yves: 'Choose Bundle to configure' page is displayed
    Yves: choose bundle template to configure:    Smartstation Kit
    Yves: select product in the bundle slot:    Slot 5    Canon PowerShot N
    Yves: select product in the bundle slot:    Slot 6    Sony HDR-MV1
    Yves: go to 'Summary' step in the bundle configurator
    Yves: add products to the shopping cart in the bundle configurator
    Yves: go to b2c shopping cart
    Yves: change quantity of the configurable bundle in the shopping cart on:    Smartstation Kit    2
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following shipping address:    Ms Sonia Wagner    Kirncher Str.    7    10247    Berlin
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: 'View Order' page is displayed
    Yves: 'Order Details' page contains the following product title N times:    Smartstation Kit    3


Discounts
    [Documentation]    Discounts, Promo Products, and Coupon Codes (includes guest checkout)
    Yves: go to PDP of the product with sku:    190
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: apply discount voucher to cart:    sprykerbe4p
    Yves: discount is applied:    10% Discount for all orders above    - €17.46
    Yves: discount is applied:    5% discount on all white products    - €8.73
    Yves: go to PDP of the product with sku:    211
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: discount is applied:    10% Discount for all orders above    - €87.96
    Yves: promotional product offer is shown in cart
    Yves: add promotional product to cart
    Yves: discount is applied:    For every purchase above certain value depending on the currency and net/gross price. you get this promotional product for free    -€162.72
    Yves: shopping cart contains the following products:    Kodak EasyShare M532    Acer Extensa M2610    HP Bundle
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: select guest checkout
    Yves: billing address same as shipping address:    true
    Yves: fill in the following shipping address:    Ms Guest User    Kirncher Str.    7    10247    Berlin
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Recommendations
    [Documentation]    Checks similar products section in cart
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: page contains CMS element:    Similar products false
    Yves: go to PDP of the product with sku:    157
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: page contains CMS element:    Similar products true

Split_Delivery
    [Documentation]    Checks split delivery in checkout
    Yves: login on Yves with provided credentials:    sonia@spryker.com
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    010
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    012
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: select delivery to multiple addresses
    Yves: select new delivery address for a product:    Canon IXUS 285    Canon IXUS 180    Canon IXUS 165
    Yves: set new shipping address for product:    Canon IXUS 285    Ms Product 007    Kirncher Str.    7    10247    Berlin
    Yves: set new shipping address for product:    Canon IXUS 180    Ms Product 010    Kirncher Str.    10    10247    Berlin
    Yves: set new shipping address for product:    Canon IXUS 165    Ms Product 012    Kirncher Str.    12    10247    Berlin
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed


Agent_Assist
    [Documentation]    Checks that agent can be used
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: create new Zed user with the following data:    agent+${random}@spryker.com    change123    Agent    Assist    Root group    This user is an agent    en_US
    Yves: go to the 'Home' page
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent+${random}@spryker.com
    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: perform search by customer:    Sonia
    Yves: agent widget contains:    sonia@spryker.com
    Yves: login under the customer:    sonia@spryker.com
    Yves: perform search by:    031
    Yves: product with name in the catalog should have price:    Canon PowerShot G9 X    €400.24
    Yves: go to PDP of the product with sku:    031
    Yves: product price on the PDP should be:    €400.24
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: delete Zed user with the following email:    agent+${random}@spryker.com

Return_Management
    [Documentation]    Checks that returns work and oms process is checked
    Yves: login on Yves with provided credentials:    sonia@spryker.com
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    008
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    009
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following shipping address:    Ms Guest User    Kirncher Str.    7    10247    Berlin
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: trigger all matching states inside this order:    Ship
    Yves: login on Yves with provided credentials:    sonia@spryker.com
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    009_30692991
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    009_30692991
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: create a return for the following order and product in it:    ${lastPlacedOrder}    007_30691822
    Zed: create new Zed user with the following data:    agent+${random}@spryker.com    change123    Agent    Assist    Root group    This user is an agent    en_US
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent+${random}@spryker.com
    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: perform search by customer:    sonia@spryker.com
    Yves: agent widget contains:    sonia@spryker.com
    Yves: login under the customer:    sonia@spryker.com
    Yves: go to user menu item in header:    Order History
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    008_30692992
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    008_30692992
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Execute return
    Yves: login on Yves with provided credentials:    sonia@spryker.com
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page is displayed
    Yves: 'Order History' page contains the following order with a status:    ${lastPlacedOrder}    Returned
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: delete Zed user with the following email:    agent+${random}@spryker.com


Content_Management
    [Documentation]    Checks cms content can be edited in zed and that correct cms elements are present on homepage   
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: go to second navigation item level:    Content   Pages
    Zed: create a new cms page:    Test Page    test-page    Page Title    Page text
    Yves: go to the 'Home' page
    Yves: page contains CMS element:    Banner
    Yves: page contains CMS element:    Top Sellers
    Yves: page contains CMS element:    Inspirational block
    Yves: page contains CMS element:    Multi-inspirational block
    Yves: page contains CMS element:    Footer
    Yves: go to URL:    en/test-page
    Yves: page contains CMS element:    Test Page










