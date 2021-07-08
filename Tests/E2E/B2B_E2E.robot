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

*** Test Cases ***
Guest_User_Restrictions
    [Documentation]    Checks that guest users are not able to see: Prices, Availability, Quick Order, "My Account" features
    Yves: header contains/doesn't contain:    false    ${priceModeSwitcher}    ${currencySwitcher}    ${quickOrderIcon}    ${accountIcon}    ${shoppingListIcon}    ${shoppingCartIcon}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku} 
    Yves: PDP contains/doesn't contain:     false    ${pdpPriceLocator}    ${addToCartButton}
    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    Yves: header contains/doesn't contain:    true    ${priceModeSwitcher}    ${currencySwitcher}    ${quickOrderIcon}    ${accountIcon}    ${shoppingListIcon}    ${shoppingCartIcon}
    Yves: company menu 'should' be available for logged in user
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: PDP contains/doesn't contain:     true    ${pdpPriceLocator}    ${addToCartButton}
    Yves: go to company menu item:    Users
    Yves: 'Company Users' page is displayed


Share_Shopping_Lists
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: go to 'Shopping Lists' page
    Yves: 'Shopping Lists' page is displayed
    Yves: create new 'Shopping List' with name:    shoppingListName+${random}
    Yves: the following shopping list is shown:    shoppingListName+${random}    ${yves_company_user_shared_permission_owner_firstname} ${yves_company_user_shared_permission_owner_lastname}    Full access
    Yves: share shopping list with user:    shoppingListName+${random}    ${yves_company_user_shared_permission_receiver_firstname} ${yves_company_user_shared_permission_receiver_lastname}    Full access
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_receiver_email}
    Yves: 'Shopping List' widget contains:    shoppingListName+${random}    Full access
    Yves: go to 'Shopping Lists' page
    Yves: 'Shopping Lists' page is displayed
    Yves: the following shopping list is shown:    shoppingListName+${random}    ${yves_company_user_shared_permission_owner_firstname} ${yves_company_user_shared_permission_owner_lastname}    Full access
    Yves: delete 'Shopping List' with name:    shoppingListName+${random}

Share_Shopping_Carts
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: go to 'Shopping Carts' page through the header
    Yves: 'Shopping Carts' page is displayed
    Yves: create new 'Shopping Cart' with name:    shoppingCartName+${random}
    Yves: 'Shopping Carts' widget contains:    shoppingCartName+${random}    Owner access
    Yves: go to 'Shopping Carts' page through the header
    Yves: 'Shopping Carts' page is displayed
    Yves: the following shopping cart is shown:    shoppingCartName+${random}    Owner access
    Yves: share shopping cart with user:    shoppingCartName+${random}    ${yves_company_user_shared_permission_receiver_lastname} ${yves_company_user_shared_permission_receiver_firstname}    Full access
    Yves: go to PDP of the product with sku:    M10569
    Yves: add product to the shopping cart
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_receiver_email}
    Yves: 'Shopping Carts' widget contains:    shoppingCartName+${random}    Full access
    Yves: go to 'Shopping Carts' page through the header
    Yves: 'Shopping Carts' page is displayed
    Yves: the following shopping cart is shown:    shoppingCartName+${random}    Full access
    Yves: go to the shopping cart through the header with name:    shoppingCartName+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    100414
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_shared_permission_receiver_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: go to the 'Home' page
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     View Order    ${lastPlacedOrder}
    Yves: 'View Order' page is displayed

Quick_Order
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    quickOrderCart+${random}
    Yves: create new 'Shopping List' with name:    quickOrderList+${random}
    Yves: go to 'Quick Order' page through the header
    Yves: 'Quick Order' page is displayed
    Yves: add the following articles into the form through quick order text area:    401627,1\n520561,3\n101509,21\n419871,1\n419869,11\n425073,1\n425084,2
    Yves: add products to the shopping cart from quick order page
    Yves: go to the shopping cart through the header with name:    quickOrderCart+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    401627    520561    101509    419871    419869    425073    425084
    Yves: go to 'Quick Order' page through the header
    Yves: add the following articles into the form through quick order text area:    401627,1\n520561,3\n101509,21\n419871,1\n419869,11\n425073,1\n425084,2
    Yves: add products to the shopping list from quick order page with name:    quickOrderList+${random}
    Yves: 'Shopping List' page is displayed
    Yves: shopping list contains the following products:    401627    520561    101509    419871    419869    425073    425084
    Yves: go to the shopping cart through the header with name:    quickOrderCart+${random}
    ### Order placement ###
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    ### Order History ###
    Yves: go to the 'Home' page
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     View Order    ${lastPlacedOrder}
    Yves: 'View Order' page is displayed
    ### Reorder ###
    Yves: reorder all items from 'View Order' page
    Yves: go to the shopping cart through the header with name:    Cart from order ${lastPlacedOrder}
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    401627    520561    101509    419871    419869    425073    425084
    Yves: delete 'Shopping List' with name:    quickOrderList+${random}

Volume_Prices
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    VolumePriceCart+${random}
    Yves: go to PDP of the product with sku:    M21189
    Yves: change quantity on PDP:    5
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    VolumePriceCart+${random}
    Yves: shopping cart contains product with unit price:    420685    Post-it stick note Super Sticky Meeting Notes 6445-4SS 4 pieces/pack    4.20
    Yves: delete 'Shopping Cart' with name:    VolumePriceCart+${random}

Discontinued_Alternative_Products
    # extend methods "Zed: discontinue the following product:" and "Zed: undo discontinue the following product:" to check first that the product can be discontinued or undicontinued
    Yves: go to PDP of the product with sku:  M21100
    Yves: PDP contains/doesn't contain:    true    ${alternativeProducts}
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping List' with name:    shoppingListName+${random}
    Yves: go to the PDP of the first available product
    Yves: add product to the shopping list:
    Yves: get sku of the concrete product on PDP
    Yves: get sku of the abstract product on PDP
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: discontinue the following product:    ${got_abstract_product_sku}    ${got_concrete_product_sku}
    Zed: product is successfully discontinued
    Zed: add following alternative products to the concrete:    M22613
    Zed: submit the form
    Zed: undo discontinue the following product:    ${got_abstract_product_sku}    ${got_concrete_product_sku}

Measurement_Units
    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    Yves: create new 'Shopping Cart' with name:    measurementUnitsCart+${random}
    Yves: go to PDP of the product with sku:    M23723
    Yves: select the following 'Sales Unit' on PDP:    Meter
    Yves: change quantity using '+' or '-' button № times:    +    1
    Yves: PDP contains/doesn't contain:    true    ${measurementUnitSuggestion}
    Yves: change quantity using '+' or '-' button № times:    -    1
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M1006871
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:  measurementUnitsCart+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    425079
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_manager_and_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Packaging_Units
    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    Yves: create new 'Shopping Cart' with name:    packagingUnitsCart+${random}
    Yves: go to PDP of the product with sku:    M21766
    Yves: change variant of the product on PDP on:    Box
    Yves: change amount on PDP:    51
    Yves: PDP contains/doesn't contain:    true    ${packagingUnitSuggestion}
    Yves: change amount on PDP:    10
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M1006871
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    packagingUnitsCart+${random}
    Yves: shopping cart contains the following products:    421519_3
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_manager_and_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Product_Sets
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    productSetsCart+${random}
    Yves: go to URL:    en/product-sets
    Yves: 'Product Sets' page contains the following sets:    The Presenter's Set    Basic office supplies    The ultimate data disposal set
    Yves: view the following Product Set:    Basic office supplies
    Yves: 'Product Set' page contains the following products:    Clairefontaine Collegeblock 8272C DIN A5, 90 sheets
    Yves: change variant of the product on CMS page on:    Clairefontaine Collegeblock 8272C DIN A5, 90 sheets    lined
    Yves: add all products to the shopping cart from Product Set
    Yves: shopping cart contains the following products:    421344    420687    421511    423452
    Yves: delete 'Shopping Cart' with name:    productSetsCart+${random}

Product_Bundles
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    productBundleCart+${random}
    Yves: go to PDP of the product with sku:    000201
    Yves: PDP contains/doesn't contain:    true    ${bundleItemsSmall}    ${bundleItemsLarge}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    productBundleCart+${random}
    Yves: shopping cart contains the following products:    000201
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Product_Relations
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    productRelationCart+${random}
    Yves: go to PDP of the product with sku:    ${product_with_relations_related_products_sku}
    Yves: PDP contains/doesn't contain:    true    ${relatedProducts}
    Yves: go to PDP of the product with sku:    ${product_with_relations_upselling_sku}
    Yves: PDP contains/doesn't contain:    false    ${relatedProducts}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    productRelationCart+${random}
    Yves: shopping cart contains/doesn't contain the following elements:    true    ${upSellProducts}
    Yves: delete 'Shopping Cart' with name:    productRelationCart+${random}

Default_Merchants
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: table should contain:    Restrictions Merchant
    Zed: table should contain:    Prices Merchant
    Zed: table should contain:    Products Restrictions Merchant

Product_Restrictions
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: perform search by:    Soennecken
    Yves: 'Catalog' page should show products:    18
    Yves: go to URL:    en/office-furniture/storage/lockers
    Yves: 'Catalog' page should show products:    34
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_restriction_customer_email_1}
    Yves: perform search by:    Soennecken
    Yves: 'Catalog' page should show products:    0
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_restriction_customer_email_2}
    Yves: go to URL:    en/office-furniture/storage/lockers
    Yves: 'Catalog' page should show products:    0
    Yves: go to URL:    en/transport/lift-carts
    Yves: 'Catalog' page should show products:    16
    Yves: go to URL:    en/transport/sack-trucks
    Yves: 'Catalog' page should show products:    10

Customer_Specific_Prices
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: perform search by:    ${one_variant_product_abstract_name}
    Yves: product with name in the catalog should have price:    ${one_variant_product_abstract_name}    ${one_variant_product_default_price}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: product price on the PDP should be:    ${one_variant_product_default_price}
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_special_prices_customer_email}
    Yves: create new 'Shopping Cart' with name:    customerPrices+${random}
    Yves: perform search by:    ${one_variant_product_abstract_name}
    Yves: product with name in the catalog should have price:    ${one_variant_product_abstract_name}    ${one_variant_product_merchant_price}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: product price on the PDP should be:    ${one_variant_product_merchant_price}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    customerPrices+${random}
    Yves: shopping cart contains product with unit price:    403125    EUROKRAFT hand truck - with open shovel - load capacity 400 kg    188.34
    Yves: delete 'Shopping Cart' with name:    customerPrices+${random}

Agent_Assist
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create new Zed user with the following data:    agent+${random}@spryker.com    change123${random}    Agent    Assist    Root group    This user is an agent    en_US
    Yves: go to the 'Home' page
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent+${random}@spryker.com    change123${random}
    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: perform search by customer:    ${yves_company_user_special_prices_customer_firstname}
    Yves: agent widget contains:    ${yves_company_user_special_prices_customer_email}
    Yves: login under the customer:    ${yves_company_user_special_prices_customer_email}
    Yves: perform search by:    ${one_variant_product_abstract_name}
    Yves: product with name in the catalog should have price:    ${one_variant_product_abstract_name}    ${one_variant_product_merchant_price}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: product price on the PDP should be:    ${one_variant_product_merchant_price}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: delete Zed user with the following email:    agent+${random}@spryker.com

Business_on_Behalf
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Customers    Company Users
    Zed: click Action Button in a table for row that contains:    Donald    Attach to BU
    Zed: attach company user to the following BU with role:    Spryker Systems Zurich (id: 25)    Admin
    Yves: login on Yves with provided credentials:    ${yves_company_user_bob_email}
    Yves: go to URL:    en/company/user/select
    Yves: 'Select Business Unit' page is displayed
    Yves: 'Business Unit' dropdown contains:    Spryker Systems GmbH / Spryker Systems Berlin    Spryker Systems GmbH / Spryker Systems Zurich

Business_Unit_Address_on_Checkout
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    businessAddressCart+${random}
    Yves: go to PDP of the product with sku:    M64933
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    businessAddressCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page is displayed
    Yves: shipping address on the order details page is:    Mr. Ahill Grant Ottom ltd Seeburger Str. 270 10115 Berlin, Germany 4908892455

Approval_Process
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_with_limit_email}
    Yves: create new 'Shopping Cart' with name:    approvalCart+${random}
    Yves: go to PDP of the product with sku:    M49320
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    approvalCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_with_limit_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: select approver on the 'Summary' page:    Lilu Dallas (€1,000.00)
    Yves: 'send the request' on the summary page
    Yves: 'Summary' page is displayed
    Yves: 'Summary' page contains/doesn't contain:    true    ${cancelRequestButton}    ${alertWarning}    ${quoteStatus}
    Yves: go to the 'Home' page
    Yves: go to the shopping cart through the header with name:    approvalCart+${random}
    Yves: shopping cart contains/doesn't contain the following elements:    true    ${lockedCart}
    Yves: create new 'Shopping Cart' with name:    newApprovalCart+${random}
    Yves: go to PDP of the product with sku:    M58314
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    newApprovalCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:            ${yves_company_user_buyer_with_limit_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: create new 'Shopping Cart' with name:    anotherApprovalCart+${random}
    Yves: go to PDP of the product with sku:    M58314
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    anotherApprovalCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:            ${yves_company_user_buyer_with_limit_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: select approver on the 'Summary' page:    Lilu Dallas (€1,000.00)
    Yves: 'send the request' on the summary page
    Yves: 'Summary' page is displayed
    Yves: 'Summary' page contains/doesn't contain:    true    ${cancelRequestButton}    ${alertWarning}    ${quoteStatus}
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_approver_email}
    Yves: go to user menu item in header:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu item in the left bar:    Shopping carts
    Yves: 'Shopping Carts' page is displayed
    Yves: the following shopping cart is shown:    approvalCart+${random}    Read-only
    Yves: the following shopping cart is shown:    anotherApprovalCart+${random}    Read-only
    Yves: shopping cart with name xxx has the following status:    approvalCart+${random}    Waiting
    Yves: shopping cart with name xxx has the following status:    anotherApprovalCart+${random}    Waiting
    Yves: go to the shopping cart through the header with name:    approvalCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: 'Summary' page is displayed
    Yves: 'approve the cart' on the summary page
    Yves: 'Summary' page is displayed
    Yves: 'Summary' page contains/doesn't contain:    false    ${cancelRequestButton}    ${alertWarning}
    Yves: go to the 'Home' page
    Yves: go to user menu item in header:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu item in the left bar:    Shopping carts
    Yves: 'Shopping Carts' page is displayed
    Yves: the following shopping cart is shown:    approvalCart+${random}    Read-only
    Yves: the following shopping cart is shown:    anotherApprovalCart+${random}    Read-only
    Yves: shopping cart with name xxx has the following status:    approvalCart+${random}    Approved
    Yves: shopping cart with name xxx has the following status:    anotherApprovalCart+${random}    Waiting
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_with_limit_email}
    Yves: go to user menu item in the left bar:    Shopping carts
    Yves: shopping cart with name xxx has the following status:    approvalCart+${random}    Approved
    Yves: go to the shopping cart through the header with name:    approvalCart+${random}
    Yves: shopping cart contains/doesn't contain the following elements:    true    ${lockedCart}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: 'Summary' page is displayed
    Yves: Accept the Terms and Conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Request_for_Quote
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create new Zed user with the following data:    agent_quote+${random}@spryker.com    change123${random}    Request    Quote    Root group    This user is an agent    en_US
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    RfQCart+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M1018212
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    RfQCart+${random}
    Yves: submit new request for quote
    Yves: click 'Send to Agent' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent_quote+${random}@spryker.com    change123${random}
    Yves: header contains/doesn't contain:    true    ${quoteRequestsWidget}
    Yves: go to 'Quote Requests' page through the header
    Yves: 'Quote Requests' page is displayed
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Waiting
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: 'Quote Request Details' page is displayed
    Yves: click 'Revise' button on the 'Quote Request Details' page
    Yves: change price for the product in the quote request with sku xxx on:    403125    500
    Yves: click 'Send to Customer' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu item in header:    Quote Requests
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Ready
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: click 'Revise' button on the 'Quote Request Details' page
    Yves: click 'Edit Items' button on the 'Quote Request Details' page
    Yves: delete product from the shopping cart with sku:    102121
    Yves: click 'Save and Back to Edit' button on the 'Quote Request Details' page
    Yves: add the following note to the quote request:    Spryker rocks
    Yves: click 'Save' button on the 'Quote Request Details' page
    Yves: click 'Send to Agent' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent_quote+${random}@spryker.com
    Yves: move mouse over header menu item:     ${quoteRequestsWidget}
    Yves: 'Quote Requests' widget is shown
    Yves: go to the quote request through the header with reference:    ${lastCreatedRfQ}
    Yves: 'Quote Request Details' page contains the following note:   Spryker rocks
    Yves: click 'Revise' button on the 'Quote Request Details' page
    Yves: set 'Valid Till' date for the quote request, today +:    1 day
    Yves: change price for the product in the quote request with sku xxx on:    403125    500
    Yves: click 'Send to Customer' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu item in header:    Quote Requests
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Ready
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: click 'Convert to Cart' button on the 'Quote Request Details' page
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains product with unit price:    403125    EUROKRAFT hand truck - with open shovel - load capacity 400 kg    500
    Yves: shopping cart doesn't contain the following products:    102121
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: shopping cart contains product with unit price:    403125    EUROKRAFT hand truck - with open shovel - load capacity 400 kg    500
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: delete Zed user with the following email:    agent_quote+${random}@spryker.com

Unique_URL
    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    Yves: create new 'Shopping Cart' with name:    externalCart+${random}
    Yves: go to PDP of the product with sku:    M90806
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    externalCart+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: get link for external cart sharing
    Yves: logout on Yves as a customer
    Yves: go to URL:    ${externalURL}
    Yves: 'Shopping Cart' page is displayed
    Yves: Shopping Cart title should be equal:    Preview: externalCart+${random}
    Yves: shopping cart contains the following products:    108302
    Yves: delete 'Shopping Cart' with name:    externalCart+${random}

Configurable_Bundle
    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    Yves: create new 'Shopping Cart' with name:    confBundle+${random}
    Yves: go to second navigation item level:    More    Configurable Bundle
    Yves: 'Choose Bundle to configure' page is displayed
    Yves: choose bundle template to configure:    Presentation bundle
    Yves: select product in the bundle slot:    Slot 5    408104
    Yves: select product in the bundle slot:    Slot 6    423172
    Yves: go to 'Summary' step in the bundle configurator
    Yves: add products to the shopping cart in the bundle configurator
    Yves: go to second navigation item level:    More    Configurable Bundle
    Yves: 'Choose Bundle to configure' page is displayed
    Yves: choose bundle template to configure:    Presentation bundle
    Yves: select product in the bundle slot:    Slot 5    421539
    Yves: select product in the bundle slot:    Slot 6    424551
    Yves: go to 'Summary' step in the bundle configurator
    Yves: add products to the shopping cart in the bundle configurator
    Yves: go to the shopping cart through the header with name:    confBundle+${random}
    Yves: change quantity of the configurable bundle in the shopping cart on:    Presentation bundle    2
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_manager_and_buyer_address}
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
    Yves: 'Order Details' page contains the following product title N times:    Presentation bundle    3

Return_Management
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    returnCart+${random}
    Yves: go to PDP of the product with sku:    M90802
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M21711
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M90737
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    returnCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
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
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    410083
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    410083
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: create a return for the following order and product in it:    ${lastPlacedOrder}    421426
    Zed: create new Zed user with the following data:    agent+${random}@spryker.com    change123${random}    Agent    Assist    Root group    This user is an agent    en_US
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent+${random}@spryker.com    change123${random}
    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: perform search by customer:    ${yves_company_user_buyer_email}
    Yves: agent widget contains:    ${yves_company_user_buyer_email}
    Yves: login under the customer:    ${yves_company_user_buyer_email}
    Yves: go to user menu item in header:    Order History
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    108278
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    108278
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Execute return
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page is displayed
    Yves: 'Order History' page contains the following order with a status:    ${lastPlacedOrder}    Returned
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: delete Zed user with the following email:    agent+${random}@spryker.com
