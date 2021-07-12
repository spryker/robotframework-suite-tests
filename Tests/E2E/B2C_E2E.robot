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
Resource    ../../Resources/Steps/Customer_Registration_steps.robot
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
Resource    ../../Resources/Steps/Zed_Availability_steps.robot
Resource    ../../Resources/Steps/Zed_Discount_steps.robot
Resource    ../../Resources/Steps/Zed_CMS_Page_steps.robot

*** Test Cases ***
New_Customer_Registration
    [Documentation]    Check that a new user can be registered in the system
    Register a new customer with data:    
    ...    || salutation | first name          | last name | e-mail                         | password           ||
    ...    || Mr.        | Test${random}       | User      | ${random}test.user@spryker.com | change123${random} || 
    Yves: flash message should be shown:    success    Almost there! We send you an email to validate your email address. Please confirm it to be able to log in.


Guest_User_Access
    [Documentation]    Checks that guest users see products info and cart but not profile
    Yves: header contains/doesn't contain:    true    ${currencySwitcher}    ${wishlistIcon}    ${accountIcon}    ${shoppingCartIcon}
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
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: header contains/doesn't contain:    true    ${currencySwitcher}    ${accountIcon}     ${wishlistIcon}    ${shoppingCartIcon} 
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
    [Teardown]    Yves: check if cart is not empty and clear it

UserAccount
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
    Yves: create a new customer address in profile:     Mr    ${yves_second_user_first_name}    ${yves_second_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    true    Mr    ${yves_second_user_first_name}    ${yves_second_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Yves: delete user address:    Mr    ${yves_second_user_first_name}    ${yves_second_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    false    Mr    ${yves_second_user_first_name}    ${yves_second_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    
    
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
    Yves: select filter value:    Color    Blue
    Yves: 'Catalog' page should show products:    1
    [Teardown]    Yves: check if cart is not empty and clear it

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
    [Teardown]    Yves: check if cart is not empty and clear it

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
    [Teardown]    Yves: check if cart is not empty and clear it

Product_PDP
    [Documentation]    Checks that PDP contains required elements
    Yves: go to PDP of the product with sku:    135
    Yves: change variant of the product on PDP on:    Flash
    Yves: PDP contains/doesn't contain:    true    ${price}    ${addToCartButton}    ${pdp_warranty_option}    ${pdp_gift_wrapping_option}    ${relatedProducts} 
    Yves: PDP contains/doesn't contain:    false    ${pdp_add_to_wishlist_button}
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    135
    Yves: PDP contains/doesn't contain:    true    ${price}    ${pdp_add_to_cart_disabled_button}    ${pdp_warranty_option}    ${pdp_gift_wrapping_option}     ${pdp_add_to_wishlist_button}    ${relatedProducts} 
    Yves: change variant of the product on PDP on:    Flash
    Yves: PDP contains/doesn't contain:    true    ${price}    ${addToCartButton}    ${pdp_warranty_option}    ${pdp_gift_wrapping_option}     ${pdp_add_to_wishlist_button}    ${relatedProducts} 


Volume_Prices
    [Documentation]    Checks volume prices are applied
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    193
    Yves: change quantity on PDP:    5
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: shopping cart contains product with unit price:    193    Sony FDR-AX40    8.25
    Yves: delete from b2c cart products with name:    Sony FDR-AX40
    [Teardown]    Yves: check if cart is not empty and clear it

Discontinued_Alternative_Products
    [Documentation]    Checks discontinued and alternative products
    Yves: go to PDP of the product with sku:  145
    Yves: change variant of the product on PDP on:    2.3 GHz - Discontinued
    Yves: PDP contains/doesn't contain:    true    ${alternativeProducts}
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: delete all wishlists
    Yves: go to the 'Home' page
    Yves: go to PDP of the product with sku:  010
    Yves: add product to wishlist:    My wishlist
    Yves: get sku of the concrete product on PDP
    Yves: get sku of the abstract product on PDP
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: discontinue the following product:    010    010_30692994
    Zed: product is successfully discontinued
    Zed: check if at least one price exists for concrete and add if doesn't:    100
    Zed: add following alternative products to the concrete:    011
    Zed: submit the form
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go To 'Wishlist' Page
    Yves: go to wishlist with name:    My wishlist
    Yves: product with sku is marked as discountinued in wishlist:    010
    Yves: try reloading page if element is/not appear:    xpath=//*[contains(text(),'Alternative for')]    True
    Yves: product with sku is marked as alternative in wishlist:    011
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: undo discontinue the following product:    010    010_30692994
    [Teardown]    Yves: check if cart is not empty and clear it

Back_in_Stock_Notification
    [Documentation]    Back in stock notification is sent and availability check
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: check if product is/not in stock:    009    true
    Zed: change product stock:    009    009_30692991    false    0
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: check if product is/not in stock:    009    false
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:  009
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
    Yves: check if product is available on PDP:    009    false
    Yves: submit back in stock notification request for email:    ${yves_second_user_email}
    Yves: unsubscribe from availability notifications
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: change product stock:    009    009_30692991    true    0  
    Zed: go to second navigation item level:    Catalog    Availability  
    Zed: check if product is/not in stock:    009    true
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:  009
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: check if product is available on PDP:    009    true
    [Teardown]    Zed: check and restore product availability in Zed:    009    Available    009_30692991 

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

Product_Sets
    [Documentation]    Check the usage of product sets
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to URL:    en/product-sets
    Yves: 'Product Sets' page contains the following sets:    HP Product Set    Sony Product Set    Upgrade your running game
    Yves: view the following Product Set:    Upgrade your running game
    Yves: 'Product Set' page contains the following products:    TomTom Golf    Samsung Galaxy S6 edge
    Yves: change variant of the product on CMS page on:    Samsung Galaxy S6 edge    128 GB
    Yves: add all products to the shopping cart from Product Set
    Yves: go to b2c shopping cart
    Yves: shopping cart contains the following products:    TomTom Golf    Samsung Galaxy S6 edge
    Yves: delete from b2c cart products with name:    TomTom Golf    Samsung Galaxy S6 edge
    [Teardown]    Yves: check if cart is not empty and clear it 

Product_Bundles
    [Documentation]    Check the usage of product bundles
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    212
    Yves: PDP contains/doesn't contain:    true    ${bundleItemsSmall}    ${bundleItemsLarge}
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: shopping cart contains the following products:    ASUS Bundle
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following shipping address:    Mr    ${yves_second_user_first_name}    ${yves_second_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Yves: check if cart is not empty and clear it

Configurable_Bundle
    [Documentation]    Check the usage of configurable bundles (includes authorized checkout)
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to URL:    en/configurable-bundle/configurator/template-selection
    Yves: 'Choose Bundle to configure' page is displayed
    Yves: choose bundle template to configure:    Smartstation Kit
    Yves: select product in the bundle slot:    Slot 5    Canon IXUS 160
    Yves: select product in the bundle slot:    Slot 6    Sony NEX-VG30E
    Yves: go to 'Summary' step in the bundle configurator
    Yves: add products to the shopping cart in the bundle configurator
    Yves: go to URL:    en/configurable-bundle/configurator/template-selection
    Yves: 'Choose Bundle to configure' page is displayed
    Yves: choose bundle template to configure:    Smartstation Kit
    Yves: select product in the bundle slot:    Slot 5    Canon IXUS 165
    Yves: select product in the bundle slot:    Slot 6    Sony HDR-MV1
    Yves: go to 'Summary' step in the bundle configurator
    Yves: add products to the shopping cart in the bundle configurator
    Yves: go to b2c shopping cart
    Yves: change quantity of the configurable bundle in the shopping cart on:    Smartstation Kit    2
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following shipping address:    Mr    ${yves_second_user_first_name}    ${yves_second_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: go to user menu item in header:    Orders History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: 'View Order' page is displayed
    Yves: 'Order Details' page contains the following product title N times:    Smartstation Kit    3
    [Teardown]    Yves: check if cart is not empty and clear it


Discounts
    [Documentation]    Discounts, Promo Products, and Coupon Codes (includes guest checkout)
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Merchandising    Discount
    Zed: create a discount and activate it:    voucher    Percentage    5    sku = '*'    test${random}    discountName=Voucher Code 5% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    10    sku = '*'    discountName=Cart Rule 10% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    100    discountName=Promotional Product 100% ${random}    promotionalProductDiscount=True    promotionalProductAbstractSku=001    promotionalProductQuantity=2
    Yves: go to the 'Home' page
    Yves: go to PDP of the product with sku:    190
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: apply discount voucher to cart:    test${random}
    Yves: discount is applied:    voucher    Voucher Code 5% ${random}    - €17.46
    Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €8.73
    Yves: go to PDP of the product with sku:    211
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €87.96
    Yves: promotional product offer is/not shown in cart:    True
    Yves: change quantity of promotional product and add to cart:    +    1
    Yves: shopping cart contains the following products:    Kodak EasyShare M532    Canon IXUS 160
    Yves: discount is applied:    cart rule    Promotional Product 100% ${random}    - €199.98
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: proceed with checkout as guest:    Mr    Guest    user    guest@user.com    
    Yves: billing address same as shipping address:    true
    Yves: fill in the following shipping address:    Mr    Guest    user    Kirncher Str.    7    10247    Berlin    Germany
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Run keywords    Yves: check if cart is not empty and clear it    
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Merchandising    Discount
    ...    AND    Zed: Deactivate Following Discounts From Overview Page:    Voucher Code 5% ${random}    Cart Rule 10% ${random}    Promotional Product 100% ${random}        

Recommendations
    [Documentation]    Checks similar products section in cart
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: page contains CMS element:    Product Slider    Similar products false
    Yves: go to PDP of the product with sku:    157
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: page contains CMS element:    Product Slider    Similar products true
    [Teardown]    Yves: check if cart is not empty and clear it

Split_Delivery
    [Documentation]    Checks split delivery in checkout
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    011
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    012
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: select delivery to multiple addresses
    Yves: select new delivery address for a product:    Canon IXUS 285    true    no    Mr    Product    285    Kirncher Str.    7    10247    Berlin    Germany
    Yves: select new delivery address for a product:    Canon IXUS 180    true    no    Mr    Product    180    Kirncher Str.    7    10247    Berlin    Germany
    Yves: select new delivery address for a product:    Canon IXUS 165    true    no    Mr    Product    165    Kirncher Str.    7    10247    Berlin    Germany
    Yves: fill in the following billing address:    Mr    Product    165    Kirncher Str.    7    10247    Berlin    Germany
    Yves: click checkout button:    Next
    Yves: select the following shipping method for product:    Canon IXUS 285    Express
    Yves: select the following shipping method for product:    Canon IXUS 180    Standard
    Yves: select the following shipping method for product:    Canon IXUS 165    Express
    Scroll and Click Element    ${submit_checkout_form_button}
    Wait For Document Ready    
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Yves: check if cart is not empty and clear it


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
    Yves: login under the customer:    ${yves_user_email}
    Yves: perform search by:    031
    Yves: product with name in the catalog should have price:    Canon PowerShot G9 X    €400.24
    Yves: go to PDP of the product with sku:    031
    Yves: product price on the PDP should be:    €400.24
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: delete Zed user with the following email:    agent+${random}@spryker.com
    [Teardown]    Yves: check if cart is not empty and clear it

Return_Management
    [Documentation]    Checks that returns work and oms process is checked
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    008
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    010
    Yves: add product to the shopping cart
    Yves: go to b2c shopping cart
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following shipping address:    Mr    Guest    User    Kirncher Str.    7    10247    Berlin    Germany
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: trigger all matching states inside this order:    Ship
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
    Zed: create new Zed user with the following data:    agent+${random}@spryker.com    change123${random}    Agent    Assist    Root group    This user is an agent    en_US
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent+${random}@spryker.com    change123${random}
    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: perform search by customer:    ${yves_user_email}
    Yves: agent widget contains:    ${yves_user_email}
    Yves: login under the customer:    ${yves_user_email}
    Yves: go to user menu item in header:    Orders History
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    008_30692992
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    008_30692992
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Execute return
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to user menu item in header:    Orders History
    Yves: 'Order History' page is displayed
    Yves: 'Order History' page contains the following order with a status:    ${lastPlacedOrder}    Returned
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: delete Zed user with the following email:    agent+${random}@spryker.com
    [Teardown]    Yves: check if cart is not empty and clear it


Content_Management
    [Documentation]    Checks cms content can be edited in zed and that correct cms elements are present on homepage   
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Content   Pages
    Zed: create a cms page and publish it:    Test Page${random}    test-page${random}    Page Title    Page text
    Yves: go to the 'Home' page
    Yves: page contains CMS element:    Homepage Banners
    Yves: page contains CMS element:    Product Slider    Top Sellers
    Yves: page contains CMS element:    Homepage Inspirational block
    Yves: page contains CMS element:    Homepage Banner Video
    Yves: page contains CMS element:    Footer section
    Yves: go to URL:    en/test-page${random}
    Yves: try reloading page if element is/not appear:     xpath=//*[contains(@class,'cms-page__title')]    True
    Yves: page contains CMS element:    CMS Page Title    Page Title
    Yves: page contains CMS element:    CMS Page Content    Page text










