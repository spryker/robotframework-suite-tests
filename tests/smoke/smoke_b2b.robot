*** Settings ***
Suite Setup       SuiteSetup
Test Setup        TestSetup
Test Teardown     TestTeardown
Suite Teardown    SuiteTeardown
Resource    ../../resources/common/common.robot
Resource    ../../resources/steps/header_steps.robot
Resource    ../../resources/common/common_yves.robot
Resource    ../../resources/common/common_zed.robot
Resource    ../../resources/steps/pdp_steps.robot
Resource    ../../resources/steps/shopping_lists_steps.robot
Resource    ../../resources/steps/checkout_steps.robot
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
Resource    ../../resources/steps/zed_customer_steps.robot
Resource    ../../resources/steps/zed_discount_steps.robot
Resource    ../../resources/steps/zed_availability_steps.robot
Resource    ../../resources/steps/zed_cms_page_steps.robot
Resource    ../../resources/steps/order_comments_steps.robot
 
*** Test Cases ***
Guest_User_Access_Restrictions
    [Documentation]    Checks that guest users are not able to see: Prices, Availability, Quick Order, "My Account" features
    Yves: header contains/doesn't contain:    false    ${priceModeSwitcher}    ${currencySwitcher}[${env}]     ${quickOrderIcon}    ${accountIcon}    ${shoppingListIcon}    ${shoppingCartIcon}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku} 
    Yves: PDP contains/doesn't contain:     false    ${pdpPriceLocator}    ${addToCartButton}
    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    Yves: header contains/doesn't contain:    true    ${priceModeSwitcher}    ${currencySwitcher}[${env}]    ${quickOrderIcon}    ${accountIcon}    ${shoppingListIcon}    ${shoppingCartIcon}
    Yves: company menu 'should' be available for logged in user
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: PDP contains/doesn't contain:     true    ${pdpPriceLocator}    ${addToCartButton}
    Yves: go to company menu item:    Users
    Yves: 'Company Users' page is displayed

Share_Shopping_Lists
    [Documentation]    Checks that shopping list can be shared
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: go to 'Shopping Lists' page
    Yves: 'Shopping Lists' page is displayed
    Yves: create new 'Shopping List' with name:    shoppingListName+${random}
    Yves: the following shopping list is shown:    shoppingListName+${random}    ${yves_company_user_shared_permission_owner_firstname} ${yves_company_user_shared_permission_owner_lastname}    Full access
    Yves: share shopping list with user:    shoppingListName+${random}    ${yves_company_user_shared_permission_receiver_firstname} ${yves_company_user_shared_permission_receiver_lastname}    Full access
    Create New Context
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_receiver_email}
    Yves: 'Shopping List' widget contains:    shoppingListName+${random}    Full access
    Yves: go to 'Shopping Lists' page
    Yves: 'Shopping Lists' page is displayed
    Yves: the following shopping list is shown:    shoppingListName+${random}    ${yves_company_user_shared_permission_owner_firstname} ${yves_company_user_shared_permission_owner_lastname}    Full access
    [Teardown]    Run Keywords    Close Context    CURRENT    AND    Yves: delete 'Shopping List' with name:    shoppingListName+${random}

Share_Shopping_Carts
    [Documentation]    Checks that cart can be shared and used for checkout
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
    [Documentation]    Checks Quick Order, checkout and Reorder
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts
    ...    AND    Yves: create new 'Shopping Cart' with name:    quickOrderCart+${random}
    ...    AND    Yves: create new 'Shopping List' with name:    quickOrderList+${random}
    Yves: go to 'Quick Order' page through the header
    Yves: 'Quick Order' page is displayed
    Yves: add the following articles into the form through quick order text area:    401627,1\n520561,3\n421340,21\n419871,1\n419869,11\n425073,1\n425084,2
    Yves: add products to the shopping cart from quick order page
    Yves: go to the shopping cart through the header with name:    quickOrderCart+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    401627    520561    421340    419871    419869    425073    425084
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to 'Quick Order' page through the header
    Yves: add the following articles into the form through quick order text area:    401627,1\n520561,3\n421340,21\n419871,1\n419869,11\n425073,1\n425084,2
    Yves: add products to the shopping list from quick order page with name:    quickOrderList+${random}
    Yves: 'Shopping List' page is displayed
    Yves: shopping list contains the following products:    401627    520561    421340    419871    419869    425073    425084
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
    Yves: shopping cart contains the following products:    401627    520561    421340    419871    419869    425073    425084
    [Teardown]    Yves: delete 'Shopping List' with name:    quickOrderList+${random}

Volume_Prices
    [Documentation]    Checks that volume prices are applied in cart
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    VolumePriceCart+${random}
    Yves: go to PDP of the product with sku:    M21189
    Yves: change quantity on PDP:    5
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    VolumePriceCart+${random}
    Yves: shopping cart contains product with unit price:    420685    Post-it stick note Super Sticky Meeting Notes 6445-4SS 4 pieces/pack    4.20
    [Teardown]    Yves: delete 'Shopping Cart' with name:    VolumePriceCart+${random}

Discontinued_Alternative_Products
    [Documentation]    Checks that product can be discontinued in Zed
    #Todo: extend methods "Zed: discontinue the following product:" and "Zed: undo discontinue the following product:" to check first that the product can be discontinued or undicontinued
    Yves: go to PDP of the product with sku:  M21100
    Yves: PDP contains/doesn't contain:    true    ${alternativeProducts}
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to the PDP of the first available product
    Yves: get sku of the concrete product on PDP
    Yves: get sku of the abstract product on PDP
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: discontinue the following product:    ${got_abstract_product_sku}    ${got_concrete_product_sku}
    Zed: product is successfully discontinued
    Zed: add following alternative products to the concrete:    M22613
    Zed: submit the form
    [Teardown]    Zed: undo discontinue the following product:    ${got_abstract_product_sku}    ${got_concrete_product_sku}

Measurement_Units
    [Documentation]    Checks checkout with Measurement Unit product
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    measurementUnitsCart+${random}
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
    [Documentation]    Checks checkout with Packaging Unit product
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    packagingUnitsCart+${random}
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
    [Documentation]    Checks that product set can be added into cart
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    productSetsCart+${random}
    Yves: go to URL:    en/product-sets
    Yves: 'Product Sets' page contains the following sets:    The Presenter's Set    Basic office supplies    The ultimate data disposal set
    Yves: view the following Product Set:    Basic office supplies
    Yves: 'Product Set' page contains the following products:    Clairefontaine Collegeblock 8272C DIN A5, 90 sheets
    Yves: change variant of the product on CMS page on:    Clairefontaine Collegeblock 8272C DIN A5, 90 sheets    lined
    Yves: add all products to the shopping cart from Product Set
    Yves: shopping cart contains the following products:    421344    420687    421511    423452
    [Teardown]    Yves: delete 'Shopping Cart' with name:    productSetsCart+${random}

Product_Bundles
    [Documentation]    Checks checkout with Bundle product
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: change product stock:    ${bundled_product_1_abstract_sku}    ${bundled_product_1_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_2_abstract_sku}    ${bundled_product_2_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_3_abstract_sku}    ${bundled_product_3_concrete_sku}    true    10
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    productBundleCart+${random}
    Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
    #Fails due to bug CC-16679
    Yves: PDP contains/doesn't contain:    true    ${bundleItemsSmall}    ${bundleItemsLarge}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    productBundleCart+${random}
    Yves: shopping cart contains the following products:    ${bundle_product_concrete_sku}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Product_Relations
    [Documentation]    Checks related product on PDP and upsell products in cart
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    productRelationCart+${random}
    Yves: go to PDP of the product with sku:    ${product_with_relations_related_products_sku}
    Yves: PDP contains/doesn't contain:    true    ${relatedProducts}
    Yves: go to PDP of the product with sku:    ${product_with_relations_upselling_sku}
    Yves: PDP contains/doesn't contain:    false    ${relatedProducts}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    productRelationCart+${random}
    Yves: shopping cart contains/doesn't contain the following elements:    true    ${upSellProducts}
    [Teardown]    Yves: delete 'Shopping Cart' with name:    productRelationCart+${random}

Default_Merchants
    [Documentation]    Checks that default merchants are present in Zed
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: table should contain:    Restrictions Merchant
    Zed: table should contain:    Prices Merchant
    Zed: table should contain:    Products Restrictions Merchant

Product_Restrictions
    [Documentation]    Checks White and Black lists
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
    [Documentation]    Checks that product price can be different for different customers
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
    [Teardown]    Yves: delete 'Shopping Cart' with name:    customerPrices+${random}

Agent_Assist
    [Documentation]    Checks Agent creation and that it can login under customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create new Zed user with the following data:    agent+${random}@spryker.com    change123${random}    Agent    Assist    Root group    This user is an agent    en_US
    Yves: go to the 'Home' page
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent+${random}@spryker.com    change123${random}
    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: perform search by customer:    ${yves_company_user_special_prices_customer_firstname}
    Yves: agent widget contains:    ${yves_company_user_special_prices_customer_email}
    Yves: As an Agent login under the customer:    ${yves_company_user_special_prices_customer_email}
    Yves: perform search by:    ${one_variant_product_abstract_name}
    Yves: product with name in the catalog should have price:    ${one_variant_product_abstract_name}    ${one_variant_product_merchant_price}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: product price on the PDP should be:    ${one_variant_product_merchant_price}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    agent+${random}@spryker.com

Business_on_Behalf
    [Documentation]    Check that BoB user has possibility to change the business unit
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Customers    Company Users
    Zed: click Action Button in a table for row that contains:    Donald    Attach to BU
    Zed: attach company user to the following BU with role:    Spryker Systems Zurich (id: 25)    Admin
    Yves: login on Yves with provided credentials:    ${yves_company_user_bob_email}
    Yves: go to URL:    en/company/user/select
    Yves: 'Select Business Unit' page is displayed
    Yves: 'Business Unit' dropdown contains:    Spryker Systems GmbH / Spryker Systems Berlin    Spryker Systems GmbH / Spryker Systems Zurich
    [Teardown]    Zed: delete company user xxx withing xxx company business unit:    Donald    Spryker Systems Zurich

Business_Unit_Address_on_Checkout
    [Documentation]    Checks that business unit address can be used during checkout
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    businessAddressCart+${random}
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
    Yves: shipping address on the order details page is:    Mr. Armando Richi Spryker Systems GmbH Gurmont Str. 23 8002 Barcelona, Spain 3490284322

Approval_Process
    [Documentation]    Checks role permissions on checkout and Approval process
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_with_limit_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    approvalCart+${random}
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
    [Documentation]    Checks user can request and receive quote
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: create new Zed user with the following data:    agent_quote+${random}@spryker.com    change123${random}    Request    Quote    Root group    This user is an agent    en_US
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: delete all shopping carts
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
    Yves: login on Yves with provided credentials:    agent_quote+${random}@spryker.com    change123${random}
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
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    agent_quote+${random}@spryker.com

# Unique_URL
#     [Documentation]    Fails due to Bug:CC-12380
#     Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
#     Yves: create new 'Shopping Cart' with name:    externalCart+${random}
#     Yves: go to PDP of the product with sku:    M90806
#     Yves: add product to the shopping cart
#     Yves: go to the shopping cart through the header with name:    externalCart+${random}
#     Yves: 'Shopping Cart' page is displayed
#     Yves: get link for external cart sharing
#     Yves: logout on Yves as a customer
#     Yves: go to URL:    ${externalURL}
#     Yves: 'Shopping Cart' page is displayed
#     Yves: Shopping Cart title should be equal:    Preview: externalCart+${random}
#     Yves: shopping cart contains the following products:    108302
#     [Teardown]    Yves: delete 'Shopping Cart' with name:    externalCart+${random}

Configurable_Bundle
    [Documentation]    Checks checkout with the configurable bundle
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    ...    AND    Yves: delete all shopping carts
    ...    AND    Yves: create new 'Shopping Cart' with name:    confBundle+${random}
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
    [Documentation]    Checks OMS and that Yves and Zed users can create returns
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    returnCart+${random}
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
    Zed: create new Zed user with the following data:    return+agent+${random}@spryker.com    change123${random}    Agent    Assist    Root group    This user is an agent    en_US
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    return+agent+${random}@spryker.com    change123${random}
    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: perform search by customer:    ${yves_company_user_buyer_email}
    Yves: agent widget contains:    ${yves_company_user_buyer_email}
    Yves: As an Agent login under the customer:    ${yves_company_user_buyer_email}
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
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    return+agent+${random}@spryker.com

User_Account
    [Documentation]    Checks user account pages work
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to user menu item in header:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu item in header:    Order History
    Yves: 'Order History' page is displayed
    Yves: go to user menu item in header:    Profile
    Yves: 'My Profile' page is displayed
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: go to user menu item in the left bar:    Newsletter
    Yves: 'Newsletter' page is displayed
    Yves: go to user menu item in the left bar:    Returns
    Yves: 'Returns' page is displayed
    Yves: create a new customer address in profile:    Ms    ${yves_user_first_name} ${random}    ${yves_user_last_name} ${random}   Kirncher Str. ${random}    7    ${random}    Berlin    Germany
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    true    ${yves_user_first_name} ${random}    ${yves_user_last_name} ${random}    Kirncher Str. ${random}    7    ${random}    Berlin    Germany
    Yves: delete user address:    Kirncher Str. ${random}
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    false    ${yves_user_first_name} ${random}    ${yves_user_last_name} ${random}    Kirncher Str. ${random}    7    ${random}    Berlin    Germany

Product_PDP
    [Documentation]    Checks that PDP contains required elements
    Yves: go to PDP of the product with sku:    ${multi_variant_product_abstract_sku}
    Yves: change variant of the product on PDP on:    500 x 930 x 400
    Yves: PDP contains/doesn't contain:    true    ${pdp_warranty_option}    ${pdp_insurance_option}
    Yves: PDP contains/doesn't contain:    false    ${pdpPriceLocator}   ${addToCartButton} 
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    ${multi_variant_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}    ${pdp_add_to_cart_disabled_button}[${env}]    ${pdp_warranty_option}    ${pdp_insurance_option}
    Yves: change variant of the product on PDP on:    500 x 930 x 400
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}    ${addToCartButton}    ${pdp_warranty_option}    ${pdp_insurance_option} 

Product_labels
    [Documentation]    Checks that products have labels on PLP and PDP
    Yves: go to first navigation item level:    Sale %
    #TODO: Method below do nothing with 'SaleLabel' and 'NewLabel'
    Yves: 1st product card in catalog (not)contains:     Sale label    true
    Yves: go to the PDP of the first available product on open catalog page
    Yves: PDP contains/doesn't contain:    true    ${pdp_sales_label}[${env}]
    Yves: go to first navigation item level:    New
    Yves: 1st product card in catalog (not)contains:     New label    true
    Yves: go to the PDP of the first available product on open catalog page
    Yves: PDP contains/doesn't contain:    true    ${pdp_new_label}[${env}] 

Catalog
    [Documentation]    Checks that catalog options and search work
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: perform search by:    claire
    Yves: 'Catalog' page should show products:    15
    Yves: catalog page contains filter:    Product Ratings     Product Labels     Brand    Color
    Yves: select filter value:    Color    blue
    Yves: 'Catalog' page should show products:    1
    Yves: go to first navigation item level:    Stationery
    Yves: 'Catalog' page should show products:    114
    Yves: page contains CMS element:    CMS Block    Build a Space That Spurs Creativity
    Yves: page contains CMS element:    CMS Block    Tackle Your To-Do's
    Yves: change sorting order on catalog page:    Sort by price ascending
    Yves: 1st product card in catalog (not)contains:     Price    0.48
    Yves: change sorting order on catalog page:    Sort by price descending
    Yves: 1st product card in catalog (not)contains:      Price    €41.68
    Yves: go to catalog page:    2
    Yves: catalog page contains filter:    Product Ratings     Product Labels     Brand    Color
    Yves: select filter value:    Color    blue
    Yves: 'Catalog' page should show products:    3

Catalog_Actions
    [Documentation]    Checks quick add to cart and product groups
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    catalogActions+${random}
    Yves: perform search by:    Verbatim USB stick OTG
    Yves: 1st product card in catalog (not)contains:      Add to Cart    true
    Yves: quick add to cart for first item in catalog
    Yves: perform search by:    New Clairefontaine Collegeblock 8272C DIN A5, 90 sheets
    Yves: 1st product card in catalog (not)contains:     Add to Cart    false
    Yves: perform search by:    ${multi_color_product_abstract_sku}
    Yves: 1st product card in catalog (not)contains:      Add to Cart    true
    Yves: 1st product card in catalog (not)contains:      Color selector   true
    Yves: select product color:    Blue
    Yves: quick add to cart for first item in catalog
    Yves: go to the shopping cart through the header with name:    catalogActions+${random}
    Yves: shopping cart contains the following products:    420573    107255
    [Teardown]    Yves: delete 'Shopping Cart' with name:    catalogActions+${random}

Discounts
    [Documentation]    Discounts, Promo Products, and Coupon Codes
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate following discounts from Overview page:    Free chair    Tu & Wed $5 off 5 or more    10% off $100+    Free marker    20% off storage    	Free office chair    Free standard delivery    	10% off Safescan    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order
    ...    AND    Zed: change product stock:    M21777    421538    true    10
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Merchandising    Discount
    Zed: create a discount and activate it:    voucher    Percentage    5    sku = '*'    test${random}    discountName=Voucher Code 5% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    10    sku = '*'    discountName=Cart Rule 10% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    100    discountName=Promotional Product 100% ${random}    promotionalProductDiscount=True    promotionalProductAbstractSku=M29503    promotionalProductQuantity=2
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    discounts+${random}
    Yves: go to PDP of the product with sku:    M21777
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    discounts+${random}
    Yves: apply discount voucher to cart:    test${random}
    Yves: discount is applied:    voucher    Voucher Code 5% ${random}    - €0.72
    Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €1.44
    Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    discounts+${random}
    Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €125.46
    Yves: promotional product offer is/not shown in cart:    true
    Yves: change quantity of promotional product and add to cart:    +    1
    Yves: shopping cart contains the following products:    419873    421538    000101
    Yves: discount is applied:    cart rule    Promotional Product 100% ${random}    - €123.10
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
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,072.31
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Merchandising    Discount
    ...    AND    Zed: Deactivate Following Discounts From Overview Page:    Voucher Code 5% ${random}    Cart Rule 10% ${random}    Promotional Product 100% ${random}        

Back_in_Stock_Notification
    [Documentation]    Back in stock notification is sent and availability check
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to the PDP of the first available product
    Yves: get sku of the concrete product on PDP
    Yves: get sku of the abstract product on PDP
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: check if product is/not in stock:    ${got_abstract_product_sku}    true
    Zed: change product stock:    ${got_abstract_product_sku}    ${got_concrete_product_sku}    false    0
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: check if product is/not in stock:    ${got_abstract_product_sku}    false
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:  ${got_abstract_product_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
    Yves: check if product is available on PDP:    ${got_abstract_product_sku}    false
    Yves: submit back in stock notification request for email:    ${yves_user_email}
    Yves: unsubscribe from availability notifications
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Availability
    Zed: change product stock:    ${got_abstract_product_sku}    ${got_concrete_product_sku}    true    0  
    Zed: go to second navigation item level:    Catalog    Availability  
    Zed: check if product is/not in stock:    ${got_abstract_product_sku}    true
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:  ${got_abstract_product_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: check if product is available on PDP:    ${got_abstract_product_sku}    true
    [Teardown]    Zed: check and restore product availability in Zed:    ${got_abstract_product_sku}    Available    ${got_concrete_product_sku}

Split_Delivery
    [Documentation]    Checks split delivery in checkout with new addresses
    [Setup]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts
    ...    AND    Yves: create new 'Shopping Cart' with name:    splitDelivery+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${multi_color_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${product_with_relations_related_products_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    splitDelivery+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select delivery to multiple addresses
    Yves: fill in new delivery address for a product:
    ...    || product | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || 403125  | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
   Yves: fill in new delivery address for a product:
    ...    || product | salutation | firstName | lastName | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || 107254  | Dr.        | First     | Last     | Second Street | 2           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
   Yves: fill in new delivery address for a product:
    ...    || product | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || 419904  | Dr.        | First     | Last     | Third Street | 3           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Dr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: click checkout button:    Next
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

Content_Management
    [Documentation]    Checks cms content can be edited in zed and that correct cms elements are present on homepage   
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Content    Pages
    Zed: create a cms page and publish it:    Test Page${random}    test-page${random}    Page Title    Page text
    Yves: go to the 'Home' page
    Yves: page contains CMS element:    Homepage Banners
    Yves: page contains CMS element:    Product Slider    Top Sellers
    Yves: page contains CMS element:    Homepage Inspirational block
    Yves: page contains CMS element:    Footer section
    Yves: go to newly created page by URL:    en/test-page${random}
    Yves: page contains CMS element:    CMS Page Title    Page Title
    Yves: page contains CMS element:    CMS Page Content    Page text

Refunds
    [Documentation]    Checks that refund can be created for an item and the whole order
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate following discounts from Overview page:    20% off storage    10% off minimum order
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    refunds+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${multi_color_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${product_with_relations_related_products_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    refunds+${random}
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
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,366.16
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: trigger matching state of order item inside xxx shipment:    107254    Ship
    Zed: trigger matching state of order item inside xxx shipment:    107254    Stock update
    Zed: trigger matching state of order item inside xxx shipment:    107254    Refund
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,162.87
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Ship
    Zed: trigger all matching states inside this order:    Stock update
    Zed: trigger all matching states inside this order:    Refund
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €0.00
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: activate following discounts from Overview page:    20% off storage    10% off minimum order

Comments_in_Cart
    [Documentation]    Adding comments to cart and verify comments in Yves and zed
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: create new 'Shopping Cart' with name:    commentCart+${random}
    Yves: go to PDP of the product with sku:    ${bundled_product_3_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    commentCart+${random}
    Yves: add comment on cart:    abc${random}
    Yves: check comments are visible or not in cart:    abc${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_shared_permission_owner_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: go to order details page to check comment:    abc${random}    ${lastPlacedOrder}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}    
    Zed: check comment appears at order detailed page in zed:    abc${random}    ${lastPlacedOrder}

Comment_Management_in_the_Cart
    [Documentation]    Adding editing and deleting comments in carts
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: create new 'Shopping Cart' with name:    commentManagement+${random}
    Yves: go to PDP of the product with sku:    ${bundled_product_3_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    commentManagement+${random}
    Yves: add comment on cart:    abc${random}
    Yves: check comments are visible or not in cart:    true    abc${random}    
    Yves: edit comment on cart:    xyz${random}
    Yves: check comments are visible or not in cart:    true    xyz${random}    
    Yves: delete comment on cart
    Yves: check comments are visible or not in cart:    false    xyz${random}
    [Teardown]    Run Keyword    Yves: delete 'Shopping Cart' with name:    commentManagement+${random}
        
Comment_Management_in_Order
    [Documentation]    Adding comments in yves and checking they appears in zed
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: create new 'Shopping Cart' with name:    comments+${random}
    Yves: go to PDP of the product with sku:    ${bundled_product_3_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    comments+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_shared_permission_owner_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: go to 'Order History' page
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
   # Bug: https://spryker.atlassian.net/browse/CC-23306
    Yves: add comment on order in order detail page:    abc${random}
    Yves: check comments is visible or not in order:    true    abc${random}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}    
    Zed: check comment appears at order detailed page in zed:    abc${random}    ${lastPlacedOrder}